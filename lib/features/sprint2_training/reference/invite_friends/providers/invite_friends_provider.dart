/*--------------------- invite_friends_provider.dart ---------------------*/
// StateNotifier and provider for the Invite Friends feature.
// Manages state updates, calls the repository, and handles
// loading, success, and error outcomes.
//
// Usage:
//   ref.watch(inviteFriendsProvider)
//   ref.read(inviteFriendsProvider.notifier).sendInvite()
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/features/sprint2_training/reference/invite_friends/data/invite_repository.dart';
import 'package:socialdeck/features/sprint2_training/reference/invite_friends/data/mock_invite_repository.dart';
import 'package:socialdeck/features/sprint2_training/reference/invite_friends/domain/invite_friend_states.dart';

class InviteFriendsNotifier extends StateNotifier<InviteFriendsState> {
  final InviteRepository _repository;

  // constructor — starts with a fresh empty state.nothing loading, nothing sent, no messages.
  InviteFriendsNotifier(this._repository) : super(const InviteFriendsState());

  //*************************** sendInvite **********************************//
  // sendInvite — called when user taps Send Invite button
  Future<void> sendInvite() async {
    // step 1: tell screen we are loading
    state = state.copyWith(isLoading: true);
    // step 2: call the repository
    await _repository.sendInvite();
    // step 3: tell screen we are done and show success message
    state = state.copyWith(isLoading: false, inviteSent: true, successMessage: 'Invite sent successfully');
  

  
  }
}

//*************************** inviteFriendsProvider **************************//
final inviteFriendsProvider =
    StateNotifierProvider<InviteFriendsNotifier, InviteFriendsState>(
      (ref) => InviteFriendsNotifier(MockInviteRepository()),
    );
