import 'dart:ffi';

import 'game_setup_repository.dart';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConnectionsGameSetupRepository implements GameSetupRepository{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  /*Future<List<String>> generateExamplePrompts(List<String> options) async{
    //TODO
    List<String> Prompts = [""];
    return Prompts;
  }

  Future<void> reportFeedback(PromptFeedbackData data) async{
    //TODO
    Timer(const Duration(seconds: 3), () {});
  }*/

  Future<List<String>> generateExamplePrompts(List<String> options) async{
    Timer(const Duration(seconds: 10), () {});
    List<String> Prompts = ["The face you make when the investor says 'let's circle back'", 
                            "POV: you just found out your co-founder used the last of the office snacks... on a Tuesday",
                            "This is fine (it is not fine)"];
    return Prompts;
  }

  Future<void> reportFeedback(PromptFeedbackData data) async{
    Timer(const Duration(seconds: 3), () {});
  }

  Future<bool> createGame(GameSubmissionData data) async{
    //TODO

    final uid = _auth.currentUser!.uid;

    final partyId = await db.collection("partySessions").doc(uid).get()
      .then((querySnapshot) {
        return querySnapshot.get("partyId");
      });

    final query = await db.collection("parties").doc(partyId).get()
      .then((querySnapshot) {
        return querySnapshot;
      });

    final game = {"id": data.gameType,
                  "mixCards": data.mixCards,
                  "requiredCards": 7,
                  "rounds": data.amountRounds,
                  "safeMode": data.safeMode,
                  "playingWith": data.playingWith,
                  "mood": data.mood,
                  "keywords": data.keywords};

    

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