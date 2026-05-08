import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

class SDeckSuggestedFriendCard extends StatelessWidget {
  final String username;
  final String subtitle;
  final VoidCallback? onTap;

  const SDeckSuggestedFriendCard({
    super.key,
    required this.username,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 104,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
        child: Column(
          children: [
            SDeckVisualPlaceholder(
              width: 96,
              height: 96,
              borderRadius: BorderRadius.circular(SDeckRadius.borderRadius48),
            ),
            const SizedBox(height: SDeckSpace.gap4),
            Text(
              username,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption.copyWith(
                    color: context.component.textPrimary,
                  ),
            ),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.footer.copyWith(
                    color: context.component.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}