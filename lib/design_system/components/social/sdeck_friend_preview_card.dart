import 'package:flutter/material.dart';
import '../../tokens/index.dart';
import '../../themes/text_theme.dart';
import '../../helpers/index.dart';
import '../placeholders/sdeck_visual_placeholder.dart';

class SDeckFriendPreviewCard extends StatelessWidget {
  final String username;
  final String status;

  const SDeckFriendPreviewCard({
    super.key,
    required this.username,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 166,
      decoration: BoxDecoration(
        color: context.semantic.surfaceInfo,
        border: Border.all(color: context.semantic.info),
      ),
      child: Column(
        children: [
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(SDeckSpace.padding4),
              child: SDeckVisualPlaceholder(
                height: 100,
                borderRadius: BorderRadius.all(
                  Radius.circular(SDeckRadius.borderRadius48),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: SDeckSpace.padding8,
              right: SDeckSpace.padding8,
              bottom: SDeckSpace.padding8,
            ),
            child: Column(
              children: [
                Text(
                  username,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmallFigma.copyWith(
                        color: context.component.textPrimary,
                      ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: context.semantic.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: SDeckSpace.gap4),
                    Flexible(
                      child: Text(
                        status,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption.copyWith(
                              color: context.component.textSecondary,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}