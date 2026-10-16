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
