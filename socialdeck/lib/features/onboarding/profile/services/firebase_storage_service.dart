/*-------------------- firebase_storage_service.dart -----------------------*/
// Firebase Storage Service for uploading and managing profile images
// Handles image compression, uploading to Firebase Storage, and URL generation
// Used by onboarding flow to replace temporary file paths with permanent cloud URLs
//
// Usage:
//   final service = FirebaseStorageService();
//   final downloadUrl = await service.uploadProfileImage(imageFile, userId);
/*--------------------------------------------------------------------------*/

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class FirebaseStorageService {
  //*************************** Storage Reference ****************************//
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //*************************** Upload Profile Image **************************//
  /// Uploads a profile image to Firebase Storage with compression
  ///
  /// Takes an XFile from image picker, compresses it, uploads to Firebase Storage,
  /// and returns the download URL for storing in Firestore
  ///
  /// Parameters:
  /// - [imageFile]: XFile from image_picker (camera or gallery)
  /// - [userId]: Firebase Auth UID to organize storage by user
  ///
  /// Returns:
  /// - String: Download URL if successful
  /// - null: If upload failed
  Future<String?> uploadProfileImage(XFile imageFile, String userId) async {
    try {
      print('🔄 Starting profile image upload for user: $userId');

      // Step 1: Compress the image before uploading
      final compressedFile = await _compressImage(imageFile);
      if (compressedFile == null) {
        print('❌ Image compression failed');
        return null;
      }

      // Step 2: Create storage reference with organized path
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = _storage.ref().child(
        'users/$userId/profile/$fileName',
      );

      print('📁 Uploading to path: users/$userId/profile/$fileName');

      // Step 3: Upload compressed image to Firebase Storage
      final uploadTask = storageRef.putFile(compressedFile);

      // Monitor upload progress (optional - for future progress bars)
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress =
            (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        print('⬆️ Upload progress: ${progress.toStringAsFixed(1)}%');
      });

      // Step 4: Wait for upload completion and get download URL
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      print('✅ Upload successful! Download URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('❌ Profile image upload failed: $e');
      return null;
    }
  }

  //*************************** Compress Image *****************************//
  /// Compresses an image file to optimize for mobile storage and loading
  ///
  /// Reduces file size while maintaining good quality for profile photos
  /// Target: ~100KB files for fast loading and lower storage costs
  Future<File?> _compressImage(XFile imageFile) async {
    try {
      print('🗜️ Compressing image: ${imageFile.path}');

      // Get original file size for comparison
      final originalFile = File(imageFile.path);
      final originalSize = await originalFile.length();
      print('📊 Original size: ${(originalSize / 1024).toStringAsFixed(1)} KB');

      // Compress the image
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        imageFile.path,
        minWidth: 800, // Resize to max 800px width (good for profile photos)
        minHeight: 800, // Resize to max 800px height
        quality: 70, // 70% quality (good balance of size vs quality)
        format: CompressFormat.jpeg, // JPEG format for smaller files
      );

      if (compressedBytes == null) {
        print('❌ Image compression returned null');
        return null;
      }

      // Write compressed bytes to a new temporary file
      final compressedPath = '${imageFile.path}_compressed.jpg';
      final compressedFile = File(compressedPath);
      await compressedFile.writeAsBytes(compressedBytes);

      // Log compression results
      final compressedSize = compressedBytes.length;
      final compressionRatio =
          ((originalSize - compressedSize) / originalSize * 100);
      print(
        '✅ Compressed size: ${(compressedSize / 1024).toStringAsFixed(1)} KB',
      );
      print('📉 Size reduction: ${compressionRatio.toStringAsFixed(1)}%');

      return compressedFile;
    } catch (e) {
      print('❌ Image compression failed: $e');
      return null;
    }
  }

  //*************************** Delete Profile Image ************************//
  /// Deletes a profile image from Firebase Storage
  ///
  /// Used when user changes their profile photo or deletes account
  /// Extracts the storage path from the download URL and deletes the file
  Future<bool> deleteProfileImage(String downloadUrl) async {
    try {
      print('🗑️ Deleting profile image: $downloadUrl');

      // Extract storage reference from download URL
      final ref = _storage.refFromURL(downloadUrl);
      await ref.delete();

      print('✅ Profile image deleted successfully');
      return true;
    } catch (e) {
      print('❌ Failed to delete profile image: $e');
      return false;
    }
  }

  //*************************** Get Current User Storage Reference ***********//
  /// Gets the storage reference for the current user's profile folder
  ///
  /// Useful for listing or managing all of a user's uploaded images
  Reference? getCurrentUserProfileRef() {
    final user = _auth.currentUser;
    if (user == null) return null;

    return _storage.ref().child('users/${user.uid}/profile/');
  }
}
