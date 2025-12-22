/*----------------------------- main.dart --------------------------------*/
// Widgetbook entry point for Socialdeck design system catalog
// Configures Widgetbook with theme addon for light/dark mode switching
// Matches Widgetbook documentation: Quick Start guide
//
// Usage: Run this file to launch Widgetbook catalog.
/*--------------------------------------------------------------------------*/

/*----------------------------- Imports -------------------------------------*/
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:socialdeck/design_system/themes/sdeck_app_theme.dart';
// Generated file - created by build_runner
import 'main.directories.g.dart';

/*----------------------------- Main Entry Point ------------------------------*/
void main() {
  runApp(const WidgetbookApp());
}
/*----------------------------- WidgetbookApp ------------------------------*/
/// Widgetbook application configuration
/// Uses MaterialThemeAddon to enable light/dark theme switching
@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      //*************************** Addons **********************************//
      // Theme Addon - enables switching between light and dark themes
      addons: [
        MaterialThemeAddon(
          themes: [
            //----------------------------- Light Theme -----------------------//
            WidgetbookTheme(
              name: 'Light',
              data: SDeckAppTheme.light,
            ),
            //----------------------------- Dark Theme -------------------------//
            WidgetbookTheme(
              name: 'Dark',
              data: SDeckAppTheme.dark,
            ),
          ],
        ),
      ],
      //*************************** Directories ******************************//
      // Generated directories from use case annotations
      directories: directories,
    );
  }
}