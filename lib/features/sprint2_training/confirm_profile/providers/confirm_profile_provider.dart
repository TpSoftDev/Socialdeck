//Imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/confirm_profile_repository.dart';
import '../data/mock_confirm_profile_repository.dart';
import '../domain/confirm_profile_states.dart';

//Allows for usage of domain fields
class ConfirmProfileNotifier extends StateNotifier<ConfirmProfileStates> {

  //Data Fields
  final ConfirmProfileRepository _repository;

  //Constructor for Notifier
  ConfirmProfileNotifier(this._repository) : super(const ConfirmProfileStates());


  //retrieveProfileUsername method
  //Tell screen that we are loading and that no user action should be taken
  //Call repository to retrieve Username
  //Have screen update on success or failure
  //Allow for interaction with buttons after success/failure
  Future<void> retrieveProfileUsername() async {
    //Tell screen that the page is currently loading
    state = state.copyWith(profileLoading: true, canPressButton: false);
    //Get username from repository and put it into the correct field
    state = state.copyWith(profileName: await _repository.getProfileName());
    //Confirm validity of getting profile name
    if(state.profileName == null){
      state = state.copyWith(errorMessage: "Unable to load profile, please go back to previous screen.");
    }
    //Screen has finished loading profile, so can tell screen is no longer loading
    if(state.errorMessage == null){
      state = state.copyWith(profileLoading: false, canPressButton: true);
    }
  }

  //retrieveProfileImage method
  //Tell screen that we are loading and that no user action should be taken
  //Call repository to retrieve Profile image
  //Have screen update on success or failure
  //Allow for interaction with buttons after success/failure
  Future<void> retrieveProfileImage() async {
    //Tell screen that the page is currently loading
    state = state.copyWith(profileLoading: true, canPressButton: false);
    //Get image from repository and put it into the correct field
    state = state.copyWith(imageURL: await _repository.getProfileImage());
    //Confirm validity of getting image
    if(state.imageURL == null){
      state = state.copyWith(errorMessage: "Unable to load profile, please go back to previous screen.");
    }
    //Screen has finished loading profile, so can tell screen is no longer loading
    if(state.errorMessage == null){
      state = state.copyWith(profileLoading: false, canPressButton: true);
    }
  }

  //retrieveBoth method
  //Tell screen that we are loading and that no user action should be taken
  //Call repository to retrieve Profile image and username
  //Have screen update on success or failure
  //Allow for interaction with buttons after success/failure
  Future<void> retrieveBoth() async {
    //Tell screen that the page is currently loading
    state = state.copyWith(profileLoading: true, canPressButton: false);
    //Get username from repository and put it into a string to later update the state
    String? username = await _repository.getProfileName();
    //Get image from repository and put it into a string to later update the state
    String? imageLink = await _repository.getProfileImage();
    //Update the state with the image and username
    state = state.copyWith(profileName: username, imageURL: imageLink);
    //Confirm validity of getting image
    if(state.imageURL == null || state.profileName == null){
      state = state.copyWith(errorMessage: "Unable to load profile, please go back to previous screen.");
    }
    //Screen has finished loading profile, so can tell screen is no longer loading
    if(state.errorMessage == null){
      state = state.copyWith(profileLoading: false, canPressButton: true);
    }
  }

}

//confirmProfileProvider
final confirmProfileProvider = StateNotifierProvider<ConfirmProfileNotifier, ConfirmProfileStates>
  ((ref) => ConfirmProfileNotifier(MockConfirmProfileRepository()));