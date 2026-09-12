import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../domain/introduce_profile_card_state.dart';
import '../domain/profile_card_state.dart';
import '../domain/invite_friends_state.dart';
import '../data/profile_repository.dart';
import '../data/concrete_profile_repository.dart';
import '../data/invite_friends_repository.dart';
//TODO: Replace mock repository when ready
import '../data/mock_invite_friends_repository.dart';


//Provider to be used in intorduce_profile_card and import_image_bottom_sheet to manage state
class IntroduceProfileCardNotifier extends StateNotifier<IntroduceProfileCardState>{

  IntroduceProfileCardNotifier() : super(const IntroduceProfileCardState());

  Future<void> resetDomain() async {
    state = const IntroduceProfileCardState();
  }

  //Used to keep track of normal state progression so the backend knows what is on the screen
  Future<void> advanceState() async {
    if(state.currentScreenState == screenState.ErrorState){
      state = state.copyWith(currentScreenState: screenState.PickImageState);
      return;
    }
    switch(state.currentScreenState){
      case(screenState.InitialState):
        state = state.copyWith(currentScreenState: screenState.PickImageState);
        break;
      case(screenState.PickImageState):
        break;
      default: 
        state = state.copyWith(currentScreenState: screenState.ErrorState);
        break;
    }
  }

  //These two handle asking permissions of the user, camera and gallery access respectively
  Future<void> cameraPermission() async {
    state = state.copyWith(cameraPermission: await Permission.camera.request());
  }

  Future<void> galleryPermission() async {
    if(Platform.isAndroid){
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if(androidInfo.version.sdkInt <= 32) {
        state = state.copyWith(galleryPermission: await Permission.storage.request());
        return;
      }
    }
    state = state.copyWith(galleryPermission: await Permission.photos.request());
  }

  Future<bool> hasCameraPermission() async {
    final p = state.cameraPermission;
    return p != null && (p.isGranted || p.isLimited);
  }

  Future<bool> hasGalleryPermission() async {
    final p = state.galleryPermission;
    return p != null && (p.isGranted || p.isLimited);
  }

  Future<bool> noCameraPermission() async {
    final p = state.cameraPermission;
    return p != null && (p.isDenied || p.isPermanentlyDenied || p.isRestricted);
  }

  Future<bool> noGalleryPermission() async {
    final p = state.galleryPermission;
    return p != null && (p.isDenied || p.isPermanentlyDenied || p.isRestricted);
  }

}

//Provider to be used with invite friends page
class InviteFriendsNotifier extends StateNotifier<InviteFriendsState>{

  final InviteFriendsRepository _repository;

  InviteFriendsNotifier(this._repository) : super(const InviteFriendsState());

  Future<bool> sendInviteToContact() async {

    //TODO: Actually implement this
    return _repository.sendInvite();
  }

  void flipSendingInvite() {
    
    state = state.copyWith(sendingInvite: !state.sendingInvite);
  }
}

//Provider to be used to help with uploading to Firebase when profile card creation and username selection are done
//For overall use across onboarding profile creation flow
class ProfileCardNotifier extends StateNotifier<ProfileCardState>{

  final ProfileRepository _repository;

  ProfileCardNotifier(this._repository) : super(const ProfileCardState());

  Future<void> resetDomain() async {
    state = const ProfileCardState();
  }

  //Image File checks
  Future<void> fileSizeCheck() async {
    final int fileSizeInBytes = await state.profileImage!.length();

    const int maxBytes = 5 * 1024 * 1024;

    if (fileSizeInBytes > maxBytes) {
      state = state.copyWith(imageSizeCheck: false);
    } else {
      state = state.copyWith(imageSizeCheck: true);
    }
  }

  Future<void> fileTypeCheck() async {
    final String lowerPath = state.profileImage!.path.toLowerCase();

    state = state.copyWith(imageTypeCheck:
        lowerPath.endsWith('.jpg') ||
        lowerPath.endsWith('.jpeg') ||
        lowerPath.endsWith('.png') ||
        lowerPath.endsWith('.webp'));

    if(!state.imageSizeCheck || !state.imageTypeCheck){
      state = state.copyWith(profileImage: state.prevImage);
    }
  }

  Future<void> pickGalleryImage() async {
    final ImagePicker picker = ImagePicker();

    state = state.copyWith(prevImage: state.profileImage);

    state = state.copyWith(profileImage: await picker.pickImage(
        source: ImageSource.gallery));
  }

  Future<void> pickCameraImage() async {
    final ImagePicker picker = ImagePicker();

    state = state.copyWith(prevImage: state.profileImage);

    state = state.copyWith(profileImage: await picker.pickImage(
        source: ImageSource.camera));
  }

  Future<void> useGenericImage() async {
    state = state.copyWith(useTempImage: true);
  }

  Future<void> updateImagePosition(double panX, double panY, double scale, double rotation) async {
    state = state.copyWith(panX: panX, panY: panY, scale: scale, rotation: rotation);
  }

  Future<void> resetImagePosition() async {
    state = state.copyWith(panX: 0.0, panY: 0.0, scale: 1.0, rotation: 0.0);
  }

  //Username checks

  Future<void> usernameChange (String username) async {
    state = state.copyWith(username: username);
  }
  //Checks if username is already in repository or not
  Future<bool> usernameAvailable () async {
    return _repository.isUsernameAvailable(state.username);
  }

  Future<bool> usernameCorrectFormat () async {
    final RegExp validPattern = RegExp(r'^[A-Za-z0-9_]+$');
    return !validPattern.hasMatch(state.username);
  }

  Future<bool> usernameClean () async {
    const Set<String> blockedWords = {
      'badword123',
    };
    bool accept = true;
    for (String word in blockedWords){
      if(state.username.toLowerCase().contains(word)){
        accept = false;
      }
    }
    return accept;
  }

  //Uploading profile data to server
  Future<bool> submitProfileToServer () async {

    final imageURL = state.useTempImage ? null : await _repository.uploadPhotoToStorage(state.profileImage);

    OnboardingSubmissionData toSubmit = 
      OnboardingSubmissionData(
          username: state.username,
          imagePath: imageURL,
          scale: state.scale,
          panX: state.panX,
          panY: state.panY,
          rotation: state.rotation);
    
    return _repository.submitProfile(toSubmit);
  }
}

//Provider to be used in intorduce_profile_card and import_image_bottom_sheet to manage state
final introduceProfileCardProvider = StateNotifierProvider<IntroduceProfileCardNotifier, IntroduceProfileCardState>
  ((ref) => IntroduceProfileCardNotifier());

//
final inviteFriendsProvider = StateNotifierProvider<InviteFriendsNotifier, InviteFriendsState>
  ((ref) => InviteFriendsNotifier(MockInviteFriendsRepository()));

//Provider to be used to help with uploading to Firebase when profile card creation and username selection are done
final profileCardProvider = StateNotifierProvider<ProfileCardNotifier, ProfileCardState>
  ((ref) => ProfileCardNotifier(ConcreteProfileRepository()));