import 'profile_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Mock implementation of ProfileRepository for testing username availability.
/// Simulates a network/database call by checking a hardcoded list of taken usernames.
/// Replace this with a real Firebase implementation when ready.
class ConcreteProfileRepository implements ProfileRepository {

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  /// Simulates an async check for username availability.
  /// Returns true if the username is NOT taken, false if it is taken.
  @override
  Future<bool> isUsernameAvailable(String username) async {

    if(db.collection("users").where("username", isEqualTo: username).get()){

    }

  }

  @override
  Future<String> uploadPhotoToStorage(XFile? profilePhoto) async {

    //Simulate delay in waiting for the image to be uploaded
    await Future.delayed(const Duration(seconds: 1));
    //Returns a string path to the image in storage
    return "path/to/image/in/storage.jpg";
  }

  //To upload profile data to Firebase database
  @override
  Future<bool> submitProfile(OnboardingSubmissionData data) async {



  }
    
}