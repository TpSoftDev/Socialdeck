/*------------------- selected_photos_section.dart -----------------------*/
// Selected Photos Section component for the Add Cards feature
// Displays selected photos in a horizontal scrollable list with delete functionality
// Handles both empty state (gray placeholder) and active state (photo cards)
//
// User Journey: User selects photos from camera roll, sees them in this section
// Can remove photos by tapping the delete button on each card
/*--------------------------------------------------------------------------*/

/*------------------------------- Imports ----------------------------------*/
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../foundations/index.dart';
import '../icons/sdeck_icon.dart';
import '../cards/sdeck_playing_card.dart';
import '../../tokens/index.dart';

//------------------------------- SelectedPhotosSection --------------------//
/// Selected Photos Section component for displaying selected photos
/// Handles both empty state and active state with photo cards
class SelectedPhotosSection extends StatelessWidget {
  //------------------------------- Properties -----------------------------//
  final List<AssetEntity>
  selectedPhotos; // List of selected photos (AssetEntity objects)
  final VoidCallback? onPhotoRemoved; // Callback when photo is removed

  //------------------------------- Constructor ----------------------------//
  const SelectedPhotosSection({
    super.key,
    required this.selectedPhotos,
    this.onPhotoRemoved,
  });

  //*************************** Build Method ********************************//
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        SDeckSpace.paddingM, // 16px left
        0, // 0px top
        SDeckSpace.paddingM, // 16px right
        SDeckSpace.paddingS, // 12px bottom
      ),
      child: Column(
        children: [
          //------------------------ Header Row ------------------------//
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: "Selected Photos" title
              Text(
                'Selected Photos',
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              // Right: Card icon + count
              _buildCountSection(context),
            ],
          ),
          //------------------------ Content Section ------------------------//
          _buildContentSection(context),
        ],
      ),
    );
  }

  //*************************** Helper Methods **********************************//

  //------------------------------- Count Section ----------------------------//
  /// Builds the card icon with count display (right side of header)
  Widget _buildCountSection(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Card icon
        SDeckIcon.small(
          //TODO: Change to deck icon when it is added to the design system
          context.icons.socialdeckLogo, // Using deck icon for cards
        ),
        const SizedBox(
          width: SDeckSpace.gapXXS,
        ), // 4px gap between icon and count
        // Count text
        Text(
          '${selectedPhotos.length}', // Dynamic count
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  //------------------------------- Content Section --------------------------//
  /// Builds the content area (empty state or photo cards)
  Widget _buildContentSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: SDeckSpace.marginS), // 12px top margin
      child:
          selectedPhotos.isEmpty
              ? _buildEmptyState(context)
              : _buildPhotoCards(context),
    );
  }

  //------------------------------- Empty State ------------------------------//
  /// Builds the empty state (gray placeholder bar)
  Widget _buildEmptyState(BuildContext context) {
    return Container(
      height: 96, // Fixed height to match Figma
      decoration: BoxDecoration(
        color:
            Theme.of(
              context,
            ).colorScheme.secondary, // Using design system color
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadiusXXS),
      ),
    );
  }

  //------------------------------- Photo Cards ------------------------------//
  /// Builds the horizontal scrollable list of photo cards
  Widget _buildPhotoCards(BuildContext context) {
    return SizedBox(
      // Slightly taller than the card to give shadow breathing room
      height: 104,
      child: ListView.builder(
        // Allow card shadows to render outside the scrollable's bounds
        clipBehavior: Clip.none,
        // Add small vertical padding so shadows aren't visually cut
        padding: const EdgeInsets.symmetric(vertical: 4),
        scrollDirection: Axis.horizontal,
        itemCount: selectedPhotos.length,
        itemBuilder: (context, index) {
          return _buildPhotoCard(context, selectedPhotos[index], index);
        },
      ),
    );
  }

  //------------------------------- Photo Card -------------------------------//
  /// Builds individual photo card using existing SDeckPlayingCard component
  Widget _buildPhotoCard(BuildContext context, AssetEntity photo, int index) {
    return Container(
      margin: const EdgeInsets.only(
        right: SDeckSpace.marginS,
      ), // 12px gap between cards
      child: FutureBuilder<File?>(
        future: photo.file, // Get the file from AssetEntity
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            // Use the existing SDeckPlayingCard.smallest component (maintains original design)
            return SDeckPlayingCard.smallest(
              imagePath: snapshot.data!.path, // Pass file path to card
              onTap: () {
                // TODO: Add photo preview functionality
              },
            );
          }
          // Loading state - show placeholder card
          return SDeckPlayingCard.smallest(
            imagePath: null, // null shows checkered background
            onTap: null,
          );
        },
      ),
    );
  }
}
