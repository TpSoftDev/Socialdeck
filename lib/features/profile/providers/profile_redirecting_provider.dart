import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/profile_redirecting_state.dart';

class ProfileRedirectingProvider extends StateNotifier<ProfileRedirectingState>{

  ProfileRedirectingProvider() : super(const ProfileRedirectingState());

  //Starts timer to count down to when the next screen will be displayed
  //Should be as long as the animation takes once or twice or so.
  void nextScreenDelay() {
    //Sets timer to move to next screen, ideally will be the length of the animation once that is made
    state = state.copyWith(toMoveNext: Timer(const Duration(seconds: 3), () {
      //Allows movement to next screen
      state = state.copyWith(moveNext: true);
    }));
  }

  //Resets moveNext variable to make it so that if the screen is visited again, it won't immediately move to the next screen upon loading.
  void reset() {
    state = const ProfileRedirectingState();
  }

}

//Provider to be used in the presentation screen
final profileRedirectingProvider = StateNotifierProvider<ProfileRedirectingProvider, ProfileRedirectingState>
  ((ref) => ProfileRedirectingProvider());