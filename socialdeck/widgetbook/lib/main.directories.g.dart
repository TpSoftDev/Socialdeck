// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:socialdeck_widgetbook/placeholder_use_case.dart'
    as _socialdeck_widgetbook_placeholder_use_case;
import 'package:socialdeck_widgetbook/tokens/colors/base_color_palette.dart'
    as _socialdeck_widgetbook_tokens_colors_base_color_palette;
import 'package:socialdeck_widgetbook/tokens/colors/neutral_base_color_palette.dart'
    as _socialdeck_widgetbook_tokens_colors_neutral_base_color_palette;
import 'package:widgetbook/widgetbook.dart' as _widgetbook;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookFolder(
    name: 'tokens',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'colors',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'BaseColorPalette',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Bright Coral',
                builder: _socialdeck_widgetbook_tokens_colors_base_color_palette
                    .buildBrightCoralUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Lavender',
                builder: _socialdeck_widgetbook_tokens_colors_base_color_palette
                    .buildLavenderUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Mint Green',
                builder: _socialdeck_widgetbook_tokens_colors_base_color_palette
                    .buildMintGreenUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Sky Blue',
                builder: _socialdeck_widgetbook_tokens_colors_base_color_palette
                    .buildSkyBlueUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Tangerine',
                builder: _socialdeck_widgetbook_tokens_colors_base_color_palette
                    .buildTangerineUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Vibrant Yellow',
                builder: _socialdeck_widgetbook_tokens_colors_base_color_palette
                    .buildVibrantYellowUseCase,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'NeutralBaseColorPalette',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Black',
                builder:
                    _socialdeck_widgetbook_tokens_colors_neutral_base_color_palette
                        .buildBlackUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Cool Gray',
                builder:
                    _socialdeck_widgetbook_tokens_colors_neutral_base_color_palette
                        .buildCoolGrayUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Slate Gray',
                builder:
                    _socialdeck_widgetbook_tokens_colors_neutral_base_color_palette
                        .buildSlateGrayUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Warm Off White',
                builder:
                    _socialdeck_widgetbook_tokens_colors_neutral_base_color_palette
                        .buildWarmOffWhiteUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'White',
                builder:
                    _socialdeck_widgetbook_tokens_colors_neutral_base_color_palette
                        .buildWhiteUseCase,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'widgets',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'Container',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _socialdeck_widgetbook_placeholder_use_case
                .buildPlaceholderUseCase,
          ),
        ],
      ),
    ],
  ),
];
