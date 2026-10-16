import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';
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
    PartyError.inviteAlreadySent => 'Invite already sent. You can resend 1 minute after the last send.',
    PartyError.full => 'This party is full (8 players).',
    PartyError.closed => 'The party has ended or the game has already started.',
    PartyError.forbidden => 'You cannot perform this action.',
    PartyError.hostMustTransfer => 'Promote another player before leaving.',
    PartyError.noGame => 'The host needs to select a game first.',
    PartyError.invalidCards => 'Choose at least seven distinct saved cards.',
    PartyError.notReady => 'At least two players must be ready to start.',
    PartyError.connectionUnconfirmed =>
      'Waiting for server confirmation. Check your connection. Party actions are temporarily unavailable.',
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
Future<String?> partyNameDialog(BuildContext context, {String initial = '',
  bool Function(WidgetRef)? canSubmit,
}) => showDialog<String>(context: context,
  builder: (_) => _NameDialog(initial, canSubmit));

class _NameDialog extends ConsumerStatefulWidget {
  const _NameDialog(this.initial, this.canSubmit);
  final bool Function(WidgetRef)? canSubmit;
  final String initial;
  @override
  ConsumerState<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends ConsumerState<_NameDialog> {
  late final controller = TextEditingController(text: widget.initial);
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: Colors.transparent,
    insetPadding: const EdgeInsets.all(SDeckSpace.margin32),
    child: SDeckPartyInGameNameInputDialog(
      controller: controller, inputState: SDeckInputState.hint,
      maxLength: 24,
      primaryButtonEnabled: controller.text.trim().isNotEmpty && widget.canSubmit?.call(ref) != false,
      onNext: controller.text.trim().isNotEmpty && widget.canSubmit?.call(ref) != false ? submit : null,
      onClose: () => Navigator.pop(context),
      onChanged: (_) => setState(() {}),
      onSubmitted: (_) => submit(), autofocus: true,
    ),
  );
  void submit() {
    if (mounted && controller.text.trim().isNotEmpty && widget.canSubmit?.call(ref) != false) {
      Navigator.pop(context, controller.text.trim());
    }
  }
}
