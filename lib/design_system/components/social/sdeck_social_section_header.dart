import 'package:flutter/material.dart';
import '../../tokens/index.dart';
import '../../themes/text_theme.dart';
import '../../helpers/index.dart';

class SDeckSocialSectionHeader extends StatelessWidget {
  final String title;
  final bool showUnreadDot;
  final Widget? trailing;

  const SDeckSocialSectionHeader({
    super.key,
    required this.title,
    this.showUnreadDot = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
      decoration: BoxDecoration(
        color: context.semantic.surfaceVariant,
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius12),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.h5.copyWith(
                  color: context.component.textPrimary,
                ),
          ),
          if (showUnreadDot) ...[
            const SizedBox(width: SDeckSpace.gap8),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: context.semantic.info,
                shape: BoxShape.circle,
              ),
            ),
          ],
          const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}