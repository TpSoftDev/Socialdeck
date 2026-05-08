import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

class SDeckSocialUserTile extends StatelessWidget {
  final String username;
  final String subtitle;
  final VoidCallback? onTap;

  const SDeckSocialUserTile({
    super.key,
    required this.username,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SDeckRadius.borderRadius12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: SDeckSpace.padding4),
        child: Row(
          children: [
            SDeckVisualPlaceholder(
              width: 48,
              height: 48,
              borderRadius: BorderRadius.circular(SDeckRadius.borderRadius24),
            ),
            const SizedBox(width: SDeckSpace.gap8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: Theme.of(context).textTheme.bodySmallFigma.copyWith(
                          color: context.component.textPrimary,
                        ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.footer.copyWith(
                          color: context.component.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}