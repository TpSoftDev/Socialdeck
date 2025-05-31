//------------------------ test_new_design_system.dart ----------------------//
// This file tests and demonstrates the NEW Social Deck Design System components.
// It showcases the improved organization: typography, colors, icons, text fields,
// and navigation components using the new organized design system structure.
// Used for component testing and design system verification with new architecture.
//----------------------------------------------------------------------------//

//-------------------------------- imports -----------------------------------//
import 'package:flutter/material.dart';

// 🎯 NEW DESIGN SYSTEM IMPROVEMENT #1: Single import for everything!
// OLD: Multiple scattered imports from different folders
// NEW: One clean import gives access to themes, components, foundations, and tokens
import 'package:socialdeck/design_system_new/index.dart';

//----------------------------------- Test -----------------------------------//
/// Component testing widget for the NEW Social Deck Design System.
/// Displays typography, color schemes, icons, text fields, and navigation
/// components in an organized, scrollable interface for development testing.
///
/// 🚀 IMPROVEMENTS DEMONSTRATED:
/// - Single import system (vs multiple scattered imports)
/// - Spacing tokens (vs hardcoded values)
/// - Better organized foundations
/// - Preserved functionality with cleaner architecture

class TestNewDesignSystem extends StatefulWidget {
  const TestNewDesignSystem({super.key});

  @override
  State<TestNewDesignSystem> createState() => _TestNewDesignSystemState();
}

class _TestNewDesignSystemState extends State<TestNewDesignSystem> {
  //------------------------------- Navigation State ----------------------//
  int _currentNavIndex = 0;

  void _onNavTap(int index) {
    setState(() {
      _currentNavIndex = index;
    });
  }

  //*************************** Build Method ********************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //------------------------------- App Bar ----------------------------//
      appBar: AppBar(
        title: Text(
          'NEW Design System Demo',
          // 🎯 IMPROVEMENT #2: Same text styles, cleaner access
          // OLD: Theme.of(context).textTheme.h5
          // NEW: Still works exactly the same way - preserved your code!
          style: Theme.of(context).textTheme.h5,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),

      //------------------------------- Body Content -----------------------//
      body: SingleChildScrollView(
        // OLD: padding: const EdgeInsets.all(16)
        // NEW: Still works exactly the same way - preserved your code!
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🚀 NEW: Improvements banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🚀 NEW Design System Improvements',
                    style: Theme.of(context).textTheme.h6!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '✅ Single import for everything\n'
                    '✅ Essential spacing tokens (no confusion!)\n'
                    '✅ Better organized foundations\n'
                    '✅ All your original code preserved\n'
                    '✅ Easier for new developers to understand',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            //*************************** Typography Section ***************//
            _buildTypographySection(context),
            const SizedBox(height: 24),

            //*************************** Color Scheme Section *************//
            _buildColorSection(context),
            const SizedBox(height: 24),

            //*************************** Icon System Section **************//
            _buildIconSection(context),
            const SizedBox(height: 24),

            //*************************** Text Field Section ***************//
            _buildTextFieldSection(context),
            const SizedBox(height: 24),

            //*************************** Navigation Demo Section **********//
            _buildNavigationDemoSection(context),
            const SizedBox(height: 24),

            // 🚀 NEW: Spacing tokens demo
            _buildSpacingTokensDemo(context),
          ],
        ),
      ),

      //*************************** Bottom Navigation Bar ***************//
      // 🎯 IMPROVEMENT #4: Same component, better organized imports
      // OLD: Multiple imports needed for navigation components
      // NEW: Available from single design system import
      bottomNavigationBar: SDeckBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
        items: SDeckBottomNavBar.defaultItems,
      ),
    );
  }

  //*************************** Typography Section ************************//
  Widget _buildTypographySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //------------------------------- Section Header ---------------------//
        Text('Typography:', style: Theme.of(context).textTheme.h4),
        const SizedBox(height: 8),
        Text(
          '🎯 SAME as before - your text styles preserved exactly!',
          style: Theme.of(context).textTheme.caption.copyWith(
            color: Theme.of(context).colorScheme.success,
          ),
        ),
        const SizedBox(height: 8),

        //------------------------------- Typography Examples ----------------//
        Text('H1 Heading', style: Theme.of(context).textTheme.h1),
        Text('H2 Heading', style: Theme.of(context).textTheme.h2),
        Text('H3 Heading', style: Theme.of(context).textTheme.h3),
        Text('H4 Heading', style: Theme.of(context).textTheme.h4),
        Text('H5 Heading', style: Theme.of(context).textTheme.h5),
        Text('H6 Heading', style: Theme.of(context).textTheme.h6),
        Text('Body Large', style: Theme.of(context).textTheme.bodyLarge),
        Text('Body Medium', style: Theme.of(context).textTheme.bodyMedium),
        Text('Body Large', style: Theme.of(context).textTheme.body),
        Text('Body Small', style: Theme.of(context).textTheme.bodySmall),
        Text('Caption', style: Theme.of(context).textTheme.caption),
      ],
    );
  }

  //*************************** Color Scheme Section **********************//
  Widget _buildColorSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //------------------------------- Section Header ---------------------//
        Text('Colors:', style: Theme.of(context).textTheme.h4),
        const SizedBox(height: 8),
        Text(
          '🎯 SAME colors - just better organized in foundations!',
          style: Theme.of(context).textTheme.caption.copyWith(
            color: Theme.of(context).colorScheme.success,
          ),
        ),
        const SizedBox(height: 8),

        //------------------------------- Primary & Secondary ---------------//
        _buildColorSubsection(context, 'Primary & Secondary:', [
          _buildColorSwatch(
            context,
            'Primary',
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.onPrimary,
          ),
          _buildColorSwatch(
            context,
            'Secondary',
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.onSecondary,
          ),
          _buildColorSwatch(
            context,
            'Container',
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ]),

        const SizedBox(height: 16),

        //------------------------------- Semantic Colors -------------------//
        _buildColorSubsection(context, 'Semantic Colors:', [
          _buildColorSwatch(
            context,
            'Success',
            Theme.of(context).colorScheme.success,
            Theme.of(context).colorScheme.onSuccess,
          ),
          _buildColorSwatch(
            context,
            'Warning',
            Theme.of(context).colorScheme.warning,
            Theme.of(context).colorScheme.onWarning,
          ),
          _buildColorSwatch(
            context,
            'Error',
            Theme.of(context).colorScheme.error,
            Theme.of(context).colorScheme.onError,
          ),
        ]),
      ],
    );
  }

  //*************************** Icon System Section ***********************//
  Widget _buildIconSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //------------------------------- Section Header ---------------------//
        Text('Icons:', style: Theme.of(context).textTheme.h4),
        const SizedBox(height: 8),
        Text(
          '🎯 SAME icons + NEW settingsNav() method available!',
          style: Theme.of(context).textTheme.caption.copyWith(
            color: Theme.of(context).colorScheme.success,
          ),
        ),
        const SizedBox(height: 8),

        //------------------------------- Theme-Aware Icons -----------------//
        Text(
          'Theme-Aware Icons (SDeckIcon):',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            SDeckIcon(context.icons.home),
            const SizedBox(width: 16),
            SDeckIcon(context.icons.profile),
            const SizedBox(width: 16),
            SDeckIcon(context.icons.settings),
            const SizedBox(width: 16),
            SDeckIcon(context.icons.google),
            const SizedBox(width: 16),
            SDeckIcon(context.icons.apple),
            const SizedBox(width: 16),
            SDeckIcon(context.icons.megaphone),
            const SizedBox(width: 24),
            SDeckIcon(context.icons.socialdeckLogo),
            const SizedBox(width: 16),
            SDeckIcon(context.icons.deck),
          ],
        ),

        const SizedBox(height: 16),

        //------------------------------- Size Variants ----------------------//
        Text('Size Variants:', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(
          '🚀 NEW: Essential spacing tokens for Figma-exact values!',
          style: Theme.of(context).textTheme.caption.copyWith(
            color: Theme.of(context).colorScheme.info,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            SDeckIcon.small(context.icons.home),
            const SizedBox(width: 16),
            SDeckIcon.medium(context.icons.home),
            const SizedBox(width: 16),
            SDeckIcon.large(context.icons.home),
            const SizedBox(width: 16),
            // Same 4 sizes as old design system: 16px, 24px, 32px, 48px
            SDeckIcon.extraLarge(context.icons.home),
          ],
        ),
      ],
    );
  }

  //*************************** Text Field Section ************************//
  Widget _buildTextFieldSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //------------------------------- Section Header ---------------------//
        Text('Text Fields:', style: Theme.of(context).textTheme.h4),
        const SizedBox(height: 8),
        Text(
          '🎯 SAME text fields - now using spacing tokens internally!',
          style: Theme.of(context).textTheme.caption.copyWith(
            color: Theme.of(context).colorScheme.success,
          ),
        ),
        const SizedBox(height: 8),

        //------------------------------- Size Variants ----------------------//
        Text('Size Variants:', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SDeckTextField.small(placeholder: 'Small Text Field'),
            const SizedBox(height: 8),
            const SDeckTextField.medium(placeholder: 'Medium Text Field'),
            const SizedBox(height: 8),
            const SDeckTextField.large(placeholder: 'Large Text Field'),
          ],
        ),

        const SizedBox(height: 16),

        //------------------------------- State Variants ---------------------//
        Text('State Variants:', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SDeckTextField.medium(
              placeholder: 'Enter your email address',
              state: SDeckTextFieldState.hint,
            ),
            const SizedBox(height: 8),
            SDeckTextField.medium(
              placeholder: 'Email',
              controller: TextEditingController(text: 'user@example.com'),
              state: SDeckTextFieldState.filled,
            ),
            const SizedBox(height: 8),
            SDeckTextField.medium(
              placeholder: 'Password',
              controller: TextEditingController(text: 'invalid'),
              state: SDeckTextFieldState.error,
            ),
            const SizedBox(height: 8),
            SDeckTextField.medium(
              placeholder: 'Username',
              controller: TextEditingController(text: 'john_doe'),
              state: SDeckTextFieldState.success,
            ),
          ],
        ),
      ],
    );
  }

  //*************************** Navigation Demo Section *******************//
  Widget _buildNavigationDemoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //------------------------------- Section Header ---------------------//
        Text(
          'Navigation Icons (Stroke vs Fill)',
          style: Theme.of(context).textTheme.h6,
        ),
        const SizedBox(height: 8),
        Text(
          '🚀 NEW: Added settingsNav() method + better documentation!',
          style: Theme.of(context).textTheme.caption.copyWith(
            color: Theme.of(context).colorScheme.info,
          ),
        ),
        const SizedBox(height: 16),

        //------------------------------- Icon Comparison --------------------//
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                SDeckNavIcon.medium('home', isSelected: false),
                const SizedBox(height: 8),
                Text('Stroke', style: Theme.of(context).textTheme.caption),
              ],
            ),
            Column(
              children: [
                SDeckNavIcon.medium('home', isSelected: true),
                const SizedBox(height: 8),
                Text('Fill', style: Theme.of(context).textTheme.caption),
              ],
            ),
            Column(
              children: [
                SDeckNavIcon.medium('friends', isSelected: false),
                const SizedBox(height: 8),
                Text('Stroke', style: Theme.of(context).textTheme.caption),
              ],
            ),
            Column(
              children: [
                SDeckNavIcon.medium('friends', isSelected: true),
                const SizedBox(height: 8),
                Text('Fill', style: Theme.of(context).textTheme.caption),
              ],
            ),
          ],
        ),
      ],
    );
  }

  //*************************** Spacing Tokens Demo ***********************//
  Widget _buildSpacingTokensDemo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //------------------------------- Section Header ---------------------//
        Text(
          '🎯 Essential Spacing Tokens',
          style: Theme.of(context).textTheme.h4,
        ),
        const SizedBox(height: 8),
        Text(
          'Only the values you actually need - no more confusion!',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16),

        //------------------------------- Spacing Examples -------------------//
        Container(
          padding: const EdgeInsets.all(16), // Simple hardcoded value
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Examples of spacing tokens:',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8), // Simple hardcoded value
              Text(
                '• Text field padding: ${SDeckSpacing.textFieldPaddingMediumVertical}px',
              ),
              Text(
                '• Text field radius: ${SDeckSpacing.textFieldRadiusMedium}px',
              ),
              Text('• Icon medium: ${SDeckSpacing.iconMedium}px'),
              Text('• Small radius: ${SDeckSpacing.radiusSmall}px'),
              Text('• Only essential values - no more confusion!'),
            ],
          ),
        ),
      ],
    );
  }

  //*************************** Helper Methods *****************************//

  //------------------------------- Color Subsection ----------------------//
  Widget _buildColorSubsection(
    BuildContext context,
    String title,
    List<Widget> colorSwatches,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        Row(
          children: [
            for (int i = 0; i < colorSwatches.length; i++) ...[
              colorSwatches[i],
              if (i < colorSwatches.length - 1) const SizedBox(width: 8),
            ],
          ],
        ),
      ],
    );
  }

  //------------------------------- Color Swatch ---------------------------//
  Widget _buildColorSwatch(
    BuildContext context,
    String label,
    Color backgroundColor,
    Color textColor, {
    bool withBorder = false,
  }) {
    return Expanded(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: backgroundColor,
          border:
              withBorder
                  ? Border.all(
                    color: Theme.of(context).colorScheme.outline,
                    width: 1,
                  )
                  : null,
          // Simple hardcoded values work great for most cases
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
