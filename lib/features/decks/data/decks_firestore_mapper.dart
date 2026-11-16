/*----------------------- decks_firestore_mapper.dart -----------------------*/
// Explicit serialization adapter between Decks domain entities and Firestore
// document maps for users/{uid}/decks/{deckId} and users/{uid}/quickPics/main.
// Keeps JSON/Timestamp conversions out of the domain layer and validates
// schemaVersion so malformed records fail visibly instead of corrupting state.
//
// Usage:
//   final map = DecksFirestoreMapper.deckToMap(deck);
//   final entity = DecksFirestoreMapper.deckFromMap(doc.id, doc.data()!);
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

import '../domain/deck_card_entity.dart';
import '../domain/deck_entity.dart';
import '../domain/decks_failure.dart';
import '../domain/quick_pics_entity.dart';

//-------------------------- DecksFirestoreMapper ---------------------------//
class DecksFirestoreMapper {
  const DecksFirestoreMapper._();

  static const int currentSchemaVersion = 1;

  //*************************** Card Mapping ********************************//
  static Map<String, dynamic> cardToMap(DeckCardEntity card) {
    card.validate();
    return <String, dynamic>{
      'id': card.id,
      'localPath': card.localPath,
      'assetId': card.assetId,
      'tiltDegrees': card.tiltDegrees,
      'scale': card.scale,
      'panX': card.panX,
      'panY': card.panY,
      'rotation': card.rotation,
    };
  }

  static DeckCardEntity cardFromMap(Map<String, dynamic> data) {
    try {
      final card = DeckCardEntity(
        id: data['id'] as String,
        localPath: data['localPath'] as String,
        assetId: data['assetId'] as String?,
        tiltDegrees: (data['tiltDegrees'] as num?)?.toDouble() ?? 0.0,
        scale: (data['scale'] as num?)?.toDouble() ?? 1.0,
        panX: (data['panX'] as num?)?.toDouble() ?? 0.0,
        panY: (data['panY'] as num?)?.toDouble() ?? 0.0,
        rotation: (data['rotation'] as num?)?.toDouble() ?? 0.0,
      );
      card.validate();
      return card;
    } catch (error) {
      if (error is DecksFailure) rethrow;
      throw DecksFailure(DecksError.invalidInput, 'Malformed card record: $error');
    }
  }

  //*************************** Deck Mapping ********************************//
  static Map<String, dynamic> deckToMap(DeckEntity deck) {
    deck.validate();
    return <String, dynamic>{
      'schemaVersion': currentSchemaVersion,
      'name': deck.name,
      'colorKey': deck.colorKey,
      'favorited': deck.favorited,
      'orderIndex': deck.orderIndex,
      'tiltDegrees': deck.tiltDegrees,
      'cards': deck.cards.map(cardToMap).toList(),
      if (deck.createdAt != null) 'createdAt': Timestamp.fromDate(deck.createdAt!),
      if (deck.updatedAt != null) 'updatedAt': Timestamp.fromDate(deck.updatedAt!),
    };
  }

  static DeckEntity deckFromMap(String id, Map<String, dynamic> data) {
    try {
      final version = data['schemaVersion'] as int? ?? currentSchemaVersion;
      requireDecks(
        version == currentSchemaVersion,
        DecksError.invalidInput,
        'Unsupported deck schemaVersion: $version',
      );

      final rawCards = data['cards'] as List<dynamic>? ?? const <dynamic>[];
      final cards = rawCards
          .map((item) => cardFromMap(Map<String, dynamic>.from(item as Map)))
          .toList();

      final deck = DeckEntity(
        id: id,
        name: data['name'] as String,
        colorKey: data['colorKey'] as String,
        favorited: data['favorited'] as bool? ?? false,
        orderIndex: (data['orderIndex'] as num?)?.toInt() ?? 0,
        tiltDegrees: (data['tiltDegrees'] as num?)?.toDouble() ?? 0.0,
        cards: cards,
        createdAt: _parseDateTime(data['createdAt']),
        updatedAt: _parseDateTime(data['updatedAt']),
      );
      deck.validate();
      return deck;
    } catch (error) {
      if (error is DecksFailure) rethrow;
      throw DecksFailure(DecksError.invalidInput, 'Malformed deck $id: $error');
    }
  }

  //*************************** Quick Pics Mapping **************************//
  static Map<String, dynamic> quickPicsToMap(QuickPicsEntity quickPics) {
    quickPics.validate();
    return <String, dynamic>{
      'schemaVersion': currentSchemaVersion,
      'cards': quickPics.cards.map(cardToMap).toList(),
      if (quickPics.updatedAt != null)
        'updatedAt': Timestamp.fromDate(quickPics.updatedAt!),
    };
  }

  static QuickPicsEntity quickPicsFromMap(Map<String, dynamic> data) {
    try {
      final version = data['schemaVersion'] as int? ?? currentSchemaVersion;
      requireDecks(
        version == currentSchemaVersion,
        DecksError.invalidInput,
        'Unsupported Quick Pics schemaVersion: $version',
      );

      final rawCards = data['cards'] as List<dynamic>? ?? const <dynamic>[];
      final cards = rawCards
          .map((item) => cardFromMap(Map<String, dynamic>.from(item as Map)))
          .toList();

      final quickPics = QuickPicsEntity(
        cards: cards,
        updatedAt: _parseDateTime(data['updatedAt']),
      );
      quickPics.validate();
      return quickPics;
    } catch (error) {
      if (error is DecksFailure) rethrow;
      throw DecksFailure(
        DecksError.invalidInput,
        'Malformed Quick Pics record: $error',
      );
    }
  }

  //*************************** Timestamp Helper ****************************//
  static DateTime? _parseDateTime(Object? raw) {
    if (raw == null) return null;
    if (raw is Timestamp) return raw.toDate();
    if (raw is DateTime) return raw;
    if (raw is String) return DateTime.tryParse(raw);
    return null;
  }
}
