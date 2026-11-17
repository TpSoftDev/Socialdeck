/*------------------------ local_photo_resolver.dart -------------------------*/
// Resolves a DeckCardEntity's on-device File for rendering and Party session
// uploads. Checks localPath on disk first, then falls back to PhotoManager's
// AssetEntity.fromId(assetId) if iOS or Android rotated a cached file path.
//
// Usage:
//   final file = await const LocalPhotoResolver().resolveCardFile(card);
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'dart:io';

import 'package:photo_manager/photo_manager.dart';

import '../domain/deck_card_entity.dart';

//--------------------------- LocalPhotoResolver ----------------------------//
class LocalPhotoResolver {
  const LocalPhotoResolver();

  /// Returns an existing [File] for [card], or `null` if the photo was deleted
  /// from the user's device library and is no longer cached locally.
  Future<File?> resolveCardFile(DeckCardEntity card) async {
    if (card.localPath.isNotEmpty) {
      final directFile = File(card.localPath);
      if (await directFile.exists()) {
        return directFile;
      }
    }

    final assetId = card.assetId;
    if (assetId == null || assetId.isEmpty) {
      return null;
    }

    try {
      final asset = await AssetEntity.fromId(assetId);
      if (asset == null) return null;
      final refreshedFile = await asset.file;
      if (refreshedFile != null && await refreshedFile.exists()) {
        return refreshedFile;
      }
    } catch (_) {
      // Permission revoked or PhotoManager unavailable on this platform.
      return null;
    }

    return null;
  }

  /// Resolves the freshest usable file path string for [card], returning the
  /// stored `localPath` if no refresh was needed or `null` if missing on device.
  Future<String?> resolveCardPath(DeckCardEntity card) async {
    final file = await resolveCardFile(card);
    return file?.path;
  }
}
