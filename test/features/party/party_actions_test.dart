// -----------------------------------------------------------------------------
// party_actions_test.dart
// Command lifecycle tests: failure recovery, double taps, and disposed pages.
// -----------------------------------------------------------------------------
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/features/party/domain/party_action_state.dart';
import 'package:socialdeck/features/party/domain/party_failure.dart';
import 'package:socialdeck/features/party/domain/party_repository.dart';
import 'package:socialdeck/features/party/providers/party_actions_provider.dart';

class ControlledRepository implements PartyRepository {
  Completer<String> result = Completer<String>();
  int calls = 0;
  @override
  Future<String> createParty(String name) {
    calls++;
    return result.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test(
    'create exposes loading, blocks a duplicate, then returns persisted ID',
    () async {
      final repository = ControlledRepository();
      final notifier = PartyActionsNotifier(repository);
      addTearDown(notifier.dispose);
      final pending = notifier.createParty('Alex');
      expect(notifier.state.isLoading, isTrue);
      expect(await notifier.createParty('Alex'), isFalse);
      expect(repository.calls, 1);
      repository.result.complete('123456');
      expect(await pending, isTrue);
      expect(notifier.state.status, PartyAsyncStatus.success);
      expect(notifier.state.partyId, '123456');
    },
  );

  test('typed errors terminate loading and allow a later retry', () async {
    final repository = ControlledRepository();
    final notifier = PartyActionsNotifier(repository);
    addTearDown(notifier.dispose);
    final pending = notifier.createParty('Alex');
    repository.result.completeError(const PartyFailure(PartyError.network));
    expect(await pending, isFalse);
    expect(notifier.state.error, PartyError.network);
    expect(notifier.state.isLoading, isFalse);
    repository.result = Completer<String>();
    final retry = notifier.createParty('Alex');
    expect(notifier.state.error, isNull);
    repository.result.complete('123456');
    expect(await retry, isTrue);
    expect(notifier.state.error, isNull);
  });

  test(
    'unexpected errors do not leave the command loading indefinitely',
    () async {
      final repository = ControlledRepository();
      final notifier = PartyActionsNotifier(repository);
      addTearDown(notifier.dispose);
      final pending = notifier.createParty('Alex');
      repository.result.completeError(StateError('unexpected'));
      expect(await pending, isFalse);
      expect(notifier.state.error, PartyError.unknown);
      expect(notifier.state.isLoading, isFalse);
    },
  );

  test(
    'a disposed notifier does not publish late results or request navigation',
    () async {
      final repository = ControlledRepository();
      final notifier = PartyActionsNotifier(repository);
      final pending = notifier.createParty('Alex');
      notifier.dispose();
      repository.result.complete('123456');
      expect(await pending, isFalse);
    },
  );

  test(
    'reset cannot reopen submission gate during an active operation',
    () async {
      final repository = ControlledRepository();
      final notifier = PartyActionsNotifier(repository);
      addTearDown(notifier.dispose);
      final pending = notifier.createParty('Alex');
      notifier.reset();
      expect(notifier.state.isLoading, isTrue);
      repository.result.complete('123456');
      await pending;
      notifier.reset();
      expect(notifier.state.status, PartyAsyncStatus.idle);
      expect(notifier.state.partyId, isNull);
    },
  );
}
