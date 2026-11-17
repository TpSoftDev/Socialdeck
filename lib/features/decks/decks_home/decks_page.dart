/*---------------------------- decks_page.dart -------------------------------*/
// Decks home tab. Quick Pics sits on top; All Decks streams the signed-in
// user's saved DeckEntity list from decksWatchProvider, supporting free-tier
// limit checks (2 decks), Socialdeck+ upgrades, and press-and-hold reordering.
//
// Usage: the Decks tab.
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/decks/domain/deck_entity.dart';
import 'package:socialdeck/features/decks/providers/decks_actions_provider.dart';
import 'package:socialdeck/features/decks/providers/decks_providers.dart';
import 'package:socialdeck/features/decks/shared/move/sdeck_move_grid.dart';

//------------------------------- DecksPage ---------------------------------//
class DecksPage extends ConsumerStatefulWidget {
  const DecksPage({super.key});

  @override
  ConsumerState<DecksPage> createState() => _DecksPageState();
}

class _DecksPageState extends ConsumerState<DecksPage> {
  //*************************** Toast State ***********************************//
  ({SDeckToastStatus status, String title, String description})? _toast;

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    // Keep autoDispose actions alive for reorder / entitlement awaits.
    ref.watch(decksActionsProvider);
    final decksAsync = ref.watch(decksWatchProvider);
    final isPlusAsync = ref.watch(isSocialdeckPlusProvider);

    final decks = decksAsync.valueOrNull ?? const <DeckEntity>[];
    final isPlus = isPlusAsync.valueOrNull ?? false;

    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),

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

            Expanded(
              child: decksAsync.isLoading && !decksAsync.hasValue
                  ? const Center(child: CircularProgressIndicator())
                  : _buildBody(context, decks: decks, isPlus: isPlus),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return const SDeckTopNavigationBar(
      left: SDeckTopBarLeft.none,
      type: SDeckTopBarType.page,
      right: SDeckTopBarRight.profile,
      title: 'Decks',
    );
  }

  Widget _buildBody(
    BuildContext context, {
    required List<DeckEntity> decks,
    required bool isPlus,
  }) {
    final hasDecks = decks.isNotEmpty;
    // Free shows 1/2. Socialdeck+ shows the count alone.
    final deckCountLabel = isPlus
        ? '${decks.length}'
        : '${decks.length}/${DeckEntity.freeDeckLimit}';
    final isAtFreeLimit = !isPlus && decks.length >= DeckEntity.freeDeckLimit;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: SDeckSpace.margin16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //------------------------ Quick Pics ------------------------------//
          SDeckImageTarget(
            title: 'Quick Pics',
            description: 'Save cards to revisit or replay',
            onTap: () => context.push(AppPaths.quickPics),
          ),

          SizedBox(height: hasDecks ? SDeckSpace.gap12 : SDeckSpace.gap16),

          //------------------------ All Decks -------------------------------//
          // Unpadded so the title sits on the page and lines up with the row.
          SDeckSectionHeader(
            title: 'All Decks',
            supportingText: deckCountLabel,
            padded: false,
          ),

          const SizedBox(height: SDeckSpace.gap12),

          if (hasDecks) ...[
            _buildDeckRow(decks, isAtFreeLimit: isAtFreeLimit),
            if (!isPlus) ...[
              const SizedBox(height: SDeckSpace.gap12),
              SDeckImageTarget(
                title: 'More Decks?',
                description: 'Get Socialdeck+ for more!',
                onTap: _showMoreDecksDialog,
              ),
            ],
          ] else ...[
            SDeckAddTarget(
              onTap: () => _startCreateDeck(isAtFreeLimit: isAtFreeLimit),
            ),
            const SizedBox(height: SDeckSpace.gap12),
            _buildEmptyState(context),
          ],
        ],
      ),
    );
  }

  //*************************** Deck Row **************************************//
  // Shared move grid. This page only draws the deck, including the held look.
  Widget _buildDeckRow(
    List<DeckEntity> decks, {
    required bool isAtFreeLimit,
  }) {
    return SDeckMoveGrid<DeckEntity>(
      items: decks,
      leading: SDeckAddTarget(
        onTap: () => _startCreateDeck(isAtFreeLimit: isAtFreeLimit),
      ),
      onItemTap: _openDeck,
      onReorder: _saveDeckOrder,
      itemBuilder: _deckTarget,
      tiltDegrees: (deck) => deck.tiltDegrees,
      heldItemBuilder: (deck) => _deckTarget(
        deck,
        state: SDeckDeckTargetState.moveHeld,
      ),
    );
  }

  Widget _deckTarget(
    DeckEntity deck, {
    SDeckDeckTargetState state = SDeckDeckTargetState.enabled,
  }) {
    return SDeckDeckTarget(
      color: _resolveDeckColor(deck.colorKey),
      favorited: deck.favorited,
      deckTitle: deck.name,
      cardCount: '${deck.cardCount}/${DeckEntity.maxCards}',
      shadow: SDeckDeckTargetShadow.none,
      state: state,
    );
  }

  SDeckColorPickerColor _resolveDeckColor(String colorKey) {
    for (final value in SDeckColorPickerColor.values) {
      if (value.name == colorKey) return value;
    }
    return SDeckColorPickerColor.brightCoral;
  }

  Future<void> _saveDeckOrder(List<DeckEntity> next) async {
    final orderedIds = next.map((deck) => deck.id).toList();
    final ok = await ref
        .read(decksActionsProvider.notifier)
        .reorderDecks(orderedIds);
    if (!mounted || ok) return;
    final error = ref.read(decksActionsProvider).error;
    setState(() {
      _toast = (
        status: SDeckToastStatus.error,
        title: decksErrorTitle(error),
        description: decksErrorMessage(error),
      );
    });
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
            'Create your first deck!',
            style: Theme.of(context).textTheme.body.copyWith(
              color: context.component.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  //*************************** Actions ***************************************//
  // A third deck is past the free limit, so add opens the upgrade dialog.
  Future<void> _startCreateDeck({required bool isAtFreeLimit}) async {
    if (isAtFreeLimit) {
      _showMoreDecksDialog();
      return;
    }
    await context.push(AppPaths.newDeckColor);
  }

  Future<void> _openDeck(DeckEntity deck) async {
    await context.push(AppPaths.deckCards, extra: deck);
  }

  // Store goes to the store. Buy turns on Socialdeck+ via decksActionsProvider.
  void _showMoreDecksDialog() {
    final dialogWidth =
        MediaQuery.sizeOf(context).width - (2 * SDeckSpace.margin32);

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(SDeckSpace.margin32),
          child: SDeckDialog(
            title: 'More Decks?',
            description: 'Upgrade to Socialdeck+ for infinite decks and more!',
            dialogWidth: dialogWidth,
            contentHeight: (dialogWidth - SDeckSpace.padding24 * 2) * 185 / 370,
            content: const SDeckVisualPlaceholder(),
            secondaryButtonText: 'Store',
            primaryButtonText: 'Buy',
            onSecondaryPressed: () {
              Navigator.of(dialogContext).pop();
              context.push(AppPaths.store);
            },
            onPrimaryPressed: () async {
              Navigator.of(dialogContext).pop();
              await ref
                  .read(decksActionsProvider.notifier)
                  .setSocialdeckPlus(true);
            },
            onClose: () => Navigator.of(dialogContext).pop(),
          ),
        );
      },
    );
  }
}
