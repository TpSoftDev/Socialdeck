/*-------------------- prompt_settings_page.dart -----------------------*/
// Prompt'd Settings after custom setup Complete.
// Assembled from existing design system pieces: top bar + sticker, chips,
// section header, outline/solid buttons. Toggle and stepper rows are composed
// from tokens until those land as shared selection-target components.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/games/providers/game_setup_provider.dart';

//------------------------------- PromptSettingsPage -----------------------------//
class PromptSettingsPage extends ConsumerStatefulWidget {

    //classNamePage
  const PromptSettingsPage({
    super.key,
    this.onBackToParty,
    this.showCustomSettings = true,
    this.enabled = true,
  });

  // Live Party supplies persistence; the standalone preview keeps its own flow.
  final VoidCallback? onBackToParty;
  final bool showCustomSettings;
  final bool enabled;

  @override
  ConsumerState<PromptSettingsPage> createState() => _PromptSettingsState();
}
//_classNameState
class _PromptSettingsState extends ConsumerState<PromptSettingsPage>{

  /*static const List<(String, SDeckChipColor)> _playStyles = [
    ('Coworkers', SDeckChipColor.tangerine),
    ('Dark Humor', SDeckChipColor.mintGreen),
    ('Brainrot', SDeckChipColor.vibrantYellow),
  ];*/

  Future<void> _createPlayStyles() async {
    ref.read(gameSetupProvider.notifier).setPlayStyles();
  }

  @override
  void initState() {
    super.initState();
    // Defer provider updates until the page has finished mounting.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _createPlayStyles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameSetupProvider);
    final notifier = ref.read(gameSetupProvider.notifier);
    final bool settingsUpdated =
        state.mixCards || state.safeMode || state.rounds != 3;

    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: Column(
          children: [
            SDeckTopNavigationBar(
              left: SDeckTopBarLeft.none,
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
                      _LobbyHelper(playStyles: state.playStyles),
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
                            _SettingsRow(
                              title: 'Environment',
                              description: state.playingWith,
                              trailing: SDeckOutlineButton(
                                text: 'Change',
                                size: SDeckButtonSize.small,
                                shape: SDeckButtonShape.round,
                                onPressed: () => context.push(
                                  AppPaths.promptCustomSetupDev,
                                ),
                              ),
                            ),
                            _SettingsRow(
                              title: 'Mood',
                              description: state.gameMood,
                              trailing: SDeckOutlineButton(
                                text: 'Change',
                                size: SDeckButtonSize.small,
                                shape: SDeckButtonShape.round,
                                onPressed: () => context.push(
                                  AppPaths.promptCustomSetupMoodDev,
                                ),
                              ),
                            ),
                            _SettingsRow(
                              title: 'Keywords',
                              description: state.gameKeywords,
                              trailing: SDeckOutlineButton(
                                text: 'Change',
                                size: SDeckButtonSize.small,
                                shape: SDeckButtonShape.round,
                                onPressed: () => context.push(
                                  AppPaths.promptCustomSetupKeywordsDev,
                                ),
                              ),
                            ),
                            ],
                            _SettingsRow(
                              title: 'Mix Cards',
                              description:
                                  "Shuffle everyone's cards and distribute.",
                              trailing: _SettingsToggle(
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
                              trailing: _SettingsToggle(
                                key: const ValueKey('party-safe-mode'),
                                value: state.safeMode,
                                onChanged: notifier.updateSafeMode,
                              ),
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
                          enabled: widget.enabled && settingsUpdated,
                          onPressed: widget.enabled && settingsUpdated
                              ? () => context.push(
                                    AppPaths.promptCustomSetupGeneratingDev,
                                  )
                              : null,
                        ),
                        SDeckSolidButton(
                          text: 'Back to Party',
                          size: SDeckButtonSize.large,
                          fullWidth: true,
                          enabled: widget.enabled,
                          onPressed: widget.enabled
                              ? widget.onBackToParty ?? () {
                                  if (context.canPop()) {
                                    context.pop();
                                  } else {
                                    context.go(AppPaths.inviteSheetDev);
                                  }
                                }
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

//------------------------------- _SettingsToggle -----------------------------//
class _SettingsToggle extends StatelessWidget {
  const _SettingsToggle({super.key, required this.value, required this.onChanged});

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
  const _SettingsStepper({
    required this.value,
    required this.onChanged,
  });

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
