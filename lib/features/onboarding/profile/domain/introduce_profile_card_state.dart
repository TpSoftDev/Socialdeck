import 'package:permission_handler/permission_handler.dart';

//Enum states for the screen state of introduce_profile_card and import_image_bottom_sheet
enum screenState 
{ //More descriptive states needed later
  State1,
  State2,
  State3,
}

class IntroduceProfileCardState{

  final screenState currentScreenState;
  final PermissionStatus? cameraPermission;
  final PermissionStatus? galleryPermission;

  //Constructor for needed fields
  const IntroduceProfileCardState({
    this.currentScreenState = screenState.State1,
    this.cameraPermission,
    this.galleryPermission,
  });

  IntroduceProfileCardState copyWith({
    screenState? currentScreenState,
    PermissionStatus? cameraPermission,
    PermissionStatus? galleryPermission,
  }) {
    return IntroduceProfileCardState(
      currentScreenState: currentScreenState ?? this.currentScreenState,
      cameraPermission: cameraPermission ?? this.cameraPermission,
      galleryPermission: galleryPermission ?? this.galleryPermission,
    );
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is IntroduceProfileCardState &&
      currentScreenState == other.currentScreenState &&
      cameraPermission == other.cameraPermission &&
      galleryPermission == other.galleryPermission;
      

  @override
  int get hashCode => Object.hash(
      currentScreenState,
      cameraPermission,
      galleryPermission,
    );

}