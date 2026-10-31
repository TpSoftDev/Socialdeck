/*-------------------- prompt_settings_page.dart -----------------------*/
// Prompt'd Settings after custom setup Complete.
// Assembled from existing design system pieces: top bar + sticker, chips,
// section header, outline/solid buttons. Toggle and stepper rows are composed
// from tokens until those land as shared selection-target components.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/games/providers/game_setup_provider.dart';
import 'prompt_custom_setup_page.dart';
import '../../providers/custom_party_preview.dart';
import 'package:socialdeck/features/party/party.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';

//------------------------------- PromptSettingsPage -----------------------------//
class PromptSettingsPage extends ConsumerStatefulWidget {

    //classNamePage
  const PromptSettingsPage({
    super.key,
    this.onBackToParty,
    this.onCancel,
    this.showCustomSettings = true,
    this.enabled = true,
  });

  // Live Party supplies persistence; the standalone preview keeps its own flow.
  final VoidCallback? onBackToParty;
  final VoidCallback? onCancel;
  final bool showCustomSettings;
  final bool enabled;

  @override
  ConsumerState<PromptSettingsPage> createState() => _PromptSettingsState();
}

//_classNameState
class _PromptSettingsState extends ConsumerState<PromptSettingsPage> {
  bool _saving = false;

  // IA: Edit the same normal setup pages, then return directly to this summary.
  void _edit(int section) {
    if (!widget.enabled) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (editContext) {
          void done() => Navigator.of(editContext).pop();
          return switch (section) {
            0 => PromptCustomSetupPage(onConfirmed: done),
            1 => PromptCustomSetupMoodPage(onConfirmed: done),
            _ => PromptCustomSetupIntensityPage(onConfirmed: done),
          };
        },
      ),
    );
  }

  Widget _choiceRow(String title, String value, int section) => Padding(
    padding: const EdgeInsets.symmetric(vertical: SDeckSpace.padding8),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.bodySmallFigma),
              const SizedBox(height: SDeckSpace.gap4),
              // IA: Wrap complete selections instead of hiding them behind an ellipsis.
              Text(
                value,
                style: Theme.of(context).textTheme.footer.copyWith(
                  color: context.component.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: SDeckSpace.gap8),
        SDeckOutlineButton(
          key: ValueKey('settings-change-$title'),
          text: 'Change',
          size: SDeckButtonSize.small,
          shape: SDeckButtonShape.round,
          onPressed: widget.enabled ? () => _edit(section) : null,
        ),
      ],
    ),
  );

  Future<void> _setupLobby(BuildContext context) async {
    if (_saving || !widget.enabled) return;
    if (widget.onBackToParty != null) {
      widget.onBackToParty!();
      return;
    }
    setState(() => _saving = true);
    try {
      final uid = ref.read(currentUserProvider)?.uid;
      if (uid == null) throw StateError('Sign in before saving your setup.');
      var target = ref.read(customSetupTargetProvider);
      // IA: Older/direct setup routes may lack a captured target. Resolve the
      // real account session instead of ever returning the hardcoded Dev lobby.
      if (target == null) {
        final partyId = await ref
            .read(activePartyIdProvider.future)
            .timeout(const Duration(seconds: 15));
        if (!mounted) return;
        if (partyId == null)
          throw StateError('Create or join a party before saving this setup.');
        final current = await ref
            .read(partyByIdProvider(partyId).future)
            .timeout(const Duration(seconds: 15));
        if (!mounted) return;
        if (current == null)
          throw StateError('Your party is no longer available.');
        target = (uid: uid, partyId: partyId, revision: current.revision);
      }
      final party = await ref
          .read(partyByIdProvider(target.partyId).future)
          .timeout(const Duration(seconds: 15));
      if (!mounted) return;
      final draft = ref.read(gameSetupProvider);
      if (uid != target.uid ||
          ref.read(currentUserProvider)?.uid != uid ||
          party == null ||
          party.hostId != uid ||
          !party.members.containsKey(uid) ||
          party.phase != PartyPhase.lobby ||
          party.revision != target.revision ||
          !draft.canContinueGroup ||
          !draft.canContinueTopics ||
          !draft.canContinueStyle ||
          (draft.examplePrompts?.length ?? 0) < 5 ||
          !ref.read(gameSetupProvider.notifier).aiReady) {
        throw StateError(
          'This setup cannot be saved. Check your party and complete the setup first.',
        );
      }
      final game = PartyGame(
        rounds: draft.rounds,
        mixCards: draft.mixCards,
        safeMode: draft.safeMode,
      );
      final aiSession = ref.read(gameSetupProvider.notifier).finalizedAiSession;
      if (aiSession != null) {
        // IA: Save final examples and game settings atomically; never treat a failed
        // summary write as success. The lobby's Firebase stream restores it later.
        await ref
            .read(partyAiSetupRepositoryProvider)
            .save(target.partyId, target.revision, draft, aiSession);
        if (!mounted || ref.read(currentUserProvider)?.uid != target.uid)
          return;
      } else {
        // IA: Legacy explicit mock fixtures still exercise the existing Party action.
        // Production always supplies the real AI session and uses the transaction above.
        final saved = await ref
            .read(partyActionsProvider.notifier)
            .selectGame(
              target.partyId,
              game,
              expectedRevision: target.revision,
            );
        if (!mounted) return;
        if (!saved || ref.read(currentUserProvider)?.uid != target.uid) {
          throw StateError('Could not save the setup. Please try again.');
        }
        final revision =
            party.game == game ? party.revision : party.revision + 1;
        ref.read(customPartyPreviewsProvider.notifier).state = {
          ...ref.read(customPartyPreviewsProvider),
          '${target.uid}:${target.partyId}': (revision: revision, draft: draft),
        };
      }
      ref.read(customSetupTargetProvider.notifier).state = null;
      // IA: go() to the same party URL does not remove imperatively pushed
      // setup routes. Close that stack first, retaining its router-owned page.
      final router = GoRouter.of(context);
      Navigator.of(
        context,
      ).popUntil((route) => route.settings is Page || route.isFirst);
      router.go('/home/party/${target.partyId}');
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error is StateError
                  ? error.message.toString()
                  : 'Could not load or save your party. Please try again.',
            ),
          ),
        );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameSetupProvider);
    final notifier = ref.read(gameSetupProvider.notifier);
    // IA: Show actual questionnaire choices, not the old mood/keywords fields.
    final groups =
        state.groupCategories
            .expand((value) => value == 'Other' ? state.customGroups : [value])
            .toList();
    final topics =
        state.selectedTopics
            .expand((value) => value == 'Other' ? state.customTopics : [value])
            .toList();
    final style = switch (state.styleLevel) {
      'light' => 'Light (SFW)',
      'bold' => 'Bold',
      'wild' => 'Wild (NSFW)',
      _ => 'Not selected',
    };
    final chips = <(String, SDeckChipColor)>[
      for (final group in groups) (group, SDeckChipColor.tangerine),
      for (final topic in topics) (topic, SDeckChipColor.mintGreen),
      if (state.styleLevel.isNotEmpty) (style, SDeckChipColor.vibrantYellow),
    ];
    final canUpdate =
        state.canContinueGroup &&
        state.canContinueTopics &&
        state.canContinueStyle;

    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: Column(
          children: [
            SDeckTopNavigationBar(
              left: widget.onCancel == null ? SDeckTopBarLeft.none : SDeckTopBarLeft.back,
              onLeftPressed: widget.onCancel,
              type: SDeckTopBarType.subpage,
              right: SDeckTopBarRight.none,
              showTitle: false,
              centerWidget: Image.asset(
                SDeckIcon.promptdSticker,
                width: 133.953,
                height: SDeckSize.size48,
                fit: BoxFit.contain,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  SDeckSpace.margin16,
                  SDeckSpace.paddingZero,
                  SDeckSpace.margin16,
                  SDeckSpace.margin16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: SDeckSpace.gap16,
                  children: [
                    if (widget.showCustomSettings)
                      _LobbyHelper(playStyles: chips),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: SDeckSpace.gap12,
                      children: [
                        // Let the heading wrap on narrow phones.
                        Text(
                          'Game Settings',
                          style: Theme.of(context).textTheme.h6.copyWith(
                            color: context.component.navigationText,
                          ),
                        ),
                        Column(
                          children: [
                            if (widget.showCustomSettings) ...[
                              _choiceRow(
                                "Who's playing",
                                groups.isEmpty
                                    ? 'Not selected'
                                    : groups.join(', '),
                                0,
                              ),
                              if (state.groupDescription.trim().isNotEmpty)
                                _choiceRow(
                                  'About your group',
                                  state.groupDescription.trim(),
                                  0,
                                ),
                              _choiceRow(
                                'Topics',
                                topics.isEmpty
                                    ? 'Not selected'
                                    : topics.join(', '),
                                1,
                              ),
                              _choiceRow('Prompt style', style, 2),
                            ],
                            _SettingsRow(
                              title: 'Mix Cards',
                              description:
                                  "Shuffle everyone's cards and distribute.",
                              trailing: PromptSettingsToggle(
                                key: const ValueKey('party-mix-cards'),
                                value: state.mixCards,
                                onChanged: notifier.updateMixCards,
                              ),
                            ),
                            _SettingsRow(
                              title: 'Rounds',
                              description:
                                  'Play up to 5 rounds in a single game.',
                              trailing: _SettingsStepper(
                                value: state.rounds,
                                onChanged: notifier.updateRounds,
                              ),
                            ),
                            _SettingsRow(
                              title: 'Safe Mode',
                              description:
                                  'Scan and remove explicit/NSFW content.',
                              trailing: PromptSettingsToggle(
                                key: const ValueKey('party-safe-mode'),
                                value: state.safeMode,
                                onChanged: notifier.updateSafeMode,
                              ),
                            ),
                            // IA: Keep optional group age directly below Safe Mode.
                            if (widget.showCustomSettings)
                              _choiceRow(
                                'Average group age',
                                state.averageAge?.toString() ??
                                    'Not specified (optional)',
                                2,
                              ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      spacing: SDeckSpace.gap8,
                      children: [
                        if (widget.showCustomSettings)
                          SDeckOutlineButton(
                            text: 'Update Prompts',
                            size: SDeckButtonSize.large,
                            fullWidth: true,
                            enabled: widget.enabled && canUpdate,
                            onPressed:
                                widget.enabled && canUpdate
                                    ? () => Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder:
                                            (_) =>
                                                const PromptCustomSetupGeneratingPage(),
                                      ),
                                    )
                                    : null,
                          ),
                        SDeckSolidButton(
                          // IA: This action saves the setup before continuing to the party.
                          text: 'Save & Continue',
                          size: SDeckButtonSize.large,
                          fullWidth: true,
                          enabled:
                              widget.enabled &&
                              !_saving &&
                              !state.loadingDatabase,
                          onPressed:
                              widget.enabled && !_saving
                                  ? () => _setupLobby(context)
                                  : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//------------------------------- _LobbyHelper -----------------------------//
class _LobbyHelper extends StatelessWidget {
  const _LobbyHelper({required this.playStyles});

  static const double _contentWidth = 280.0;

  final List<(String, SDeckChipColor)> playStyles;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: _contentWidth,
        child: Column(
          spacing: SDeckSpace.gap12,
          children: [
            Text(
              'You chose to play based on:',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption.copyWith(
                    color: context.component.textSecondary,
                  ),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: SDeckSpace.gap4,
              runSpacing: SDeckSpace.gap4,
              children: [
                for (final (String label, SDeckChipColor color) in playStyles)
                  SDeckChip(label: label, color: color),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//------------------------------- _SettingsRow -----------------------------//
class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.title,
    required this.description,
    required this.trailing,
  });

  final String title;
  final String description;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SDeckSize.size64,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: SDeckSpace.padding8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: SDeckSpace.gap4,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmallFigma.copyWith(
                          color: context.component.selectionTargetTitleText,
                        ),
                  ),
                  Text(
                    description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.footer.copyWith(
                          color: context.semantic.secondary,
                        ),
                  ),
                ],
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

//------------------------------- PromptSettingsToggle -----------------------------//
// IA: Shared with Custom AI setup to keep the existing Safe Mode design.
class PromptSettingsToggle extends StatelessWidget {
  const PromptSettingsToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: SDeckMotionDuration.normal,
        curve: SDeckMotionCurve.easeInOut,
        width: 56,
        height: SDeckSize.size32,
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        decoration: BoxDecoration(
          color: value
              ? context.semantic.primary
              : context.semantic.tertiary,
          borderRadius: BorderRadius.circular(SDeckRadius.borderRadius24),
          border: Border.all(
            color: context.component.solidButtonBorder,
            width: SDeckSize.size4,
          ),
        ),
        child: Container(
          width: SDeckSize.size24,
          height: SDeckSize.size24,
          decoration: BoxDecoration(
            color: context.semantic.surface,
            borderRadius: BorderRadius.circular(SDeckRadius.borderRadius24),
          ),
        ),
      ),
    );
  }
}

//------------------------------- _SettingsStepper -----------------------------//
class _SettingsStepper extends StatelessWidget {
  const _SettingsStepper({required this.value, required this.onChanged});

  static const int _min = 1;
  static const int _max = 5;

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final Color iconColor = context.component.iconPrimary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: SDeckSpace.gap12,
      children: [
        GestureDetector(
          key: const ValueKey('party-rounds-decrease'),
          onTap: value > _min ? () => onChanged(value - 1) : null,
          child: SDeckIcons(
            SDeckIcon.leftChevron,
            size: SDeckSize.size36,
            color: value > _min ? iconColor : context.component.iconDisabled,
          ),
        ),
        Text(
          '$value',
          style: Theme.of(context).textTheme.h6.copyWith(
                color: context.component.selectionTargetTitleText,
              ),
        ),
        GestureDetector(
          key: const ValueKey('party-rounds-increase'),
          onTap: value < _max ? () => onChanged(value + 1) : null,
          child: SDeckIcons(
            SDeckIcon.rightChevron,
            size: SDeckSize.size36,
            color: value < _max ? iconColor : context.component.iconDisabled,
          ),
        ),
      ],
    );
  }
}
