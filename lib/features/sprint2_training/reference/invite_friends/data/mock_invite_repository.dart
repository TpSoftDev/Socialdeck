/*----------------------- mock_invite_repository.dart ---------------------*/
// Mock implementation of InviteRepository for local development and testing.
// Simulates a real network call with a fake delay — no Firebase needed.
// Swap this for FirebaseInviteRepository when ready for production.
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'invite_repository.dart';

//--------------------------- MockInviteRepository ------------------------//
class MockInviteRepository implements InviteRepository {

  //*************************** sendInvite **********************************//
  // Pretends to send an email invite.
  // Waits 2 seconds to simulate a real network call, then completes.
  @override
  Future<void> sendInvite() async {
    await Future.delayed(const Duration(seconds: 2));
  }
}
