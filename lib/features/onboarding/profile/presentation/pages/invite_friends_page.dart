import 'package:socialdeck/features/onboarding/profile/utils/fade_swap.dart';
/*---------------------- invite_friends_page.dart ------------------------*/
// Invite Friends Page
//
// Purpose:
// - Final onboarding step before loading into the main app
// - Lets the user optionally share an invite link
// - Lets the user continue into the app by tapping "Get Started"
//
// Figma behavior:
// - "Send Invite" opens a native share sheet
// - After sharing / dismissing, return to this screen
// - "Get Started" transitions toward the main app / home
//
// Notes:
// - The large visual area is currently a placeholder and can later be
//   replaced by the final Rive animation
// - The share behavior below is stubbed with a TODO so you can plug in
//   your preferred native sharing package later
/*-----------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/features/onboarding/profile/providers/profile_provider.dart';

class InviteFriendsPage extends ConsumerStatefulWidget {
  const InviteFriendsPage({super.key});

  @override
  ConsumerState<InviteFriendsPage> createState() => _InviteFriendsPageState();
}

class _InviteFriendsPageState extends ConsumerState<InviteFriendsPage> {
  //*************************** Local UI State *******************************//
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _startEntranceAnimation();
  }

  //*************************** Entrance Animation ***************************//
  void _startEntranceAnimation() async {
    await Future.delayed(SDeckMotionDuration.fast);

    if (!mounted) return;

    setState(() {
      _visible = true;
    });
  }

  //*************************** Send Invite *********************************//
  // Opens the native share flow.
  //
  // For now this is stubbed. Later you can plug in a package like share_plus.
  Future<void> _onSendInvite() async {

    final state = ref.watch(inviteFriendsProvider);

    if (state.sendingInvite) return;

    ref.read(inviteFriendsProvider.notifier).flipSendingInvite();

    // Small intentional delay for interaction feel.
    await Future.delayed(SDeckMotionDuration.fast);

    if (!mounted) return;

    // TODO:
    // Replace this with native share-sheet logic.
    //
    // Example later with share_plus:
    // await SharePlus.instance.share(
    //   ShareParams(
    //     text: 'Play Socialdeck with me! <invite link>',
    //   ),
    // );
    //
    ref.read(inviteFriendsProvider.notifier).sendInviteToContact();

    if (!mounted) return;

    ref.read(inviteFriendsProvider.notifier).flipSendingInvite();
  }

  //*************************** Continue Into App ***************************//
  Future<void> _onGetStarted() async {
    setState(() {
      _visible = false;
    });

    await Future.delayed(SDeckMotionDuration.normal);

    if (!mounted) return;

    if (mounted) {
      context.go('/home',); // Use go() instead of push() to clear navigation stack
    }
  }

  //*************************** Build ***************************************//
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inviteFriendsProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //------------------------ Title ------------------------//
              SDeckTopNavigationBar(
                left: SDeckTopBarLeft.none,
                type: SDeckTopBarType.subpage,
                right: SDeckTopBarRight.none,
                title: 'Invite Friends',
              ),

              //------------------------ Visual Placeholder ----------//
              FadeSwap(
                visible: _visible,
                child: Container(
                  width: 370,
                  height: 370,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      SDeckRadius.borderRadius16,
                    ),
                    image: const DecorationImage(
                      image: AssetImage(SDeckIcon.checkeredBackground),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: SDeckSpace.gap16),

              //------------------------ Prompt Text ------------------//
              FadeSwap(
                visible: _visible,
                child: Text(
                  'Invite some friends to get\nthe party started!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: context.component.textSecondary,
                      ),
                ),
              ),

              const SizedBox(height: SDeckSpace.gap16),

              //------------------------ Send Invite ------------------//
              FadeSwap(
                visible: _visible,
                child: SizedBox(
                  width: 370,
                  child: SDeckSolidButton(
                    iconLocation: SDeckButtonIconLocation.left,
                    icon: SDeckIcons(
                      SDeckIcon.mail,
                      size: SDeckSize.size24,
                      color: context.component.iconPrimary,
                    ),
                    text: state.sendingInvite ? 'Loading...' : 'Send Invite',
                    size: SDeckButtonSize.large,
                    fullWidth: true,
                    onPressed: state.sendingInvite ? null : _onSendInvite,
                  ),
                ),
              ),

              const SizedBox(height: SDeckSpace.gap8),

              //------------------------ Get Started ------------------//
              FadeSwap(
                visible: _visible,
                child: SizedBox(
                  width: 370,
                  child: SDeckOutlineButton(
                    text: 'Get Started',
                    size: SDeckButtonSize.large,
                    fullWidth: true,
                    onPressed: _onGetStarted,
                  ),
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}