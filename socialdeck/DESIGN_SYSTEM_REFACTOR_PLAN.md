# Design System Token Refactor Plan
## Goal: Match Figma Design System Exactly

**Date Created:** 2025-01-XX  
**Status:** Approved - Ready for Implementation

---

## Objective

Refactor the design system tokens to match Figma exactly:
- Variable names must match Figma exactly
- Values must match Figma exactly
- Structure must match Figma's hierarchy (Size foundation → everything references it)
- Designers use the same names in Figma that developers use in code

---

## Current State

### Files to Replace/Update:
- `lib/design_system/tokens/spacing.dart` → Replace with `space.dart`
- `lib/design_system/tokens/radius.dart` → Update to reference Size
- `lib/design_system/tokens/index.dart` → Update exports

### Files to Create:
- `lib/design_system/tokens/size.dart` (NEW - Foundation)
- `lib/design_system/tokens/control.dart` (NEW - Control sizes)

### Files to Keep (Unchanged for now):
- `lib/design_system/tokens/colors.dart`
- `lib/design_system/tokens/shadows.dart`
- `lib/design_system/tokens/assets.dart`

---

## Approach: Direct Const References

**Decision:** Use Approach 1 - Direct const references
- Simple, clear, performant (compile-time constants)
- Easy to read and understand
- Type-safe
- Matches Figma structure

**File Structure:** Separate files (one class per file)
- Matches Figma organization
- Scalable and maintainable
- Better for team collaboration

---

## Step-by-Step Implementation Plan

### STEP 1: Create Size Foundation (`size.dart`)

**File:** `lib/design_system/tokens/size.dart`

**Class:** `SDeckSize`

**Values (from Figma):**
```dart
class SDeckSize {
  SDeckSize._(); // Private constructor
  
  static const double zero = 0.0;      // sizeZero
  static const double xxxs = 2.0;     // sizeXXXS (NEW - currently missing)
  static const double xxs = 4.0;      // sizeXXS
  static const double xs = 8.0;       // sizeXS
  static const double s = 12.0;       // sizeS
  static const double m = 16.0;       // sizeM
  static const double l = 24.0;       // sizeL
  static const double xl = 32.0;      // sizeXL
  static const double xxl = 48.0;     // sizeXXL
  static const double xxxl = 64.0;    // sizeXXXL
}
```

**Notes:**
- This is the foundation - single source of truth for all numeric values
- All other tokens will reference these values

---

### STEP 2: Create Control Sizes (`control.dart`)

**File:** `lib/design_system/tokens/control.dart`

**Class:** `SDeckControl`

**Values (reference Size with 1:1 mapping):**
```dart
class SDeckControl {
  SDeckControl._(); // Private constructor
  
  static const double xxs = SDeckSize.xxxs;  // controlXXS = 2.0
  static const double xs = SDeckSize.xxs;    // controlXS = 4.0
  static const double s = SDeckSize.xs;      // controlS = 8.0
  static const double m = SDeckSize.m;       // controlM = 16.0
  static const double l = SDeckSize.l;       // controlL = 24.0
  static const double xl = SDeckSize.xl;     // controlXL = 32.0
  static const double xxl = SDeckSize.xxl;   // controlXXL = 48.0
}
```

**Notes:**
- 1:1 mapping to Size tokens
- Semantic names for control-specific contexts

---

### STEP 3: Replace `spacing.dart` → `space.dart`

**File:** `lib/design_system/tokens/spacing.dart` → DELETE  
**New File:** `lib/design_system/tokens/space.dart` → CREATE

**Class:** `SDeckSpace`

**Structure:**
```dart
class SDeckSpace {
  SDeckSpace._(); // Private constructor
  
  //*************************** Margin **********************************//
  // Margin values reference Size tokens (semantic aliases)
  static const double marginZero = SDeckSize.zero;    // marginZero → sizeZero (0)
  static const double marginXXS = SDeckSize.xxs;       // marginXXS → sizeXXS (4)
  static const double marginXS = SDeckSize.xs;        // marginXS → sizeXS (8)
  static const double marginS = SDeckSize.s;          // marginS → sizeS (12)
  static const double marginM = SDeckSize.m;          // marginM → sizeM (16)
  static const double marginL = SDeckSize.l;         // marginL → sizeL (24)
  static const double marginXL = SDeckSize.xl;        // marginXL → sizeXL (32)
  static const double marginXXL = SDeckSize.xxl;     // marginXXL → sizeXXL (48)
  
  //*************************** Padding **********************************//
  // Padding values reference Size tokens (semantic aliases)
  static const double paddingZero = SDeckSize.zero;  // paddingZero → sizeZero (0)
  static const double paddingXXS = SDeckSize.xxs;     // paddingXXS → sizeXXS (4)
  static const double paddingXS = SDeckSize.xs;       // paddingXS → sizeXS (8)
  static const double paddingS = SDeckSize.s;        // paddingS → sizeS (12)
  static const double paddingM = SDeckSize.m;        // paddingM → sizeM (16)
  static const double paddingL = SDeckSize.l;        // paddingL → sizeL (24)
  static const double paddingXL = SDeckSize.xl;      // paddingXL → sizeXL (32)
  static const double paddingXXL = SDeckSize.xxl;     // paddingXXL → sizeXXL (48)
  
  //*************************** Gap **********************************//
  // Gap values reference Size tokens (semantic aliases)
  static const double gapZero = SDeckSize.zero;      // gapZero → sizeZero (0)
  static const double gapXXS = SDeckSize.xxs;        // gapXXS → sizeXXS (4)
  static const double gapXS = SDeckSize.xs;          // gapXS → sizeXS (8)
  static const double gapS = SDeckSize.s;            // gapS → sizeS (12)
  static const double gapM = SDeckSize.m;            // gapM → sizeM (16)
  static const double gapL = SDeckSize.l;             // gapL → sizeL (24)
  static const double gapXL = SDeckSize.xl;           // gapXL → sizeXL (32)
  static const double gapXXL = SDeckSize.xxl;        // gapXXL → sizeXXL (48)
  
  //*************************** Component-Specific Values ********************//
  // TODO: These will be refactored later when we update components
  // Keeping them temporarily to avoid breaking components
  //----------------------------- Text Field Values -------------------------//
  static const double textFieldPaddingSmallVertical = SDeckSize.xs;      // 8.0
  static const double textFieldPaddingSmallHorizontal = SDeckSize.s;    // 12.0
  static const double textFieldPaddingMediumVertical = SDeckSize.s;      // 12.0
  static const double textFieldPaddingMediumHorizontal = SDeckSize.s;    // 12.0 (FIX: was 16.0, should be 12.0 per Figma)
  static const double textFieldPaddingLargeVertical = SDeckSize.m;       // 16.0
  static const double textFieldPaddingLargeHorizontal = SDeckSize.m;      // 16.0 (FIX: was 20.0, need to verify in Figma)
  
  //----------------------------- Button Values -----------------------------//
  static const double buttonPaddingSmallVertical = SDeckSize.zero;      // 0.0
  static const double buttonPaddingSmallHorizontal = SDeckSize.xs;      // 8.0
  static const double buttonPaddingMediumVertical = SDeckSize.xs;       // 8.0
  static const double buttonPaddingMediumHorizontal = SDeckSize.m;      // 16.0
  static const double buttonPaddingLargeVertical = SDeckSize.m;          // 16.0 (FIX: was 20.0, need to verify in Figma)
  static const double buttonPaddingLargeHorizontal = SDeckSize.l;       // 24.0
  
  //----------------------------- Button Icon Gap ---------------------------//
  static const double buttonIconGap = SDeckSize.xxs;                    // 4.0
  
  //*************************** Icon Sizes ***********************************//
  static const double iconSmall = SDeckSize.m;                          // 16.0
  static const double iconMedium = SDeckSize.l;                        // 24.0
  static const double iconLarge = SDeckSize.xxl;                       // 48.0 (FIX: was 36.0, need to verify in Figma)
  static const double iconXLarge = SDeckSize.xxl;                      // 48.0
}
```

**Notes:**
- Semantic tokens (margin/padding/gap) reference Size
- Component-specific values kept temporarily (will refactor later)
- Some values need verification in Figma (marked with FIX comments)

---

### STEP 4: Update `radius.dart`

**File:** `lib/design_system/tokens/radius.dart` → UPDATE

**Class:** `SDeckRadius` (keep same name)

**Values (reference Size with OFFSET mapping - one step smaller):**
```dart
class SDeckRadius {
  SDeckRadius._(); // Private constructor
  
  //*************************** Radius Scale **********************************//
  // Radius values reference Size tokens with OFFSET mapping (one step smaller)
  static const double zero = SDeckSize.zero;        // borderRadiusZero → sizeZero (0)
  static const double xxs = SDeckSize.xxxs;        // borderRadiusXXS → sizeXXXS (2) ← offset
  static const double xs = SDeckSize.xxs;          // borderRadiusXS → sizeXXS (4) ← offset
  static const double s = SDeckSize.xs;             // borderRadiusS → sizeXS (8) ← offset
  static const double m = SDeckSize.s;             // borderRadiusM → sizeS (12) ← offset
  static const double l = SDeckSize.m;             // borderRadiusL → sizeM (16) ← offset
  static const double xl = SDeckSize.l;            // borderRadiusXL → sizeL (24) ← offset
  static const double xxl = SDeckSize.xl;          // borderRadiusXXL → sizeXL (32) ← offset
  static const double xxxl = SDeckSize.xxl;         // borderRadiusXXXL → sizeXXL (48) ← offset
}
```

**Notes:**
- Offset mapping: each radius token references the Size token ONE STEP SMALLER
- This matches Figma's structure exactly

---

### STEP 5: Update `index.dart`

**File:** `lib/design_system/tokens/index.dart` → UPDATE

**Changes:**
```dart
export 'colors.dart';
export 'size.dart';        // NEW
export 'control.dart';     // NEW
export 'space.dart';       // CHANGED (was spacing.dart)
export 'radius.dart';
export 'shadows.dart';
export 'assets.dart';
```

---

### STEP 6: Migration - Update All Usages

**Strategy:** Find and replace all usages across the codebase

**Mapping Table:**

| Old Usage | New Usage (Context-Dependent) |
|-----------|-------------------------------|
| `SDeckSpacing.x0` | `SDeckSize.zero` or `SDeckSpace.marginZero` / `paddingZero` / `gapZero` |
| `SDeckSpacing.x4` | `SDeckSize.xxs` or `SDeckSpace.marginXXS` / `paddingXXS` / `gapXXS` |
| `SDeckSpacing.x8` | `SDeckSize.xs` or `SDeckSpace.marginXS` / `paddingXS` / `gapXS` |
| `SDeckSpacing.x12` | `SDeckSize.s` or `SDeckSpace.marginS` / `paddingS` / `gapS` |
| `SDeckSpacing.x16` | `SDeckSize.m` or `SDeckSpace.marginM` / `paddingM` / `gapM` |
| `SDeckSpacing.x24` | `SDeckSize.l` or `SDeckSpace.marginL` / `paddingL` / `gapL` |
| `SDeckSpacing.x32` | `SDeckSize.xl` or `SDeckSpace.marginXL` / `paddingXL` / `gapXL` |
| `SDeckSpacing.x48` | `SDeckSize.xxl` or `SDeckSpace.marginXXL` / `paddingXXL` / `gapXXL` |
| `SDeckSpacing.x64` | `SDeckSize.xxxl` or `SDeckSpace.marginXXXL` / `paddingXXXL` / `gapXXXL` |

**Remove (not in Figma):**
- `SDeckSpacing.x6` → Use `SDeckSize.xxs` (4) or `SDeckSize.xs` (8)
- `SDeckSpacing.x20` → Use `SDeckSize.l` (24) or `SDeckSize.m` (16)
- `SDeckSpacing.x40` → Use `SDeckSize.xl` (32) or `SDeckSize.xxl` (48)
- `SDeckSpacing.x56` → Use `SDeckSize.xxl` (48) or `SDeckSize.xxxl` (64)
- `SDeckSpacing.x72` → Use `SDeckSize.xxxl` (64)
- `SDeckSpacing.x80` → Use `SDeckSize.xxxl` (64)
- `SDeckSpacing.x88` → Use `SDeckSize.xxxl` (64)
- `SDeckSpacing.x96` → Use `SDeckSize.xxxl` (64)

**Radius Migration:**
- `SDeckRadius.none` → `SDeckRadius.zero` (or keep `none` if preferred)
- `SDeckRadius.xxxs` → `SDeckRadius.xxs` (value changes: 4.0 → 2.0)
- `SDeckRadius.xxs` → `SDeckRadius.xs` (value changes: 8.0 → 4.0)
- `SDeckRadius.xs` → `SDeckRadius.s` (value changes: 16.0 → 8.0)
- `SDeckRadius.s` → `SDeckRadius.m` (value changes: 24.0 → 12.0)
- `SDeckRadius.m` → `SDeckRadius.l` (value changes: 32.0 → 16.0)
- `SDeckRadius.l` → `SDeckRadius.xl` (value changes: 48.0 → 24.0)
- `SDeckRadius.xl` → `SDeckRadius.xxl` (value changes: 64.0 → 32.0)
- `SDeckRadius.xxl` → `SDeckRadius.xxxl` (value changes: 96.0 → 48.0)

**Component-Specific Values (Keep for now):**
- `SDeckSpacing.textFieldPadding*` → `SDeckSpace.textFieldPadding*` (same names)
- `SDeckSpacing.buttonPadding*` → `SDeckSpace.buttonPadding*` (same names)
- `SDeckSpacing.buttonIconGap` → `SDeckSpace.buttonIconGap` (same name)
- `SDeckSpacing.icon*` → `SDeckSpace.icon*` (same names)

**Usage Guidelines:**
- When you need **margin** → Use `SDeckSpace.marginM` (not `SDeckSize.m`)
- When you need **padding** → Use `SDeckSpace.paddingM` (not `SDeckSize.m`)
- When you need **gap** → Use `SDeckSpace.gapM` (not `SDeckSize.m`)
- When you need **general size** → Use `SDeckSize.m` (rare cases)

---

### STEP 7: Testing and Fixes

1. **Compile the project** - Fix all compilation errors
2. **Visual testing** - Check all screens for visual changes
3. **Radius values** - Verify radius changes look correct (values will change)
4. **Component testing** - Test buttons, text fields, cards, etc.
5. **Fix any issues** - Address visual regressions

---

## Final File Structure

```
lib/design_system/tokens/
├── size.dart          (NEW - Foundation: sizeZero, sizeXXXS, etc.)
├── control.dart       (NEW - Control sizes: controlXXS, etc.)
├── space.dart         (REPLACED - Was spacing.dart: margin/padding/gap)
├── radius.dart        (UPDATED - References Size with offset)
├── colors.dart        (UNCHANGED - For now)
├── shadows.dart       (UNCHANGED - For now)
├── assets.dart        (UNCHANGED - For now)
└── index.dart         (UPDATED - New exports)
```

---

## Figma Reference Values

### Size Tokens (Foundation):
- `sizeZero` = 0
- `sizeXXXS` = 2
- `sizeXXS` = 4
- `sizeXS` = 8
- `sizeS` = 12
- `sizeM` = 16
- `sizeL` = 24
- `sizeXL` = 32
- `sizeXXL` = 48
- `sizeXXXL` = 64

### Control Tokens (1:1 with Size):
- `controlXXS` = 2 → `sizeXXXS`
- `controlXS` = 4 → `sizeXXS`
- `controlS` = 8 → `sizeXS`
- `controlM` = 16 → `sizeM`
- `controlL` = 24 → `sizeL`
- `controlXL` = 32 → `sizeXL`
- `controlXXL` = 48 → `sizeXXL`

### Space Tokens (Aliases to Size):
- `marginZero` → `sizeZero` (0)
- `marginXXS` → `sizeXXS` (4)
- `marginXS` → `sizeXS` (8)
- `marginS` → `sizeS` (12)
- `marginM` → `sizeM` (16)
- `marginL` → `sizeL` (24)
- `marginXL` → `sizeXL` (32)
- `marginXXL` → `sizeXXL` (48)
- Same pattern for `padding*` and `gap*`

### Radius Tokens (Offset mapping - one step smaller):
- `borderRadiusZero` → `sizeZero` (0)
- `borderRadiusXXS` → `sizeXXXS` (2) ← offset
- `borderRadiusXS` → `sizeXXS` (4) ← offset
- `borderRadiusS` → `sizeXS` (8) ← offset
- `borderRadiusM` → `sizeS` (12) ← offset
- `borderRadiusL` → `sizeM` (16) ← offset
- `borderRadiusXL` → `sizeL` (24) ← offset
- `borderRadiusXXL` → `sizeXL` (32) ← offset
- `borderRadiusXXXL` → `sizeXXL` (48) ← offset

---

## Important Notes

1. **Component-Specific Values:** Kept temporarily in `space.dart` with TODO comments. Will be refactored when we update text fields and buttons later.

2. **Values to Verify in Figma:**
   - `textFieldPaddingLargeHorizontal` = 20.0 (not in Size scale - need to verify)
   - `buttonPaddingLargeVertical` = 20.0 (not in Size scale - need to verify)
   - `iconLarge` = 36.0 (not in Size scale - need to verify)

3. **Radius Values Will Change:** All radius values will change because they currently use wrong values. This is expected and correct.

4. **Migration Impact:** 
   - ~137 usages of `SDeckSpacing.*` need updating
   - ~51 usages of `SDeckRadius.*` need updating
   - All will break initially - fix one file at a time

5. **Semantic Usage:** Always use semantic tokens (`marginM`, `paddingM`, `gapM`) not base Size tokens when the semantic meaning is clear.

---

## Execution Order

1. Create `size.dart` (foundation)
2. Create `control.dart` (references Size)
3. Create `space.dart` (references Size)
4. Update `radius.dart` (references Size with offset)
5. Update `index.dart` (exports)
6. Test compilation
7. Migrate usages file by file
8. Test and fix visual issues

---

## Success Criteria

✅ All variable names match Figma exactly  
✅ All values match Figma exactly  
✅ Size is the foundation - everything references it  
✅ Semantic tokens (margin/padding/gap) are used correctly  
✅ No compilation errors  
✅ Visual appearance matches Figma (after radius fixes)  
✅ Code is clean, maintainable, and scalable  

---

**END OF PLAN**

