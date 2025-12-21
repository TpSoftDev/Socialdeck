import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';

class ProfileCardTestPage extends StatefulWidget {
  const ProfileCardTestPage({super.key});

  @override
  State<ProfileCardTestPage> createState() => _ProfileCardTestPageState();
}

class _ProfileCardTestPageState extends State<ProfileCardTestPage> {
  // Variable to track selected image
  XFile? selectedImage;

  // Function to take photo with camera
  Future<XFile?> _pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera, // Take a new photo with camera
      imageQuality: 80, // Optional: compress image to 80% quality
    );
    return image;
  }

  // Function to pick image from gallery
  Future<XFile?> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery, // Select from camera roll/gallery
      imageQuality: 80, // Optional: compress image to 80% quality
    );
    return image;
  }

  //*************************** Bottom Sheet Method ********************************//
  /// Shows the bottom sheet with image picker options
  void _showImagePickerBottomSheet(BuildContext context) {
    // Capture the parent context for safe navigation after bottom sheet closes
    final parentContext = context;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          Colors.transparent, // Let our component handle background
      builder:
          (context) => SDeckBottomSheet(
            title: "Insert Photo",
            showHomeIndicator: false, // Let iOS handle its own home indicator
            child: Column(
              children: [
                // Primary action - Take a Photo
                SDeckSolidButton.large(
                  text: "Take a Photo!",
                  fullWidth: true,
                  onPressed: () async {
                    Navigator.pop(context); // Close bottom sheet first
                    final image = await _pickImageFromCamera();
                    if (image != null) {
                      setState(() {
                        selectedImage = image;
                      });
                      print('📷 Camera image selected: ${image.name}');

                      // Navigate using parent context (safe after bottom sheet closes)
                      if (parentContext.mounted) {
                        parentContext.push(
                          '/test/adjust-profile?imagePath=${image.path}',
                        );
                      }
                    }
                  },
                ),

                SizedBox(height: SDeckSpace.gapXS), // 8px gap from Figma
                // Secondary action - View Camera Roll
                SDeckHollowButton.large(
                  text: "View Camera Roll",
                  fullWidth: true,
                  onPressed: () async {
                    Navigator.pop(context); // Close bottom sheet first
                    final image = await _pickImageFromGallery();
                    if (image != null) {
                      setState(() {
                        selectedImage = image;
                      });
                      print('🖼️ Gallery image selected: ${image.name}');

                      // Navigate using parent context (safe after bottom sheet closes)
                      if (parentContext.mounted) {
                        parentContext.push(
                          '/test/adjust-profile?imagePath=${image.path}',
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
    );
  }

  //*************************** Build Method ********************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Page header
            SDeckTopNavigationBar.logoWithSkip(),

            // Simple test layout
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Upload Profile Card
                      SDeckCreateProfileCard(
                        onTap: () => _showImagePickerBottomSheet(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
