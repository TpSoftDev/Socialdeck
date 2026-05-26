import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';

class FindFriendsPage extends ConsumerStatefulWidget {
  const FindFriendsPage({super.key});

  @override
  ConsumerState<FindFriendsPage> createState() => _FindFriendsPageState();
}

class _FindFriendsPageState extends ConsumerState<FindFriendsPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String _query = '';

  @override
  void initState() {
    super.initState();

    _searchFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  SDeckInputState get _searchState {
    if (_searchFocusNode.hasFocus) {
      return SDeckInputState.focused;
    }

    if (_query.isNotEmpty) {
      return SDeckInputState.filled;
    }

    return SDeckInputState.hint;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: Column(
          children: [
            SDeckTopNavigationBar(
              left: SDeckTopBarLeft.back,
              title: 'Find Friends',
              onLeftPressed: () => context.go('/social'),
            ),
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
                    SDeckInput(
                      size: SDeckInputSize.medium,
                      placeholder: 'Search',
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      state: _searchState,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      iconLeft: SDeckIcons(
                        SDeckIcon.search,
                        size: SDeckSize.size24,
                        color: context.component.inputIcon,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _query = value;
                        });
                      },
                    ),

                    const SizedBox(height: SDeckSpace.gap8),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: SDeckSpace.padding8,
                        vertical: SDeckSpace.padding8,
                      ),
                      decoration: BoxDecoration(
                        color: context.semantic.surfaceVariant,
                        borderRadius: BorderRadius.circular(
                          SDeckRadius.borderRadius8,
                        ),
                      ),
                      child: Text(
                        'Suggested',
                        style: Theme.of(context).textTheme.bodySmallFigma.copyWith(
                              color: context.component.textPrimary,
                            ),
                      ),
                    ),

                    const SizedBox(height: SDeckSpace.gap8),

                    SizedBox(
                      height: 132,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: SDeckSpace.gap8),
                        itemBuilder: (context, index) {
                          return SDeckSuggestedFriendCard(
                            username: 'Username',
                            subtitle: 'names ->',
                            onTap: () {},
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: SDeckSpace.gap8),

                    const SDeckSocialUserTile(
                      username: 'name1',
                      subtitle: 'names',
                    ),
                    const SDeckSocialUserTile(
                      username: 'name2',
                      subtitle: 'names',
                    ),
                    const SDeckSocialUserTile(
                      username: 'name3',
                      subtitle: 'names',
                    ),
                    const SDeckSocialUserTile(
                      username: 'name4',
                      subtitle: 'names',
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