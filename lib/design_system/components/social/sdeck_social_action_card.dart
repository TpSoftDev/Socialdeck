import 'package:flutter/material.dart';
import '../../tokens/index.dart';
import '../../themes/text_theme.dart';
import '../../helpers/index.dart';
import '../placeholders/sdeck_visual_placeholder.dart';

class SDeckSocialActionCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onTap;

  const SDeckSocialActionCard({
    super.key,
    required this.title,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius12),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 88,
          padding: const EdgeInsets.all(SDeckSpace.padding16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SDeckRadius.borderRadius12),
            border: Border.all(color: context.semantic.outline, width: 4),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              const Positioned.fill(
                child: SDeckVisualPlaceholder(
                  height: 88,
                  borderRadius: BorderRadius.all(
                    Radius.circular(SDeckRadius.borderRadius8),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.h5.copyWith(
                          color: context.component.textPrimary,
                        ),
                  ),
                  const SizedBox(height: SDeckSpace.gap4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMediumFigma.copyWith(
                          color: context.component.textSecondary,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}