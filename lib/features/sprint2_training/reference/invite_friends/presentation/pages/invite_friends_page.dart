import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/sprint2_training/reference/invite_friends/providers/invite_friends_provider.dart';



// CLASS 1 — The widget shell.
// This is lightweight and can be rebuilt by Flutter at any time.
// Its only job is createState() — it points Flutter to the class
// that holds all the real logic and UI.
class InviteFriendsPage extends ConsumerStatefulWidget {
  const InviteFriendsPage({super.key});

  @override
  // createState() tells Flutter: "when you need my state, create this."
  // Think of it as a factory — it produces the state object once.
  ConsumerState<InviteFriendsPage> createState() => _InviteFriendsPageState();
}

// CLASS 2 — The state. This is where everything actually lives.
// It survives Flutter rebuilds — data and methods stay alive.
// extends ConsumerState gives us:
//   - ref      → talk to Riverpod providers
//   - context  → access the widget tree
//   - setState → trigger local UI rebuilds if needed
//   - mounted  → check if widget is still in the tree (important for async)
class _InviteFriendsPageState extends ConsumerState<InviteFriendsPage> {

  //backend code
  //*************************** onSendInvite **********************************//
  Future<void> _onSendInvite() async {
    await ref.read(inviteFriendsProvider.notifier).sendInvite();
  }
  //*************************** onGetStarted **********************************//
  void _onGetStarted() {
    context.goNamed(AppRoute.home.name);
  }



























  //frontend code
  //*************************** Build Method *******************************//
  @override
  Widget build(BuildContext context) {
    //*************************** State Management ***************************//
    final state = ref.watch(inviteFriendsProvider);

    //*************************** Success Message ***************************//
    ref.listen(inviteFriendsProvider, (previous, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.successMessage!),),
        );
      }
    });






    //*************************** Build Method *******************************//
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //------------------------ Top Navigation ------------------------//
            SDeckTopNavigationBar(
              left: SDeckTopBarLeft.none,
              type: SDeckTopBarType.subpage,
              right: SDeckTopBarRight.none,
              title: 'Invite Friends',
            ),

            //------------------------ Visual Placeholder --------------------------//
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
              child: buildVisualPlaceholder(context),
            ),

            SizedBox(height: SDeckSpace.gap16),

            //------------------------ Body Text ----------------------------//
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
              child: Text("Invite some friends to get \nthe party started!", 
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: context.component.textSecondary),),
            ),
            //------------------------ --------------------------//  
            const SizedBox(height: SDeckSpace.gap16),

            //------------------------ Button Positioning --------------------------//
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
              child: SDeckSolidButton(
                text: "Send Invite",
                size: SDeckButtonSize.large,
                fullWidth: true,
                iconLocation: SDeckButtonIconLocation.right,
                icon: SDeckIcons(SDeckIcon.mail, size: SDeckSize.size24, color: context.component.iconPrimary,),
                onPressed: _onSendInvite,
                enabled: !state.isLoading,
                 //disable button if loading cannot be tapped twice 
                
              ),
            ),
            //------------------------ Gap between buttons --------------------------//
            const SizedBox(height: SDeckSpace.gap8),

            //------------------------ Get Started Button --------------------------//
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
              child: SDeckOutlineButton(
                text: "Get Started",
                size: SDeckButtonSize.large,
                fullWidth: true,
                onPressed: _onGetStarted,
              ),
            ),

            //------------------------ Loading Spinner --------------------------//
            // Only appears while sendInvite() is in progress.
            // state.isLoading flips to true in the provider → spinner appears.
            // When the mock delay finishes → isLoading flips to false → spinner disappears.
            if (state.isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }



//*************************** Helper Methods ********************************//
//------------------------ Visual Placeholder ----------------------------//
  Widget buildVisualPlaceholder(BuildContext context) {
    return Container(
      width: 370,
      height: 370,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
        image: const DecorationImage(
          image: AssetImage(SDeckIcon.checkeredBackground),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}