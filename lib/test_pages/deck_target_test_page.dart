/*-------------------- deck_target_test_page.dart ------------------------*/
// Playground for SDeckDeckTarget variants: color, favorited, state, and
// optional top chrome. Open from Dev Hub to compare against Figma.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

//------------------------------- DeckTargetTestPage -------------------------//
class DeckTargetTestPage extends StatefulWidget {
  const DeckTargetTestPage({super.key});

  @override
  State<DeckTargetTestPage> createState() => _DeckTargetTestPageState();
}

class _DeckTargetTestPageState extends State<DeckTargetTestPage> {
  SDeckColorPickerColor _color = SDeckColorPickerColor.brightCoral;
  SDeckDeckTargetState _state = SDeckDeckTargetState.enabled;
  bool _favorited = false;
  bool _showFavoriteIcon = true;
  bool _showCardCount = true;
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: 'Deck Title');
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = _titleController.text.isEmpty
        ? 'Deck Title'
        : _titleController.text;
    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: Column(
          children: [
            SDeckTopNavigationBar(
              left: SDeckTopBarLeft.back,
              type: SDeckTopBarType.subpage,
              right: SDeckTopBarRight.none,
              title: 'Deck Target',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  SDeckSpace.padding16,
                  SDeckSpace.padding8,
                  SDeckSpace.padding16,
                  SDeckSpace.padding48,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle(context, 'Live playground'),
                    const SizedBox(height: SDeckSpace.gap16),
                    Center(
                      child: SDeckDeckTarget(
                        color: _color,
                        favorited: _favorited,
                        state: _state,
                        deckTitle: title,
                        cardCount: '#',
                        showFavoriteIcon: _showFavoriteIcon,
                        showCardCount: _showCardCount,
                      ),
                    ),
                    const SizedBox(height: SDeckSpace.gap24),
                    Wrap(
                      spacing: SDeckSpace.gap8,
                      runSpacing: SDeckSpace.gap8,
                      children: [
                        for (final color in SDeckColorPickerColor.values)
                          ChoiceChip(
                            label: Text(color.name),
                            selected: _color == color,
                            onSelected: (_) => setState(() => _color = color),
                          ),
                      ],
                    ),
                    const SizedBox(height: SDeckSpace.gap16),
                    Wrap(
                      spacing: SDeckSpace.gap8,
                      runSpacing: SDeckSpace.gap8,
                      children: [
                        for (final state in SDeckDeckTargetState.values)
                          ChoiceChip(
                            label: Text(state.name),
                            selected: _state == state,
                            onSelected: (_) => setState(() => _state = state),
                          ),
                      ],
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Favorited?'),
                      value: _favorited,
                      onChanged: (v) => setState(() => _favorited = v),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Favorite Icon?'),
                      value: _showFavoriteIcon,
                      onChanged: (v) => setState(() => _showFavoriteIcon = v),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Card Count?'),
                      value: _showCardCount,
                      onChanged: (v) => setState(() => _showCardCount = v),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Deck Title',
                      ),
                      controller: _titleController,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: SDeckSpace.gap32),
                    _sectionTitle(context, 'All colors (Enabled)'),
                    const SizedBox(height: SDeckSpace.gap16),
                    Wrap(
                      spacing: SDeckSpace.gap12,
                      runSpacing: SDeckSpace.gap12,
                      children: [
                        for (final color in SDeckColorPickerColor.values)
                          SDeckDeckTarget(
                            color: color,
                            state: SDeckDeckTargetState.enabled,
                            deckTitle: color.name,
                          ),
                      ],
                    ),
                    const SizedBox(height: SDeckSpace.gap32),
                    _sectionTitle(context, 'States (Bright Coral)'),
                    const SizedBox(height: SDeckSpace.gap16),
                    Wrap(
                      spacing: SDeckSpace.gap12,
                      runSpacing: SDeckSpace.gap12,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        for (final state in SDeckDeckTargetState.values)
                          Column(
                            children: [
                              SDeckDeckTarget(
                                color: SDeckColorPickerColor.brightCoral,
                                state: state,
                                favorited: state ==
                                    SDeckDeckTargetState.moveHeld,
                              ),
                              const SizedBox(height: SDeckSpace.gap8),
                              Text(
                                state.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                      color: context.component.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: SDeckSpace.gap32),
                    _sectionTitle(context, 'Create-deck style (chrome off)'),
                    const SizedBox(height: SDeckSpace.gap16),
                    const SDeckDeckTarget(
                      color: SDeckColorPickerColor.vibrantYellow,
                      state: SDeckDeckTargetState.enabled,
                      deckTitle: 'Your Deck',
                      showFavoriteIcon: false,
                      showCardCount: false,
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

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.h6.copyWith(
            color: context.component.textPrimary,
          ),
    );
  }
}
