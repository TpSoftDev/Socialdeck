import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

class ProfileCardTestPage extends StatelessWidget {
  const ProfileCardTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SDeckTopNavigationBar.logoWithTitle(title: "ProfileCard Test"),
            Expanded(child: Center(child: ProfileCard())),
          ],
        ),
      ),
    );
  }
}
