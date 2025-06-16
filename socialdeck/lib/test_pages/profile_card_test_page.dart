import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialdeck/design_system/index.dart';

class ProfileCardTestPage extends StatefulWidget {
  const ProfileCardTestPage({super.key});

  @override
  State<ProfileCardTestPage> createState() => _ProfileCardTestPageState();
}

class _ProfileCardTestPageState extends State<ProfileCardTestPage> {
  // Variables to track selected images for each state
  XFile? defaultStateImage;
  XFile? blinkStateImage;
  XFile? selectedStateImage;

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
            SDeckTopNavigationBar.logoWithTitle(
              title: "CreateProfileCard Test",
            ),

            // Simple test layout
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Test State 1: Default (gray border)
                    Column(
                      children: [
                        Text(
                          'State 1: Default',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        SDeckCreateProfileCard.defaultState(
                          onTap: () async {
                            final image = await _pickImage();
                            if (image != null) {
                              setState(() {
                                defaultStateImage = image;
                              });
                              print('Default state: Image selected');
                            }
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Test State 2: Blink (blue border)
                    Column(
                      children: [
                        Text(
                          'State 2: Blink',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        SDeckCreateProfileCard.blink(
                          onTap: () => print('Blink state tapped'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Test State 3: Selected (gray border)
                    Column(
                      children: [
                        Text(
                          'State 3: Selected',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        SDeckCreateProfileCard.selected(
                          onTap: () => print('Selected state tapped'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
