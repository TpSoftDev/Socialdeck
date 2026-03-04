// -----------------------------------------------------------------------------
// lib/features/sprint2_training/edit_photo/data/edit_photo_repository.dart
// Repository contract for saving edited photos in the Edit Photo feature.
// -----------------------------------------------------------------------------

import 'dart:typed_data';

/// Repository interface for Edit Photo operations.
/// Implementations may use Firebase, APIs, or mock data.
abstract class EditPhotoRepository {

  /// Saves the edited photo after the user presses "Looks great!".
  ///
  /// Parameters:
  /// • photoBytes → image data
  /// • scale → zoom level
  /// • rotation → rotation applied to the image
  /// • panX / panY → image movement offsets
  Future<void> saveEditedPhoto({
    required Uint8List photoBytes,
    required double scale,
    required double rotation,
    required double panX,
    required double panY,
  });
}