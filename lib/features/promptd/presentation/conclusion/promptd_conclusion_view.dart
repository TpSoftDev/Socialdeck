/*------------------- promptd_conclusion_view.dart -----------------------*/
// Prompt'd conclusion. Stateless snapshot of the host or player frame.
// Empty top bar, thanks line, Prompt'd sticker, visual placeholder, then
// the actions. Light and dark colors come from the theme.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

enum PromptdConclusionRole { host, player }

//---------------------------- PromptdConclusionView ---------------------------//
class PromptdConclusionView extends StatelessWidget {
  const PromptdConclusionView({
    super.key,
    required this.role,
    this.onPlayAgain,
    this.onChangeSettings,
    this.onBackToParty,
  });

  final PromptdConclusionRole role;

  /// The game screen supplies these. A missing callback still leaves the
  /// button enabled so the frame matches the design.
  final VoidCallback? onPlayAgain;
  final VoidCallback? onChangeSettings;
  final VoidCallback? onBackToParty;

  static const double _stickerAspect = 133.9534912109375 / 48;
  static const double _placeholderAspect = 370 / 185;

  bool get _isHost => role == PromptdConclusionRole.host;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.semantic.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SDeckPromptdTopBar(
            showRoundDetails: false,
            showPause: false,
            showRightIcon: false,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  SDeckSpace.padding16,
                  0,
                  SDeckSpace.padding16,
                  SDeckSpace.margin48,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Thanks for playing!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.h6.copyWith(
                        color: context.component.textPrimary,
                      ),
                    ),
                    const SizedBox(height: SDeckSpace.gap16),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(
                        SDeckSpace.margin24,
                        0,
                        SDeckSpace.margin24,
                        SDeckSpace.margin16,
                      ),
                      child: AspectRatio(
                        aspectRatio: _stickerAspect,
                        child: Image(
                          image: AssetImage(SDeckIcon.promptdSticker),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: SDeckSpace.gap16),
                    const AspectRatio(
                      aspectRatio: _placeholderAspect,
                      child: SDeckVisualPlaceholder(),
                    ),
                    const SizedBox(height: SDeckSpace.gap16),
                    if (_isHost) ...[
                      SDeckSolidButton(
                        text: 'Play Again',
                        size: SDeckButtonSize.large,
                        fullWidth: true,
                        iconTextGap: SDeckSpace.gap6,
                        iconLocation: SDeckButtonIconLocation.left,
                        icon: SDeckIcons(
                          SDeckIcon.redo,
                          size: SDeckSize.size24,
                          color: context.component.solidButtonText,
                        ),
                        onPressed: onPlayAgain ?? () {},
                      ),
                      const SizedBox(height: SDeckSpace.gap8),
                      SDeckOutlineButton(
                        text: 'Change Settings',
                        size: SDeckButtonSize.large,
                        fullWidth: true,
                        iconTextGap: SDeckSpace.gap6,
                        iconLocation: SDeckButtonIconLocation.left,
                        icon: SDeckIcons(
                          SDeckIcon.settings,
                          size: SDeckSize.size24,
                          color: context.component.outlineButtonText,
                        ),
                        onPressed: onChangeSettings ?? () {},
                      ),
                      const SizedBox(height: SDeckSpace.gap8),
                      SDeckTextButton(
                        text: 'Back to Party',
                        size: SDeckButtonSize.large,
                        fullWidth: true,
                        onPressed: onBackToParty ?? () {},
                      ),
                    ] else
                      SDeckSolidButton(
                        text: 'Back to Party',
                        size: SDeckButtonSize.large,
                        fullWidth: true,
                        onPressed: onBackToParty ?? () {},
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
