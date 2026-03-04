import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/edit_photo_provider.dart';
import '../../domain/edit_photo_state.dart'; // Wiring: needed for EditPhotoState type

class EditPhotoPage extends ConsumerWidget {
  const EditPhotoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Wiring: watch provider state so UI rebuilds when EditPhotoState changes
    final state = ref.watch(editPhotoProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //------------------------ Top Navigation ------------------------//
            SDeckTopNavigationBar.titleOnly(title: "Edit Photo"),

            //------------------------ Visual Placeholder ------------------------//
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
              child: buildVisualPlaceholder(context, state),
            ),

            const SizedBox(height: SDeckSpace.gap16),

            //------------------------ Body Text ------------------------//
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
              child: Text(
                "Use your finger to \nmove, zoom, and rotate.",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: context.component.textSecondary
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: SDeckSpace.gap16),

            // Wiring: show loading indicator while provider save() is running
            if (state.isSaving)
              const Center(child: CircularProgressIndicator()),

            // Added: show error feedback from provider
            if (state.errorMessage != null) ...[
              const SizedBox(height: SDeckSpace.gap8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
                child: Text(
                  state.errorMessage!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.component.textSecondary,
                  ),
                ),
              ),
            ],

            // Added: show success feedback after saving
            if (state.saveSuccess) ...[
              const SizedBox(height: SDeckSpace.gap8),
              const Center(child: Text('Saved!')),
            ],

            //------------------------ Solid Button Positioning ------------------------//
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
              child: SDeckSolidButton(
                text: "Looks great!",
                size: SDeckButtonSize.large,
                fullWidth: true,

                // Wiring: call provider.save() when button is pressed
                onPressed: state.isSaving
                    ? null
                    : () => ref.read(editPhotoProvider.notifier).save(),
              ),
            ),

            const SizedBox(height: SDeckSpace.gap8),

            //------------------------ Outlined Button Positioning ----------------------//
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
              child: SDeckOutlineButton(
                iconLocation: SDeckButtonIconLocation.left,
                icon: SDeckIcons(
                  SDeckIcon.redo,
                  size: SDeckSize.size24,
                  color: context.component.iconPrimary
                ),
                text: "Change Photo",
                size: SDeckButtonSize.large,
                fullWidth: true,

                // Wiring: open picker options and set selected photo bytes
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) {
                      return SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: const Text('Choose from Gallery'),
                              onTap: () {
                                Navigator.pop(context);
                                ref.read(editPhotoProvider.notifier).pickFromGallery();
                              },
                            ),
                            ListTile(
                              title: const Text('Take a Photo'),
                              onTap: () {
                                Navigator.pop(context);
                                ref.read(editPhotoProvider.notifier).pickFromCamera();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  //------------------------------- Build Visual Placeholder ----------------------------//
  Widget buildVisualPlaceholder(BuildContext context, EditPhotoState state) {
    return Container(
      width: 370,
      height: 370,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
        image: DecorationImage(
          image: state.photoBytes != null
              ? MemoryImage(state.photoBytes!)
              : const AssetImage(SDeckIcon.checkeredBackground) as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}