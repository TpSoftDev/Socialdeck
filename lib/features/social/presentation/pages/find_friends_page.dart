/*-------------------- find_friends_page.dart -------------------------*/
// Find Friends page — search for and discover other players.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';

class FindFriendsPage extends StatelessWidget {
  const FindFriendsPage({super.key});

  //---------------------------- Placeholders ------------------------------//

  static const _suggestedPlaceholders = ['Username', 'Username', 'Username'];
  static const _listPlaceholders = ['name1', 'name2', 'name3', 'name4'];

  //------------------------------- Build ----------------------------------//

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Top Navigation ----------------------//
            SDeckTopNavigationBar(
              type: SDeckTopBarType.subpage,
              left: SDeckTopBarLeft.back,
              right: SDeckTopBarRight.profile,
              title: 'Find Friends',
              onLeftPressed: () => context.go('/social'),
            ),

            //------------------------ Scrollable Content ------------------//
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  SDeckSpace.padding16,
                  SDeckSpace.paddingZero,
                  SDeckSpace.padding16,
                  SDeckSpace.padding16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TODO(backend): Convert page to ConsumerStatefulWidget.
                    // Add TextEditingController + FocusNode. Drive state:
                    //   focused → SDeckInputState.focused (blue border)
                    //   has text → SDeckInputState.filled
                    //   else → SDeckInputState.hint
                    // Use onChanged to trigger your search provider.
                    //------------------- Search Input -------------------//
                    SDeckInput(
                      size: SDeckInputSize.large,
                      placeholder: 'Search',
                      state: SDeckInputState.hint,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      iconLeft: SDeckIcons(
                        SDeckIcon.search,
                        size: SDeckSize.size24,
                        color: context.component.inputIcon,
                      ),
                    ),

                    const SizedBox(height: SDeckSpace.gap12),

                    //------------------- Suggested Section --------------//
                    const SDeckSectionHeader(title: 'Suggested'),

                    const SizedBox(height: SDeckSpace.gap8),

                    // TODO(backend): Replace _suggestedPlaceholders with your provider list (max 3).
                    // Confirm whether you always return exactly 3 or a variable count.
                    //------------------- Horizontal Grid ----------------//
                    GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: SDeckSpace.gap8,
                      mainAxisSpacing: SDeckSpace.gap8,
                      childAspectRatio: 0.68,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: _suggestedPlaceholders
                          .map(
                            (name) => SDeckFriendBlockTarget(
                              username: name,
                              mutualFriendText: 'knows',
                            ),
                          )
                          .toList(),
                    ),

                    const SizedBox(height: SDeckSpace.gap8),

                    // TODO(backend): Replace _listPlaceholders with your provider list.
                    //------------------- Vertical List ------------------//
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _listPlaceholders.length,
                      itemBuilder: (context, index) => SDeckFriendListTarget(
                        username: _listPlaceholders[index],
                        mutualFriendText: 'knows',
                      ),
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
