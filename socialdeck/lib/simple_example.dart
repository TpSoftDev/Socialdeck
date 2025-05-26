import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socialdeck/Design_System%20/Utils/constants/app_colors.dart';
import 'package:socialdeck/Design_System%20/Utils/constants/color_palette.dart';
import 'package:socialdeck/Design_System%20/Utils/constants/image_strings.dart';
import 'package:socialdeck/Design_System%20/Utils/Themes/custom_themes/typography.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Typography Examples
            Text('H1 Heading', style: Theme.of(context).textTheme.h1),
            Text('H3 Heading', style: Theme.of(context).textTheme.h3),
            Text('Body Large', style: Theme.of(context).textTheme.body),
            Text('Body Medium', style: Theme.of(context).textTheme.bodyMedium),
            Text('Body Small', style: Theme.of(context).textTheme.bodySmall),

            const SizedBox(height: 20),

            // Color Examples - Using Theme Colors
            Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Primary',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Secondary',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Semantic Colors - Now Theme Aware!
            Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.success,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Success',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSuccess,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.warning,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Warning',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onWarning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.info,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Info',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onInfo,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Icon Examples
            Row(
              children: [
                SvgPicture.asset(
                  SDeckImages.homeFill,
                  width: 30,
                  height: 30,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 10),
                SvgPicture.asset(
                  SDeckImages.profileStroke,
                  width: 30,
                  height: 30,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.onSurface,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
