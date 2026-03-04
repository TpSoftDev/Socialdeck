// -----------------------------------------------------------------------------
// lib/features/sprint2_training/edit_photo/domain/edit_photo_state.dart
// Domain state for the Edit Photo feature (photo data, transforms, save state).
// -----------------------------------------------------------------------------

import 'dart:typed_data';
import 'package:flutter/foundation.dart';

@immutable
class EditPhotoState {
  // Selected image bytes (null if no photo chosen)
  final Uint8List? photoBytes;

  // Image transform values
  final double panX;
  final double panY;
  final double scale;
  final double rotation;

  // UI workflow state
  final bool isSaving;
  final bool saveSuccess;
  final String? errorMessage;

  const EditPhotoState({
    this.photoBytes,
    this.panX = 0.0,
    this.panY = 0.0,
    this.scale = 1.0,
    this.rotation = 0.0,
    this.isSaving = false,
    this.saveSuccess = false,
    this.errorMessage,
  });

  // True if the user has changed the photo position, zoom, or rotation
  bool get hasEdits =>
      panX != 0.0 || panY != 0.0 || scale != 1.0 || rotation != 0.0;

  // Creates a new state with updated values
  EditPhotoState copyWith({
    Uint8List? photoBytes,
    bool clearPhotoBytes = false,
    double? panX,
    double? panY,
    double? scale,
    double? rotation,
    bool? isSaving,
    bool? saveSuccess,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return EditPhotoState(
      photoBytes: clearPhotoBytes ? null : (photoBytes ?? this.photoBytes),
      panX: panX ?? this.panX,
      panY: panY ?? this.panY,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
      isSaving: isSaving ?? this.isSaving,
      saveSuccess: saveSuccess ?? this.saveSuccess,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditPhotoState &&
          listEquals(photoBytes, other.photoBytes) &&
          panX == other.panX &&
          panY == other.panY &&
          scale == other.scale &&
          rotation == other.rotation &&
          isSaving == other.isSaving &&
          saveSuccess == other.saveSuccess &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => Object.hash(
        photoBytes == null ? 0 : Object.hashAll(photoBytes!),
        panX,
        panY,
        scale,
        rotation,
        isSaving,
        saveSuccess,
        errorMessage,
      );
}