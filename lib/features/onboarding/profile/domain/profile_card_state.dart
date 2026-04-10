import 'package:image_picker/image_picker.dart';

class ProfileCardState {

  final XFile? profileImage;
  final XFile? prevImage;
  final String username;
  final bool imageSizeCheck;
  final bool imageTypeCheck;
  final bool useTempImage;
  final double panX;
  final double panY;
  final double scale;
  final double rotation;

  const ProfileCardState({
    this.profileImage,
    this.prevImage,
    this.username = "",
    this.imageSizeCheck = false,
    this.imageTypeCheck = false,
    this.useTempImage = false,
    this.panX = 0.0,
    this.panY = 0.0,
    this.scale = 1.0,
    this.rotation = 0.0,
  });

  ProfileCardState copyWith({
    XFile? profileImage,
    XFile? prevImage,
    String? username,
    bool? imageSizeCheck,
    bool? imageTypeCheck,
    bool? useTempImage,
    double? panX,
    double? panY,
    double? scale,
    double? rotation,
  }) {
    return ProfileCardState(
      profileImage: profileImage ?? this.profileImage,
      prevImage: prevImage ?? this.prevImage,
      username: username ?? this.username,
      imageSizeCheck: imageSizeCheck ?? this.imageSizeCheck,
      imageTypeCheck: imageTypeCheck ?? this.imageTypeCheck,
      useTempImage: useTempImage ?? this.useTempImage,
      panX: panX ?? this.panX,
      panY: panY ?? this.panY,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
    );
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileCardState &&
        profileImage == other.profileImage &&
        prevImage == other.prevImage &&
        username == other.username &&
        imageSizeCheck == other.imageSizeCheck &&
        imageTypeCheck == other.imageTypeCheck &&
        useTempImage == other.useTempImage &&
        panX == other.panX &&
        panY == other.panY &&
        scale == other.scale && 
        rotation == other.rotation;

  @override
  int get hashCode => Object.hash(
    profileImage,
    prevImage,
    username,
    imageSizeCheck,
    imageTypeCheck,
    useTempImage,
    panX,
    panY,
    scale,
    rotation,
  );
}