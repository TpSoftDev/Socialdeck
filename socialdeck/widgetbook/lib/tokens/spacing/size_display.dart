/*----------------------------- size_display.dart --------------------------------*/
// Visual display for Size tokens
// Shows size tokens with visual bars that scale proportionally
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/tokens/colors/index.dart';
import 'package:socialdeck/design_system/tokens/spacing/index.dart';

/*----------------------------- SizeDisplay ------------------------------*/
/// Displays all Size tokens with visual bars showing relative sizes
class SizeDisplay extends StatelessWidget {
  const SizeDisplay({super.key});

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
                'Size',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: context.component.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: SDeckSize.size32),
              //----------------------------- Size Items ---------------------------//
              ..._sizeTokens.map((token) => _SizeItem(
                    name: token['name']! as String,
                    value: token['value']! as String,
                    size: token['size']! as double,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  static final List<Map<String, dynamic>> _sizeTokens = [
    {'name': 'zero', 'value': '0px', 'size': SDeckSize.sizeZero},
    {'name': 'size1', 'value': '1px', 'size': SDeckSize.size1},
    {'name': 'size2', 'value': '2px', 'size': SDeckSize.size2},
    {'name': 'size3', 'value': '3px', 'size': SDeckSize.size3},
    {'name': 'size4', 'value': '4px', 'size': SDeckSize.size4},
    {'name': 'size8', 'value': '8px', 'size': SDeckSize.size8},
    {'name': 'size12', 'value': '12px', 'size': SDeckSize.size12},
    {'name': 'size16', 'value': '16px', 'size': SDeckSize.size16},
    {'name': 'size24', 'value': '24px', 'size': SDeckSize.size24},
    {'name': 'size32', 'value': '32px', 'size': SDeckSize.size32},
    {'name': 'size48', 'value': '48px', 'size': SDeckSize.size48},
    {'name': 'size64', 'value': '64px', 'size': SDeckSize.size64},
    {'name': 'size80', 'value': '80px', 'size': SDeckSize.size80},
    {'name': 'size96', 'value': '96px', 'size': SDeckSize.size96},
    {'name': 'size108', 'value': '108px', 'size': SDeckSize.size108},
    {'name': 'size120', 'value': '120px', 'size': SDeckSize.size120},
  ];
}

/*----------------------------- _SizeItem ------------------------------*/
/// Individual size token with visual bar representation
class _SizeItem extends StatelessWidget {
  const _SizeItem({
    required this.name,
    required this.value,
    required this.size,
  });

  final String name;
  final String value;
  final double size;

  @override
  Widget build(BuildContext context) {
    // Calculate bar width - scale proportionally with max width of 400px
    final maxSize = 120.0;
    final maxBarWidth = 400.0;
    final barWidth = (size == 0 ? 0.0 : (size / maxSize) * maxBarWidth).toDouble();
    
    // Bar height varies: thin lines for small values, wider rectangles for large
    final barHeight = size <= 16 ? 2.0 : (size <= 32 ? 8.0 : 16.0);
    
    // Border radius for larger bars
    final borderRadius = size >= 48 ? SDeckRadius.borderRadius4.toDouble() : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: SDeckSize.size24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //----------------------------- Label ---------------------------//
          SizedBox(
            width: 80,
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: context.component.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          SizedBox(width: SDeckSize.size16),
          //----------------------------- Value ---------------------------//
          SizedBox(
            width: 60,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: context.component.textSecondary,
                  ),
            ),
          ),
          SizedBox(width: SDeckSize.size24),
          //----------------------------- Visual Bar ---------------------------//
          Expanded(
            child: Container(
              height: barHeight,
              width: barWidth,
              decoration: BoxDecoration(
                color: context.semantic.primary,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

