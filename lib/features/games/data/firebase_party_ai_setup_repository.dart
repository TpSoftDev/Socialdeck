import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/game_setup_state.dart';
import '../domain/party_ai_setup.dart';
import '../domain/prompt_ai.dart';
import '../../party/domain/party_models.dart';
import '../../party/domain/party_policy.dart';
import '../../party/data/party_firestore_mapper.dart';
import 'party_ai_setup_mapper.dart';

class FirebasePartyAiSetupRepository implements PartyAiSetupRepository {
  final String uid;
  final FirebaseFirestore db;
  final FirebaseAuth auth;
  FirebasePartyAiSetupRepository(
    this.uid, {
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  }) : db = firestore ?? FirebaseFirestore.instance,
       auth = auth ?? FirebaseAuth.instance;
  DocumentReference<Map<String, dynamic>> _party(String id) =>
      db.collection('parties').doc(PartyPolicy.cleanCode(id));
  @override
  Stream<PartyAiSetup?> watch(String partyId) => _party(partyId)
      .collection('aiSetup')
      .doc('current')
      .snapshots()
      .map((s) => s.exists ? PartyAiSetupMapper.decode(s.data()!) : null);
  @override
  Future<PartyAiSetup> save(
    String partyId,
    int expectedRevision,
    GameSetupState draft,
    PromptAiSession session,
  ) async {
    if (!session.complete)
      throw const PromptAiException('Approve all five examples before saving.');
    promptProfile(draft);
    final partyRef = _party(partyId);
    // IA: Atomic write. Host/phase/revision are rechecked on every transaction retry.
    // If summary permission fails, the game update rolls back too.
    return db.runTransaction((tx) async {
      if (auth.currentUser?.uid != uid)
        throw const PromptAiException(
          'Account changed. Sign in and try again.',
        );
      final snapshot = await tx.get(partyRef);
      if (!snapshot.exists)
        throw const PromptAiException('This party no longer exists.');
      final current = PartyFirestoreMapper.fromMap(partyId, snapshot.data()!);
      if (current.revision != expectedRevision)
        throw const PromptAiException(
          'Party settings changed. Reopen setup before saving.',
        );
      final game = PartyGame(
        rounds: draft.rounds,
        mixCards: draft.mixCards,
        safeMode: draft.safeMode,
      );
      final next = PartyPolicy.selectGame(current, uid, game);
      final saved = PartyAiSetup(
        revision: next.revision,
        sessionId: session.id,
        draft: draft,
        prompts: session.prompts,
      );
      if (next.revision != current.revision) {
        tx.update(partyRef, {
          'game': PartyFirestoreMapper.gameToMap(game),
          'revision': next.revision,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      tx.set(partyRef.collection('aiSetup').doc('current'), {
        ...PartyAiSetupMapper.encode(saved),
        'savedBy': uid,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return saved;
    });
  }
}
