/*------------------------ profile_card_enums.dart --------------------------*/
// Enums for the profileCard and profileCardPlaceholder components.
//
// Controls which Figma variant of profileCard/profileCardPlaceholder is used.
//
// fixed      — compact, fixed size (default 48×48), borderRadius24.
//              Used in topBar, friendListTarget, or any area where
//              the parent height is rigid.
//
// responsive — always a perfect circle, width fills its parent,
//              height always equals width via AspectRatio(1:1).
//              Used in wrapping lists like friendBlockTarget where
//              the column width changes with screen size.
/*--------------------------------------------------------------------------*/

enum SDeckProfileCardVariant { fixed, responsive }
