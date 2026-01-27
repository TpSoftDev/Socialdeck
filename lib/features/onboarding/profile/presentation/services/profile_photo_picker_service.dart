/*-------------------- profile_photo_picker_service.dart -----------------------*/
// Profile Photo Picker Service for onboarding screens
// Handles ONLY the photo picking business logic (camera/gallery)
// UI logic (modals, buttons) handled by pages using existing design system components
//
// Usage:
//   final service = ProfilePhotoPickerService();
//   final photo = await service.pickFromCamera();
//   final photo = await service.pickFromGallery();
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePhotoPickerService {
  //*************************** Public Methods ***********************************//

  /// Captures a photo using the device camera
  /// Returns selected XFile or null if cancelled/failed
  /// Handles camera permissions and errors gracefully
  Future<XFile?> pickFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      return await picker.pickImage(source: ImageSource.camera);
    } catch (e) {
      // Handle camera errors gracefully (permissions, no camera, etc.)
      debugPrint('📷 Camera error: $e');
      return null;
    }
  }

  /// Selects a photo from the device gallery/camera roll
  /// Returns selected XFile or null if cancelled/failed
  /// Handles gallery permissions and errors gracefully
  Future<XFile?> pickFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      return await picker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      // Handle gallery errors gracefully (permissions, no photos, etc.)
      debugPrint('🖼️ Gallery error: $e');
      return null;
    }
  }

  //*************************** Future Methods for Firebase Integration ***********//

  /// Future method for uploading photo to Firebase Storage
  /// Will be implemented when Firebase integration is added
  // Future<String?> uploadPhotoToFirebase(XFile photo) async {
  //   // TODO: Implement Firebase Storage upload
  //   // Return download URL or null if failed
  // }

  /// Future method for saving photo metadata to Firestore
  /// Will be implemented when Firebase integration is added
  // Future<void> savePhotoMetadata(String userId, String photoUrl) async {
  //   // TODO: Implement Firestore photo metadata saving
  // }
}
