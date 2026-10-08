import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import '../party.dart';
import '../domain/party_selection.dart';
import 'party_feedback.dart';

/// Selection stays local while browsing decks. Confirm saves a validated hand.
class PartyCardsPage extends ConsumerStatefulWidget {
  const PartyCardsPage({
    super.key,
    required this.partyId,
    required this.method,
  });
  final String partyId;
  final PartySelectionMethod method;
  @override
  ConsumerState<PartyCardsPage> createState() => _PartyCardsPageState();
}

class _PartyCardsPageState extends ConsumerState<PartyCardsPage> {
  final selected = <String, PartyCard>{};
  String? deckId;
  String? deckName;

  bool canPick(AsyncValue<Party?> snapshot, String? uid) {
    final party = snapshot.asData?.value;
    return !snapshot.isLoading &&
        !snapshot.hasError &&
        uid != null &&
        party != null &&
        party.members.containsKey(uid) &&
        party.phase == PartyPhase.lobby &&
        party.game != null;
  }

  void backToDecks() => setState(() {
    deckId = null;
    deckName = null;
  });

  Widget loadError(Object error, String label, VoidCallback retry) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(partyErrorMessage(error)),
        TextButton(onPressed: retry, child: Text(label)),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final busy = ref.watch(partyActionsProvider).isLoading;
    final decks = ref.watch(partyDecksProvider);
    final allCards = ref.watch(partyAllCardsProvider);
    final partySnapshot = ref.watch(partyByIdProvider(widget.partyId));
    final party = partySnapshot.asData?.value;
    final uid = ref.watch(currentUserProvider)?.uid;
    // Stale data can still be displayed during a retry, but cannot be submitted.
    final catalogReady =
        allCards.hasValue &&
        !allCards.isLoading &&
        !allCards.hasError &&
        decks.hasValue &&
        !decks.isLoading &&
        !decks.hasError;
    final enabled = !busy && catalogReady && canPick(partySnapshot, uid);
    final deckIds = {
      for (final deck in decks.asData?.value ?? <PartyDeck>[]) deck.id,
    };
    // A deleted deck must not leave invisible cards eligible for a random draw.
    final cards = [
      for (final card in allCards.asData?.value ?? <PartyCard>[])
        if (deckIds.contains(card.deckId)) card,
    ];
    final cardsById = <String, PartyCard>{};
    final cardsByDeck = <String, List<PartyCard>>{};
    // One pass replaces scanning the entire catalog for every deck row.
    for (final card in cards) {
      cardsById[card.id] = card;
      (cardsByDeck[card.deckId] ??= []).add(card);
    }
    // Keep selection order, but use current records and ignore deleted cards.
    final selectedCards = [
      for (final id in selected.keys)
        if (cardsById.containsKey(id)) cardsById[id]!,
    ];
    final visibleCards =
        deckId == null ? cards : cardsByDeck[deckId] ?? const <PartyCard>[];
    final single = widget.method == PartySelectionMethod.singleDeck;
    final random = widget.method == PartySelectionMethod.random;
    final browsingDeck = !single && !random && deckId != null;
    final unavailable =
        uid == null
            ? 'Sign in to pick cards.'
            : partySnapshot.isLoading
            ? 'Loading your party…'
            : partySnapshot.hasError
            ? partyErrorMessage(partySnapshot.error)
            : party == null ||
                party.phase == PartyPhase.closed ||
                !party.members.containsKey(uid)
            ? 'You are no longer in this party.'
            : party.phase != PartyPhase.lobby
            ? 'The game has started. Card selection is closed.'
            : party.game == null
            ? 'Card selection is unavailable until the host selects a game.'
            : null;
    return PopScope(
      canPop: !browsingDeck,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && browsingDeck) backToDecks();
      },
      child: Scaffold(
        backgroundColor: context.semantic.surface,
        appBar: AppBar(
          title: Text(deckName ?? (single ? 'Pick a Deck' : 'Pick 7 Cards')),
          leading: BackButton(
            onPressed: () {
              if (browsingDeck) {
                backToDecks();
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: Column(
          children: [
            if (busy) const LinearProgressIndicator(),
            if (unavailable != null && !busy)
              Padding(padding: EdgeInsets.all(16), child: Text(unavailable)),
            if (partySnapshot.hasError)
              TextButton(
                onPressed:
                    () => ref.invalidate(partyByIdProvider(widget.partyId)),
                child: const Text('Retry party connection'),
              ),
            Expanded(
              child: allCards.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error:
                    (e, _) => loadError(
                      e,
                      'Retry cards',
                      () => ref.invalidate(partyAllCardsProvider),
                    ),
                data:
                    (_) => decks.when(
                      loading:
                          () =>
                              const Center(child: CircularProgressIndicator()),
                      error:
                          (e, _) => loadError(
                            e,
                            'Retry decks',
                            () => ref.invalidate(partyDecksProvider),
                          ),
                      data: (items) {
                        if (cards.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: Text(
                                'No saved cards yet. Add cards to your decks before picking a hand.',
                              ),
                            ),
                          );
                        }
                        if (random) {
                          return Center(
                            child: Text(
                              'Choose 7 random cards from your ${cards.length} saved cards.',
                            ),
                          );
                        }
                        if (single || deckId == null) {
                          final sorted = [...items]..sort((a, b) {
                            final favorite = (b.favorite ? 1 : 0).compareTo(
                              a.favorite ? 1 : 0,
                            );
                            return favorite != 0
                                ? favorite
                                : a.name.compareTo(b.name);
                          });
                          return ListView(
                            children:
                                sorted.map((deck) {
                                  final count =
                                      cardsByDeck[deck.id]?.length ?? 0;
                                  return ListTile(
                                    leading: Icon(
                                      deck.favorite ? Icons.star : Icons.style,
                                    ),
                                    title: Text(deck.name),
                                    subtitle: Text('$count cards'),
                                    selected: deckId == deck.id,
                                    enabled: enabled && (!single || count >= 7),
                                    onTap:
                                        () => setState(() {
                                          deckId = deck.id;
                                          deckName = deck.name;
                                        }),
                                  );
                                }).toList(),
                          );
                        }
                        return GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: .72,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                              ),
                          itemCount: visibleCards.length,
                          itemBuilder: (context, index) {
                            final card = visibleCards[index];
                            final chosen = selected.containsKey(card.id);
                            return Semantics(
                              selected: chosen,
                              label: 'Card ${index + 1}',
                              child: InkWell(
                                onTap:
                                    !enabled
                                        ? null
                                        : () => setState(() {
                                          if (chosen) {
                                            selected.remove(card.id);
                                          } else {
                                            selected[card.id] = card;
                                          }
                                        }),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(
                                      card.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (_, __, ___) =>
                                              const Icon(Icons.broken_image),
                                    ),
                                    if (chosen)
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                            width: 4,
                                          ),
                                        ),
                                      ),
                                    if (chosen)
                                      const Align(
                                        alignment: Alignment.topRight,
                                        child: Icon(Icons.check_circle),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
              ),
            ),
            if (!single && !random)
              SizedBox(
                height: 72,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children:
                      selectedCards
                          .toList()
                          .reversed
                          .map(
                            (card) => Padding(
                              padding: const EdgeInsets.all(4),
                              child: InputChip(
                                label: SizedBox(
                                  width: 38,
                                  height: 48,
                                  child: Image.network(
                                    card.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (_, __, ___) => const Icon(Icons.image),
                                  ),
                                ),
                                onDeleted:
                                    busy
                                        ? null
                                        : () => setState(
                                          () => selected.remove(card.id),
                                        ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed:
                        enabled &&
                                allCards.hasValue &&
                                (random
                                    ? cards.length >= 7
                                    : single
                                    ? deckIds.contains(deckId) &&
                                        visibleCards.length >= 7
                                    : selectedCards.length >= 7)
                            ? () => save(
                              random
                                  ? cards
                                  : single
                                  ? visibleCards
                                  : selectedCards,
                            )
                            : null,
                    child: Text(
                      busy
                          ? 'Saving…'
                          : random
                          ? 'Use 7 Random Cards'
                          : single
                          ? (deckName == null
                              ? 'None Selected'
                              : 'Use $deckName')
                          : selectedCards.length < 7
                          ? '${7 - selectedCards.length} Cards Remaining'
                          : selectedCards.length == 7
                          ? 'Use These 7 Cards'
                          : 'Use Any of ${selectedCards.length} Cards',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> save(List<PartyCard> candidates) async {
    // Recheck captured callbacks against current party and catalog snapshots.
    if (!mounted ||
        ref.read(partyActionsProvider).isLoading ||
        !canPick(
          ref.read(partyByIdProvider(widget.partyId)),
          ref.read(currentUserProvider)?.uid,
        )) {
      return;
    }
    final cards = ref.read(partyAllCardsProvider);
    final decks = ref.read(partyDecksProvider);
    if (!cards.hasValue ||
        cards.isLoading ||
        cards.hasError ||
        !decks.hasValue ||
        decks.isLoading ||
        decks.hasError) {
      return;
    }
    final deckIds = {for (final deck in decks.requireValue) deck.id};
    final candidateIds = {for (final card in candidates) card.id};
    final current = [
      for (final card in cards.requireValue)
        if (candidateIds.contains(card.id) &&
            deckIds.contains(card.deckId) &&
            (widget.method != PartySelectionMethod.singleDeck ||
                card.deckId == deckId))
          card,
    ];
    if (current.map((card) => card.id).toSet().length < 7) return;
    final ids = PartySelection.draw(current, count: 7);
    final ok = await ref
        .read(partyActionsProvider.notifier)
        .selectCards(widget.partyId, ids);
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
    } else {
      partyToast(
        context,
        partyErrorMessage(ref.read(partyActionsProvider).error),
      );
    }
  }
}
