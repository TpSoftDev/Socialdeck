import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/party_providers.dart';
import '../domain/party_failure.dart';

/// Retry the lobby as well as its session, even if another screen keeps it alive.
void retryPartySession(WidgetRef ref) {
  final id = ref.read(activePartyIdProvider).asData?.value;
  if (id != null) ref.invalidate(partyByIdProvider(id));
  ref.invalidate(activePartyIdProvider);
}

String partyErrorMessage(Object? error) {
  final code = error is PartyFailure ? error.code : error;
  return switch (code) {
    PartyError.unauthenticated => 'Sign in to use Party.',
    PartyError.invalidInput => 'Check your name or six-digit party code.',
    PartyError.notFound => 'This party or invitation no longer exists.',
    PartyError.alreadyInParty => 'This player is already in a party.',
    PartyError.full => 'This party is full (8 players).',
    PartyError.closed => 'The party has ended or the game has already started.',
    PartyError.forbidden => 'You cannot perform this action.',
    PartyError.hostMustTransfer => 'Promote another player before leaving.',
    PartyError.noGame => 'The host needs to select a game first.',
    PartyError.invalidCards => 'Choose at least seven distinct saved cards.',
    PartyError.notReady => 'At least two players must be ready to start.',
    PartyError.network => 'Could not connect. Check your connection and retry.',
    PartyError.permissionDenied =>
      'Party access was denied. Please try again later.',
    PartyError.conflict => 'The party changed. Refresh and try again.',
    _ => 'Could not complete the action. Please try again.',
  };
}

void partyToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 3500),
      showCloseIcon: true,
    ),
  );
}

/// The dialog owns its controller until its route is disposed.
Future<String?> partyNameDialog(BuildContext context, {String initial = ''}) =>
    showDialog<String>(context: context, builder: (_) => _NameDialog(initial));

class _NameDialog extends StatefulWidget {
  const _NameDialog(this.initial);
  final String initial;
  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  late final controller = TextEditingController(text: widget.initial);
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('In-game name'),
    content: TextField(
      controller: controller,
      autofocus: true,
      maxLength: 24,
      decoration: const InputDecoration(
        helperText: 'Only visible in this party.',
      ),
      onChanged: (_) => setState(() {}),
      onSubmitted: (_) => submit(),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Back'),
      ),
      FilledButton(
        onPressed: controller.text.trim().isEmpty ? null : submit,
        child: const Text('Update'),
      ),
    ],
  );
  void submit() {
    if (controller.text.trim().isNotEmpty) {
      Navigator.pop(context, controller.text.trim());
    }
  }
}
