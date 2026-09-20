/*-------------------- prompt_setup_host_page.dart -----------------------*/
// Isolated Prompt Setup Host sandbox.
// Opened from Party Dev so the host flow can be built without changing
// Home or In-Party Home. Wire into the party card tap when it is ready.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';

//------------------------------- PromptSetupHostPage -----------------------------//
class PromptSetupHostPage extends StatelessWidget {
  const PromptSetupHostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Top Navigation ------------------------//
            const SDeckTopNavigationBar(
              left: SDeckTopBarLeft.back,
              type: SDeckTopBarType.subpage,
              right: SDeckTopBarRight.none,
              title: 'Game Library',
            ),

            //------------------------ Main Content Area ---------------------//
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: SDeckSpace.margin16,
                ),
                child: Column(
                  spacing: SDeckSpace.gap12,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SDeckSectionHeader(
                      title: 'Open Beta',
                      padded: false,
                    ),
                    _PromptGameTarget(
                      onTap: () => _showPlayPromptdSheet(context),
                    ),
                    const _ComingSoonCta(),
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

void _showPlayPromptdSheet(BuildContext context) {
  showSDeckBottomSheet(
    context: context,
    title: "Play Prompt'd",
    buttons: [
      _PromptPlayOption(
        title: 'Normal',
        description: 'Quick and easy setup.',
        onTap: () {
          Navigator.of(context, rootNavigator: true).pop();
          context.push(AppPaths.defaultPartyDev);
        },
      ),
      _PromptPlayOption(
        title: 'Custom AI',
        description: 'Generate custom prompts based on inputs.',
        onTap: () {
          Navigator.of(context, rootNavigator: true).pop();
          context.push(AppPaths.promptCustomSetupDev);
        },
      ),
      SDeckOutlineButton(
        text: 'How to Play',
        size: SDeckButtonSize.large,
        fullWidth: true,
        iconLocation: SDeckButtonIconLocation.left,
        iconTextGap: SDeckSpace.gap6,
        icon: SDeckIcons(
          SDeckIcon.information,
          size: SDeckSize.size24,
          color: context.component.outlineButtonText,
        ),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          context.push(AppPaths.store);
        },
      ),
    ],
  );
}

//------------------------------- _PromptPlayOption -----------------------------//
/// Figma `imageTarget (Rive)`: H6 title + Caption description, same for
/// Normal and Custom AI.
class _PromptPlayOption extends StatelessWidget {
  const _PromptPlayOption({
    required this.title,
    required this.description,
    this.onTap,
  });

  final String title;
  final String description;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SDeckImageTarget(
      title: title,
      description: description,
      backgroundAssetPath: SDeckIcon.checkeredBackground,
      onTap: onTap,
    );
  }
}

//------------------------------- _ComingSoonCta -----------------------------//
/// Figma `CTA`: checkered placeholder + Body Large coming-soon label.
class _ComingSoonCta extends StatelessWidget {
  const _ComingSoonCta();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: SDeckSpace.gap12,
      children: [
        AspectRatio(
          aspectRatio: 370 / 185,
          child: SDeckVisualPlaceholder(
            borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
          ),
        ),
        Text(
          'More games coming soon!',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: context.component.textSecondary,
          ),
        ),
      ],
    );
  }
}

//------------------------------- _PromptGameTarget -----------------------------//
/// Figma `gameTarget`: Prompt'd sticker + player/duration info on the
/// same framed checkered card used by [SDeckSelectionTargetCard].
class _PromptGameTarget extends StatelessWidget {
  const _PromptGameTarget({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final BorderRadius outerRadius = BorderRadius.circular(
      SDeckRadius.borderRadius16,
    );
    final Color infoColor = context.semantic.secondaryVariant;

    return Material(
      type: MaterialType.transparency,
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: outerRadius,
        splashFactory: NoSplash.splashFactory,
        overlayColor: const WidgetStatePropertyAll<Color?>(Colors.transparent),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: context.semantic.surface,
            borderRadius: outerRadius,
            border: Border.all(
              color: context.component.selectionTargetBorder,
              width: SDeckSize.size4,
            ),
          ),
          child: ClipRRect(
            borderRadius: outerRadius,
            child: Stack(
              children: [
                const Positioned.fill(
                  child: IgnorePointer(
                    child: SDeckVisualPlaceholder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(SDeckSpace.padding12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          SDeckIcon.promptdSticker,
                          width: 133.953,
                          height: SDeckSize.size48,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: SDeckSpace.gap4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _GameInfoStat(
                              iconPath: SDeckIcon.player,
                              label: '2-8',
                              color: infoColor,
                            ),
                            const SizedBox(width: SDeckSpace.gap8),
                            _GameInfoStat(
                              iconPath: SDeckIcon.clock,
                              label: '10-15 mins',
                              color: infoColor,
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
        ),
      ),
    );
  }
}

//------------------------------- _GameInfoStat -----------------------------//
/// Players and duration both use a 16px icon + Label Small (footer) text.
class _GameInfoStat extends StatelessWidget {
  const _GameInfoStat({
    required this.iconPath,
    required this.label,
    required this.color,
  });

  final String iconPath;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: SDeckSize.size16,
          height: SDeckSize.size16,
          child: SDeckIcons(
            iconPath,
            size: SDeckSize.size16,
            color: color,
          ),
        ),
        const SizedBox(width: SDeckSpace.gap4),
        Text(
          label,
          style: Theme.of(context).textTheme.footer.copyWith(color: color),
        ),
      ],
    );
  }
}
