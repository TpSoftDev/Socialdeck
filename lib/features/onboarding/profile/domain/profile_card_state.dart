import 'package:image_picker/image_picker.dart';

class ProfileCardState {

  final XFile? profileImage;
  final String username;
  final bool imageSizeCheck;
  final bool imageTypeCheck;

  const ProfileCardState({
    this.profileImage,
    this.username = "",
    this.imageSizeCheck = false,
    this.imageTypeCheck = false,
  });

  ProfileCardState copyWith({
    XFile? profileImage,
    String? username,
    bool? imageSizeCheck,
    bool? imageTypeCheck,
  }) {
    return ProfileCardState(
      profileImage: profileImage ?? this.profileImage,
      username: username ?? this.username,
      imageSizeCheck: imageSizeCheck ?? this.imageSizeCheck,
      imageTypeCheck: imageTypeCheck ?? this.imageTypeCheck,
    );
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileCardState &&
        profileImage == other.profileImage &&
        username == other.username &&
        imageSizeCheck == other.imageSizeCheck &&
        imageTypeCheck == other.imageTypeCheck;

  @override
  int get hashCode => Object.hash(
    profileImage,
    username,
    imageSizeCheck,
    imageTypeCheck,
  );
}