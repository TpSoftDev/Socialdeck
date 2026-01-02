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
  List<AssetEntity> selectedPhotos =
      []; // List of selected photos (AssetEntity objects)

  // Permission and photo state
  bool _hasPhotoPermission = false;
  List<AssetEntity> _photos = [];
  bool _isLoadingPhotos = false;
  // Albums state
  List<AssetPathEntity> _albums = [];
  AssetPathEntity? _currentAlbum;
  // ---------------- Pagination state for camera roll grid ---------------- //
  // Current page index for the active album (0-based)
  int _currentPage = 0;
  // Whether a next-page load is in-flight
  bool _isLoadingMore = false;
  // Whether the album still has more items after the last load
  bool _hasMore = true;
  // Scroll controller to detect when we are near the bottom of the grid
  final ScrollController _gridScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Kick off permission flow for Camera Roll access
    _ensurePhotoPermission();

    // Attach a listener to implement infinite scroll pagination.
    _gridScrollController.addListener(() {
      // If not permitted or no album yet, ignore
      if (!_hasPhotoPermission || _currentAlbum == null) return;
      // If already loading or nothing more to load, ignore
      if (_isLoadingMore || !_hasMore) return;

      // If we've scrolled within ~2 screens of the bottom, load next page
      final position = _gridScrollController.position;
      if (position.pixels >=
          position.maxScrollExtent - position.viewportDimension * 2) {
        _loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    _gridScrollController.dispose();
    super.dispose();
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
      child: Align(
        alignment: Alignment.centerLeft,
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
      // OUTER GRID PADDING: space between grid and screen edges
      padding: const EdgeInsets.symmetric(horizontal: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        // COLUMN COUNT: number of tiles per row
        crossAxisCount: 4,
        // HORIZONTAL GAP: space between tiles in a row (px)
        crossAxisSpacing: 2,
        // VERTICAL GAP: space between rows (px)
        mainAxisSpacing: 2,
      ),
      // Attach controller so we can detect near-bottom scroll to paginate
      controller: _gridScrollController,
      itemCount: _photos.length,
      itemBuilder: (context, index) {
        final entity = _photos[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              // Toggle selection: add if not selected, remove if already selected
              if (selectedPhotos.contains(entity)) {
                selectedPhotos.remove(entity);
              } else {
                selectedPhotos.add(entity); // Store AssetEntity directly
              }
            });
          },
          child: ClipRRect(
            // TILE CORNER RADIUS: rounding of each image tile
            child: FutureBuilder<Uint8List?>(
              future: entity.thumbnailDataWithSize(
                // THUMBNAIL SIZE: requested image resolution (w x h)
                const ThumbnailSize(300, 300),
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  // IMAGE FIT: how image fills the square tile (cover crops to fill)
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
  /// Returns selected photos to the calling page
  void _onSavePressed() {
    // Pop back to previous screen and return the selected photos
    Navigator.pop(context, selectedPhotos);
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

      // Reset pagination whenever we switch or initially pick an album
      _currentPage = 0;
      _hasMore = true;

      // Load the first page
      const pageSize = 60; // Tune for UX/perf; 60 is a good starting point
      final List<AssetEntity> firstPage = await _currentAlbum!
          .getAssetListPaged(page: _currentPage, size: pageSize);

      setState(() {
        _photos = firstPage;
        _isLoadingPhotos = false;
        // If we received fewer than pageSize, there is no next page
        _hasMore = firstPage.length == pageSize;
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

    // Reset pagination for the new album
    _currentPage = 0;
    _hasMore = true;

    const pageSize = 60;
    final items = await album.getAssetListPaged(
      page: _currentPage,
      size: pageSize,
    );
    setState(() {
      _photos = items;
      _isLoadingPhotos = false;
      _hasMore = items.length == pageSize;
    });
  }

  // Loads the next page of items for the current album and appends to the grid
  Future<void> _loadNextPage() async {
    if (_currentAlbum == null) return;
    setState(() => _isLoadingMore = true);

    const pageSize = 60;
    final nextPage = _currentPage + 1;
    final items = await _currentAlbum!.getAssetListPaged(
      page: nextPage,
      size: pageSize,
    );

    setState(() {
      _currentPage = nextPage;
      _photos.addAll(items);
      _isLoadingMore = false;
      _hasMore = items.length == pageSize;
    });
  }
}
