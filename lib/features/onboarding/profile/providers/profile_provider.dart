import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../domain/introduce_profile_card_state.dart';
import '../domain/profile_card_state.dart';


//Provider to be used in intorduce_profile_card and import_image_bottom_sheet to manage state
class IntroduceProfileCardProvider extends StateNotifier<IntroduceProfileCardState>{

  IntroduceProfileCardProvider() : super(const IntroduceProfileCardState());

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

  //General function to check if permission has been granted
  Future<bool> hasPermission() async {
    if(state.cameraPermission != null){
      if(state.cameraPermission!.isGranted || state.cameraPermission!.isLimited){
        return Future.value(true);
      }
    } else if (state.galleryPermission != null){
      if(state.galleryPermission!.isGranted || state.galleryPermission!.isLimited){
        return Future.value(true);
      }
    }
    return Future.value(false);
  }

  Future<bool> noPermission() async {
    if(state.cameraPermission != null){
      if(state.cameraPermission!.isDenied || state.cameraPermission!.isPermanentlyDenied || state.cameraPermission!.isRestricted){
        return Future.value(true);
      }
    } else if (state.galleryPermission != null){
      if(state.galleryPermission!.isDenied || state.galleryPermission!.isPermanentlyDenied || state.galleryPermission!.isRestricted){
        return Future.value(true);
      }
    }
    return Future.value(false);
  }

}


//Provider to be used to help with uploading to Firebase when profile card creation and username selection are done
//For overall use across onboarding profile creation flow
class ProfileCardProvider extends StateNotifier<ProfileCardState>{

  ProfileCardProvider() : super(const ProfileCardState());

  Future<void> resetDomain() async {
    state = const ProfileCardState();
  }

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
  }

  Future<void> pickGalleryImage() async {
    final ImagePicker picker = ImagePicker();

    state = state.copyWith(profileImage: await picker.pickImage(
        source: ImageSource.gallery));
  }

  Future<void> pickCameraImage() async {
    final ImagePicker picker = ImagePicker();

    state = state.copyWith(profileImage: await picker.pickImage(
        source: ImageSource.camera));
  }

  Future<void> useGenericImage() async {
    state = state.copyWith(useTempImage: true);
  }
}

//Provider to be used in intorduce_profile_card and import_image_bottom_sheet to manage state
final introduceProfileCardProvider = StateNotifierProvider<IntroduceProfileCardProvider, IntroduceProfileCardState>
  ((ref) => IntroduceProfileCardProvider());

//Provider to be used to help with uploading to Firebase when profile card creation and username selection are done
final profileCardProvider = StateNotifierProvider<ProfileCardProvider, ProfileCardState>
  ((ref) => ProfileCardProvider());