import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import '../data/firebase_party_friend_repository.dart';
import '../domain/party_friend.dart';
export '../domain/party_friend.dart';

final partyFriendsProvider = StreamProvider.autoDispose<List<PartyFriend>>((
  ref,
) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(const []);
  return FirebasePartyFriendRepository(uid: user.uid).watchFriends();
});
