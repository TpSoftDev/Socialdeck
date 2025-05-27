import 'package:flutter/material.dart';
import 'package:socialdeck/Design_System%20/Utils/constants/app_colors.dart';
import 'package:socialdeck/Design_System%20/Utils/Themes/custom_themes/typography.dart';
import 'package:socialdeck/Design_System%20/Utils/Themes/custom_themes/icons.dart';
import 'package:socialdeck/Design_System%20/Utils/widgets/index.dart';

class SimpleExample extends StatelessWidget {
  const SimpleExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Design System Demo',
          style: Theme.of(context).textTheme.h5,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Typography Examples
            Text('Typography:', style: Theme.of(context).textTheme.h4),
            const SizedBox(height: 8),
            Text('H1 Heading', style: Theme.of(context).textTheme.h1),
            Text('Body Large', style: Theme.of(context).textTheme.body),
            Text('Body Small', style: Theme.of(context).textTheme.bodySmall),

            const SizedBox(height: 24),

            // Color Examples
            Text('Colors:', style: Theme.of(context).textTheme.h4),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 60,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Primary',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 60,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.success,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Success',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSuccess,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 60,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Error',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onError,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Icon Examples
            Text('Icons:', style: Theme.of(context).textTheme.h4),
            const SizedBox(height: 8),

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
                SDeckIcon(context.icons.placeholder),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              'Size Variants:',
              style: Theme.of(context).textTheme.bodySmall,
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
                SDeckIcon.extraLarge(context.icons.home),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
