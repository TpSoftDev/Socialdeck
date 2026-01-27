/*----------------------------- space_display.dart --------------------------------*/
// Visual display for Space tokens
// Shows Margin, Padding, and Gap with visual examples
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/tokens/colors/index.dart';
import 'package:socialdeck/design_system/tokens/spacing/index.dart';

/*----------------------------- SpaceDisplay ------------------------------*/
/// Displays all Space tokens (Margin, Padding, Gap) with visual examples
class SpaceDisplay extends StatelessWidget {
  const SpaceDisplay({super.key});

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
              //----------------------------- Margin Section ---------------------------//
              _SpaceSection(
                title: 'Margin',
                description: 'Defines outer spacing between components.',
                type: SpaceType.margin,
                tokens: [
                  {'name': 'marginZero', 'value': '0px', 'size': SDeckSpace.marginZero},
                  {'name': 'margin4', 'value': '4px', 'size': SDeckSpace.margin4},
                  {'name': 'margin8', 'value': '8px', 'size': SDeckSpace.margin8},
                  {'name': 'margin12', 'value': '12px', 'size': SDeckSpace.margin12},
                  {'name': 'margin16', 'value': '16px', 'size': SDeckSpace.margin16},
                  {'name': 'margin24', 'value': '24px', 'size': SDeckSpace.margin24},
                  {'name': 'margin32', 'value': '32px', 'size': SDeckSpace.margin32},
                  {'name': 'margin48', 'value': '48px', 'size': SDeckSpace.margin48},
                ],
              ),
              SizedBox(height: SDeckSize.size48),
              //----------------------------- Padding Section ---------------------------//
              _SpaceSection(
                title: 'Padding',
                description: 'Defines inner spacing within components.',
                type: SpaceType.padding,
                tokens: [
                  {'name': 'paddingZero', 'value': '0px', 'size': SDeckSpace.paddingZero},
                  {'name': 'padding4', 'value': '4px', 'size': SDeckSpace.padding4},
                  {'name': 'padding8', 'value': '8px', 'size': SDeckSpace.padding8},
                  {'name': 'padding12', 'value': '12px', 'size': SDeckSpace.padding12},
                  {'name': 'padding16', 'value': '16px', 'size': SDeckSpace.padding16},
                  {'name': 'padding24', 'value': '24px', 'size': SDeckSpace.padding24},
                  {'name': 'padding32', 'value': '32px', 'size': SDeckSpace.padding32},
                  {'name': 'padding48', 'value': '48px', 'size': SDeckSpace.padding48},
                ],
              ),
              SizedBox(height: SDeckSize.size48),
              //----------------------------- Gap Section ---------------------------//
              _SpaceSection(
                title: 'Gap',
                description: 'Defines spacing between items in a layout or group.',
                type: SpaceType.gap,
                tokens: [
                  {'name': 'gapZero', 'value': '0px', 'size': SDeckSpace.gapZero},
                  {'name': 'gap4', 'value': '4px', 'size': SDeckSpace.gap4},
                  {'name': 'gap8', 'value': '8px', 'size': SDeckSpace.gap8},
                  {'name': 'gap12', 'value': '12px', 'size': SDeckSpace.gap12},
                  {'name': 'gap16', 'value': '16px', 'size': SDeckSpace.gap16},
                  {'name': 'gap24', 'value': '24px', 'size': SDeckSpace.gap24},
                  {'name': 'gap32', 'value': '32px', 'size': SDeckSpace.gap32},
                  {'name': 'gap48', 'value': '48px', 'size': SDeckSpace.gap48},
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*----------------------------- SpaceType ------------------------------*/
enum SpaceType { margin, padding, gap }

/*----------------------------- _SpaceSection ------------------------------*/
/// Section with title, description, and visual examples
class _SpaceSection extends StatelessWidget {
  const _SpaceSection({
    required this.title,
    required this.description,
    required this.type,
    required this.tokens,
  });

  final String title;
  final String description;
  final SpaceType type;
  final List<Map<String, dynamic>> tokens;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: context.component.textPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: SDeckSize.size24),
        Text(
          description,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: context.component.textSecondary,
              ),
        ),
        SizedBox(height: SDeckSize.size32),
        ...tokens.map((token) => _SpaceItem(
              name: token['name']!,
              value: token['value']!,
              size: token['size']!,
              type: type,
            )),
      ],
    );
  }
}

/*----------------------------- _SpaceItem ------------------------------*/
/// Individual space token with visual example
class _SpaceItem extends StatelessWidget {
  const _SpaceItem({
    required this.name,
    required this.value,
    required this.size,
    required this.type,
  });

  final String name;
  final String value;
  final double size;
  final SpaceType type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SDeckSize.size32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //----------------------------- Label and Value ---------------------------//
          Row(
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: context.component.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              SizedBox(width: SDeckSize.size12),
              Text(
                value,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: context.component.textSecondary,
                    ),
              ),
            ],
          ),
          SizedBox(height: SDeckSize.size16),
          //----------------------------- Visual Example ---------------------------//
          _VisualExample(size: size, type: type),
        ],
      ),
    );
  }
}

/*----------------------------- _VisualExample ------------------------------*/
/// Visual representation of spacing
class _VisualExample extends StatelessWidget {
  const _VisualExample({
    required this.size,
    required this.type,
  });

  final double size;
  final SpaceType type;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case SpaceType.margin:
        return _MarginExample(size: size);
      case SpaceType.padding:
        return _PaddingExample(size: size);
      case SpaceType.gap:
        return _GapExample(size: size);
    }
  }
}

/*----------------------------- _MarginExample ------------------------------*/
/// Shows two boxes with margin between them
class _MarginExample extends StatelessWidget {
  const _MarginExample({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Box(),
        SizedBox(width: size),
        _Box(),
      ],
    );
  }
}

/*----------------------------- _PaddingExample ------------------------------*/
/// Shows a box with padding (outer box vs inner content)
class _PaddingExample extends StatelessWidget {
  const _PaddingExample({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(size),
      decoration: BoxDecoration(
        color: context.semantic.surfaceVariant,
        border: Border.all(
          color: context.semantic.primary,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius8),
      ),
      child: Container(
        width: 60,
        height: 40,
        decoration: BoxDecoration(
          color: context.semantic.primary,
          borderRadius: BorderRadius.circular(SDeckRadius.borderRadius4),
        ),
      ),
    );
  }
}

/*----------------------------- _GapExample ------------------------------*/
/// Shows multiple items with gap spacing
class _GapExample extends StatelessWidget {
  const _GapExample({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: size,
      runSpacing: size,
      children: List.generate(3, (index) => _Box()),
    );
  }
}

/*----------------------------- _Box ------------------------------*/
/// Simple box for visual examples
class _Box extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 40,
      decoration: BoxDecoration(
        color: context.semantic.primary,
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius8),
      ),
    );
  }
}

