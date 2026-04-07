import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

const double _TopBarReservedHeight = 76;

class LoginLoadIntoMainMenuPage extends StatelessWidget {
  const LoginLoadIntoMainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
          child: Column(
            children: [
              const SizedBox(height: _TopBarReservedHeight),
              SizedBox(height: SDeckSpace.gap16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final size = constraints.maxWidth;
                  return Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        SDeckRadius.borderRadius16,
                      ),
                      image: DecorationImage(
                        image: AssetImage(SDeckIcon.checkeredBackground),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
