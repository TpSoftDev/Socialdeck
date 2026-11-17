/*------------------------- quick_pics_page.dart -----------------------------*/
// Quick Pics page for the Decks feature. Streams the signed-in user's saved
// Quick Pics cards (up to 100 local-reference photos) from quickPicsWatchProvider
// so navigating back or switching tabs preserves all added and reordered cards.
//
// Usage: context.push(AppPaths.quickPics)
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/decks/data/local_photo_resolver.dart';
import 'package:socialdeck/features/decks/domain/deck_card_entity.dart';
import 'package:socialdeck/features/decks/domain/decks_failure.dart';
import 'package:socialdeck/features/decks/domain/decks_repository.dart';
import 'package:socialdeck/features/decks/domain/quick_pics_entity.dart';
import 'package:socialdeck/features/decks/providers/decks_actions_provider.dart';
import 'package:socialdeck/features/decks/providers/decks_providers.dart';
import 'package:socialdeck/features/decks/shared/move/sdeck_move_grid.dart';

//------------------------------- QuickPicsPage -----------------------------//
class QuickPicsPage extends ConsumerStatefulWidget {
  const QuickPicsPage({super.key});

  @override
  ConsumerState<QuickPicsPage> createState() => _QuickPicsPageState();
}

class _QuickPicsPageState extends ConsumerState<QuickPicsPage> {
  //*************************** Toast State ***********************************//
  ({SDeckToastStatus status, String title, String description})? _toast;

  // Fresh file paths. The saved localPath is a temporary copy iOS may delete.
  final _resolver = const LocalPhotoResolver();
  final Map<String, String> _photoPaths = {};
  final Set<String> _resolving = {};
  final Set<String> _missingPhotos = {};
  Future<bool>? _photoAccess;

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    // Keep autoDispose actions alive for Camera Roll / reorder awaits.
    ref.watch(decksActionsProvider);
    final quickPicsAsync = ref.watch(quickPicsWatchProvider);
    final cards = quickPicsAsync.valueOrNull?.cards ?? const <DeckCardEntity>[];
    final hasPhotos = cards.isNotEmpty;
    _resolveMissingPhotos(cards);

    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Top Navigation ------------------------//
            const SDeckTopNavigationBar(
              left: SDeckTopBarLeft.back,
              type: SDeckTopBarType.subpage,
              right: SDeckTopBarRight.none,
              title: 'Quick Pics',
            ),

            //------------------------ Toast Feedback ------------------------//
            if (_toast != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  SDeckSpace.margin16,
                  0,
                  SDeckSpace.margin16,
                  SDeckSpace.gap12,
                ),
                child: SDeckToast(
                  status: _toast!.status,
                  title: _toast!.title,
                  description: _toast!.description,
                  onDismiss: () => setState(() => _toast = null),
                ),
              ),

            //------------------------ Main Content Area ---------------------//
            Expanded(
              child: quickPicsAsync.isLoading && !quickPicsAsync.hasValue
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SDeckSpace.margin16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //------------------ All Cards Section --------------//
                          SDeckSectionHeader(
                            title: 'All Cards',
                            supportingText:
                                '${cards.length}/${QuickPicsEntity.maxCards}',
                          ),

                          const SizedBox(height: SDeckSpace.gap12),

                          //---------------------- Cards ----------------------//
                          if (hasPhotos)
                            _buildPhotoGrid(cards)
                          else ...[
                            SDeckAddTarget(
                              onTap: () => _showAddCardsSheet(context),
                            ),
                            const SizedBox(height: SDeckSpace.gap12),
                            _buildEmptyState(context),
                          ],
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  //*************************** Card Grid *************************************//
  // Same press-and-hold grid the decks use. This page draws the card.
  Widget _buildPhotoGrid(List<DeckCardEntity> cards) {
    return SDeckMoveGrid<DeckCardEntity>(
      items: cards,
      leading: SDeckAddTarget(
        onTap: () => _showAddCardsSheet(context),
      ),
      onReorder: _saveCardOrder,
      tiltDegrees: (card) => card.tiltDegrees,
      itemBuilder: _card,
      heldItemBuilder: _heldCard,
    );
  }

  Widget _card(DeckCardEntity card) {
    return SDeckPlayingCard(
      size: SDeckPlayingCardSize.small,
      shadow: SDeckPlayingCardShadow.none,
      imagePath: _photoPaths[card.id] ?? card.localPath,
      scale: card.scale,
      panX: card.panX,
      panY: card.panY,
    );
  }

  // Held card stays straight and grows to 174 by 234.
  // The yellow border comes from moveHeld.
  Widget _heldCard(DeckCardEntity card) {
    return SizedBox(
      width: 116 * 1.5,
      height: 156 * 1.5,
      child: FittedBox(
        fit: BoxFit.fill,
        child: SDeckPlayingCard(
          size: SDeckPlayingCardSize.small,
          shadow: SDeckPlayingCardShadow.none,
          state: SDeckPlayingCardState.moveHeld,
          imagePath: _photoPaths[card.id] ?? card.localPath,
          scale: card.scale,
          panX: card.panX,
          panY: card.panY,
        ),
      ),
    );
  }

  // Ask the camera roll for a new file when the saved temporary copy is gone.
  void _resolveMissingPhotos(List<DeckCardEntity> cards) {
    for (final card in cards) {
      if (_photoPaths.containsKey(card.id) ||
          _resolving.contains(card.id) ||
          _missingPhotos.contains(card.id)) {
        continue;
      }
      _resolving.add(card.id);
      _resolvePhoto(card);
    }
  }

  Future<void> _resolvePhoto(DeckCardEntity card) async {
    final allowed = await _hasPhotoAccess();
    if (!mounted) return;
    if (!allowed) {
      _resolving.remove(card.id);
      _missingPhotos.add(card.id);
      return;
    }

    final path = await _resolver.resolveCardPath(card);
    if (!mounted) return;
    _resolving.remove(card.id);
    if (path == null) {
      _missingPhotos.add(card.id);
      return;
    }
    setState(() => _photoPaths[card.id] = path);
  }

  Future<bool> _hasPhotoAccess() {
    return _photoAccess ??= () async {
      var permission = await PhotoManager.getPermissionState(
        requestOption: const PermissionRequestOption(),
      );
      if (!permission.hasAccess &&
          permission == PermissionState.notDetermined) {
        permission = await PhotoManager.requestPermissionExtend();
      }
      return permission.hasAccess;
    }();
  }

  Future<void> _saveCardOrder(List<DeckCardEntity> next) async {
    final orderedIds = next.map((card) => card.id).toList();
    final ok = await ref
        .read(decksActionsProvider.notifier)
        .reorderQuickPics(orderedIds);
    if (!mounted || ok) return;
    _showErrorToast();
  }

  //*************************** Empty State ***********************************//
  Widget _buildEmptyState(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 370 / 185,
          child: SDeckVisualPlaceholder(
            borderRadius: BorderRadius.circular(
              SDeckRadius.borderRadius16,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            'Save some cards for later!',
            style: Theme.of(context).textTheme.body.copyWith(
              color: context.component.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  //*************************** Add Cards Sheet *******************************//
  void _showAddCardsSheet(BuildContext context) {
    showSDeckBottomSheet(
      context: context,
      title: 'Add Cards',
      buttons: [
        //-------------------- Shuffle Search Target -------------------------//
        SDeckImageTarget(
          title: 'Shuffle Search',
          description: 'Select from 16 random photos',
          onTap: () {},
        ),

        //-------------------- Camera Roll Button ---------------------------//
        SDeckSolidButton(
          text: 'Camera Roll',
          size: SDeckButtonSize.large,
          iconLocation: SDeckButtonIconLocation.left,
          iconTextGap: SDeckSpace.gap6,
          icon: SDeckIcons(
            SDeckIcon.grid,
            size: SDeckSize.size24,
            color: Colors.white,
          ),
          onPressed: () async {
            Navigator.of(context, rootNavigator: true).pop();
            final picked = await context.push<List<NewDeckCardDraft>>(
              AppPaths.cameraRoll,
            );
            if (!mounted || picked == null || picked.isEmpty) return;

            final ok = await ref
                .read(decksActionsProvider.notifier)
                .addCardsToQuickPics(picked);
            if (!mounted || ok) return;
            _showErrorToast();
          },
        ),

        //-------------------- Take a Photo Button --------------------------//
        SDeckOutlineButton(
          text: 'Take a Photo',
          size: SDeckButtonSize.large,
          iconLocation: SDeckButtonIconLocation.left,
          iconTextGap: SDeckSpace.gap6,
          icon: SDeckIcons(
            SDeckIcon.camera,
            size: SDeckSize.size24,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  void _showErrorToast() {
    final error = ref.read(decksActionsProvider).error;
    final isLimit = error == DecksError.quickPicsLimitReached;
    setState(() {
      _toast = (
        status: isLimit ? SDeckToastStatus.warning : SDeckToastStatus.error,
        title: decksErrorTitle(error),
        description: decksErrorMessage(error),
      );
    });
  }
}
