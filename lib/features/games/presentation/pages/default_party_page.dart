/*-------------------- default_party_page.dart -----------------------*/
// Isolated Normal-mode Prompt'd lobby.
// Opened from Play Prompt'd → Normal (and Party Dev → Default Party).
// Reuses InviteSheetPage so invite / kick / promote stay in one lobby.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/features/games/presentation/pages/invite_sheet_page.dart';

//------------------------------- DefaultPartyPage -----------------------------//
class DefaultPartyPage extends StatelessWidget {
  const DefaultPartyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const InviteSheetPage(playMode: PartyPlayMode.normal);
  }
}
