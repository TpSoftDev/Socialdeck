/*-------------------- test_deck_persistence.dart -----------------------*/
// Test Deck Persistence Page - Reference-Based Approach
// Tests saving and loading decks using only photo IDs (not uploading images)
// User Journey:
// 1. User selects photos → Extract IDs
// 2. User saves deck → Write IDs to Firestore
// 3. User loads deck → Read IDs from Firestore
// 4. App reconstructs photos → Display in grid
/*--------------------------------------------------------------------------*/

import 'dart:typed_data'; // For Uint8List (thumbnail data)
import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:socialdeck/features/decks/presentation/pages/add_cards_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For saving to Firestore
import 'package:firebase_auth/firebase_auth.dart'; // For getting current user ID

/// TestDeckPersistencePage: Tests the reference-based deck approach
/// This page demonstrates saving/loading decks WITHOUT uploading images
class TestDeckPersistencePage extends StatefulWidget {
  const TestDeckPersistencePage({super.key});

  @override
  State<TestDeckPersistencePage> createState() =>
      _TestDeckPersistencePageState();
}

class _TestDeckPersistencePageState extends State<TestDeckPersistencePage> {
  //*************************** State Variables ******************************//
  // Stage 1: Selection & Saving
  List<AssetEntity> _selectedPhotos = []; // Photos selected from picker
  String? _savedDeckId; // Firestore deck ID after saving
  String _saveStatus = "Not saved yet"; // Status message for save operation
  int? _saveTimeMs; // Time taken to save (milliseconds)
  bool _isSaving = false; // Whether save is in progress

  // Stage 2: Loading & Display
  List<AssetEntity?> _loadedPhotos =
      []; // Photos reconstructed from IDs (some may be null if deleted)
  String _loadStatus = "No deck loaded"; // Status message for load operation
  int? _loadTimeMs; // Time taken to load (milliseconds)
  bool _isLoading = false; // Whether load is in progress

  //*************************** Lifecycle Methods ******************************//
  @override
  void initState() {
    super.initState();
    // TODO: We'll add initialization logic later if needed
  }

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Top Navigation ------------------------//
            // Back button to return to main decks test hub
            SDeckTopNavigationBar.backWithTitleAndIcon(
              title: "Upload Deck",
              onBackPressed: () => Navigator.pop(context),
            ),

            //------------------------ Main Content Area ---------------------//
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //---------- STAGE 1: SELECT & SAVE ----------//
                    _buildStage1SelectAndSave(context),

                    const SizedBox(height: 32),

                    // Divider between stages
                    const Divider(thickness: 2),

                    const SizedBox(height: 32),

                    //---------- STAGE 2: LOAD & DISPLAY ----------//
                    _buildStage2LoadAndDisplay(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //*************************** UI Section Builders **************************//
  //------------------------------- Stage 1: Select & Save -------------------//
  /// Builds the first stage: Photo selection and saving to Firestore
  Widget _buildStage1SelectAndSave(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stage title
        Text(
          "📸 STAGE 1: SELECT & SAVE",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: context.component.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Select photos and save deck metadata to Firestore",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: context.component.textSecondary,
          ),
        ),

        const SizedBox(height: 16),

        // Select Photos Button
        SDeckSolidButton(
          text: "Select Photos",
          size: SDeckButtonSize.large,
          fullWidth: true,
          onPressed: _onSelectPhotosPressed,
        ),

        const SizedBox(height: 12),

        // Display count of selected photos (updates when user selects photos)
        Text(
          "Selected: ${_selectedPhotos.length} photos",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: context.component.textPrimary,
          ),
        ),

        const SizedBox(height: 24),

        // Save Deck Button (disabled while saving is in progress)
        SDeckSolidButton(
          text: _isSaving ? "Saving..." : "Save Deck to Firestore",
          size: SDeckButtonSize.large,
          fullWidth: true,
          onPressed: _isSaving ? null : _onSaveDeckPressed,
        ),

        const SizedBox(height: 12),

        // Display save status and timing (updates after save completes)
        Text(
          _saveStatus + (_saveTimeMs != null ? " ($_saveTimeMs ms)" : ""),
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: context.component.textPrimary,
          ),
        ),

        // Show saved deck ID if available
        if (_savedDeckId != null) ...[
          const SizedBox(height: 8),
          Text(
            "Deck ID: $_savedDeckId",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: context.component.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  //------------------------------- Stage 2: Load & Display ------------------//
  /// Builds the second stage: Loading deck and displaying photos
  Widget _buildStage2LoadAndDisplay(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stage title
        Text(
          "💾 STAGE 2: LOAD & DISPLAY",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: context.component.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Load deck from Firestore and reconstruct photos",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: context.component.textSecondary,
          ),
        ),

        const SizedBox(height: 16),

        // Load Deck Button (disabled while loading or if no deck saved yet)
        SDeckSolidButton(
          text: _isLoading ? "Loading..." : "Load Deck from Firestore",
          size: SDeckButtonSize.large,
          fullWidth: true,
          onPressed:
              (_isLoading || _savedDeckId == null) ? null : _onLoadDeckPressed,
        ),

        const SizedBox(height: 12),

        // Display load status and timing (updates after load completes)
        Text(
          _loadStatus + (_loadTimeMs != null ? " ($_loadTimeMs ms)" : ""),
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: context.component.textPrimary,
          ),
        ),

        const SizedBox(height: 24),

        // Photo Grid Header
        Text(
          "Loaded Photos: (${_loadedPhotos.where((p) => p != null).length} of ${_loadedPhotos.length})",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w600,
            color: context.component.textPrimary,
          ),
        ),
        const SizedBox(height: 12),

        // Photo Grid - shows loaded photos or empty state
        _buildLoadedPhotosGrid(context),
      ],
    );
  }

  //*************************** UI Builders **************************************//

  //------------------------------- Loaded Photos Grid -----------------------//
  /// Builds the grid of loaded photos (or empty state)
  Widget _buildLoadedPhotosGrid(BuildContext context) {
    // Empty state - no photos loaded yet
    if (_loadedPhotos.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[400]!),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.photo_library_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 8),
              Text(
                "Photos will appear here after loading",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    // Grid of loaded photos
    return GridView.builder(
      shrinkWrap: true, // Don't take infinite height
      physics:
          const NeverScrollableScrollPhysics(), // Disable scrolling (parent scrolls)
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 columns
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7, // Card aspect ratio
      ),
      itemCount: _loadedPhotos.length,
      itemBuilder: (context, index) {
        final photo = _loadedPhotos[index];

        // Handle missing photo (null)
        if (photo == null) {
          return _buildMissingPhotoCard(context);
        }

        // Display found photo
        return _buildPhotoCard(context, photo);
      },
    );
  }

  //------------------------------- Photo Card -------------------------------//
  /// Builds a card for a successfully loaded photo
  Widget _buildPhotoCard(BuildContext context, AssetEntity photo) {
    return FutureBuilder<Uint8List?>(
      future: photo.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.memory(snapshot.data!, fit: BoxFit.cover),
                  // Success indicator
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        // Loading state
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      },
    );
  }

  //------------------------------- Missing Photo Card -----------------------//
  /// Builds a placeholder card for a missing photo
  Widget _buildMissingPhotoCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[300]!, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image_outlined, size: 40, color: Colors.red[300]),
          const SizedBox(height: 4),
          Text(
            "Missing",
            style: TextStyle(color: Colors.red[700], fontSize: 12),
          ),
        ],
      ),
    );
  }

  //*************************** Button Handlers ******************************//
  // These functions will be called when buttons are pressed

  //------------------------------- Select Photos Handler --------------------//
  /// Handles the "Select Photos" button press
  /// Navigates to AddCardsPage and receives selected photos back
  void _onSelectPhotosPressed() async {
    print("🖼️ Opening photo picker...");

    // Navigate to AddCardsPage and wait for result
    // The result will be a List<AssetEntity> of selected photos
    final result = await Navigator.push<List<AssetEntity>>(
      context,
      MaterialPageRoute(builder: (context) => const AddCardsPage()),
    );

    // If user selected photos (didn't cancel), update our state
    if (result != null && result.isNotEmpty) {
      setState(() {
        _selectedPhotos = result; // Store the selected photos
      });
      print("✅ Selected ${result.length} photos");
    } else {
      print("❌ No photos selected");
    }
  }

  //------------------------------- Save Deck Handler ------------------------//
  /// Handles the "Save Deck to Firestore" button press
  /// Saves deck metadata (IDs only) to Firestore and measures performance
  Future<void> _onSaveDeckPressed() async {
    // Validation: Check if user selected photos
    if (_selectedPhotos.isEmpty) {
      setState(() {
        _saveStatus = "❌ Error: No photos selected";
      });
      return;
    }

    // Set loading state (disables button, shows "Saving...")
    setState(() {
      _isSaving = true;
      _saveStatus = "Saving to Firestore...";
    });

    try {
      // Start timing to measure performance
      final startTime = DateTime.now();

      // Step 1: Extract photo IDs (the KEY to reference-based approach)
      final photoIds = _extractPhotoIds(_selectedPhotos);
      print("📋 Extracted ${photoIds.length} photo IDs");

      // Step 2: Generate unique deck ID
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final deckId = 'test_deck_$timestamp';

      // Step 3: Get current user ID (for ownership)
      final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

      // Step 4: Create deck data structure (ONLY metadata, NO images)
      final deckData = {
        'deckId': deckId,
        'deckName': 'Test Deck',
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
        'cardCount': photoIds.length,
        'photoIds': photoIds, // Just the IDs! Not the actual photos
      };

      print("💾 Saving deck to Firestore: $deckId");
      print("📊 Data size: ~${deckData.toString().length} bytes");

      // Step 5: Save to Firestore (test_decks collection)
      await FirebaseFirestore.instance
          .collection('test_decks')
          .doc(deckId)
          .set(deckData);

      // Stop timing
      final endTime = DateTime.now();
      final durationMs = endTime.difference(startTime).inMilliseconds;

      print("✅ Save complete in $durationMs ms");

      // Update UI with success
      setState(() {
        _isSaving = false;
        _saveStatus = "✅ Saved successfully!";
        _saveTimeMs = durationMs;
        _savedDeckId = deckId;
      });
    } catch (e) {
      // Handle errors (network issues, permissions, etc.)
      print("❌ Save failed: $e");
      setState(() {
        _isSaving = false;
        _saveStatus = "❌ Error: ${e.toString()}";
      });
    }
  }

  //------------------------------- Load Deck Handler ------------------------//
  /// Handles the "Load Deck from Firestore" button press
  /// Loads deck metadata and reconstructs photos from IDs
  Future<void> _onLoadDeckPressed() async {
    // Validation: Check if we have a deck ID to load
    if (_savedDeckId == null) {
      setState(() {
        _loadStatus = "❌ Error: No deck to load (save a deck first)";
      });
      return;
    }

    // Set loading state
    setState(() {
      _isLoading = true;
      _loadStatus = "Loading from Firestore...";
      _loadedPhotos = []; // Clear previous results
    });

    try {
      // Start timing to measure performance
      final startTime = DateTime.now();

      print("📥 Loading deck from Firestore: $_savedDeckId");

      // Step 1: Read deck document from Firestore
      final docSnapshot =
          await FirebaseFirestore.instance
              .collection('test_decks')
              .doc(_savedDeckId)
              .get();

      // Check if deck exists
      if (!docSnapshot.exists) {
        setState(() {
          _isLoading = false;
          _loadStatus = "❌ Error: Deck not found";
        });
        return;
      }

      // Step 2: Extract photo IDs from the document
      final deckData = docSnapshot.data()!;
      final List<dynamic> photoIds = deckData['photoIds'] ?? [];
      print("📋 Found ${photoIds.length} photo IDs in deck");

      // Step 3: Reconstruct photos from IDs using Photo Manager
      final List<AssetEntity?> reconstructedPhotos = [];
      int foundCount = 0;
      int missingCount = 0;

      for (int i = 0; i < photoIds.length; i++) {
        final photoId = photoIds[i] as String;
        print("🔍 Looking up photo $i: $photoId");

        try {
          // Ask Photo Manager for the photo with this ID
          final List<AssetEntity> assets = await PhotoManager.getAssetListRange(
            start: 0,
            end: 100000, // Large number to get all photos
          );

          // Find the photo with matching ID
          AssetEntity? foundPhoto;
          for (final asset in assets) {
            if (asset.id == photoId) {
              foundPhoto = asset;
              break;
            }
          }

          if (foundPhoto != null) {
            reconstructedPhotos.add(foundPhoto);
            foundCount++;
            print("✅ Photo $i found");
          } else {
            reconstructedPhotos.add(null); // Photo not found (deleted?)
            missingCount++;
            print("❌ Photo $i missing");
          }
        } catch (e) {
          reconstructedPhotos.add(null);
          missingCount++;
          print("❌ Error loading photo $i: $e");
        }
      }

      // Stop timing
      final endTime = DateTime.now();
      final durationMs = endTime.difference(startTime).inMilliseconds;

      print("✅ Load complete in $durationMs ms");
      print("📊 Results: $foundCount found, $missingCount missing");

      // Update UI with results
      setState(() {
        _isLoading = false;
        _loadedPhotos = reconstructedPhotos;
        _loadTimeMs = durationMs;
        _loadStatus =
            missingCount == 0
                ? "✅ Loaded all $foundCount photos!"
                : "⚠️ Loaded $foundCount of ${photoIds.length} photos ($missingCount missing)";
      });
    } catch (e) {
      // Handle errors
      print("❌ Load failed: $e");
      setState(() {
        _isLoading = false;
        _loadStatus = "❌ Error: ${e.toString()}";
      });
    }
  }

  //*************************** Helper Functions *****************************//

  //------------------------------- Extract Photo IDs ------------------------//
  /// Extracts Asset IDs from photo objects
  /// This is the KEY to reference-based approach: we only save IDs, not images
  ///
  /// Input: [AssetEntity, AssetEntity, AssetEntity]
  /// Output: ["id1", "id2", "id3"]
  List<String> _extractPhotoIds(List<AssetEntity> photos) {
    return photos.map((photo) => photo.id).toList();
  }
}
