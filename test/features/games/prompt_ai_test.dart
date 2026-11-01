import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/games/presentation/pages/prompt_custom_setup_page.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:socialdeck/features/games/domain/prompt_ai.dart';
import 'package:socialdeck/features/games/domain/game_setup_state.dart';
import 'package:socialdeck/features/games/data/firebase_prompt_ai_repository.dart';
import 'package:socialdeck/features/games/data/mock_game_setup_repository.dart';
import 'package:socialdeck/features/games/providers/game_setup_provider.dart';

const draft = GameSetupState(
  groupCategories: ['Friends', 'Mutuals', 'Other'],
  customGroups: ['Roommates'],
  groupDescription: 'College friends who enjoy photography',
  selectedTopics: ['Memes', 'Other'],
  customTopics: ['Campus life'],
  styleLevel: 'bold',
  averageAgeText: '22',
);

// IA: Opt-in live tests bypass the widget test network stub only.
class LiveHttp extends HttpOverrides {}

class FakeUser extends Fake implements User {
  String? token = 'team-id-token';
  @override
  Future<String?> getIdToken([bool forceRefresh = false]) async => token;
  @override
  String get uid => 'flutter-ai-test';
}

class FakeApp extends Fake implements FirebaseApp {
  @override
  FirebaseOptions get options => const FirebaseOptions(
    apiKey: 'public-test-config',
    appId: 'test-app',
    messagingSenderId: 'test-sender',
    projectId: 'socialdeck-dev',
  );
}

class FakeAuth extends Fake implements FirebaseAuth {
  @override
  FirebaseApp get app => FakeApp();
  User? user = FakeUser();
  @override
  User? get currentUser => user;
}

Map<String, dynamic> sessionJson({Map<String, bool> votes = const {}}) => {
  'contractVersion': 1,
  'id': 'test_session_12345678',
  'prompts': List.generate(
    5,
    (i) => {
      'id': 'test_prompt_12345678_$i',
      'text': 'A real-shaped test photo prompt number $i',
    },
  ),
  'feedback':
      votes.entries
          .map((e) => {'promptId': e.key, 'accepted': e.value})
          .toList(),
};

class FakeAi extends PromptAiRepository {
  bool fail = false;
  final ids = <String>[];
  final votes = <String, bool>{};
  Completer<void>? gate;
  Completer<void>? replacementGate;
  List<AiPrompt>? replacements;
  PromptAiSession result() {
    final initial = PromptAiSession.fromJson(sessionJson(votes: votes));
    return PromptAiSession(
      initial.id,
      replacements ?? initial.prompts,
      Map.of(votes),
    );
  }

  @override
  Future<PromptAiSession> generate(
    Map<String, Object?> profile,
    String requestId,
  ) async {
    ids.add(requestId);
    if (gate != null) await gate!.future;
    if (fail) throw const PromptAiException('offline');
    return result();
  }

  @override
  Future<PromptAiSession> vote(
    String sid,
    String pid,
    bool yes,
    List<String> reasons,
    String explanation,
    String id,
  ) async {
    ids.add(id);
    if (fail) throw const PromptAiException('offline');
    votes[pid] = yes;
    return result();
  }

  @override
  Future<PromptAiSession> replaceRejected(String sid, String id) async {
    ids.add(id);
    if (fail) throw const PromptAiException('offline');
    if (replacementGate != null) await replacementGate!.future;
    final before = result();
    final prompts =
        before.prompts
            .map(
              (p) =>
                  votes[p.id] == true
                      ? p
                      : AiPrompt(
                        'replacement_12345678',
                        'A brand new replacement photo prompt',
                      ),
            )
            .toList();
    replacements = prompts;
    return PromptAiSession(sid, prompts, Map.of(votes));
  }
}

void main() {
  test(
    'maps full app context without adding Less Topics or dropping Other',
    () {
      final p = promptProfile(draft);
      expect(p['groupTypes'], ['close_friends']);
      expect(p['groupNote'], 'Mutuals, Roommates');
      expect(p['moreOfNote'], 'Memes, Campus life');
      expect(p['lessOf'], isEmpty);
      expect(p['lessOfNote'], '');
      expect(p['safeMode'], true);
      expect(p['averageAge'], 22);
      expect(
        promptProfile(draft.copyWith(groupCategories: []))['groupNote'],
        draft.groupDescription,
      );
      expect(
        promptProfile(
          draft.copyWith(
            groupCategories: ['Friends'],
            selectedTopics: ['Memes'],
          ),
        )['moreOfNote'],
        'Memes',
      );
    },
  );
  test('rejects oversize notes and invalid age before sending', () {
    expect(
      () => promptProfile(draft.copyWith(customTopics: ['x' * 501])),
      throwsA(isA<PromptAiException>()),
    );
    expect(
      () => promptProfile(draft.copyWith(averageAgeText: '121')),
      throwsA(isA<PromptAiException>()),
    );
  });
  test('bad or incomplete server sessions cannot be treated as examples', () {
    expect(
      () => PromptAiSession.fromJson({'contractVersion': 1}),
      throwsA(isA<PromptAiException>()),
    );
  });
  test(
    'retry keeps request ID, double taps blocked, reset discards late response',
    () async {
      final repo = FakeAi()..fail = true;
      final flow = PromptAiFlow(repo);
      await expectLater(
        flow.generate(promptProfile(draft)),
        throwsA(isA<PromptAiException>()),
      );
      repo.fail = false;
      await flow.generate(promptProfile(draft));
      expect(repo.ids[0], repo.ids[1]);
      repo.gate = Completer<void>();
      final first = flow.generate(promptProfile(draft));
      await expectLater(
        flow.generate(promptProfile(draft)),
        throwsA(isA<PromptAiException>()),
      );
      flow.reset();
      repo.gate!.complete();
      await expectLater(first, throwsA(isA<PromptAiException>()));
      expect(flow.session, isNull);
    },
  );
  test(
    'rejected replacement keeps accepted texts and never falsely completes',
    () async {
      final repo = FakeAi();
      final flow = PromptAiFlow(repo);
      await flow.generate(promptProfile(draft));
      await expectLater(flow.finish(), throwsA(isA<PromptAiException>()));
      for (var i = 0; i < 4; i++) {
        await flow.vote(i, true, [], '');
      }
      final accepted = flow.session!.approved;
      await flow.vote(4, false, [
        'too_generic',
        'other',
      ], 'More campus context');
      repo.fail = true;
      await expectLater(flow.finish(), throwsA(isA<PromptAiException>()));
      final failedId = repo.ids.last;
      expect(flow.session!.approved, accepted);
      expect(flow.session!.complete, false);
      repo.fail = false;
      final replacement = await flow.finish();
      expect(repo.ids.last, failedId);
      expect(replacement.approved, accepted);
      expect(replacement.nextUnreviewed, 4);
      expect(replacement.complete, false);
    },
  );
  test('failed vote does not approve locally and retry uses same ID', () async {
    final repo = FakeAi();
    final flow = PromptAiFlow(repo);
    await flow.generate(promptProfile(draft));
    repo.fail = true;
    await expectLater(
      flow.vote(0, true, [], ''),
      throwsA(isA<PromptAiException>()),
    );
    final id = repo.ids.last;
    expect(flow.session!.approved, isEmpty);
    repo.fail = false;
    await flow.vote(0, true, [], '');
    expect(repo.ids.last, id);
    expect(flow.session!.approved.length, 1);
  });
  test(
    'settings changes require regenerated approved prompts before save',
    () async {
      final repo = FakeAi();
      final notifier = GameSetupNotifier(
        MockGameSetupRepository(),
        aiRepository: repo,
      );
      notifier.toggleGroupCategory('Friends');
      notifier.confirmGroup();
      notifier.toggleTopic('Memes');
      notifier.confirmTopics();
      notifier.updateStyleLevel('bold');
      await notifier.generatePrompts();
      expect(notifier.aiReady, false);
      for (var i = 0; i < 5; i++) {
        await notifier.approveExample(i);
      }
      expect(notifier.aiReady, true);
      notifier.updateAverageAge('30');
      expect(notifier.aiReady, false);
      notifier.dispose();
    },
  );
  test(
    'REST isolates local auth, wraps callable data and sends structured feedback',
    () async {
      final requests = <http.Request>[];
      final repo = FirebasePromptAiRepository(
        emulatorHost: '127.0.0.1',
        projectId: 'demo-socialdeck-promptd',
        auth: () => FakeAuth(),
        client: MockClient((req) async {
          requests.add(req);
          return http.Response(
            jsonEncode(
              req.url.port == 9099
                  ? {'idToken': 'local-token', 'refreshToken': 'local-refresh'}
                  : {'result': sessionJson()},
            ),
            200,
          );
        }),
      );
      await repo.generate(promptProfile(draft), 'request_1234567890');
      await repo.vote(
        'session_1234567890',
        'prompt_1234567890',
        false,
        ['too_generic', 'other'],
        'More context',
        'request_2234567890',
      );
      expect(requests.length, 3);
      expect(requests[1].headers['Authorization'], 'Bearer local-token');
      final data = jsonDecode(requests.last.body)['data'];
      expect(data['reasons'], ['too_generic', 'other']);
      expect(data['explanation'], 'More context');
      repo.dispose();
    },
  );
  // IA: Normal app builds use hosted AI; the existing Firebase token stays on HTTPS.
  test(
    'hosted AI defaults to the signed-in project without local defines',
    () async {
      final requests = <http.Request>[];
      final repo = FirebasePromptAiRepository(
        auth: () => FakeAuth(),
        client: MockClient((request) async {
          requests.add(request);
          return http.Response(jsonEncode({'result': sessionJson()}), 200);
        }),
      );
      addTearDown(repo.dispose);
      await repo.generate(promptProfile(draft), 'request_1234567890');
      expect(requests, hasLength(1));
      expect(
        requests.single.url.toString(),
        'https://us-central1-socialdeck-dev.cloudfunctions.net/generatePromptExamples',
      );
      expect(requests.single.headers['Authorization'], 'Bearer team-id-token');
      expect(jsonDecode(requests.single.body)['data']['count'], 5);
    },
  );
  test(
    'cloud rejects mismatched project, missing login or token before HTTP',
    () async {
      for (final mode in ['project', 'login', 'token', 'empty-token']) {
        final auth = FakeAuth();
        if (mode == 'login') auth.user = null;
        if (mode == 'token') (auth.user as FakeUser).token = null;
        if (mode == 'empty-token') (auth.user as FakeUser).token = '';
        var calls = 0;
        final repo = FirebasePromptAiRepository(
          projectId: mode == 'project' ? 'another-project' : '',
          auth: () => auth,
          client: MockClient((_) async {
            calls++;
            return http.Response('{}', 200);
          }),
        );
        addTearDown(repo.dispose);
        await expectLater(
          repo.generate(promptProfile(draft), 'request_1234567890'),
          throwsA(isA<PromptAiException>()),
        );
        expect(calls, 0, reason: mode);
      }
    },
  );
  test(
    'cloud error preserves failure and account change discards late result',
    () async {
      for (final mode in ['permission', 'missing-server', 'account-change']) {
        final auth = FakeAuth();
        final repo = FirebasePromptAiRepository(
          auth: () => auth,
          client: MockClient((_) async {
            if (mode == 'account-change') {
              auth.user = null;
              return http.Response(jsonEncode({'result': sessionJson()}), 200);
            }
            if (mode == 'missing-server') {
              return http.Response('Not found', 404);
            }
            return http.Response(
              jsonEncode({
                'error': {'status': 'PERMISSION_DENIED'},
              }),
              403,
            );
          }),
        );
        addTearDown(repo.dispose);
        await expectLater(
          repo.generate(promptProfile(draft), 'request_1234567890'),
          throwsA(isA<PromptAiException>()),
        );
      }
    },
  );
  // IA: PC sharing sends the normal Firebase login only to an explicit HTTPS origin.
  test(
    'PC host uses the supplied HTTPS origin with normal Firebase auth',
    () async {
      final calls = <http.Request>[];
      final repo = FirebasePromptAiRepository(
        serverUrl: 'https://team-test.trycloudflare.com/',
        auth: () => FakeAuth(),
        client: MockClient((request) async {
          calls.add(request);
          return http.Response(jsonEncode({'result': sessionJson()}), 200);
        }),
      );
      addTearDown(repo.dispose);
      await repo.generate(promptProfile(draft), 'request_1234567890');
      expect(
        calls.single.url.toString(),
        'https://team-test.trycloudflare.com/generatePromptExamples',
      );
      expect(calls.single.headers['Authorization'], 'Bearer team-id-token');
    },
  );
  test(
    'unsafe sharing URLs and mixed local mode send no token or request',
    () async {
      for (final url in [
        'http://team.test',
        'https://user:password@team.test',
        'https://team.test/path',
        'https://team.test?key=x',
        'https://team.test#part',
        'not-a-url',
      ]) {
        var calls = 0;
        final repo = FirebasePromptAiRepository(
          serverUrl: url,
          auth: () => FakeAuth(),
          client: MockClient((_) async {
            calls++;
            return http.Response('{}', 200);
          }),
        );
        addTearDown(repo.dispose);
        await expectLater(
          repo.generate(promptProfile(draft), 'request_1234567890'),
          throwsA(isA<PromptAiException>()),
        );
        expect(calls, 0, reason: url);
      }
      final mixed = FirebasePromptAiRepository(
        serverUrl: 'https://team.test',
        emulatorHost: '127.0.0.1',
        auth: () => FakeAuth(),
      );
      addTearDown(mixed.dispose);
      await expectLater(
        mixed.generate(promptProfile(draft), 'request_1234567890'),
        throwsA(isA<PromptAiException>()),
      );
    },
  );
  testWidgets('app sends rejection, reviews only replacement, then completes', (
    tester,
  ) async {
    final repo = FakeAi();
    final setup = GameSetupNotifier(
      MockGameSetupRepository(),
      aiRepository: repo,
    );
    setup.toggleGroupCategory('Friends');
    setup.confirmGroup();
    setup.toggleTopic('Memes');
    setup.confirmTopics();
    setup.updateStyleLevel('bold');
    await setup.generatePrompts();
    for (var i = 0; i < 4; i++) {
      await setup.approveExample(i);
    }
    final accepted = List.of(setup.state.approvedExamples);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [gameSetupProvider.overrideWith((ref) => setup)],
        child: MaterialApp(
          theme: SDeckAppTheme.light,
          home: const PromptCustomSetupReviewPage(),
        ),
      ),
    );
    expect(find.text('Example 5 of 5'), findsOneWidget);
    await tester.ensureVisible(find.bySemanticsLabel('Dislike this prompt'));
    await tester.tap(find.bySemanticsLabel('Dislike this prompt'));
    await tester.pumpAndSettle();
    final reason = find.byKey(const ValueKey('feedback-Too generic'));
    await tester.ensureVisible(reason);
    await tester.tap(reason);
    await tester.pumpAndSettle();
    repo.replacementGate = Completer<void>();
    final next = find.byKey(const ValueKey('feedback-next'));
    await tester.ensureVisible(next);
    await tester.tap(next);
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Generating 1 replacement example...'),
      findsOneWidget,
    );
    expect(
      find.textContaining('Your approved examples stay unchanged.'),
      findsOneWidget,
    );
    expect(find.text('Finalizing prompts...'), findsNothing);
    expect(find.text('Complete!'), findsNothing);
    repo.replacementGate!.complete();
    await tester.pumpAndSettle();
    expect(
      find.textContaining('A brand new replacement photo prompt'),
      findsOneWidget,
    );
    expect(find.text('Complete!'), findsNothing);
    expect(setup.state.approvedExamples, accepted);
    final like = find.bySemanticsLabel('Like this prompt');
    await tester.ensureVisible(like);
    await tester.tap(like);
    await tester.pumpAndSettle();
    expect(find.text('Finalizing prompts...'), findsOneWidget);
    expect(find.text('Complete!'), findsNothing);
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Complete!'), findsOneWidget);
    expect(setup.aiReady, true);
    expect(setup.state.approvedExamples, [
      ...accepted,
      'A brand new replacement photo prompt',
    ]);
    expect(
      setup.state.approvedExamples,
      isNot(contains('A real-shaped test photo prompt number 4')),
    );
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
  test(
    'live prototype: generate, reject, replace and preserve approved examples',
    () => HttpOverrides.runWithHttpOverrides(() async {
      final repo = FirebasePromptAiRepository(
        emulatorHost: '127.0.0.1',
        projectId: 'demo-socialdeck-promptd',
        auth: () => FakeAuth(),
      );
      addTearDown(repo.dispose);
      final flow = PromptAiFlow(repo);
      final generated = await flow.generate(
        promptProfile(draft.copyWith(selectedTopics: ['Other'])),
      );
      expect(generated.prompts.length, 5);
      expect(
        generated.prompts
            .where((p) => p.text.toLowerCase().startsWith('a photo'))
            .length,
        lessThanOrEqualTo(2),
      );
      expect(generated.prompts.every((p) => p.topics.isNotEmpty), true);
      expect(
        generated.prompts
            .expand((p) => p.topics)
            .every(['Campus life'].contains),
        true,
      );
      for (var i = 0; i < 4; i++) {
        await flow.vote(i, true, [], '');
      }
      final approved = flow.session!.approved;
      await flow.vote(
        4,
        false,
        ['too_generic', 'other'],
        'Make this more specific to our college friend group, still a photo prompt.',
      );
      final replaced = await flow.finish();
      expect(replaced.approved, approved);
      expect(replaced.nextUnreviewed, greaterThanOrEqualTo(0));
      expect(
        replaced.prompts.every((p) => p.topics.contains('Campus life')),
        true,
      );
      await flow.vote(replaced.nextUnreviewed, true, [], '');
      expect((await flow.finish()).complete, true);
      expect(flow.session!.approved.length, 5);
    }, LiveHttp()),
    skip: !const bool.fromEnvironment('RUN_LIVE_AI'),
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
