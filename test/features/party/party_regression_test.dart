// -----------------------------------------------------------------------------
// party_regression_test.dart
// Regressions found during the backend-only review.
// -----------------------------------------------------------------------------
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/features/party/data/party_firebase_errors.dart';
import 'package:socialdeck/features/party/domain/party_failure.dart';
import 'package:socialdeck/features/party/domain/party_models.dart';
import 'package:socialdeck/features/party/domain/party_policy.dart';
import 'package:socialdeck/features/party/providers/party_form_provider.dart';

void main() {
  test('saving equal game settings preserves selections and Ready', () {
    final party = Party(
      id: '123456',
      hostId: 'host',
      revision: 2,
      game: const PartyGame(),
      members: {
        'host': const PartyMember(
          uid: 'host',
          name: 'Host',
          cardCount: 7,
          selectionRevision: 2,
          ready: true,
        ),
      },
    );
    final result = PartyPolicy.selectGame(party, 'host', const PartyGame());
    expect(identical(result, party), isTrue);
    expect(result.isReady('host'), isTrue);
    expect(result.revision, 2);
    final changed = PartyPolicy.selectGame(
      party,
      'host',
      const PartyGame(rounds: 4),
    );
    expect(changed.revision, 3);
    expect(changed.isReady('host'), isFalse);
  });

  test('unchanged form values do not send extra state notifications', () {
    final notifier = PartyFormNotifier();
    addTearDown(notifier.dispose);
    var notifications = 0;
    notifier.addListener((_) => notifications++, fireImmediately: false);
    notifier.updateName('Alex');
    notifier.updateName('Alex');
    notifier.updateCode('123456');
    notifier.updateCode('123456');
    expect(notifications, 2);
  });

  test('catalog and Party streams expose typed Firebase errors', () async {
    final source = Stream<int>.error(
      FirebaseException(plugin: 'cloud_firestore', code: 'permission-denied'),
    );
    await expectLater(
      PartyFirebaseErrors.stream(source),
      emitsError(
        isA<PartyFailure>().having(
          (e) => e.code,
          'code',
          PartyError.permissionDenied,
        ),
      ),
    );
  });

  test('typed domain failures are preserved at the Firebase boundary', () {
    const failure = PartyFailure(PartyError.full);
    expect(identical(PartyFirebaseErrors.map(failure), failure), isTrue);
    expect(
      PartyFirebaseErrors.map(StateError('bad data')).code,
      PartyError.unknown,
    );
    expect(
      PartyFirebaseErrors.map(
        FirebaseException(plugin: 'cloud_firestore', code: 'unavailable'),
      ).code,
      PartyError.network,
    );
  });
}
