import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

class OpeningScreenPage extends StatelessWidget{
  const OpeningScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, 
          children: [
        //------------------------ Top Navigation ------------------------//
            // const SDeckTopNavigationBar.titleOnly(title: 'Hello Testing!'),
        //------------------------ Visual Placeholder --------------------------//
        Padding( 
          padding: const EdgeInsets.all(SDeckSpace.padding16), 
          child: buildVisualPlaceholder(context)
        ),

        SizedBox(height: SDeckSpace.gap16)

      ],),),

      );
  }

  //*************************** Helper Methods ********************************//
  //------------------------ Visual Placeholder ----------------------------//
  Widget buildVisualPlaceholder(BuildContext context) {
    return Container(
      width: 370,
      height: 370,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
        image: const DecorationImage(
          image: AssetImage(SDeckIcon.checkeredBackground),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}