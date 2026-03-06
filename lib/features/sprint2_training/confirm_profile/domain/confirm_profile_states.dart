class ConfirmProfileStates {

  //Data Fields

  //Chosen as the profile has to load before anything else on the screen can be done. True at start, false after has been loaded
  final bool profileLoading;

  //The button should only be able to be pressed if nothing else is trying to load on the screen. True if profileLoading is true and confirmingProfileChoice is false, False otherwise.
  final bool canPressButton;

  //String that manages the user profile name, will be null until profile is fetched
  final String? profileName;

  //Need something for the image, ask Thabang and Ibrahim during backend meeting
  final String? imageURL;

  //Error message if image or name are unable to be loaded
  final String? errorMessage;

  //Constructor
  const ConfirmProfileStates({
    this.profileLoading = false,
    this.canPressButton = true,
    this.profileName,
    this.imageURL,
    this.errorMessage,
  });

  //copyWith method
  ConfirmProfileStates copyWith({
    bool? profileLoading,
    bool? canPressButton,
    bool? confirmingProfileChoice,
    String? profileName,
    String? imageURL,
    String? errorMessage,
  }) {
    return ConfirmProfileStates(
      profileLoading: profileLoading ?? this.profileLoading,
      canPressButton: canPressButton ?? this.canPressButton,
      profileName: profileName ?? this.profileName,
      imageURL: imageURL ?? this.imageURL,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  //Equals Method
  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is ConfirmProfileStates &&
      runtimeType == other.runtimeType &&
      profileLoading == other.profileLoading &&
      canPressButton == other.canPressButton &&
      profileName == other.profileName &&
      imageURL == other.imageURL &&
      errorMessage == other.errorMessage;
  
  //hashCode method
  @override
  int get hashCode => Object.hash(
    profileLoading,
    canPressButton,
    profileName,
    imageURL,
    errorMessage,
  );
}