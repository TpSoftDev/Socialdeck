import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/profile_form_state.dart';

/// StateNotifier that manages the state of the profile onboarding form.
/// This class exposes methods to update each field in the ProfileFormState.
/// It is used by all profile onboarding pages to read and update the user's input.
class ProfileFormNotifier extends StateNotifier<ProfileFormState> {
  /// Initializes with an empty ProfileFormState.
  ProfileFormNotifier() : super(ProfileFormState());

  /// Updates the username in the form state.
  void setUsername(String username) {
    state = state.copyWith(username: username);
  }

  /// Updates the image path in the form state.
  void setImagePath(String imagePath) {
    state = state.copyWith(imagePath: imagePath);
  }

  /// Updates the image adjustment data (scale, panX, panY) in the form state.
  void setTransform(double scale, double panX, double panY) {
    state = state.copyWith(scale: scale, panX: panX, panY: panY);
  }

  /// Resets the form state to its initial values.
  void reset() {
    state = ProfileFormState();
  }
}

/// Riverpod provider for the ProfileFormNotifier.
/// Use ref.read(profileFormProvider.notifier) to update state.
/// Use ref.watch(profileFormProvider) to read the current state.
final profileFormProvider =
    StateNotifierProvider<ProfileFormNotifier, ProfileFormState>(
      (ref) => ProfileFormNotifier(),
    );
