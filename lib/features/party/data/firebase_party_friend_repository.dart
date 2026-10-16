import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/party_friend.dart';
import 'party_firebase_errors.dart';

/// Reads accepted friendships; creating friendships belongs to Social.
class FirebasePartyFriendRepository {
  FirebasePartyFriendRepository({
    required this.uid,
    FirebaseFirestore? firestore,
  }) : _db = firestore ?? FirebaseFirestore.instance;
  final String uid;
  final FirebaseFirestore _db;

  Stream<List<PartyFriend>> watchFriends() => PartyFirebaseErrors.stream(
    _db
        .collection('friends')
        .doc(uid)
        .collection('members')
        .where('status', isEqualTo: 'accepted')
        .snapshots()
        .map(
          (snapshot) => List.unmodifiable(
            snapshot.docs.map(
              (doc) => PartyFriend(
                uid: doc.id,
                name: doc.data()['username'] as String,
                // Presence is not implemented; do not claim these users are online.
              ),
            ),
          ),
        ),
  );
}
