# Color System Refactor Plan

## Overview
Refactor the color system to match Figma's structure exactly, removing "In-House" naming and using semantic tokens that align with Figma's Brand Color Palette and Main Semantic Color Palette.

---

## Final Decisions

### Class Names
- `SDeckColors` (base tokens - existing, stays as-is)
- `SDeckBrandColors` (new - Brand Color Palette)
- `SDeckMainSemanticColors` (new - Main Semantic Color Palette)

### File Names
- `colors_base.dart` (rename from `colors.dart`)
- `colors_brand.dart` (new)
- `colors_main_semantic.dart` (new)

### Theme Names
- `SDeckTheme.light` (rename from `inHouseLight`)
- `SDeckTheme.dark` (rename from `inHouseDark`)

---

## Architecture Diagrams

### Current Architecture (Before)

```
Layer 1: Base Tokens
  └─ colors.dart
     └─ SDeckColors.coolGray[900]!  ← Numeric indices

         │
         ▼

Layer 2: Color Schemes
  └─ color_schemes.dart
     └─ inHouseLight / inHouseDark  ← "In-House" naming
        primary: SDeckColors.coolGray[900]!  ← Direct numeric access

         │
         ▼

Layer 3: Color Extensions
  └─ color_extensions.dart
     └─ success: SDeckColors.mintGreen[100]!  ← Direct numeric access

         │
         ▼

Layer 4: Theme Assembly
  └─ sdeck_theme.dart
     └─ SDeckTheme.inHouseLight  ← "In-House" naming
        SDeckTheme.inHouseDark

         │
         ▼

Components
  └─ Theme.of(context).colorScheme.primary
```

### New Architecture (After)

```
Layer 1: Base Color Palette
  └─ colors_base.dart
     └─ SDeckColors.coolGray[900]!  ← MaterialColor palettes (UNCHANGED)

         │
         ▼

Layer 2: Brand Color Palette (Identity Layer)
  └─ colors_brand.dart  ✨ NEW
     └─ SDeckBrandColors
        ├─ coolGrayDarkest = SDeckColors.coolGray[900]!
        ├─ coolGrayLightest = SDeckColors.coolGray[100]!
        ├─ brightCoralLightest = SDeckColors.brightCoral[100]!
        └─ warmOffWhite = SDeckColors.warmOffWhite[300]!
        (Matches Figma: Brand Color Palette)

         │
         ▼

Layer 3: Main Semantic Color Palette (Map Layer)
  └─ colors_main_semantic.dart  ✨ NEW
     └─ SDeckMainSemanticColors
        ├─ background = SDeckBrandColors.warmOffWhite (light)
        │                 SDeckBrandColors.slateGray (dark)
        ├─ primary = SDeckBrandColors.coolGrayDarkest (light)
        │             SDeckBrandColors.coolGrayLightest (dark)
        └─ onPrimary = SDeckBrandColors.warmOffWhite (light)
                       SDeckBrandColors.slateGray (dark)
        (Matches Figma: Main Semantic Color Palette)

         │
         ▼

Layer 4: Color Schemes
  └─ color_schemes.dart  🔄 UPDATED
     └─ light / dark  ← Renamed from inHouseLight/inHouseDark
        primary: SDeckMainSemanticColors.primary  ← Uses semantic tokens!

         │
         ▼

Layer 5: Color Extensions
  └─ color_extensions.dart  🔄 UPDATED
     └─ success: SDeckBrandColors.mintGreenLightest (light)
                  SDeckBrandColors.mintGreenDarkest (dark)
        ← Uses brand tokens with theme-aware logic!

         │
         ▼

Layer 6: Theme Assembly
  └─ sdeck_theme.dart  🔄 UPDATED
     └─ SDeckTheme.light  ← Renamed from inHouseLight
        SDeckTheme.dark   ← Renamed from inHouseDark

         │
         ▼

Components  ✅ UNCHANGED
  └─ Theme.of(context).colorScheme.primary
     Theme.of(context).colorScheme.success
```

### Connection Flow

```
Figma Structure          Code Structure
─────────────────────────────────────────────────────────────

Base Color Palette
  └─ brightCoral100     →  SDeckColors.brightCoral[100]!
     coolGray900        →  SDeckColors.coolGray[900]!

         │
         ▼

Brand Color Palette (Identity)
  └─ brightCoralLightest →  SDeckBrandColors.brightCoralLightest
     (references brightCoral100)  = SDeckColors.brightCoral[100]!
     
     coolGrayDarkest    →  SDeckBrandColors.coolGrayDarkest
     (references coolGray900)    = SDeckColors.coolGray[900]!

         │
         ▼

Main Semantic (Map)
  └─ primary            →  SDeckMainSemanticColors.primary
     (references coolGrayDarkest) = SDeckBrandColors.coolGrayDarkest
     
     background          →  SDeckMainSemanticColors.background
     (references warmOffWhite)    = SDeckBrandColors.warmOffWhite

         │
         ▼

ColorScheme
  └─ primary            →  primary: SDeckMainSemanticColors.primary
     (uses Main Semantic)         (which uses Brand)
                                  (which uses Base)
```

### File Structure

**BEFORE:**
```
lib/design_system/
  ├─ tokens/
  │  └─ colors.dart  ← Base tokens only
  │
  ├─ foundations/
  │  ├─ color_schemes.dart  ← Uses SDeckColors.coolGray[900]!
  │  └─ color_extensions.dart  ← Uses SDeckColors.mintGreen[100]!
  │
  └─ themes/
     └─ sdeck_theme.dart  ← inHouseLight / inHouseDark
```

**AFTER:**
```
lib/design_system/
  ├─ tokens/
  │  ├─ colors_base.dart  ← Renamed from colors.dart
  │  ├─ colors_brand.dart  ✨ NEW
  │  └─ colors_main_semantic.dart  ✨ NEW
  │
  ├─ foundations/
  │  ├─ color_schemes.dart  🔄 Uses SDeckMainSemanticColors.*
  │  └─ color_extensions.dart  🔄 Uses SDeckBrandColors.*
  │
  └─ themes/
     └─ sdeck_theme.dart  🔄 light / dark
```

---

## Step-by-Step Implementation Plan

### Step 1: Create Brand Color Palette
**File:** `lib/design_system/tokens/colors_brand.dart` (NEW)

**What:** Create `SDeckBrandColors` class with semantic identity names matching Figma's Brand Color Palette.

**Structure:**
```dart
class SDeckBrandColors {
  // Cool Gray
  static const Color coolGrayDarkest = SDeckColors.coolGray[900]!;
  static const Color coolGrayLightest = SDeckColors.coolGray[100]!;
  static const Color coolGrayDark = SDeckColors.coolGray[700]!;
  static const Color coolGray = SDeckColors.coolGray[500]!;
  
  // Bright Coral
  static const Color brightCoralLightest = SDeckColors.brightCoral[100]!;
  static const Color brightCoralLight = SDeckColors.brightCoral[300]!;
  static const Color brightCoral = SDeckColors.brightCoral[500]!;
  static const Color brightCoralDark = SDeckColors.brightCoral[700]!;
  static const Color brightCoralDarkest = SDeckColors.brightCoral[900]!;
  
  // Warm Off White
  static const Color warmOffWhite = SDeckColors.warmOffWhite[300]!;
  
  // Slate Gray
  static const Color slateGray = SDeckColors.slateGray[800]!;
  
  // Mint Green
  static const Color mintGreenLightest = SDeckColors.mintGreen[100]!;
  static const Color mintGreenDarkest = SDeckColors.mintGreen[900]!;
  static const Color mintGreen = SDeckColors.mintGreen[500]!;
  
  // ... (all colors from Figma Brand Color Palette)
}
```

**Why:** Provides semantic identity layer matching Figma's Brand Color Palette.

---

### Step 2: Create Main Semantic Color Palette
**File:** `lib/design_system/tokens/colors_main_semantic.dart` (NEW)

**What:** Create `SDeckMainSemanticColors` class with Material Design 3 properties. Note: These will need light/dark variants handled in color_schemes.dart.

**Structure:**
```dart
class SDeckMainSemanticColors {
  // Note: Light/dark variants will be handled in color_schemes.dart
  // These are the base semantic mappings
  
  // Background & Surface (Light mode values)
  static const Color background = SDeckBrandColors.warmOffWhite;
  static const Color surface = SDeckBrandColors.warmOffWhite;
  static const Color onBackground = SDeckBrandColors.coolGrayDarkest;
  static const Color onSurface = SDeckBrandColors.coolGrayDarkest;
  
  // Primary Colors (Light mode values)
  static const Color primary = SDeckBrandColors.coolGrayDarkest;
  static const Color onPrimary = SDeckBrandColors.warmOffWhite;
  
  // ... (all Material Design 3 properties from Figma)
}
```

**Why:** Provides Material Design 3 mapping layer matching Figma's Main Semantic Color Palette.

**Note:** Light/dark mode switching will be handled in `color_schemes.dart` when building the ColorScheme.

---

### Step 3: Rename Base Colors File
**File:** `lib/design_system/tokens/colors.dart` → `colors_base.dart`

**What:** Rename file to match new naming convention.

**Why:** Consistency with new file naming pattern (`colors_base.dart`, `colors_brand.dart`, `colors_main_semantic.dart`).

---

### Step 4: Update Color Schemes
**File:** `lib/design_system/foundations/color_schemes.dart`

**What:**
- Rename `inHouseLight` → `light`
- Rename `inHouseDark` → `dark`
- Replace all numeric indices with semantic tokens
- Handle light/dark mode mapping for Main Semantic colors

**Before:**
```dart
static final inHouseLight = ColorScheme(
  brightness: Brightness.light,
  primary: SDeckColors.coolGray[900]!,
  onPrimary: SDeckColors.warmOffWhite[300]!,
);
```

**After:**
```dart
static final light = ColorScheme(
  brightness: Brightness.light,
  primary: SDeckMainSemanticColors.primary, // Uses Brand → Base
  onPrimary: SDeckMainSemanticColors.onPrimary,
);

static final dark = ColorScheme(
  brightness: Brightness.dark,
  primary: SDeckBrandColors.coolGrayLightest, // Different for dark mode
  onPrimary: SDeckBrandColors.slateGray,
);
```

**Why:** Uses semantic tokens and removes "In-House" naming.

---

### Step 5: Update Color Extensions
**File:** `lib/design_system/foundations/color_extensions.dart`

**What:** Replace numeric indices with Brand Color tokens, keeping theme-aware logic.

**Before:**
```dart
Color get success =>
    brightness == Brightness.light
        ? SDeckColors.mintGreen[100]!
        : SDeckColors.mintGreen[900]!;
```

**After:**
```dart
Color get success =>
    brightness == Brightness.light
        ? SDeckBrandColors.mintGreenLightest
        : SDeckBrandColors.mintGreenDarkest;
```

**Why:** Uses semantic brand tokens matching Figma.

---

### Step 6: Update Theme Names
**File:** `lib/design_system/themes/sdeck_theme.dart`

**What:** Rename theme getters.

**Before:**
```dart
static ThemeData get inHouseLight => _buildTheme(SDeckColorSchemes.inHouseLight);
static ThemeData get inHouseDark => _buildTheme(SDeckColorSchemes.inHouseDark);
```

**After:**
```dart
static ThemeData get light => _buildTheme(SDeckColorSchemes.light);
static ThemeData get dark => _buildTheme(SDeckColorSchemes.dark);
```

**Why:** Matches Figma naming (no "In-House").

---

### Step 7: Update Main.dart
**File:** `lib/main.dart`

**What:** Update theme references.

**Before:**
```dart
theme: SDeckTheme.inHouseLight,
darkTheme: SDeckTheme.inHouseDark,
```

**After:**
```dart
theme: SDeckTheme.light,
darkTheme: SDeckTheme.dark,
```

**Why:** Uses new theme names.

---

### Step 8: Update Exports
**File:** `lib/design_system/tokens/index.dart`

**What:** Add exports for new files, update colors.dart export.

**Before:**
```dart
export 'colors.dart';
```

**After:**
```dart
export 'colors_base.dart';
export 'colors_brand.dart';
export 'colors_main_semantic.dart';
```

**Why:** Makes new tokens available via barrel export.

---

## Implementation Summary

### Files Created
- `lib/design_system/tokens/colors_brand.dart` (NEW)
- `lib/design_system/tokens/colors_main_semantic.dart` (NEW)

### Files Renamed
- `lib/design_system/tokens/colors.dart` → `colors_base.dart`

### Files Updated
- `lib/design_system/foundations/color_schemes.dart`
- `lib/design_system/foundations/color_extensions.dart`
- `lib/design_system/themes/sdeck_theme.dart`
- `lib/main.dart`
- `lib/design_system/tokens/index.dart`

### Files Unchanged
- All component files (no changes needed - they use colorScheme extensions)

---

## Key Benefits

1. **Matches Figma Exactly:** Variable names align with Figma's Brand Color Palette and Main Semantic Color Palette
2. **No Component Changes:** Components continue using `colorScheme.*` - no breaking changes
3. **Preserves Architecture:** Base tokens, theme-aware logic, and structure remain intact
4. **Better Maintainability:** Change semantic mapping without touching base values
5. **Improved DX:** Clear, autocomplete-friendly names
6. **Scalable:** Easy to add new semantic tokens or future themes (Game, etc.)

---

## Developer Experience

### Before
```dart
// Developer types:
SDeckColors.coolGray[900]!  // Need to know [900] = Darkest
```

### After
```dart
// Developer types:
SDeckBrandColors.coolGrayDarkest  // Clear, matches Figma!
```

### Figma to Code Mapping
```
Figma Designer: "Use coolGrayDarkest from Brand Color Palette"
Developer: SDeckBrandColors.coolGrayDarkest  ✅ Exact match!
```

---

## Notes

- All changes maintain backward compatibility at the component level
- Theme-aware switching logic is preserved
- MaterialColor palettes remain unchanged
- ColorScheme structure remains intact
- This refactor focuses on naming and structure, not functionality

---

## Next Steps

1. Review this plan
2. Begin Step 1: Create `colors_brand.dart`
3. Review and approve each step before proceeding
4. Test after each major step
5. Complete all 8 steps sequentially

---

**Last Updated:** [Current Date]
**Status:** Ready for Implementation

