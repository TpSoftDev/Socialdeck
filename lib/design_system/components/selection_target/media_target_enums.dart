/*------------------------ media_target_enums.dart --------------------------*/
// Corner variants for mediaTarget in the Camera Roll grid.
// Only the outer cells of the grid round one corner. Center cells stay square.
//
// Usage:
//   SDeckMediaTargetCorner.topLeft
//   SDeckMediaTargetCorner.none
/*--------------------------------------------------------------------------*/

//*************************** Enums **********************************//

/// Which corner of a media cell is rounded.
enum SDeckMediaTargetCorner {
  none,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}
