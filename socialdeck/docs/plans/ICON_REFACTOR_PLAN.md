# Icon System Refactor Plan

## Overview
Complete refactor to match Figma workflow exactly: monochrome icons + ColorScheme colors. Simple, direct usage matching designer's process.

**Goal:** `SDeckIcon(SDeckIcons.home, color: Theme.of(context).colorScheme.onPrimary)`

---

## Phase 1: Create SDeckIcons Class ✅
**Status:** COMPLETE

**What was done:**
- Created `lib/design_system/tokens/icons/icons.dart`
- Added `SDeckIcons` class matching Figma structure exactly
- 32 Primary Stroke icons
- 5 Fill icons
- 3 Misc icons
- Icon names match Figma (converted to camelCase)

**File:** `lib/design_system/tokens/icons/icons.dart`

---

## Phase 2: Move Icons & Update Assets
**Status:** PENDING

**Tasks:**
1. Move icons from `iconsv2/` to final location:
   - `assets/iconsv2/stroke/` → `assets/icons/stroke/`
   - `assets/iconsv2/fill/` → `assets/icons/fill/`
   - `assets/iconsv2/misc/` → `assets/icons/misc/`

2. Update `pubspec.yaml`:
   - Remove old paths: `assets/icons/light/`, `assets/icons/dark/`
   - Add new paths: `assets/icons/stroke/`, `assets/icons/fill/`, `assets/icons/misc/`

3. Export `SDeckIcons` from tokens index (if needed)

**Files:**
- `pubspec.yaml` (lines 58-66)
- `lib/design_system/tokens/index.dart` (if icons need export)

---

## Phase 3: Update Components
**Status:** PENDING

**Goal:** Replace `context.icons` with `SDeckIcons` + `colorScheme`

**Files to update (19 total):**

1. `lib/design_system/components/navigation/sdeck_nav_icon.dart`
2. `lib/design_system/components/sheets/sdeck_bottom_sheet.dart`
3. `lib/design_system/components/sections/selected_photos_section.dart`
4. `lib/design_system/components/navigation/sdeck_top_navigation_bar.dart`
5. `lib/design_system/components/cards/sdeck_create_profile_card.dart`
6. `lib/design_system/components/inputs/sdeck_text_field.dart`
7. `lib/design_system/components/cards/sdeck_adjust_profile_card.dart`
8. `lib/features/welcome/presentation/pages/welcome_page.dart`
9. `lib/archived/invite_friends_page.dart`
10. `lib/test_pages/test_review_cards_page.dart`
11. `lib/test_pages/test_create_deck_bottom_sheet.dart`
12. `lib/test_pages/test_deck_list_view.dart`
13. `lib/test_pages/test_empty_deck.dart`
14. `lib/test_pages/test_create_deck.dart`
15. `lib/features/onboarding/shared/templates/onboarding_input_template.dart`
16. `lib/features/onboarding/shared/templates/onboarding_info_template.dart`
17. `lib/design_system/components/buttons/sdeck_solid_button.dart` (if uses icons)
18. `lib/design_system/components/buttons/sdeck_hollow_button.dart` (if uses icons)
19. `lib/design_system/components/cards/sdeck_playing_card.dart` (uses SDeckAssets.checkeredBackground - background pattern, not icon)

**Changes per file:**
- Replace `context.icons.iconName` → `SDeckIcons.iconName`
- Add `color: Theme.of(context).colorScheme.xxx` (use component-specific colors where available)
- Remove import: `import '../../themes/icon_themes.dart';`
- Add import: `import '../../tokens/icons/icons.dart';`

**Missing icons (handle with TODOs):**
- `socialdeckLogo` - used in 5 files
- `wordmark` - used in 1 file
- `addProfileCard` - used in 1 file
- `circleX`, `circleCheck` - used in text field
- `vector30`, `vector35Alt` - used in test pages
- `friends` stroke, `deck` stroke - only fill versions exist

---

## Phase 4: Remove Old System
**Status:** PENDING

**Tasks:**
1. Delete `lib/design_system/themes/icon_themes.dart` (no longer needed)
2. Delete `lib/design_system/tokens/icons/assets.dart` (replaced by `icons.dart`)
3. Update `lib/design_system/themes/sdeck_app_theme.dart`:
   - Remove `SDeckIconThemes.light` and `SDeckIconThemes.dark` from extensions
   - Remove icon theme extension completely

**Files:**
- Delete: `lib/design_system/themes/icon_themes.dart`
- Delete: `lib/design_system/tokens/icons/assets.dart`
- Update: `lib/design_system/themes/sdeck_app_theme.dart` (lines 36-38)

---

## Phase 5: Cleanup
**Status:** PENDING

**Tasks:**
1. Delete old icon folders:
   - `assets/icons/light/` (entire folder)
   - `assets/icons/dark/` (entire folder)
   - `assets/iconsv2/` (after confirming icons moved)

2. Verify all tests pass

3. Test icon rendering in light/dark modes

---

## Usage Pattern (After Refactor)

```dart
// Simple - matches Figma workflow
SDeckIcon(
  SDeckIcons.home,  // Pick icon (like designer picks from "Primary Stroke")
  color: Theme.of(context).colorScheme.onPrimary  // Apply color (like designer applies color variable)
)

// Component-specific colors (when available)
SDeckIcon(
  SDeckIcons.search,
  color: Theme.of(context).colorScheme.inputIcon  // Component-specific
)

// Navigation icons (fill vs stroke)
SDeckIcon(
  isSelected ? SDeckIcons.homeFill : SDeckIcons.home,
  color: Theme.of(context).colorScheme.onSurface
)
```

---

## Notes

- **Default color behavior:** TODO - decide what happens when color not specified
- **Missing icons:** Some icons used in code don't exist in new Figma set - handle with TODOs
- **Component-specific colors:** Use `SDeckComponentSpecificColors` extension where available
- **Light/dark mode:** Handled automatically by `ColorScheme` - no manual switching needed

---

## Current Status

- ✅ Phase 1: SDeckIcons class created
- 🔄 Phase 2: **IN PROGRESS** - Move icons and update pubspec.yaml (DO THIS BEFORE touching components)
- ⏸️ Phase 3: **WAITING** - Update components (only after Phase 2 complete)
- ⏸️ Phase 4: **WAITING** - Remove old system (only after Phase 3 complete)
- ⏸️ Phase 5: **WAITING** - Cleanup (only after Phase 4 complete)

## Important Notes

- **DO NOT update components until infrastructure is complete**
- Components still use `assets.dart` and `icon_themes.dart` - keep them working
- Finish Phase 2 (move icons, update pubspec.yaml) before Phase 3
- Each phase must be complete before moving to next
