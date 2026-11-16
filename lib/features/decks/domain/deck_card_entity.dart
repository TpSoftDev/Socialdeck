/*-------------------------- deck_card_entity.dart --------------------------*/
// Immutable domain model representing one saved photo card in a Deck or in
// Quick Pics. Photos stay local on the user's phone: localPath points to the
// current file on disk, while assetId stores the PhotoManager AssetEntity ID
// so the file path can be re-resolved if the OS rotates temporary cache paths.
//
// Usage:
//   final card = DeckCardEntity(
//     id: 'card_1',
//     localPath: '/var/mobile/.../IMG_0001.JPG',
//     assetId: 'asset-uuid-1',
//     tiltDegrees: -1.25,
//   );
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'dart:math' as math;

import 'decks_failure.dart';

//----------------------------- DeckCardEntity ------------------------------//
class DeckCardEntity {
  const DeckCardEntity({
    required this.id,
    required this.localPath,
    this.assetId,
    this.tiltDegrees = 0.0,
    this.scale = 1.0,
    this.panX = 0.0,
    this.panY = 0.0,
    this.rotation = 0.0,
  });

  /// Creates a new card with a generated resting tilt between -2.00 and 2.00
  /// degrees so reordering preserves the card's visual angle in the grid.
  factory DeckCardEntity.create({
    required String id,
    required String localPath,
    String? assetId,
    double? tiltDegrees,
    math.Random? random,
  }) {
    final trimmedId = id.trim();
    final trimmedPath = localPath.trim();
    requireDecks(trimmedId.isNotEmpty, DecksError.invalidInput, 'Card ID cannot be empty.');
    requireDecks(
      trimmedPath.isNotEmpty,
      DecksError.invalidInput,
      'Card localPath cannot be empty.',
    );

    final normalizedAssetId =
        (assetId == null || assetId.trim().isEmpty) ? null : assetId.trim();

    return DeckCardEntity(
      id: trimmedId,
      localPath: trimmedPath,
      assetId: normalizedAssetId,
      tiltDegrees: tiltDegrees ?? generateRestingTiltDegrees(random),
    );
  }

  //*************************** Properties **********************************//
  final String id;

  /// On-device file path used directly by SDeckPlayingCard for instant rendering.
  final String localPath;

  /// Optional PhotoManager AssetEntity.id used to re-locate the local photo if
  /// iOS or Android invalidates a cached file path across app launches.
  final String? assetId;

  /// Resting grid angle in degrees (-2.00 to 2.00). Kept stable across reorders.
  final double tiltDegrees;

  /// Optional Edit Card gesture transforms (pan, zoom, rotate) for future card editing.
  final double scale;
  final double panX;
  final double panY;
  final double rotation;

  //*************************** Validation **********************************//
  void validate() {
    requireDecks(
      id.trim().isNotEmpty && !id.contains('/'),
      DecksError.invalidInput,
      'Invalid card ID.',
    );
    requireDecks(
      localPath.trim().isNotEmpty,
      DecksError.invalidInput,
      'Card localPath cannot be empty.',
    );
    requireDecks(
      tiltDegrees >= -2.0 && tiltDegrees <= 2.0,
      DecksError.invalidInput,
      'Card tiltDegrees must stay within [-2.0, 2.0].',
    );
    requireDecks(
      scale > 0 && scale <= 10.0,
      DecksError.invalidInput,
      'Card scale must be positive.',
    );
  }

  //*************************** Copy & Equality *****************************//
  DeckCardEntity copyWith({
    String? id,
    String? localPath,
    String? assetId,
    bool clearAssetId = false,
    double? tiltDegrees,
    double? scale,
    double? panX,
    double? panY,
    double? rotation,
  }) {
    return DeckCardEntity(
      id: id ?? this.id,
      localPath: localPath ?? this.localPath,
      assetId: clearAssetId ? null : (assetId ?? this.assetId),
      tiltDegrees: tiltDegrees ?? this.tiltDegrees,
      scale: scale ?? this.scale,
      panX: panX ?? this.panX,
      panY: panY ?? this.panY,
      rotation: rotation ?? this.rotation,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeckCardEntity &&
          id == other.id &&
          localPath == other.localPath &&
          assetId == other.assetId &&
          tiltDegrees == other.tiltDegrees &&
          scale == other.scale &&
          panX == other.panX &&
          panY == other.panY &&
          rotation == other.rotation;

  @override
  int get hashCode => Object.hash(
    id,
    localPath,
    assetId,
    tiltDegrees,
    scale,
    panX,
    panY,
    rotation,
  );
}

//------------------------ Resting Tilt Generator ---------------------------//
final math.Random _defaultTiltRandom = math.Random();

/// Generates a two-decimal-place angle in [-2.00, 2.00] degrees for resting
/// deck and card tiles inside SDeckMoveGrid.
double generateRestingTiltDegrees([math.Random? random]) {
  final rng = random ?? _defaultTiltRandom;
  return (rng.nextInt(401) - 200) / 100.0;
}

/// Pure-Dart ordered equality check for DeckCardEntity lists so domain models
/// never need to import package:flutter.
bool sameDeckCardList(List<DeckCardEntity> a, List<DeckCardEntity> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
