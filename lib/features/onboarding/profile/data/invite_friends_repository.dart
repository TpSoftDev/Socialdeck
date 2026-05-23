
//Abstraction of the repository calls for Invite Friends page
abstract class InviteFriendsRepository {

  //Returns true when invite is properly sent
  Future<bool> sendInvite();

}