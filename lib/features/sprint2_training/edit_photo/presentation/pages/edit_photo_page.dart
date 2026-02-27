import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

class EditPhotoPage extends StatelessWidget {
  const EditPhotoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //------------------------ Top Navigation ------------------------//
            SDeckTopNavigationBar.titleOnly(title: "Edit Photo"),

            //------------------------ Visual Placeholder ------------------------//
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
              child: buildVisualPlaceholder(context),
            ),

            SizedBox(height: SDeckSpace.gap16),

            //------------------------ Body Text ------------------------//
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16), 
              child: Text("Use your finger to \nmove, zoom, and rotate.",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: context.component.textSecondary),
              textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: SDeckSpace.gap16),

            //------------------------ Solid Button Positioning ------------------------//
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
              child: SDeckSolidButton(
                text: "Looks great!",
                size: SDeckButtonSize.large,
                fullWidth: true,
                onPressed: () {},
              ),
            ),

            SizedBox(height: SDeckSpace.gap8),

            //------------------------ Outlined Button Positioning ----------------------//
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
              child: SDeckOutlineButton(
                iconLocation: SDeckButtonIconLocation.left,
                icon: SDeckIcons(SDeckIcon.redo, size: SDeckSize.size24, color: context.component.iconPrimary),
                text: "Change Photo",
                size: SDeckButtonSize.large,
                fullWidth: true,
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }

  //------------------------------- Build Visual Placeholder ----------------------------//
  Widget buildVisualPlaceholder(BuildContext context) {
    return Container(
      width: 370,
      height: 370,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
        image: const DecorationImage(
          image: AssetImage(SDeckIcon.checkeredBackground),
          fit: BoxFit.cover
          ),
      ),
    );
  }
}