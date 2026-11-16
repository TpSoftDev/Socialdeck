/*----------------------- new_deck_name_page.dart ----------------------------*/
// New Deck Name page — second step of the Create a Deck flow.
// User enters a deck name (max 15 characters). Create Deck stays disabled
// until the field has text, then persists the deck via decksActionsProvider
// and opens DeckCardsPage. Backing up and re-submitting updates the same deck.
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/decks/domain/deck_entity.dart';
import 'package:socialdeck/features/decks/domain/decks_failure.dart';
import 'package:socialdeck/features/decks/providers/decks_actions_provider.dart';

//---------------------------- NewDeckNamePage ------------------------------//
class NewDeckNamePage extends ConsumerStatefulWidget {
  const NewDeckNamePage({
    super.key,
    this.selectedColor = SDeckColorPickerColor.brightCoral,
  });

  final SDeckColorPickerColor selectedColor;

  @override
  ConsumerState<NewDeckNamePage> createState() => _NewDeckNamePageState();
}

class _NewDeckNamePageState extends ConsumerState<NewDeckNamePage> {
  static const int _maxNameLength = DeckEntity.maxNameLength;

  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

  // Set on the first Create. A later Create after pressing Back updates this
  // deck instead of creating a duplicate second deck.
  String? _createdDeckId;

  ({SDeckToastStatus status, String title, String description})? _toast;

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  bool get _hasName => _nameController.text.trim().isNotEmpty;

  String get _previewTitle {
    final name = _nameController.text.trim();
    return name.isEmpty ? 'Your Deck' : name;
  }

  SDeckInputState get _inputState {
    if (_nameFocusNode.hasFocus) return SDeckInputState.focused;
    if (_nameController.text.isNotEmpty) return SDeckInputState.filled;
    return SDeckInputState.hint;
  }

  void _onNameChanged(String value) {
    if (value.length > _maxNameLength) {
      _nameController.text = value.substring(0, _maxNameLength);
      _nameController.selection = const TextSelection.collapsed(
        offset: _maxNameLength,
      );
    }
    setState(() {});
  }

  Future<void> _onCreatePressed() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final actions = ref.read(decksActionsProvider.notifier);
    final colorKey = widget.selectedColor.name;

    final existingId = _createdDeckId;
    final DeckEntity? saved = existingId == null
        ? await actions.createDeck(name: name, colorKey: colorKey)
        : await actions.updateDeck(
            deckId: existingId,
            name: name,
            colorKey: colorKey,
          );

    if (!mounted) return;

    if (saved == null) {
      final error = ref.read(decksActionsProvider).error;
      final isLimit = error == DecksError.freeDeckLimitReached;
      setState(() {
        _toast = (
          status: isLimit ? SDeckToastStatus.warning : SDeckToastStatus.error,
          title: decksErrorTitle(error),
          description: decksErrorMessage(error),
        );
      });
      return;
    }

    _createdDeckId = saved.id;
    await context.push(AppPaths.deckCards, extra: saved);
  }

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    final isSaving = ref.watch(decksActionsProvider).isLoading;
    final canSubmit = _hasName && !isSaving;

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
              title: 'New Deck',
            ),

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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: SDeckSpace.margin16,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: SDeckSpace.gap16),

                    //------------------------ Deck Preview -------------------//
                    Transform.rotate(
                      angle: -0.53 * math.pi / 180,
                      child: SDeckDeckTarget(
                        color: widget.selectedColor,
                        shadow: SDeckDeckTargetShadow.medium,
                        state: SDeckDeckTargetState.enabled,
                        deckTitle: _previewTitle,
                        showFavoriteIcon: false,
                        showCardCount: false,
                      ),
                    ),
                    const SizedBox(height: SDeckSpace.gap6),
                    Text(
                      'Preview',
                      style: Theme.of(context).textTheme.footer.copyWith(
                        color: context.component.textTertiary,
                      ),
                    ),

                    const SizedBox(height: SDeckSpace.gap24),

                    //------------------------ Deck Name Input ----------------//
                    SDeckInput(
                      size: SDeckInputSize.large,
                      label: 'Deck Name',
                      placeholder: 'Enter a name',
                      supportingText: 'Max $_maxNameLength characters',
                      state: _inputState,
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      onChanged: _onNameChanged,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) {
                        if (canSubmit) _onCreatePressed();
                      },
                    ),

                    const SizedBox(height: SDeckSpace.gap24),

                    //------------------------ Create Deck Button -------------//
                    SDeckSolidButton(
                      text: isSaving ? 'Creating...' : 'Create Deck',
                      size: SDeckButtonSize.large,
                      fullWidth: true,
                      enabled: canSubmit,
                      onPressed: canSubmit ? _onCreatePressed : null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
