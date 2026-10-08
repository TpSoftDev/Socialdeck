import 'package:flutter_riverpod/flutter_riverpod.dart';

class PartyFriend {
  const PartyFriend({
    required this.uid,
    required this.name,
    this.online = false,
  });
  final String uid;
  final String name;
  final bool online;
}

/// Override this boundary when Social provides real friends/presence.
/// An empty list never exposes unrelated users or invents friendships.
final partyFriendsProvider = StreamProvider.autoDispose<List<PartyFriend>>(
  (ref) => Stream.value(const []),
);
