/*----------------------- invite_repository.dart --------------------------*/
// Abstract repository interface for the Invite Friends feature.
// Defines what operations exist without specifying how they are implemented.
// Swap MockInviteRepository for FirebaseInviteRepository for production.
/*--------------------------------------------------------------------------*/

//--------------------------- InviteRepository ----------------------------//
abstract class InviteRepository {
  // Sends an invite. Async because it involves a network call.
  // Returns Future<void> — no data comes back, it just completes.
  Future<void> sendInvite();
}
