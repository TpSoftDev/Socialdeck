/*-------------------- playing_card_test_page.dart -----------------------*/
// Playground for SDeckPlayingCard variants: size, shadow, and state.
// Open from Dev Hub to compare against the design system component set.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

//------------------------------- PlayingCardTestPage ------------------------//
class PlayingCardTestPage extends StatelessWidget {
  const PlayingCardTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SDeckTopNavigationBar(
              left: SDeckTopBarLeft.back,
              type: SDeckTopBarType.subpage,
              right: SDeckTopBarRight.none,
              title: 'Playing Card',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  SDeckSpace.padding16,
                  SDeckSpace.padding8,
                  SDeckSpace.padding16,
                  SDeckSpace.padding48,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle(context, 'Sizes (Default, No Shadow)'),
                    const SizedBox(height: SDeckSpace.gap16),
                    _wrapRow([
                      for (final size in SDeckPlayingCardSize.values.reversed)
                        _labeledCard(
                          context,
                          label: size.name,
                          child: SDeckPlayingCard(
                            size: size,
                            shadow: SDeckPlayingCardShadow.none,
                            state: SDeckPlayingCardState.default_,
                          ),
                        ),
                    ]),
                    const SizedBox(height: SDeckSpace.gap32),
                    _sectionTitle(context, 'Shadows (Medium, Default)'),
                    const SizedBox(height: SDeckSpace.gap16),
                    _wrapRow([
                      for (final shadow in SDeckPlayingCardShadow.values)
                        _labeledCard(
                          context,
                          label: shadow.name,
                          child: SDeckPlayingCard(
                            size: SDeckPlayingCardSize.medium,
                            shadow: shadow,
                            state: SDeckPlayingCardState.default_,
                          ),
                        ),
                    ]),
                    const SizedBox(height: SDeckSpace.gap32),
                    _sectionTitle(context, 'Default Matrix (Size x Shadow)'),
                    const SizedBox(height: SDeckSpace.gap16),
                    for (final size in SDeckPlayingCardSize.values.reversed) ...[
                      Text(
                        size.name,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.component.textSecondary,
                        ),
                      ),
                      const SizedBox(height: SDeckSpace.gap8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            for (final shadow
                                in SDeckPlayingCardShadow.values) ...[
                              _labeledCard(
                                context,
                                label: shadow.name,
                                child: SDeckPlayingCard(
                                  size: size,
                                  shadow: shadow,
                                  state: SDeckPlayingCardState.default_,
                                ),
                              ),
                              const SizedBox(width: SDeckSpace.gap16),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: SDeckSpace.gap24),
                    ],
                    _sectionTitle(context, 'Selected'),
                    const SizedBox(height: SDeckSpace.gap16),
                    _wrapRow([
                      for (final size in SDeckPlayingCardSize.values)
                        _labeledCard(
                          context,
                          label: size.name,
                          child: SDeckPlayingCard(
                            size: size,
                            shadow: SDeckPlayingCardShadow.none,
                            state: SDeckPlayingCardState.selected,
                          ),
                        ),
                    ]),
                    const SizedBox(height: SDeckSpace.gap32),
                    _sectionTitle(context, 'Move (Held)'),
                    const SizedBox(height: SDeckSpace.gap16),
                    _wrapRow([
                      for (final size in SDeckPlayingCardSize.values)
                        _labeledCard(
                          context,
                          label: size.name,
                          child: SDeckPlayingCard(
                            size: size,
                            shadow: SDeckPlayingCardShadow.high,
                            state: SDeckPlayingCardState.moveHeld,
                          ),
                        ),
                    ]),
                    const SizedBox(height: SDeckSpace.gap32),
                    _sectionTitle(context, 'Remove'),
                    const SizedBox(height: SDeckSpace.gap16),
                    _wrapRow([
                      for (final size in SDeckPlayingCardSize.values)
                        _labeledCard(
                          context,
                          label: size.name,
                          child: SDeckPlayingCard(
                            size: size,
                            shadow: SDeckPlayingCardShadow.none,
                            state: SDeckPlayingCardState.remove,
                            onRemove: () {},
                          ),
                        ),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: context.component.textPrimary,
      ),
    );
  }

  Widget _wrapRow(List<Widget> children) {
    return Wrap(
      spacing: SDeckSpace.gap16,
      runSpacing: SDeckSpace.gap16,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: children,
    );
  }

  Widget _labeledCard(
    BuildContext context, {
    required String label,
    required Widget child,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        const SizedBox(height: SDeckSpace.gap8),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: context.component.textSecondary,
          ),
        ),
      ],
    );
  }
}
