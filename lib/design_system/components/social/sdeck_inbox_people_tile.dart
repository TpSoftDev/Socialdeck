import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

enum SDeckInboxPeopleTileVariant {
  partyInvite,
  friendRequest,
  friendOnly,
}

class SDeckInboxPeopleTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final SDeckInboxPeopleTileVariant variant;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onRejectPressed;

  const SDeckInboxPeopleTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.variant,
    this.onPrimaryPressed,
    this.onRejectPressed,
  });

  @override
  Widget build(BuildContext context) {
    final showActions = variant != SDeckInboxPeopleTileVariant.friendOnly;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SDeckSpace.padding8),
      decoration: BoxDecoration(
        color: context.semantic.surface,
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius8),
        border: Border.all(
          color: context.semantic.outline,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const SDeckVisualPlaceholder(
            width: 48,
            height: 48,
            borderRadius: BorderRadius.all(
              Radius.circular(SDeckRadius.borderRadius4),
            ),
          ),
          const SizedBox(width: SDeckSpace.gap8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmallFigma.copyWith(
                        color: context.component.textPrimary,
                      ),
                ),
                const SizedBox(height: SDeckSpace.gap4),
                Text(
                  subtitle,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.footer.copyWith(
                        color: context.component.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          if (showActions) ...[
            const SizedBox(width: SDeckSpace.gap8),
            if (variant == SDeckInboxPeopleTileVariant.friendRequest) ...[
              GestureDetector(
                onTap: onRejectPressed,
                child: SDeckIcons(
                  SDeckIcon.x,
                  size: SDeckSize.size24,
                  color: context.semantic.error,
                ),
              ),
              const SizedBox(width: SDeckSpace.gap8),
            ],
            SizedBox(
              height: 40,
              child: SDeckSolidButton(
                text: variant == SDeckInboxPeopleTileVariant.partyInvite
                    ? 'Join'
                    : 'Accept',
                size: SDeckButtonSize.small,
                shape: SDeckButtonShape.round,
                onPressed: onPrimaryPressed,
              ),
            ),
          ],
        ],
      ),
    );
  }
}