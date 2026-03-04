// -----------------------------------------------------------------------------
// lib/features/sprint2_training/edit_photo/providers/edit_photo_provider.dart
// Riverpod provider + notifier for Edit Photo (state updates + save action).
// -----------------------------------------------------------------------------

import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/edit_photo_repository.dart';
import '../data/mock_edit_photo_repository.dart';
import '../data/photo_picker_service.dart';
import '../domain/edit_photo_state.dart';

// Provides the repository implementation for this feature (mock for now)
final editPhotoRepositoryProvider = Provider<EditPhotoRepository>((ref) {
  return MockEditPhotoRepository();
});

// Provides the photo picker service (camera/gallery)
final photoPickerServiceProvider = Provider<PhotoPickerService>((ref) {
  return PhotoPickerService();
});

// UI watches this provider for state changes
final editPhotoProvider =
    StateNotifierProvider<EditPhotoNotifier, EditPhotoState>((ref) {
  final repo = ref.watch(editPhotoRepositoryProvider);
  final picker = ref.watch(photoPickerServiceProvider); // Added
  return EditPhotoNotifier(repo, picker); // Updated
});

class EditPhotoNotifier extends StateNotifier<EditPhotoState> {
  EditPhotoNotifier(this._repository, this._photoPicker)
      : super(const EditPhotoState());

  final EditPhotoRepository _repository;
  final PhotoPickerService _photoPicker; // Added

  // Pick photo from gallery and store as bytes
  Future<void> pickFromGallery() async {
    final file = await _photoPicker.pickFromGallery();
    if (file == null) return;

    final bytes = await file.readAsBytes();
    setPhotoBytes(bytes);
  }

  // Take photo with camera and store as bytes
  Future<void> pickFromCamera() async {
    final file = await _photoPicker.pickFromCamera();
    if (file == null) return;

    final bytes = await file.readAsBytes();
    setPhotoBytes(bytes);
  }

  // Called when user taps "Looks great!"
  Future<void> save() async {
    final bytes = state.photoBytes;

    if (bytes == null) {
      state = state.copyWith(errorMessage: 'No photo selected.');
      return;
    }

    state = state.copyWith(
      isSaving: true,
      saveSuccess: false,
      clearErrorMessage: true,
    );

    try {
      await _repository.saveEditedPhoto(
        photoBytes: bytes,
        scale: state.scale,
        rotation: state.rotation,
        panX: state.panX,
        panY: state.panY,
      );

      state = state.copyWith(
        isSaving: false,
        saveSuccess: true,
      );
    } catch (_) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to save photo. Please try again.',
      );
    }
  }

  // Called when user taps "Change Photo" (clears photo + resets transforms)
  void changePhoto() {
    state = state.copyWith(
      clearPhotoBytes: true,
      panX: 0.0,
      panY: 0.0,
      scale: 1.0,
      rotation: 0.0,
      saveSuccess: false,
      clearErrorMessage: true,
    );
  }

  // Updates pan (move)
  void setPan({required double panX, required double panY}) {
    state = state.copyWith(panX: panX, panY: panY);
  }

  // Updates zoom
  void setScale(double scale) {
    final clamped = scale.clamp(0.5, 4.0);
    state = state.copyWith(scale: clamped);
  }

  // Updates rotation (radians)
  void setRotation(double rotation) {
    state = state.copyWith(rotation: rotation);
  }

  // Resets transforms but keeps the photo
  void resetEdits() {
    state = state.copyWith(
      panX: 0.0,
      panY: 0.0,
      scale: 1.0,
      rotation: 0.0,
      saveSuccess: false,
      clearErrorMessage: true,
    );
  }

  // Sets the selected image bytes
  void setPhotoBytes(Uint8List bytes) {
    state = state.copyWith(
      photoBytes: bytes,
      saveSuccess: false,
      clearErrorMessage: true,
    );
  }
}