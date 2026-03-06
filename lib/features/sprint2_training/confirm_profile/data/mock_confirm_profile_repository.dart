//Import abstract dart class
import 'confirm_profile_repository.dart';

class MockConfirmProfileRepository implements ConfirmProfileRepository {

  //Simulates getting the username of the profile from Firebase
  @override
  Future<String?> getProfileName() async {
    await Future.delayed(const Duration(seconds: 2));
    return "Username";
  }

  //Simulates getting the image from the repository
  @override
  Future<String?> getProfileImage() async {
    await Future.delayed(const Duration(seconds: 4));
    return "assets/Photos/IL9A0525-Enhanced-NR.jpg";
  }
}