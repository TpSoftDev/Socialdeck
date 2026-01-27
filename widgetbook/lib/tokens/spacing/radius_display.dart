/*----------------------------- radius_display.dart --------------------------------*/
// Visual display for Radius tokens
// Shows shapes with different border radius values applied
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/tokens/colors/index.dart';
import 'package:socialdeck/design_system/tokens/spacing/index.dart';

/*----------------------------- RadiusDisplay ------------------------------*/
/// Displays all Radius tokens with visual shapes showing the border radius
class RadiusDisplay extends StatelessWidget {
  const RadiusDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.semantic.surface,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(SDeckSpace.padding24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //----------------------------- Section Title ---------------------------//
              Text(
                'Border Radius',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: context.component.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: SDeckSize.size32),
              //----------------------------- Radius Grid ---------------------------//
              Wrap(
                spacing: SDeckSize.size24,
                runSpacing: SDeckSize.size32,
                children: _radiusTokens.map((token) => _RadiusItem(
                      name: token['name']!,
                      value: token['value']!,
                      radius: token['radius']!,
                    )).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static final List<Map<String, dynamic>> _radiusTokens = [
    {'name': 'zero', 'value': '0px', 'radius': SDeckRadius.borderRadiusZero},
    {'name': 'borderRadius2', 'value': '2px', 'radius': SDeckRadius.borderRadius2},
    {'name': 'borderRadius4', 'value': '4px', 'radius': SDeckRadius.borderRadius4},
    {'name': 'borderRadius8', 'value': '8px', 'radius': SDeckRadius.borderRadius8},
    {'name': 'borderRadius12', 'value': '12px', 'radius': SDeckRadius.borderRadius12},
    {'name': 'borderRadius16', 'value': '16px', 'radius': SDeckRadius.borderRadius16},
    {'name': 'borderRadius24', 'value': '24px', 'radius': SDeckRadius.borderRadius24},
    {'name': 'borderRadius32', 'value': '32px', 'radius': SDeckRadius.borderRadius32},
    {'name': 'borderRadius48', 'value': '48px', 'radius': SDeckRadius.borderRadius48},
  ];
}

/*----------------------------- _RadiusItem ------------------------------*/
/// Individual radius token with visual shape
class _RadiusItem extends StatelessWidget {
  const _RadiusItem({
    required this.name,
    required this.value,
    required this.radius,
  });

  final String name;
  final String value;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final isFull = radius >= 999;
    final shapeSize = isFull ? 120.0 : 80.0;

    return Column(
      children: [
        //----------------------------- Shape ---------------------------//
        Container(
          width: shapeSize,
          height: shapeSize,
          decoration: BoxDecoration(
            color: context.semantic.surfaceVariant,
            border: Border.all(
              color: context.semantic.primary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(radius),
            shape: isFull ? BoxShape.circle : BoxShape.rectangle,
          ),
        ),
        SizedBox(height: SDeckSize.size12),
        //----------------------------- Label ---------------------------//
        Text(
          name,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: context.component.textPrimary,
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: SDeckSize.size4),
        //----------------------------- Value ---------------------------//
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: context.component.textSecondary,
              ),
        ),
      ],
    );
  }
}

