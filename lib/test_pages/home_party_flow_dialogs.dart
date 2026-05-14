import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

//--------------------------- HomePartyFlowDialogs ---------------------------//
/// Shared modal flows for **Create Party** / **Join a Party** test UIs.
/*--------------------------------------------------------------------------*/

/// Optional payload after join completes (in-game name + 6-digit code).
typedef HomePartyJoinCompleted =
    void Function(BuildContext hostContext, String inGameName, String partyCode);

/// After **Create Party** → **Let's Begin!** → **Next** with a non-empty name.
typedef HomePartyCreateNamedComplete =
    void Function(BuildContext hostContext, String inGameName);

/// Result of **Leave Party** (Figma `230:3660`): outline **Leave** vs solid
/// **Disband**; `null` if dismissed (**X** or barrier).
enum LeavePartyDialogChoice {
  /// Leave party; next player becomes leader (test: continue to create/join).
  leave,

  /// End party for everyone (test: return to Home – Returning).
  disband,
}

class HomePartyFlowDialogs {
  HomePartyFlowDialogs._();

  /// **Home – In Party** — **Leave Party** (Figma `230:3660`): outline **Leave**
  /// + solid **Disband**, copy + `gap8` between buttons per spec.
  ///
  /// [onLeaveParty] runs after **Leave**. [onDisbandParty] after **Disband**.
  /// **X** / barrier dismiss: neither runs.
  static void showLeavePartyThen(
    BuildContext hostContext, {
    required VoidCallback onLeaveParty,
    VoidCallback? onDisbandParty,
  }) {
    showGeneralDialog<LeavePartyDialogChoice?>(
      context: hostContext,
      barrierDismissible: true,
      barrierLabel:
          MaterialLocalizations.of(hostContext).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (
        BuildContext dialogContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        final double dialogWidth =
            MediaQuery.sizeOf(hostContext).width - 2 * SDeckSpace.margin32;

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(SDeckSpace.margin32),
          child: SDeckDialog(
            title: 'Leave Party',
            description:
                'Are you sure you want to leave your current party?',
            secondaryButtonText: 'Leave',
            onSecondaryPressed: () {
              if (Navigator.of(dialogContext).canPop()) {
                Navigator.of(dialogContext).pop(LeavePartyDialogChoice.leave);
              }
            },
            primaryButtonText: 'Disband',
            onPrimaryPressed: () {
              if (Navigator.of(dialogContext).canPop()) {
                Navigator.of(dialogContext).pop(LeavePartyDialogChoice.disband);
              }
            },
            dialogWidth: dialogWidth,
            onClose: () {
              if (Navigator.of(dialogContext).canPop()) {
                Navigator.of(dialogContext).pop();
              }
            },
          ),
        );
      },
      transitionBuilder: fadeDialogTransition,
    ).then((LeavePartyDialogChoice? choice) {
      if (!hostContext.mounted) {
        return;
      }
      switch (choice) {
        case LeavePartyDialogChoice.leave:
          onLeaveParty();
        case LeavePartyDialogChoice.disband:
          onDisbandParty?.call();
        case null:
          break;
      }
    });
  }

  /// Fade for [showGeneralDialog]. Uses [animation] directly — do **not**
  /// call [Animation.drive] here: [transitionBuilder] can rebuild and would
  /// register duplicate listeners on the route animation (`_dependents`
  /// assertion, odd dispose ordering).
  static Widget fadeDialogTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  /// **Let's Begin!** in-game name dialog. Pops on **Next** / keyboard submit.
  ///
  /// When [onNamedComplete] is set, it runs after the dialog closes (host is
  /// [context] from the call site). Use it to open **Home – In Party** with
  /// [HomeInPartyRouteArgs] built from the trimmed name.
  static void showCreatePartyLetsBegin(
    BuildContext context, {
    HomePartyCreateNamedComplete? onNamedComplete,
  }) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel:
          MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (
        BuildContext dialogContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: SDeckSpace.padding24,
          ),
          child: _CreatePartyNameFlow(
            dialogContext: dialogContext,
            hostContext: context,
            onNamedComplete: onNamedComplete,
          ),
        );
      },
      transitionBuilder: fadeDialogTransition,
    );
  }

  /// In-game name → enter code. Calls [onJoinCompleted] after successful **Next**
  /// on the code step (after dialog is closed).
  static void showJoinPartyFlow(
    BuildContext hostContext, {
    HomePartyJoinCompleted? onJoinCompleted,
  }) {
    showGeneralDialog<void>(
      context: hostContext,
      barrierDismissible: true,
      barrierLabel:
          MaterialLocalizations.of(hostContext).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (
        BuildContext dialogContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: SDeckSpace.padding24,
          ),
          child: _JoinPartyFlow(
            dialogContext: dialogContext,
            hostContext: hostContext,
            onJoinCompleted: onJoinCompleted,
          ),
        );
      },
      transitionBuilder: fadeDialogTransition,
    );
  }
}

//============================== _CreatePartyNameFlow =========================//
class _CreatePartyNameFlow extends StatefulWidget {
  const _CreatePartyNameFlow({
    required this.dialogContext,
    required this.hostContext,
    this.onNamedComplete,
  });

  final BuildContext dialogContext;
  final BuildContext hostContext;
  final HomePartyCreateNamedComplete? onNamedComplete;

  @override
  State<_CreatePartyNameFlow> createState() => _CreatePartyNameFlowState();
}

class _CreatePartyNameFlowState extends State<_CreatePartyNameFlow> {
  late final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onTextChanged);
  }

  void _onTextChanged() => setState(() {});

  @override
  void dispose() {
    _nameController.removeListener(_onTextChanged);
    _nameController.dispose();
    super.dispose();
  }

  void _closeFlow() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (Navigator.of(widget.dialogContext).canPop()) {
      Navigator.of(widget.dialogContext).pop();
    }
  }

  void _submitName() {
    final String trimmed = _nameController.text.trim();
    if (trimmed.isEmpty) {
      return;
    }
    _closeFlow();
    if (widget.onNamedComplete == null) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.hostContext.mounted) {
        return;
      }
      widget.onNamedComplete!(widget.hostContext, trimmed);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String raw = _nameController.text;
    final bool nameOk = raw.trim().isNotEmpty;
    return SDeckPartyInGameNameInputDialog(
      controller: _nameController,
      inputState: raw.isEmpty ? SDeckInputState.hint : SDeckInputState.filled,
      primaryButtonEnabled: nameOk,
      onChanged: (_) {},
      onClose: _closeFlow,
      onNext: _submitName,
      onSubmitted: (_) => _submitName(),
    );
  }
}

//================================ _JoinPartyFlow =============================//
class _JoinPartyFlow extends StatefulWidget {
  const _JoinPartyFlow({
    required this.dialogContext,
    required this.hostContext,
    this.onJoinCompleted,
  });

  final BuildContext dialogContext;
  final BuildContext hostContext;
  final HomePartyJoinCompleted? onJoinCompleted;

  @override
  State<_JoinPartyFlow> createState() => _JoinPartyFlowState();
}

class _JoinPartyFlowState extends State<_JoinPartyFlow> {
  late final TextEditingController _nameController = TextEditingController();
  late final TextEditingController _codeController = TextEditingController();
  int _step = 0;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onTextChanged);
    _codeController.addListener(_onTextChanged);
  }

  void _onTextChanged() => setState(() {});

  @override
  void dispose() {
    _nameController.removeListener(_onTextChanged);
    _codeController.removeListener(_onTextChanged);
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _closeFlow() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (Navigator.of(widget.dialogContext).canPop()) {
      Navigator.of(widget.dialogContext).pop();
    }
  }

  void _finishJoin(String digits) {
    final String name = _nameController.text.trim();
    _closeFlow();
    if (widget.onJoinCompleted == null) {
      return;
    }
    // Let the first route finish popping before touching [hostContext].
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!widget.hostContext.mounted) {
          return;
        }
        widget.onJoinCompleted!(widget.hostContext, name, digits);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_step == 0) {
      final String raw = _nameController.text;
      final bool nameOk = raw.trim().isNotEmpty;
      return SDeckPartyInGameNameInputDialog(
        controller: _nameController,
        inputState: raw.isEmpty ? SDeckInputState.hint : SDeckInputState.filled,
        primaryButtonEnabled: nameOk,
        onChanged: (_) {},
        onClose: _closeFlow,
        onNext: () {
          if (_nameController.text.trim().isEmpty) {
            return;
          }
          setState(() => _step = 1);
        },
        onSubmitted: (_) {
          if (_nameController.text.trim().isNotEmpty) {
            setState(() => _step = 1);
          }
        },
      );
    }

    final String digits = _codeController.text;
    final bool codeComplete = digits.length == 6;

    return SDeckPartyCodeInputDialog(
      controller: _codeController,
      inputState: digits.isEmpty ? SDeckInputState.hint : SDeckInputState.filled,
      primaryButtonEnabled: codeComplete,
      onChanged: (_) {},
      onClose: _closeFlow,
      onNext: () {
        if (!codeComplete) {
          return;
        }
        _finishJoin(digits);
      },
      onSubmitted: (_) {
        if (codeComplete) {
          _finishJoin(digits);
        }
      },
    );
  }
}
