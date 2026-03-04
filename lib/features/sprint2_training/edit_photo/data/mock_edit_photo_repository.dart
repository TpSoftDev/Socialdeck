// -----------------------------------------------------------------------------
// lib/features/sprint2_training/edit_photo/data/mock_edit_photo_repository.dart
// Mock repository used for development/testing of the Edit Photo feature.
// Simulates saving an edited photo without a real backend.
// -----------------------------------------------------------------------------

import 'dart:typed_data';
import 'edit_photo_repository.dart';

/// Mock implementation of [EditPhotoRepository].
/// Used during development before a real backend is connected.
class MockEditPhotoRepository implements EditPhotoRepository {

  /// Simulates saving an edited photo.
  /// Waits briefly to mimic a network request.
  @override
  Future<void> saveEditedPhoto({
    required Uint8List photoBytes,
    required double scale,
    required double rotation,
    required double panX,
    required double panY,
  }) async {

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // No actual save logic yet (mock success)
  }
}