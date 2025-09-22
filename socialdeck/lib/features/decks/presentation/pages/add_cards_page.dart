/*-------------------- add_cards_page.dart -----------------------*/
// Add Cards Page for the Decks feature
// Instagram-like interface for selecting photos to add to a deck
//
// User Journey: User taps 'Add Cards' → Sees this page with camera roll
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/design_system/components/sections/selected_photos_section.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class AddCardsPage extends ConsumerStatefulWidget {
  const AddCardsPage({super.key});

  @override
  ConsumerState<AddCardsPage> createState() => _AddCardsPageState();
}

class _AddCardsPageState extends ConsumerState<AddCardsPage> {
  //*************************** State Variables ******************************//
  List<String> selectedPhotos = []; // List of selected photo paths

  // Permission and photo state
  bool _hasPhotoPermission = false;
  List<AssetEntity> _photos = [];
  bool _isLoadingPhotos = false;
  // Albums state
  List<AssetPathEntity> _albums = [];
  AssetPathEntity? _currentAlbum;
  // int _currentPage = 0; // reserved for future pagination

  @override
  void initState() {
    super.initState();
    // Kick off permission flow for Camera Roll access
    _ensurePhotoPermission();
  }

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Top Navigation ------------------------//
            SDeckTopNavigationBar.backWithTitle(
              title: "Add Cards",
              onBackPressed: () => Navigator.pop(context),
              onActionPressed: _onSavePressed,
            ),

            //------------------------ Main Content Area ---------------------//
            Expanded(
              child: Column(
                children: [
                  // Top section: Selected photos (we'll build this next)
                  _buildSelectedPhotosSection(context),

                  // Bottom section: Camera roll (we'll build this next)
                  Expanded(child: _buildCameraRollSection(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //*************************** Helper Methods **********************************//

  //------------------------------- Selected Photos Section --------------------//
  /// Builds the selected photos section (top half)
  Widget _buildSelectedPhotosSection(BuildContext context) {
    return SelectedPhotosSection(
      selectedPhotos: selectedPhotos,
      onPhotoRemoved: _onPhotoRemoved,
    );
  }

  //------------------------------- Camera Roll Section ----------------------//
  /// Builds the camera roll section (bottom half)
  Widget _buildCameraRollSection(BuildContext context) {
    // Teaching note:
    // - We show three possible states for the camera roll area:
    //   1) Loading while we request permission and fetch photos
    //   2) Permission denied → show an explanation and a button to request again
    //   3) Permission granted → show a simple summary (we will build the grid next)

    if (_isLoadingPhotos) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_hasPhotoPermission) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "We need access to your photos to show the camera roll.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            SDeckSolidButton.medium(
              text: "Allow Photos",
              onPressed: _requestPhotosPermissionManually,
            ),
          ],
        ),
      );
    }

    // Permission granted → render album selector + grid
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildAlbumsBar(context),
        const SizedBox(height: 8),
        Expanded(child: _buildCameraRollGrid(context)),
      ],
    );
  }

  //------------------------------- Albums Bar --------------------------------//
  /// Small bar to pick an album (e.g., Recents, Favorites, Screenshots)
  Widget _buildAlbumsBar(BuildContext context) {
    final title = _currentAlbum?.name ?? 'Recents';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Center(
        child: TextButton.icon(
          onPressed: _showAlbumsSheet,
          icon: const Icon(Icons.expand_more),
          label: Text(title, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ),
    );
  }

  //------------------------------- Camera Roll Grid -------------------------//
  /// Renders a 3-column grid of recent photos with small spacing.
  /// Tapping a photo adds it to the selected photos at the top.
  Widget _buildCameraRollGrid(BuildContext context) {
    if (_photos.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            "No photos found",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: _photos.length,
      itemBuilder: (context, index) {
        final entity = _photos[index];
        return GestureDetector(
          onTap: () async {
            final file = await entity.file;
            if (file != null) {
              setState(() {
                selectedPhotos.add(file.path);
              });
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: FutureBuilder<Uint8List?>(
              future: entity.thumbnailDataWithSize(
                const ThumbnailSize(300, 300),
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Image.memory(snapshot.data!, fit: BoxFit.cover);
                }
                return Container(color: Colors.grey.shade300);
              },
            ),
          ),
        );
      },
    );
  }

  //------------------------------- Save Button Handler -----------------------//
  /// Handles save button press
  void _onSavePressed() {
    // We'll implement this later
    print("Save pressed - no photos selected yet");
  }

  //------------------------------- Photo Removal Handler ---------------------//
  /// Handles photo removal from selected photos
  void _onPhotoRemoved() {
    setState(() {
      if (selectedPhotos.isNotEmpty) {
        selectedPhotos.removeLast(); // Remove the last photo for testing
      }
    });
  }

  //*************************** Permissions & Photos ***************************//
  /// Ensures we have photo permission and loads a first page of recent photos
  Future<void> _ensurePhotoPermission() async {
    // Start loading state for the camera roll area
    setState(() => _isLoadingPhotos = true);

    // 1) Ask PhotoManager for extended permission (best for iOS 14+ limited access)
    final pmResult = await PhotoManager.requestPermissionExtend();
    final grantedByPM = pmResult.isAuth;

    if (!grantedByPM) {
      // 2) Fallback using permission_handler in case of edge cases
      final phStatus = await Permission.photos.request();
      if (phStatus.isGranted) {
        setState(() => _hasPhotoPermission = true);
        await _loadAlbumsAndFirstPage();
        return;
      }

      // Not granted
      setState(() {
        _hasPhotoPermission = false;
        _isLoadingPhotos = false;
      });
      return;
    }

    // Granted by PhotoManager
    setState(() => _hasPhotoPermission = true);
    await _loadAlbumsAndFirstPage();
  }

  /// Manual re-request (bound to the "Allow Photos" button)
  Future<void> _requestPhotosPermissionManually() async {
    setState(() => _isLoadingPhotos = true);
    await _ensurePhotoPermission();
  }

  /// Loads albums and the first page of the initially selected album
  Future<void> _loadAlbumsAndFirstPage() async {
    try {
      // Fetch all image albums (not just "All Photos")
      _albums = await PhotoManager.getAssetPathList(
        onlyAll: false,
        type: RequestType.image,
      );

      if (_albums.isEmpty) {
        setState(() {
          _photos = [];
          _isLoadingPhotos = false;
        });
        return;
      }

      // Default to the first album (typically Recents)
      _currentAlbum = _albums.first;

      final List<AssetEntity> firstPage = await _currentAlbum!
          .getAssetListPaged(page: 0, size: 60);

      setState(() {
        _photos = firstPage;
        _isLoadingPhotos = false;
      });
    } catch (_) {
      setState(() => _isLoadingPhotos = false);
    }
  }

  /// Shows a bottom sheet with available albums to switch between
  Future<void> _showAlbumsSheet() async {
    if (_albums.isEmpty) return;
    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: ListView.separated(
            itemCount: _albums.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final album = _albums[index];
              final isCurrent = album == _currentAlbum;
              return ListTile(
                title: Text(album.name),
                trailing: isCurrent ? const Icon(Icons.check) : null,
                onTap: () async {
                  Navigator.pop(context);
                  await _switchAlbum(album);
                },
              );
            },
          ),
        );
      },
    );
  }

  /// Switches the current album and loads its first page
  Future<void> _switchAlbum(AssetPathEntity album) async {
    setState(() {
      _isLoadingPhotos = true;
      _currentAlbum = album;
    });

    final items = await album.getAssetListPaged(page: 0, size: 60);
    setState(() {
      _photos = items;
      _isLoadingPhotos = false;
    });
  }
}
