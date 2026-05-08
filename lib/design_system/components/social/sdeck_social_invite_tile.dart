import 'package:flutter/material.dart';
import '../../tokens/index.dart';
import '../../themes/text_theme.dart';

class SDeckSocialInviteTile extends StatelessWidget {
  final String username;
  final String subtitle;
  final String actionLabel;
  final VoidCallback? onPressed;

  const SDeckSocialInviteTile({
    super.key,
    required this.username,
    required this.subtitle,
    this.actionLabel = 'Join',
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        SDeckSpace.padding16,
        SDeckSpace.padding8,
        SDeckSpace.padding8,
        SDeckSpace.padding8,
      ),
      decoration: BoxDecoration(
        color: context.semantic.surface,
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius12),
        border: Border.all(color: context.semantic.outline, width: 4),
      ),
      child: Row(
        children: [
          Expanded(
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyMediumFigma.copyWith(
                    color: context.component.textPrimary,
                  ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: context.component.textPrimary,
                        ) ??
                        TextStyle(
                          color: context.component.textPrimary,
                        ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMediumFigma.copyWith(
                          color: context.component.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: context.semantic.primary,
                foregroundColor: context.semantic.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SDeckRadius.borderRadius24),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: SDeckSpace.padding24,
                ),
              ),
              onPressed: onPressed,
              child: Text(
                actionLabel,
                style: Theme.of(context).textTheme.bodyMediumFigma.copyWith(
                      color: context.semantic.onPrimary,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}