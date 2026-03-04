// -----------------------------------------------------------------------------
// lib/features/sprint2_training/edit_photo/data/photo_picker_service.dart
// Photo picking service (camera/gallery) for the Edit Photo feature.
// -----------------------------------------------------------------------------

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class PhotoPickerService {
  Future<XFile?> pickFromCamera() async {
    try {
      final picker = ImagePicker();
      return await picker.pickImage(source: ImageSource.camera);
    } catch (e) {
      debugPrint('📷 Camera error: $e');
      return null;
    }
  }

  Future<XFile?> pickFromGallery() async {
    try {
      final picker = ImagePicker();
      return await picker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      debugPrint('🖼️ Gallery error: $e');
      return null;
    }
  }
}