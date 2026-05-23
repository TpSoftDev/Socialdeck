import 'package:socialdeck/features/onboarding/profile/utils/fade_swap.dart';
/*-------------------- profile_redirecting.dart -----------------------*/
// Redirecting screen for the profile / sign-up flow
//
// Purpose:
// - Shows the lightweight redirecting/loading UI
// - Hosts the existing SDeckToast widget directly
/*---------------------------------------------------------------------*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/profile/providers/profile_redirecting_provider.dart';

//---------------------- ProfileRedirectingPage ------------------//
class ProfileRedirectingPage extends ConsumerStatefulWidget {
  const ProfileRedirectingPage({super.key});

  @override
  ConsumerState<ProfileRedirectingPage> createState() =>
      _ProfileRedirectingPageState();
}

class _ProfileRedirectingPageState
    extends ConsumerState<ProfileRedirectingPage> {
  bool _showToast = false;
  final SDeckToastStatus _toastStatus = SDeckToastStatus.info;
  String _toastTitle = '';
  String _toastDescription = '';



  @override
  void initState(){
    super.initState();
    _resetDomain();
    _transitionStart();
  }

  void _transitionStart() {
    Timer(Duration(seconds: 3), () {
      ref.read(profileRedirectingProvider.notifier).toNextScreen();
    });
  }

  Future<void> _resetDomain () async  {
    ref.read(profileRedirectingProvider.notifier).reset();
  }

  @override
  Widget build(BuildContext context) {
    
    //Backend State variable
    final state = ref.watch(profileRedirectingProvider);

    if(state.moveNext){
      context.push('/profile/introduce-card');
    }




    //Frontend design
    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 402,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        SDeckRadius.borderRadius16,
                      ),
                      child: Image.asset(
                        SDeckIcon.checkeredBackground,
                        height: 64,
                        width: 64,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            IgnorePointer(
              ignoring: !_showToast,
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: SDeckSpace.padding16,
                    left: SDeckSpace.padding16,
                    right: SDeckSpace.padding16,
                  ),
                  child: FadeSwap(
                    visible: _showToast,
                    child: SDeckToast(
                      status: _toastStatus,
                      title: _toastTitle,
                      description: _toastDescription,
                      onDismiss: () {
                        if (!mounted) return;
                        setState(() {
                          _showToast = false;
                        });
                      },
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
}