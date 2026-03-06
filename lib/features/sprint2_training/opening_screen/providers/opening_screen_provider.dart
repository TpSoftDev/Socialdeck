import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/features/sprint2_training/opening_screen/data/opening_screen_repository.dart';
import 'package:socialdeck/features/sprint2_training/opening_screen/data/test_opening_screen_repository.dart';
import 'package:socialdeck/features/sprint2_training/opening_screen/domain/opening_screen_state.dart';

class OpeningScreenNotifier extends StateNotifier<OpeningScreenState> {
  //------------------------------- Repository -----------------------------//
  final OpeningScreenRepository _repository;

  //------------------------------- Constructor -----------------------------//
  OpeningScreenNotifier(this._repository) : super(const OpeningScreenState());

  //checkAuthStatus method
  Future<void> checkAuthStatus() async {
    //show loading state
    state = state.copyWith(
      isLoading: true,
      statusMessage: 'Status: Checking login...',
    );
    //call repository to check if user is logged in
    final isLoggedIn = await _repository.isUserLoggedIn();
    //update state based on result
    state = state.copyWith(
      isLoading: false,
      isAuthenticated: isLoggedIn,
      statusMessage:
          isLoggedIn
              ? 'Status: Logged in (mock)'
              : 'Status: Not logged in (mock)',
    );
  }

  /// Simulates a successful login (for training). Sets isAuthenticated = true;
  /// ref.listen on the page will then navigate to home.
  void simulateLogin() {
    state = state.copyWith(
      isAuthenticated: true,
      statusMessage: 'Status: Logged in (mock)',
    );
  }
}

//------------------------------- Provider -----------------------------//
final openingScreenProvider =
    StateNotifierProvider<OpeningScreenNotifier, OpeningScreenState>(
      (ref) => OpeningScreenNotifier(TestOpeningScreenRepository()),
    );
