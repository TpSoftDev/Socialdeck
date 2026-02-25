import 'package:flutter/material.dart';

class OpeningScreenPage extends StatelessWidget{
  const OpeningScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [
          Text("Opening Screen")
      ],),),

      );
  }
}