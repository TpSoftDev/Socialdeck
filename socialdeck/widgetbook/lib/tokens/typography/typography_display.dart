/*----------------------------- typography_display.dart --------------------------------*/
// Reusable widget for displaying Typography tokens in Widgetbook
// Shows all text styles with their properties and visual examples
// Matches Figma: Text Styles
//
// Usage: Displays typography tokens organized by style type
/*--------------------------------------------------------------------------*/

/*----------------------------- Imports -------------------------------------*/
import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/tokens/colors/index.dart';
import 'package:socialdeck/design_system/tokens/spacing/index.dart';
import 'package:socialdeck/design_system/tokens/typography/index.dart';

/*----------------------------- TypographyDisplay ------------------------------*/
/// Displays all typography text styles matching Figma design exactly
/// Two-column layout: properties on left, examples on right
class TypographyDisplay extends StatelessWidget {
  const TypographyDisplay({super.key});

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
              //----------------------------- Line-Height Ratio ---------------------------//
              _TextStyleRow(
                title: 'Line-Height Ratio',
                properties: 'Multiplier: ~1.25',
                showExample: false,
              ),
              SizedBox(height: SDeckSize.size48),
              //----------------------------- H1 ---------------------------//
              _TextStyleRow(
                title: 'H1',
                properties:
                    'Weight: Bold (700)\nFont Size: 64px\nLine Height: 80px',
                exampleText: 'Heading 1',
                textStyle: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontWeight: SDeckFontWeights.bold,
                  fontSize: SDeckFontSizes.h1,
                  height: SDeckLineHeights.h1 / SDeckFontSizes.h1,
                  color: context.component.textPrimary,
                ),
              ),
              SizedBox(height: SDeckSize.size48),
              //----------------------------- H2 ---------------------------//
              _TextStyleRow(
                title: 'H2',
                properties:
                    'Weight: Bold (700)\nFont Size: 48px\nLine Height: 60px',
                exampleText: 'Heading 2',
                textStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: SDeckFontWeights.bold,
                  fontSize: SDeckFontSizes.h2,
                  height: SDeckLineHeights.h2 / SDeckFontSizes.h2,
                  color: context.component.textPrimary,
                ),
              ),
              SizedBox(height: SDeckSize.size48),
              //----------------------------- H3 ---------------------------//
              _TextStyleRow(
                title: 'H3',
                properties:
                    'Weight: SemiBold (600)\nFont Size: 40px\nLine Height: 48px',
                exampleText: 'Heading 3',
                textStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: SDeckFontWeights.semiBold,
                  fontSize: SDeckFontSizes.h3,
                  height: SDeckLineHeights.h3 / SDeckFontSizes.h3,
                  color: context.component.textPrimary,
                ),
              ),
              SizedBox(height: SDeckSize.size48),
              //----------------------------- H4 ---------------------------//
              _TextStyleRow(
                title: 'H4',
                properties:
                    'Weight: SemiBold (600)\nFont Size: 32px\nLine Height: 40px',
                exampleText: 'Heading 4',
                textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: SDeckFontWeights.semiBold,
                  fontSize: SDeckFontSizes.h4,
                  height: SDeckLineHeights.h4 / SDeckFontSizes.h4,
                  color: context.component.textPrimary,
                ),
              ),
              SizedBox(height: SDeckSize.size48),
              //----------------------------- H5 ---------------------------//
              _TextStyleRow(
                title: 'H5',
                properties:
                    'Weight: SemiBold (600)\nFont Size: 28px\nLine Height: 36px',
                exampleText: 'Heading 5',
                textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: SDeckFontWeights.semiBold,
                  fontSize: SDeckFontSizes.h5,
                  height: SDeckLineHeights.h5 / SDeckFontSizes.h5,
                  color: context.component.textPrimary,
                ),
              ),
              SizedBox(height: SDeckSize.size48),
              //----------------------------- H6 ---------------------------//
              _TextStyleRow(
                title: 'H6',
                properties:
                    'Weight: SemiBold (600)\nFont Size: 24px\nLine Height: 30px',
                exampleText: 'Heading 6',
                textStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: SDeckFontWeights.semiBold,
                  fontSize: SDeckFontSizes.h6,
                  height: SDeckLineHeights.h6 / SDeckFontSizes.h6,
                  color: context.component.textPrimary,
                ),
              ),
              SizedBox(height: SDeckSize.size48),
              //----------------------------- Body Large ---------------------------//
              _TextStyleRow(
                title: 'Body Large',
                properties:
                    'Weight: Medium (500)\nFont Size: 20px\nLine Height: 24px',
                showVariations: true,
                baseStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: SDeckFontWeights.medium,
                  fontSize: SDeckFontSizes.bodyLarge,
                  height: SDeckLineHeights.bodyLarge / SDeckFontSizes.bodyLarge,
                  color: context.component.textPrimary,
                ),
              ),
              SizedBox(height: SDeckSize.size48),
              //----------------------------- Body Medium ---------------------------//
              _TextStyleRow(
                title: 'Body Medium',
                properties:
                    'Weight: Medium (500)\nFont Size: 18px\nLine Height: 22px',
                showVariations: true,
                baseStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: SDeckFontWeights.medium,
                  fontSize: SDeckFontSizes.bodyMedium,
                  height:
                      SDeckLineHeights.bodyMedium / SDeckFontSizes.bodyMedium,
                  color: context.component.textPrimary,
                ),
              ),
              SizedBox(height: SDeckSize.size48),
              //----------------------------- Body Small ---------------------------//
              _TextStyleRow(
                title: 'Body Small',
                properties:
                    'Weight: Medium (500)\nFont Size: 16px\nLine Height: 20px',
                showVariations: true,
                baseStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: SDeckFontWeights.medium,
                  fontSize: SDeckFontSizes.bodySmall,
                  height: SDeckLineHeights.bodySmall / SDeckFontSizes.bodySmall,
                  color: context.component.textPrimary,
                ),
              ),
              SizedBox(height: SDeckSize.size48),
              //----------------------------- Caption ---------------------------//
              _TextStyleRow(
                title: 'Caption',
                properties:
                    'Weight: Medium (500)\nFont Size: 14px\nLine Height: 18px',
                showVariations: true,
                baseStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: SDeckFontWeights.medium,
                  fontSize: SDeckFontSizes.caption,
                  height: SDeckLineHeights.caption / SDeckFontSizes.caption,
                  color: context.component.textPrimary,
                ),
              ),
              SizedBox(height: SDeckSize.size48),
              //----------------------------- Label Large ---------------------------//
              _TextStyleRow(
                title: 'Label Large',
                properties:
                    'Weight: Medium (500)\nFont Size: 14px\nLine Height: 18px',
                showVariations: true,
                baseStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: SDeckFontWeights.medium,
                  fontSize: SDeckFontSizes.labelLarge,
                  height:
                      SDeckLineHeights.labelLarge / SDeckFontSizes.labelLarge,
                  color: context.component.textPrimary,
                ),
              ),
              SizedBox(height: SDeckSize.size48),
              //----------------------------- Label Small ---------------------------//
              _TextStyleRow(
                title: 'Label Small',
                properties:
                    'Weight: Medium (500)\nFont Size: 12px\nLine Height: 16px',
                showVariations: true,
                baseStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: SDeckFontWeights.medium,
                  fontSize: SDeckFontSizes.labelSmall,
                  height:
                      SDeckLineHeights.labelSmall / SDeckFontSizes.labelSmall,
                  color: context.component.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*----------------------------- _TextStyleRow ------------------------------*/
/// Row displaying text style with properties on left and example on right
/// Matches Figma two-column layout exactly
class _TextStyleRow extends StatelessWidget {
  const _TextStyleRow({
    required this.title,
    required this.properties,
    this.exampleText,
    this.textStyle,
    this.showVariations = false,
    this.baseStyle,
    this.showExample = true,
  });

  final String title;
  final String properties;
  final String? exampleText;
  final TextStyle? textStyle;
  final bool showVariations;
  final TextStyle? baseStyle;
  final bool showExample;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: context.semantic.outlineVariant, width: 3),
        ),
      ),
      padding: const EdgeInsets.only(bottom: SDeckSpace.padding48),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //----------------------------- Properties Column -----------------------//
          Expanded(
            child: Column(
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
                  properties,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: context.component.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: SDeckSize.size24),
          //----------------------------- Example Column -----------------------//
          if (showExample)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showVariations && baseStyle != null)
                    _TextVariations(style: baseStyle!)
                  else if (exampleText != null && textStyle != null)
                    Text(exampleText!, style: textStyle),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/*----------------------------- _TextVariations ------------------------------*/
/// Shows text variations (Normal, Strong, Underlined, Delete, Italic)
/// Stacked vertically matching Figma
class _TextVariations extends StatelessWidget {
  const _TextVariations({required this.style});

  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Normal', style: style),
        SizedBox(height: 4),
        Text(
          'Strong',
          style: style.copyWith(fontWeight: SDeckFontWeights.bold),
        ),
        SizedBox(height: 4),
        Text(
          'Underlined',
          style: style.copyWith(
            decoration: TextDecoration.underline,
            decorationColor: style.color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Delete',
          style: style.copyWith(
            decoration: TextDecoration.lineThrough,
            decorationColor: style.color,
          ),
        ),
        SizedBox(height: 4),
        Text('Italic', style: style.copyWith(fontStyle: FontStyle.italic)),
      ],
    );
  }
}
