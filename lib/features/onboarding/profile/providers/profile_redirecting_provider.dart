import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/profile_redirecting_state.dart';


//Provider for the profile_redirecting screen
class ProfileRedirectingProvider extends StateNotifier<ProfileRedirectingState>{

  ProfileRedirectingProvider() : super(const ProfileRedirectingState());

  //Starts timer to count down to when the next screen will be displayed
  //Should be as long as the animation takes once or twice or so.
  void toNextScreen() {
    state = state.copyWith(moveNext: true);
  }

  //Resets moveNext variable to make it so that if the screen is visited again, it won't immediately move to the next screen upon loading.
  void reset() {
    state = const ProfileRedirectingState();
  }

}



//Provider to be used in the presentation screen
final profileRedirectingProvider = StateNotifierProvider<ProfileRedirectingProvider, ProfileRedirectingState>
  ((ref) => ProfileRedirectingProvider());