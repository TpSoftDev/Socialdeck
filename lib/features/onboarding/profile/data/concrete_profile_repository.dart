import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

import 'profile_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Mock implementation of ProfileRepository for testing username availability.
/// Simulates a network/database call by checking a hardcoded list of taken usernames.
/// Replace this with a real Firebase implementation when ready.
class ConcreteProfileRepository implements ProfileRepository {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  /// Returns true if the username is NOT taken, false if it is taken.
  @override
  Future<bool> isUsernameAvailable(String username) async {

    //Should query for if username exists, then return true if no username is in the database that matches
    return await db.collection("users").where("username_insensitive", isEqualTo: username.toLowerCase()).get()
      .then((querySnapshot) {
        return querySnapshot.size == 0;
      });

  }

  @override
  Future<String?> uploadPhotoToStorage(XFile? profilePhoto) async {

    final uid = _auth.currentUser!.uid;

    if (profilePhoto == null){
      return null;
    }

    //Variables to denoted names for where image is stored
    final fileName = 'profile_$uid.jpg';
    final storageRef = _storage.ref().child('users/$uid/profile/$fileName');

    //Convert XFile to bytes for upload — avoids iOS 18.4 HTTP/3 bug with putFile
    final imageAsFile = File(profilePhoto.path);
    final bytes = await imageAsFile.readAsBytes();
    final uploadTask = storageRef.putData(bytes);

    //Perform upload, then return the URL in storage
    final snapshot = await uploadTask;
    return snapshot.ref.getDownloadURL();
  }

  //To upload profile data to Firebase database
  @override
  Future<bool> submitProfile(OnboardingSubmissionData data) async {

    final uid = _auth.currentUser!.uid;

    //All user profile data to be uploaded
    final userProfile = {
      "username": data.username,
      "username_insensitive": data.username.toLowerCase(),
      "email": _auth.currentUser!.email,
      "photoUrl": data.imagePath,
      "scale": data.scale,
      "panX": data.panX,
      "panY": data.panY,
      "rotation": data.rotation,
      "onboardingComplete": true,
      "createdAt": FieldValue.serverTimestamp(),
    };
    
    //Records error state of uploading profile, as well as sets the document for the user with the user profile information
    bool result = true;
    await db.collection('users')
      .doc(uid)
      .set(userProfile, SetOptions(merge: true))
      .onError((e, _) => result = false);
    return result;

  }
    
}