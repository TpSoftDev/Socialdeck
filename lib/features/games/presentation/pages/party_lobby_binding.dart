import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

/// Live values and actions supplied by Party. No Firebase dependencies in the UI.
class PartyLobbySeat {
  const PartyLobbySeat(this.id, this.name, {this.ready = false});
  final String id;
  final String name;
  final bool ready;
}

class PartyLobbyBinding {
  const PartyLobbyBinding({
    required this.code,
    required this.seats,
    required this.isHost,
    required this.gameSelected,
    required this.busy,
    required this.ready,
    required this.playing,
    required this.onBack,
    required this.onOptions,
    required this.onLeave,
    required this.onDisband,
    required this.onPlayer,
    required this.onInvite,
    this.disbandGuard,
    this.feedback,
    this.onSettings,
    this.onCards,
    this.onReady,
    this.onStart,
    this.cardsTitle = 'Pick 7 Cards',
    this.cardsDescription = 'Choose from one or many decks.',
    this.cardsStatus,
  });
  final ValueNotifier<PartyLobbyNotice?>? feedback;
  final String code;
  final List<PartyLobbySeat> seats;
  final bool isHost, gameSelected, busy, ready, playing;
  final VoidCallback onBack, onLeave, onDisband;
  final ValueChanged<VoidCallback> onOptions;
  final ValueChanged<String> onPlayer;
  final ValueChanged<ValueChanged<PartyInviteNotice>>? onInvite;
  final VoidCallback? onSettings, onCards, onReady, onStart;
  // Rebuild the separate confirmation route when live permissions change.
  final Widget Function(Widget Function(bool allowed) builder)? disbandGuard;
  final String cardsTitle, cardsDescription;
  final Widget? cardsStatus;
}

/// Backend results rendered by the same toast queue as the frontend preview.
class PartyInviteNotice {
  const PartyInviteNotice({required this.success, required this.description});
  final bool success;
  final String description;
}

class PartyLobbyNotice {
  const PartyLobbyNotice(this.status, this.title, this.description);
  final SDeckToastStatus status;
  final String title, description;
}
