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

  // Function to pick image from gallery
  Future<XFile?> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
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
                        onTap: () async {
                          final image = await _pickImage();
                          if (image != null) {
                            setState(() {
                              selectedImage = image;
                            });
                            print('Image selected: ${image.name}');

                            // Navigate to adjust screen with image path
                            context.push(
                              '/test/adjust-profile?imagePath=${image.path}',
                            );
                          }
                        },
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
