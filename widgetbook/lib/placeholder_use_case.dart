import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: Container)
Widget buildPlaceholderUseCase(BuildContext context) {
  return Container(
    color: Colors.blue,
    child: const Center(
      child: Text('Widgetbook is working!'),
    ),
  );
}