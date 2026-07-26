/*-------------------- color_picker_test_page.dart -----------------------*/
// Playground for SDeckSwatch and SDeckColorPicker.
// Open from Dev Hub to compare against the design system component set.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

//------------------------------- ColorPickerTestPage ------------------------//
class ColorPickerTestPage extends StatefulWidget {
  const ColorPickerTestPage({super.key});

  @override
  State<ColorPickerTestPage> createState() => _ColorPickerTestPageState();
}

class _ColorPickerTestPageState extends State<ColorPickerTestPage> {
  SDeckColorPickerColor _selected = SDeckColorPickerColor.brightCoral;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SDeckTopNavigationBar(
              left: SDeckTopBarLeft.back,
              type: SDeckTopBarType.subpage,
              right: SDeckTopBarRight.none,
              title: 'Color Picker',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  SDeckSpace.padding16,
                  SDeckSpace.padding8,
                  SDeckSpace.padding16,
                  SDeckSpace.padding48,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle(context, 'Swatch States'),
                    const SizedBox(height: SDeckSpace.gap16),
                    Row(
                      children: [
                        for (final state in SDeckSwatchState.values) ...[
                          if (state != SDeckSwatchState.values.first)
                            const SizedBox(width: SDeckSpace.gap16),
                          _labeled(
                            context,
                            label: state.name,
                            child: SizedBox(
                              width: SDeckSize.size36,
                              child: SDeckSwatch(
                                color: SDeckColorPickerColor.brightCoral,
                                state: state,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: SDeckSpace.gap32),
                    _sectionTitle(context, 'All Colors (Enabled)'),
                    const SizedBox(height: SDeckSpace.gap16),
                    Wrap(
                      spacing: SDeckSpace.gap6,
                      runSpacing: SDeckSpace.gap6,
                      children: [
                        for (final color in SDeckColorPickerColor.values)
                          SizedBox(
                            width: SDeckSize.size36,
                            child: SDeckSwatch(
                              color: color,
                              state: SDeckSwatchState.enabled,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: SDeckSpace.gap32),
                    _sectionTitle(context, 'Interactive Color Picker'),
                    const SizedBox(height: SDeckSpace.gap8),
                    Text(
                      'Selected: ${_selected.name}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: context.component.textSecondary,
                          ),
                    ),
                    const SizedBox(height: SDeckSpace.gap16),
                    SDeckColorPicker(
                      selected: _selected,
                      onChanged: (color) {
                        setState(() => _selected = color);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.h6.copyWith(
            color: context.component.textPrimary,
          ),
    );
  }

  Widget _labeled(
    BuildContext context, {
    required String label,
    required Widget child,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        const SizedBox(height: SDeckSpace.gap8),
        Text(
          label,
          style: Theme.of(context).textTheme.caption.copyWith(
                color: context.component.textSecondary,
              ),
        ),
      ],
    );
  }
}
