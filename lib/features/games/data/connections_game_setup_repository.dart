import 'game_setup_repository.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConnectionsGameSetupRepository implements GameSetupRepository{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // IA: Real AI operations use FirebasePromptAiRepository. Never silently return samples.
  @override
  Future<List<String>> generateExamplePrompts(List<String> options) async =>
      throw StateError('Use the structured AI repository.');
  @override
  Future<void> reportFeedback(PromptFeedbackData data) async =>
      throw StateError('Use the structured AI repository.');

  Future<bool> createGame(GameSubmissionData data) async {
    //TODO

    final uid = _auth.currentUser!.uid;

    final partyId = await db.collection("partySessions").doc(uid).get().then((
      querySnapshot,
    ) {
      return querySnapshot.get("partyId");
    });

    final query = await db.collection("parties").doc(partyId).get().then((
      querySnapshot,
    ) {
      return querySnapshot;
    });

    final game = {
      "id": data.gameType,
      "mixCards": data.mixCards,
      "requiredCards": 7,
      "rounds": data.amountRounds,
      "safeMode": data.safeMode,
      "playingWith": data.playingWith,
      "mood": data.mood,
      "keywords": data.keywords,
    };

    final gameProfile = {
      "hostId": query.get("hostId"),
      "phase": query.get("phase"),
      "revision": query.get("revision") + 1,
      "game": game,
      "memberIds": query.get("memberIds"),
      "members": query.get("members"),
      "createdAt": query.get("createdAt"),
      "updatedAt": FieldValue.serverTimestamp(),
    };

    bool result = true;
    await db.collection("parties")
      .doc(partyId)
      .update(gameProfile)
      .onError((e, _) => print("Error $e"));

    return result;
  }
}