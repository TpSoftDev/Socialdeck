import '../data/invite_friends_repository.dart';

class MockInviteFriendsRepository implements InviteFriendsRepository {

  @override
  Future<bool> sendInvite() async {
    //Simulate delay
    await Future.delayed(const Duration(seconds: 2));
    return false;
  }
}