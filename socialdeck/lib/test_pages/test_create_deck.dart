/*-------------------- test_add_cards_page.dart -----------------------*/
// Test Add Cards Page for the Decks feature
// Instagram-like interface for selecting photos to add to a deck
//
// User Journey: User taps 'Add Cards' → Sees this page with camera roll
/*--------------------------------------------------------------------------*/

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';

class TestCreateDeckPage extends StatefulWidget {
  const TestCreateDeckPage({super.key});

  @override
  State<TestCreateDeckPage> createState() => _TestCreateDeckPageState();
}

class _TestCreateDeckPageState extends State<TestCreateDeckPage> {
  //*************************** State Variables ******************************//
  // Photo management
  List<AssetEntity> _photos = []; // List of photos from device
  List<AssetEntity> _selectedPhotos = []; // Currently selected photos
  bool _isLoadingPhotos = false; // Loading state
  bool _hasPermission = false; // Permission status

  // Album management
  List<AssetPathEntity> _albums = []; // Available albums
  AssetPathEntity? _currentAlbum; // Currently selected album
  bool _showAlbumSelector = false; // Show/hide album selector

  //*************************** Lifecycle Methods ******************************//
  @override
  void initState() {
    super.initState();
    _requestPermissionAndLoadPhotos();
  }

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Top Navigation ------------------------//
            // Top navigation bar (we'll build this next)
            SDeckTopNavigationBar.logoWithTitle(title: "Add Cards"),

            //------------------------ Main Content Area ---------------------//
            // Split-screen layout: selected cards on top, camera roll below
            Expanded(
              child: Column(
                children: [
                  // Top section: Selected cards (fixed height)
                  _buildSelectedCardsSection(context),

                  // Bottom section: Camera roll grid (expanded)
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

  //------------------------------- Selected Cards Section --------------------//
  /// Builds the selected cards section (top half)
  /// Shows horizontal scrolling list of selected photos as small cards
  /// Matches Figma design with proper spacing and card dimensions
  Widget _buildSelectedCardsSection(BuildContext context) {
    return Container(
      // Fixed height to match Figma proportions (144px)
      height: 144,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        children: [
          // Header with "Selected Photos" and count
          _buildSelectedCardsHeader(context),
          const SizedBox(height: 12),
          // Horizontal scrolling cards
          Expanded(child: _buildSelectedCardsList(context)),
        ],
      ),
    );
  }

  //------------------------------- Selected Cards Header ---------------------//
  /// Builds the header showing "Selected Photos" and count
  /// Left side: "Selected Photos" label
  /// Right side: Card icon + count (e.g., "5")
  Widget _buildSelectedCardsHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Selected Photos",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 18, // Exact Figma size
            fontWeight: FontWeight.w600, // Poppins SemiBold
          ),
        ),
        Row(
          children: [
            // Card icon (using socialdeck logo as placeholder)
            SDeckIcon.small(
              SDeckIcons.placeholder, // TODO: socialdeckLogo missing - using placeholder
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 2),
            // Count (dynamic based on selected photos)
            Text(
              "${_selectedPhotos.length}", // Dynamic count of selected photos
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  //------------------------------- Selected Cards List -----------------------//
  /// Builds the horizontal scrolling list of selected cards
  /// Uses ListView.builder for performance with many cards
  Widget _buildSelectedCardsList(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _selectedPhotos.length, // Show actual selected photos
      itemBuilder: (context, index) {
        return _buildSelectedCard(context, index);
      },
    );
  }

  //------------------------------- Individual Selected Card ------------------//
  /// Builds an individual selected card with delete button
  /// Matches Figma design: 68x96px with shadow and rounded corners
  /// Delete button positioned in top-right corner
  Widget _buildSelectedCard(BuildContext context, int index) {
    final photo = _selectedPhotos[index];

    return Container(
      width: 68, // Exact Figma width
      height: 96, // Exact Figma height
      margin: const EdgeInsets.only(right: 12), // 12px spacing between cards
      child: Stack(
        children: [
          // Card background with shadow
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEBEBEB), // Light gray from Figma
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FutureBuilder<Uint8List?>(
                future: photo.thumbnailDataWithSize(
                  const ThumbnailSize(68, 96),
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Image.memory(
                      snapshot.data!,
                      width: 68,
                      height: 96,
                      fit: BoxFit.cover,
                    );
                  }
                  return const Center(
                    child: Text("Loading...", style: TextStyle(fontSize: 10)),
                  );
                },
              ),
            ),
          ),
          // Delete button (top-right corner)
          Positioned(
            top: -12,
            right: -12,
            child: GestureDetector(
              onTap: () {
                _removeSelectedPhoto(index);
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //------------------------------- Camera Roll Section ----------------------//
  /// Builds the camera roll section (bottom half)
  /// Shows photo grid from device gallery with selection functionality
  Widget _buildCameraRollSection(BuildContext context) {
    if (!_hasPermission) {
      return _buildPermissionPrompt(context);
    }

    if (_isLoadingPhotos) {
      return _buildLoadingState(context);
    }

    if (_photos.isEmpty) {
      return _buildEmptyState(context);
    }

    return _buildPhotoGrid(context);
  }

  //------------------------------- Permission Prompt -------------------------//
  /// Shows permission request prompt when photos access is not granted
  Widget _buildPermissionPrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_library_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "Photo Access Required",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            "Allow access to your photos to select cards",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SDeckSolidButton.medium(
            text: "Grant Permission",
            onPressed: _requestPermissionAndLoadPhotos,
          ),
        ],
      ),
    );
  }

  //------------------------------- Loading State -----------------------------//
  /// Shows loading indicator while photos are being loaded
  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            "Loading Photos...",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  //------------------------------- Empty State -------------------------------//
  /// Shows message when no photos are found
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_library_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "No Photos Found",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            "Take some photos to get started",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  //------------------------------- Photo Grid --------------------------------//
  /// Builds the photo grid with selection functionality
  Widget _buildPhotoGrid(BuildContext context) {
    return Column(
      children: [
        // Album selector header
        _buildAlbumSelector(context),

        // Album dropdown (if showing)
        if (_showAlbumSelector) _buildAlbumDropdown(context),

        // Photo grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 columns like Instagram
              crossAxisSpacing: 2, // Small spacing between photos
              mainAxisSpacing: 2,
              childAspectRatio: 1, // Square photos
            ),
            itemCount: _photos.length,
            itemBuilder: (context, index) {
              return _buildPhotoGridItem(context, index);
            },
          ),
        ),
      ],
    );
  }

  //------------------------------- Album Dropdown -----------------------------//
  /// Builds the album dropdown list
  Widget _buildAlbumDropdown(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children:
            _albums.map((album) {
              final isSelected = album == _currentAlbum;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _currentAlbum = album;
                    _showAlbumSelector = false;
                  });
                  _loadPhotosFromAlbum(album);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue[50] : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      // Album icon
                      Icon(
                        Icons.folder,
                        size: 20,
                        color: isSelected ? Colors.blue : Colors.grey[600],
                      ),
                      const SizedBox(width: 12),
                      // Album name
                      Expanded(
                        child: Text(
                          album.name,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: isSelected ? Colors.blue : Colors.black,
                            fontWeight:
                                isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                          ),
                        ),
                      ),
                      // Photo count
                      FutureBuilder<int>(
                        future: album.assetCountAsync,
                        builder: (context, snapshot) {
                          final count = snapshot.data ?? 0;
                          return Text(
                            "$count",
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  //------------------------------- Album Selector ----------------------------//
  /// Builds the album selector header
  Widget _buildAlbumSelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Current album name
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showAlbumSelector = !_showAlbumSelector;
                });
              },
              child: Row(
                children: [
                  Text(
                    _currentAlbum?.name ?? "Select Album",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _showAlbumSelector
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          // Photo count
          Text(
            "${_photos.length} photos",
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  //------------------------------- Photo Grid Item ---------------------------//
  /// Builds individual photo grid item with selection functionality
  Widget _buildPhotoGridItem(BuildContext context, int index) {
    final photo = _photos[index];
    final isSelected = _selectedPhotos.contains(photo);

    return GestureDetector(
      onTap: () => _togglePhotoSelection(photo),
      child: Stack(
        children: [
          // Photo
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border:
                  isSelected ? Border.all(color: Colors.blue, width: 2) : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: FutureBuilder<Uint8List?>(
                future: photo.thumbnailDataWithSize(
                  const ThumbnailSize(200, 200),
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Image.memory(snapshot.data!, fit: BoxFit.cover);
                  }
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                },
              ),
            ),
          ),
          // Selection indicator
          if (isSelected)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 14),
              ),
            ),
        ],
      ),
    );
  }

  //*************************** Photo Management Methods **********************//

  //------------------------------- Request Permission and Load Photos --------//
  /// Requests photo permission and loads photos from device
  Future<void> _requestPermissionAndLoadPhotos() async {
    print("🔍 Starting permission request...");
    setState(() {
      _isLoadingPhotos = true;
    });

    try {
      // Check current permission status first
      final currentStatus = await Permission.photos.status;
      print("📱 Current permission status: $currentStatus");

      // Try PhotoManager's permission method first
      final pmPermission = await PhotoManager.requestPermissionExtend();
      print("📱 PhotoManager permission result: $pmPermission");

      if (pmPermission == PermissionState.authorized) {
        print("✅ PhotoManager permission granted! Loading photos...");
        setState(() {
          _hasPermission = true;
        });
        await _loadPhotos();
      } else {
        print("❌ PhotoManager permission denied: $pmPermission");
        // Fallback to permission_handler
        final permission = await Permission.photos.request();
        print("📱 Permission handler result: $permission");

        if (permission.isGranted) {
          print("✅ Permission handler granted! Loading photos...");
          setState(() {
            _hasPermission = true;
          });
          await _loadPhotos();
        } else {
          print("❌ All permission methods failed");
          setState(() {
            _hasPermission = false;
            _isLoadingPhotos = false;
          });
        }
      }
    } catch (e) {
      print("💥 Error requesting permission: $e");
      setState(() {
        _hasPermission = false;
        _isLoadingPhotos = false;
      });
    }
  }

  //------------------------------- Load Photos -------------------------------//
  /// Loads photos from device gallery
  Future<void> _loadPhotos() async {
    print("📸 Starting to load photos...");
    try {
      // Get all albums
      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        hasAll: true,
      );
      print("📁 Found ${albums.length} albums");

      if (albums.isNotEmpty) {
        setState(() {
          _albums = albums;
          _currentAlbum =
              albums.first; // Start with first album (usually "Recent")
        });

        await _loadPhotosFromAlbum(_currentAlbum!);
      } else {
        print("📁 No albums found");
        setState(() {
          _photos = [];
          _isLoadingPhotos = false;
        });
      }
    } catch (e) {
      print("💥 Error loading photos: $e");
      setState(() {
        _photos = [];
        _isLoadingPhotos = false;
      });
    }
  }

  //------------------------------- Load Photos From Album --------------------//
  /// Loads photos from a specific album
  Future<void> _loadPhotosFromAlbum(AssetPathEntity album) async {
    print("📂 Loading photos from album: ${album.name}");
    setState(() {
      _isLoadingPhotos = true;
    });

    try {
      // Load more photos (500 instead of 100)
      final photos = await album.getAssetListPaged(
        page: 0,
        size: 500, // Load first 500 photos
      );
      print("🖼️ Loaded ${photos.length} photos from ${album.name}");

      setState(() {
        _photos = photos;
        _isLoadingPhotos = false;
      });
    } catch (e) {
      print("💥 Error loading photos from album: $e");
      setState(() {
        _photos = [];
        _isLoadingPhotos = false;
      });
    }
  }

  //------------------------------- Toggle Photo Selection --------------------//
  /// Toggles photo selection (add/remove from selected photos)
  void _togglePhotoSelection(AssetEntity photo) {
    setState(() {
      if (_selectedPhotos.contains(photo)) {
        _selectedPhotos.remove(photo);
      } else {
        _selectedPhotos.add(photo);
      }
    });
  }

  //------------------------------- Remove Selected Photo ---------------------//
  /// Removes a photo from selected photos by index
  void _removeSelectedPhoto(int index) {
    setState(() {
      _selectedPhotos.removeAt(index);
    });
  }
}
