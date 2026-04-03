//Imports
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/introduce_profile_card_state.dart';

class IntroduceProfileCardProvider extends StateNotifier<IntroduceProfileCardState>{

  IntroduceProfileCardProvider() : super(const IntroduceProfileCardState());

  //Starts timer to change text displayed
  //Once initial timer runs out, text is hidden. Another timer is ran to make sure the text dissapears
  //After the second timer finishes, the text fades back in with a different message.
  void textSwitch() {

    //Initial timer start, can change seconds ran as needed.
    state = state.copyWith(initialDelayTimer: Timer(const Duration(seconds: 2), () {
      //After timer finishes, copy state with text not being visible.
      state = state.copyWith(isTextVisible: false);
      //Starts second timer to coincide with fade out finishing
      state = state.copyWith(fadeOutTimer: Timer(const Duration(milliseconds: 300), () {
        //Change text, and display the text again.
        state = state.copyWith(isTextVisible: true, displayText: "I'm feeling a bit… generic.\nLet's personalize me.");

        state = state.copyWith(routingTimer: Timer(const Duration(seconds: 2), () {
          //Tells the screen to move to the next one as the purpose of this screen is done.
          state = state.copyWith(moveNext: true);
        }));
      }));
    }));
  }

  //Resets display text and makes text visible
  void reset() {
    state = const IntroduceProfileCardState();
  }

}

//Provider to be used in the presentation screen
final introduceProfileCardProvider = StateNotifierProvider<IntroduceProfileCardProvider, IntroduceProfileCardState>
  ((ref) => IntroduceProfileCardProvider());