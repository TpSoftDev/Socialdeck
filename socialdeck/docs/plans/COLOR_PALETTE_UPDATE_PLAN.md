# Complete Implementation Plan - Issue #6 + Background Migration

## Overview
This plan covers updating Main Semantic and Component-Specific Color Palettes to match Figma exactly, plus migrating from deprecated `background` to `surface`.

**Issue Reference:** #6 - Update Main Semantic and Component-Specific Color Palettes to Match Figma Design System

**Figma References:**
- Main Semantic Color Palette: `node-id=5434-32283`
- Component-Specific Color Palette: `node-id=5873-5442`

---

## Phase 0: Background → Surface Migration (Foundational)

### Step 0.1: Remove `background` from Main Semantic (`colors_main_semantic.dart`)
- [ ] Remove `background()` method (lines 22-25)
- [ ] Remove `onBackground()` method (lines 29-32)
- [ ] Update section comment from "Background & Surface" → "Surface" (if needed)

### Step 0.2: Remove `background` from ColorScheme (`color_schemes.dart`)
- [ ] Remove `background:` line (line 59)
- [ ] Remove `onBackground:` line (line 60)
- [ ] Remove `background:` line (line 128)
- [ ] Remove `onBackground:` line (line 129)

### Step 0.3: Replace `background` → `surface` in Component-Specific (`colors_component_specific.dart`)
- [ ] Change `outlineButtonPrimarySurface` from `background` → `surface` (line 39)

### Step 0.4: Replace `background` → `surface` in Theme (`sdeck_app_theme.dart`)
- [ ] Change `scaffoldBackgroundColor: colorScheme.background` → `colorScheme.surface` (line 31)

### Step 0.5: Replace `onBackground` → `onSurface` in Components/Pages (15 files)
- [ ] `test_review_cards_page.dart` (line 86)
- [ ] `test_empty_deck.dart` (lines 50, 111)
- [ ] `test_deck_persistence.dart` (lines 107, 181)
- [ ] `test_deck_list_view.dart` (line 51)
- [ ] `test_create_deck_bottom_sheet.dart` (lines 119, 181)
- [ ] `test_create_deck.dart` (lines 250, 283, 303)
- [ ] `welcome_page.dart` (line 43)
- [ ] `store_page.dart` (line 38)
- [ ] `social_page.dart` (line 41)
- [ ] `profile_page.dart` (lines 182, 201)
- [ ] `onboarding_profile_card_template.dart` (line 104)
- [ ] `onboarding_login_template.dart` (line 195)
- [ ] `onboarding_input_template.dart` (line 167)
- [ ] `onboarding_info_template.dart` (line 120)
- [ ] `account_description_widget.dart` (line 71)

---

## Phase 1: Main Semantic Color Palette (`colors_main_semantic.dart`)

### Step 1.1: Fix Background & Surface Section
- [ ] Fix `surfaceVariant`: Change from `coolGrayLightest`/`coolGrayDark` → `coolGrayLightest`/`coolGrayDarkest` (line 50-53)
- [ ] Rename `inverseSurface` → `surfaceInverse` (line 62) - add deprecated alias for backward compatibility
- [ ] Add `surfaceError` → `brightCoralLightest` (light) / `brightCoralDarkest` (dark)
- [ ] Add `surfaceSuccess` → `mintGreenLightest` (light) / `mintGreenDarkest` (dark)
- [ ] Add `surfaceWarning` → `vibrantYellowLightest` (light) / `vibrantYellowDarkest` (dark)
- [ ] Add `surfaceInfo` → `skyBlueLightest` (light) / `skyBlueDarkest` (dark)
- [ ] Add `surfaceLink` → `lavenderLightest` (light) / `lavenderDarkest` (dark)
- [ ] Add `surfaceNote` → `coolGrayLightest` (light) / `coolGrayDarkest` (dark)

### Step 1.2: Fix Secondary Colors Section
- [ ] Fix `secondary`: Change from `coolGrayLightest`/`coolGrayDarkest` → `coolGrayDark`/`coolGrayLight` (line 106-109)
- [ ] Add `secondaryVariant`: `coolGray` (both light and dark)
- [ ] Fix `onSecondary`: Change from `coolGrayDarkest`/`coolGrayLightest` → `warmOffWhite`/`slateGray` (line 113-116)
- [ ] Add `onSecondaryVariant`: `coolGrayLight`/`coolGrayDark`

### Step 1.3: Fix Tertiary Colors Section
- [ ] Fix `tertiary`: Change from `coolGrayDark`/`coolGrayLight` → `coolGrayLightest`/`coolGrayDarkest` (line 135-138)
- [ ] Add `tertiaryVariant`: `coolGrayLight`/`coolGrayDark`
- [ ] Fix `onTertiary`: Change from `warmOffWhite`/`slateGray` → `coolGrayDarkest`/`coolGrayLightest` (line 142-145)
- [ ] Add `onTertiaryVariant`: `coolGrayDark`/`coolGrayLight`

### Step 1.4: Fix Outline & Misc Section
- [ ] Fix `outline`: Change from brand colors → `#F0F0F0` @ 20% opacity (both modes) (line 214-217)
- [ ] Fix `outlineVariant`: Change from brand colors → `#F0F0F0` @ 30% opacity (both modes) (line 221-222)
- [ ] Add `shadow`: `coolGrayDarkest` / `coolGrayLightest`
- [ ] Add `scrim`: `#000000` @ 25% opacity (both modes)

### Step 1.5: Add New Color Sections
- [ ] Add **Warning Colors** section: `warning` → `vibrantYellow` (both modes)
- [ ] Add **Information Colors** section: `info` → `skyBlue` (both modes)
- [ ] Add **Link Colors** section: `link` → `lavender` (both modes)
- [ ] Add **Note Colors** section: `note` → `coolGrayDark` / `coolGrayLight`

---

## Phase 2: Component-Specific Color Palette (`colors_component_specific.dart`)

### Step 2.1: Fix Existing Button Colors (Replace Brand → Semantic)
- [ ] Fix **Solid Button**:
  - `solidButtonPrimarySurfaceHover`: `coolGrayDark` (brand) → `secondary` (semantic) (line 27)
  - `solidButtonPrimarySurfacePressed`: `coolGrayDark` (brand) → `secondary` (semantic) (line 29)
  - `solidButtonSurfaceDisabled`: `coolGray` (brand) → `secondaryVariant` (semantic) (line 31)
- [ ] Fix **Outline Button**:
  - `outlineButtonIconDisabled`: `coolGray` (brand) → `secondaryVariant` (semantic) (line 42)
  - `outlineButtonTextDisabled`: `coolGray` (brand) → `secondaryVariant` (semantic) (line 45)
  - `outlineButtonBorderHover`: `coolGray` (brand) → `secondaryVariant` (semantic) (line 48)
  - `outlineButtonBorderPressed`: `coolGray` (brand) → `secondaryVariant` (semantic) (line 50)
  - `outlineButtonBorderDisabled`: `coolGrayLight` (brand) → `tertiaryVariant` (semantic) (line 52)
- [ ] Fix **Text Button**:
  - `textButtonIconHover`: `coolGrayDark` (brand) → `secondary` (semantic) (line 58)
  - `textButtonIconPressed`: `coolGrayDark` (brand) → `secondary` (semantic) (line 60)
  - `textButtonIconDisabled`: `coolGray` (brand) → `secondaryVariant` (semantic) (line 62)
  - `textButtonTextHover`: `coolGrayDark` (brand) → `secondary` (semantic) (line 65)
  - `textButtonTextPressed`: `coolGrayDark` (brand) → `secondary` (semantic) (line 67)
  - `textButtonTextDisabled`: `coolGray` (brand) → `secondaryVariant` (semantic) (line 69)
- [ ] Remove all TODO comments after fixes

### Step 2.2: Fix Input Component Colors
- [ ] Fix `inputSurfaceError`: Change from `error` → `surfaceError` (line 75)
- [ ] Fix `inputOutlineFocused`: Change from `skyBlue` (brand) → `info` (semantic) (line 88)

### Step 2.3: Add New Components from Figma
- [ ] Add **Dialog** component:
  - `dialogSurface` → `surface`
  - `dialogTitle` → `primary`
  - `dialogIcon` → `secondary`
  - `dialogText` → `onSurface`
  - `dialogSupportingText` → `onSurfaceVariant`
- [ ] Add **Navigation** component:
  - `navBackground` → `surface`
  - `navIcon` → `primary`
  - `navText` → `onSurface`
- [ ] Add **Icon (Standalone)** component:
  - `iconPrimary` → `primary`
  - `iconSecondary` → `secondary`
  - `iconTertiary` → `tertiary`
  - `iconDisabled` → `onSurfaceVariant`
  - `iconError` → `error`
- [ ] Add **Text (Standalone)** component:
  - `textPrimary` → `primary`
  - `textSecondary` → `secondary`
  - `textTertiary` → `tertiary`
  - `textDisabled` → `onSurfaceVariant`
  - `textError` → `error`
  - `textLink` → `link`
- [ ] Add **Toast** component:
  - `toastSurfaceSuccess` → `surfaceSuccess`
  - `toastSurfaceError` → `surfaceError`
  - `toastSurfaceWarning` → `surfaceWarning`
  - `toastSurfaceInfo` → `surfaceInfo`
  - `toastSurfaceNote` → `surfaceNote`
  - `toastIconSuccess` → `onSuccess`
  - `toastIconError` → `onError`
  - `toastIconWarning` → `onWarning`
  - `toastIconInfo` → `onInfo`
  - `toastIconNote` → `onNote`
  - `toastTextSuccess` → `onSuccess`
  - `toastTextError` → `onError`
  - `toastTextWarning` → `onWarning`
  - `toastTextInfo` → `onInfo`
  - `toastTextNote` → `onNote`

---

## Phase 3: Update Color Schemes (`color_schemes.dart`)

### Step 3.1: Update References
- [ ] Update `inverseSurface` → `surfaceInverse` (or keep both with deprecation)
- [ ] Update `shadow` to use new semantic method
- [ ] Update `scrim` to use new semantic method (opacity-based)

---

## Phase 4: Testing & Verification

### Step 4.1: Code Verification
- [ ] Run linter to check for errors
- [ ] Verify all imports are correct
- [ ] Check that all brand color references are replaced with semantic colors in component-specific palette
- [ ] Verify no references to `background`/`onBackground` remain (except in comments)

### Step 4.2: Visual Verification
- [ ] Test light mode colors match Figma
- [ ] Test dark mode colors match Figma
- [ ] Verify opacity-based colors render correctly (`outline`, `outlineVariant`, `scrim`)
- [ ] Check component-specific colors in actual components

---

## Implementation Order

1. **Phase 0**: Background → Surface Migration (Foundational - must be done first)
2. **Phase 1**: Main Semantic Color Palette (Foundation for Phase 2)
3. **Phase 2**: Component-Specific Color Palette (Depends on Phase 1)
4. **Phase 3**: Update Color Schemes (Uses Phase 1)
5. **Phase 4**: Testing & Verification

---

## Summary

- **Total Steps**: ~80+ individual changes
- **Files to Modify**: ~20 files
- **New Colors to Add**: ~30+
- **Colors to Fix**: ~25+
- **Background Migrations**: ~20+ replacements

---

## Notes

- All changes must match Figma exactly
- Opacity colors use `Color.fromRGBO()` for implementation
- All component-specific colors MUST reference semantic colors, not brand colors
- Background/onBackground are deprecated in Flutter - use surface/onSurface instead

