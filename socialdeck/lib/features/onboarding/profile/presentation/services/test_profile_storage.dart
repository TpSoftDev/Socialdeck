/*-------------------- test_profile_storage.dart -----------------------*/
// Temporary storage service for testing profile data
// Saves and loads profile adjustments using SharedPreferences
// DELETE THIS FILE when done testing - not for production use
/*--------------------------------------------------------------------------*/

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

/// Temporary helper class for testing profile data storage
/// This class saves the last adjusted profile to device storage
/// so we can show it on the login screen for testing purposes
class TestProfileStorage {
  /// Saves the adjusted profile data to device storage
  /// This overwrites any previously saved profile (last one wins)
  static Future<void> saveProfile({
    required String imagePath,
    required double scale,
    required double panX,
    required double panY,
  }) async {
    debugPrint('💾 Saving profile data to device storage...');

    // Get access to SharedPreferences (the device's "notebook")
    final prefs = await SharedPreferences.getInstance();

    // Save each piece of data with a unique key
    await prefs.setString('test_profile_image_path', imagePath);
    await prefs.setDouble('test_profile_scale', scale);
    await prefs.setDouble('test_profile_pan_x', panX);
    await prefs.setDouble('test_profile_pan_y', panY);

    debugPrint(
      '✅ Profile saved: $imagePath, scale: $scale, panX: $panX, panY: $panY',
    );
  }

  /// Loads the saved profile data from device storage
  /// Returns a Map with all the data, or null if no profile was saved
  static Future<Map<String, dynamic>?> loadProfile() async {
    debugPrint('📖 Loading profile data from device storage...');

    // Get access to SharedPreferences (the device's "notebook")
    final prefs = await SharedPreferences.getInstance();

    // Try to read the image path - if this doesn't exist, no profile was saved
    final imagePath = prefs.getString('test_profile_image_path');

    // If no image path, return null (no profile saved yet)
    if (imagePath == null) {
      debugPrint('❌ No profile data found');
      return null;
    }

    // Read the rest of the data (these should exist if imagePath exists)
    final scale = prefs.getDouble('test_profile_scale') ?? 1.0;
    final panX = prefs.getDouble('test_profile_pan_x') ?? 0.0;
    final panY = prefs.getDouble('test_profile_pan_y') ?? 0.0;

    // Package all data into a Map for easy use
    final profileData = {
      'imagePath': imagePath,
      'scale': scale,
      'panX': panX,
      'panY': panY,
    };

    debugPrint('✅ Profile loaded: $profileData');
    return profileData;
  }

  // TODO: Add clearProfile method for cleanup
}
