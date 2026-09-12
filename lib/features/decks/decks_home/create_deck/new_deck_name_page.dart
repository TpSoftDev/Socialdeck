/*----------------------- new_deck_name_page.dart ----------------------------*/
// New Deck Name page — second step of the Create a Deck flow.
// User enters a deck name (max 16 characters). Create Deck stays disabled
// until the field has text. Preview is SDeckDeckTarget; title tracks the input.
// Selected color is passed from the previous step.
/*--------------------------------------------------------------------------*/

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';

//---------------------------- NewDeckNamePage ------------------------------//
class NewDeckNamePage extends StatefulWidget {
  const NewDeckNamePage({
    super.key,
    this.selectedColor = SDeckColorPickerColor.brightCoral,
  });

  final SDeckColorPickerColor selectedColor;

  @override
  State<NewDeckNamePage> createState() => _NewDeckNamePageState();
}

class _NewDeckNamePageState extends State<NewDeckNamePage> {
  static const int _maxNameLength = 16;

  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

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
      _nameController.selection = TextSelection.collapsed(
        offset: _maxNameLength,
      );
    }
    setState(() {});
  }

  void _onCreatePressed() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    context.push(
      AppPaths.deckCards,
      extra: {
        'name': name,
        'color': widget.selectedColor,
      },
    );
  }

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Top Navigation ------------------------//
            SDeckTopNavigationBar(
              left: SDeckTopBarLeft.back,
              type: SDeckTopBarType.subpage,
              right: SDeckTopBarRight.none,
              title: 'New Deck',
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
                      supportingText: 'Max 16 characters',
                      state: _inputState,
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      onChanged: _onNameChanged,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) {
                        if (_hasName) _onCreatePressed();
                      },
                    ),

                    const SizedBox(height: SDeckSpace.gap24),

                    //------------------------ Create Deck Button -------------//
                    SDeckSolidButton(
                      text: 'Create Deck',
                      size: SDeckButtonSize.large,
                      fullWidth: true,
                      enabled: _hasName,
                      onPressed: _hasName ? _onCreatePressed : null,
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
