/*----------------------------- dialog_enums.dart -------------------------*/
// Shared enums for dialog components in the SocialDeck design system.
// These enums define dialog variations and optional preview sizing.
//
// Usage:
//   SDeckDialogVariant.standard
//   SDeckDialogPreviewSize.banner
/*--------------------------------------------------------------------------*/

//*************************** Enums **********************************//
/// Dialog layout variations
enum SDeckDialogVariant {
  standard, // Title + optional preview + description/content + actions
  input, // Reserved for future input dialog usage
  step, // Reserved for future step dialog usage
}

/// Preview size variations used for the optional visual area
enum SDeckDialogPreviewSize {
  banner, // Short preview area (good for confirmation dialogs)
  square, // Larger square preview area
}