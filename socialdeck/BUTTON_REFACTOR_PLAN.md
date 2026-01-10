# Button System Refactor Plan

## Overview

Complete refactor of the button system to match Figma's variant properties exactly. This plan covers migrating from the current 18-named-constructor pattern to a single parameterized constructor that mirrors Figma's property matrix.

**Goal:** Three button classes (Solid, Outline, Text) with Figma-matching property names, supporting all 288 variants (3 types × 3 sizes × 4 states × 4 icon locations × 2 shapes).

---

## Current State Analysis

### What We Have Now

**Files:**
- `lib/design_system/components/buttons/sdeck_solid_button.dart` (667 lines)
- `lib/design_system/components/buttons/sdeck_hollow_button.dart` (617 lines)
- `lib/design_system/components/buttons/button_enums.dart` (49 lines)

**Current Structure:**
- 2 button types: `SDeckSolidButton`, `SDeckHollowButton`
- 18 named constructors per type (3 sizes × 2 radii × 3 icon configs)
- ~144 variants covered
- Used in 21 files across codebase

**Current Property Names:**
- `size` → `SDeckButtonSize` (small, medium, large) ✅ Matches Figma
- `radius` → `SDeckButtonRadius` (squared, round) ❌ Should be "Shape" with "Default"
- `iconConfig` → `SDeckButtonIconConfig` (none, left, right) ❌ Should be "Icon Location" with "Only"
- `enabled` → `bool` ✅ Stays the same
- `state` → Internal only ✅ Stays internal

### What's Missing

- ❌ Text button type (no background/border, just text)
- ❌ Icon-only configuration (square/circular buttons with just icon)
- ❌ Property names don't match Figma exactly
- ❌ ~144 additional variants needed

---

## Figma Property Mapping

### Figma Properties Panel

From Figma screenshot, the exact properties are:

| Figma Property | Figma Values | Current Code | Proposed Code |
|---------------|--------------|--------------|---------------|
| **Size** | Small, Medium, Large | `SDeckButtonSize` ✅ | `SDeckButtonSize` ✅ |
| **State** | Default, Hover, Pressed, Disabled | Internal only ✅ | Internal only ✅ |
| **Icon Location** | None, Left, Right, Only | `SDeckButtonIconConfig` ❌ | `SDeckButtonIconLocation` ✅ |
| **Shape** | Default, Round | `SDeckButtonRadius` (squared, round) ❌ | `SDeckButtonShape` (default_, round) ✅ |
| **Type** | Solid, Outline, Text | Separate classes ✅ | Separate classes ✅ |

**Key Notes:**
- **Shape**: Figma uses "Default" (not "Squared") for the squared corners variant
- **State**: Handled internally, not a constructor parameter
- **Type**: Determined by which class you use (`SDeckSolidButton`, `SDeckOutlineButton`, `SDeckTextButton`)

---

## Finalized Approach

### Architecture Decision

**Approach:** Three separate classes with parameterized constructors

**Rationale:**
- ✅ Matches Figma organization (three button types)
- ✅ Clear separation of concerns
- ✅ Type-safe (can't mix solid/outline)
- ✅ Strong Figma-to-code mapping
- ✅ Minimal breaking changes (can migrate incrementally)

### Class Structure

```
SDeckSolidButton
├── Single parameterized constructor
├── Properties match Figma exactly
└── Internal state management (unchanged)

SDeckOutlineButton (rename from SDeckHollowButton)
├── Single parameterized constructor
├── Properties match Figma exactly
└── Internal state management (unchanged)

SDeckTextButton (NEW)
├── Single parameterized constructor
├── Properties match Figma exactly
└── Internal state management (same pattern)
```

---

## Implementation Plan

### Phase 1: Update Enums ✅

**File:** `lib/design_system/components/buttons/button_enums.dart`

**Changes:**
1. Rename `SDeckButtonIconConfig` → `SDeckButtonIconLocation`
2. Add `only` value to icon location enum
3. Rename `SDeckButtonRadius` → `SDeckButtonShape`
4. Change `squared` → `default_` (Dart doesn't allow `default` keyword)
5. Keep `SDeckButtonState` enum (internal use only, no changes)
6. Keep `SDeckButtonSize` enum (no changes)

**Updated Enum Structure:**
```dart
enum SDeckButtonSize {
  small,   // Maps to Figma "Small"
  medium,  // Maps to Figma "Medium"
  large,   // Maps to Figma "Large"
}

enum SDeckButtonIconLocation {
  none,   // Maps to Figma "None"
  left,   // Maps to Figma "Left"
  right,  // Maps to Figma "Right"
  only,   // Maps to Figma "Only" (NEW)
}

enum SDeckButtonShape {
  default_,  // Maps to Figma "Default" (squared corners)
  round,     // Maps to Figma "Round"
}

enum SDeckButtonState {
  enabled,   // Internal: Maps to Figma "Default"
  hover,     // Internal: Maps to Figma "Hover"
  pressed,   // Internal: Maps to Figma "Pressed"
  disabled,  // Internal: Maps to Figma "Disabled"
}
```

**Validation:**
- ✅ All enum values match Figma conceptually
- ✅ Property names match Figma exactly
- ✅ Dart naming conventions followed

---

### Phase 2: Refactor SDeckSolidButton

**File:** `lib/design_system/components/buttons/sdeck_solid_button.dart`

**Changes:**

1. **Update Properties:**
   ```dart
   // OLD
   final SDeckButtonRadius radius;
   final SDeckButtonIconConfig iconConfig;
   
   // NEW
   final SDeckButtonShape shape;
   final SDeckButtonIconLocation iconLocation;
   ```

2. **Replace 18 Named Constructors with 1 Parameterized Constructor:**
   ```dart
   // OLD: 18 constructors like
   // SDeckSolidButton.small()
   // SDeckSolidButton.smallWithLeftIcon()
   // SDeckSolidButton.smallRound()
   // etc.
   
   // NEW: Single constructor
   const SDeckSolidButton({
     super.key,
     this.text,
     this.icon,
     this.size = SDeckButtonSize.medium,
     this.iconLocation = SDeckButtonIconLocation.none,
     this.shape = SDeckButtonShape.default_,
     this.onPressed,
     this.enabled = true,
     this.fullWidth = false,
   }) : assert(
     (iconLocation == SDeckButtonIconLocation.only && icon != null) ||
     (iconLocation != SDeckButtonIconLocation.only && text != null),
     'Icon-only buttons require icon, others require text',
   );
   ```

3. **Update Internal References:**
   - `widget.radius` → `widget.shape`
   - `widget.iconConfig` → `widget.iconLocation`
   - `SDeckButtonRadius.squared` → `SDeckButtonShape.default_`
   - `SDeckButtonIconConfig.left` → `SDeckButtonIconLocation.left`
   - `SDeckButtonIconConfig.right` → `SDeckButtonIconLocation.right`
   - `SDeckButtonIconConfig.none` → `SDeckButtonIconLocation.none`

4. **Update Content Building Logic:**
   ```dart
   List<Widget> _buildButtonContent(BuildContext context) {
     final List<Widget> children = [];
     
     // NEW: Handle icon-only case
     if (widget.iconLocation == SDeckButtonIconLocation.only) {
       return [widget.icon!];
     }
     
     // Left icon
     if (widget.iconLocation == SDeckButtonIconLocation.left && widget.icon != null) {
       children.add(widget.icon!);
       children.add(const SizedBox(width: SDeckSpace.gap4));
     }
     
     // Text (required for non-icon-only)
     if (widget.text != null) {
       children.add(Text(widget.text!, style: _getTextStyle(context)));
     }
     
     // Right icon
     if (widget.iconLocation == SDeckButtonIconLocation.right && widget.icon != null) {
       children.add(const SizedBox(width: SDeckSpace.gap4));
       children.add(widget.icon!);
     }
     
     return children;
   }
   ```

5. **Keep State Management Unchanged:**
   - ✅ Keep `_currentState` variable
   - ✅ Keep `_updateState()` method
   - ✅ Keep gesture handlers
   - ✅ Keep state-based color logic

**Expected Result:**
- ~400 lines (down from 667)
- Single constructor
- All functionality preserved
- Figma-matching property names

---

### Phase 3: Refactor SDeckHollowButton → SDeckOutlineButton

**File:** `lib/design_system/components/buttons/sdeck_hollow_button.dart` → `sdeck_outline_button.dart`

**Changes:**

1. **Rename Class:**
   ```dart
   // OLD
   class SDeckHollowButton extends StatefulWidget { ... }
   class _SDeckHollowButtonState extends State<SDeckHollowButton> { ... }
   
   // NEW
   class SDeckOutlineButton extends StatefulWidget { ... }
   class _SDeckOutlineButtonState extends State<SDeckOutlineButton> { ... }
   ```

2. **Apply Same Changes as Phase 2:**
   - Update property names
   - Replace 18 constructors with 1
   - Update internal references
   - Update content building logic
   - Keep state management unchanged

3. **Update File Header/Comments:**
   - Change "Hollow" → "Outline" in all comments
   - Update usage examples

**Expected Result:**
- ~400 lines (down from 617)
- Matches Figma naming ("Outline" not "Hollow")
- Same structure as Solid button

---

### Phase 4: Create SDeckTextButton

**File:** `lib/design_system/components/buttons/sdeck_text_button.dart` (NEW)

**Structure:**
- Copy structure from `SDeckSolidButton`
- Modify background/border logic:
  - No background color (transparent)
  - No border
  - Text color changes based on state
- Same property structure
- Same state management
- Same icon-only support

**Key Differences from Solid/Outline:**
```dart
Color _getBackgroundColor(BuildContext context) {
  return Colors.transparent; // Always transparent for text buttons
}

// No border decoration
decoration: BoxDecoration(
  color: Colors.transparent,
  borderRadius: BorderRadius.circular(_getBorderRadius()),
  // No border property
),
```

**Icon Color Handling:**
- Developers pass icons with appropriate component color tokens (e.g., `context.component.textButtonIcon`)
- Component colors automatically handle light/dark mode via semantic tokens
- Note: Mobile apps don't use hover/pressed states; those are for future web support

**Expected Result:**
- ~400 lines
- Matches Figma "Text" button type
- Supports all variants (size, shape, icon location, states)

---

### Phase 4.5: Remove Hover State (Mobile-Only Optimization) ✅

**Rationale:**
- Mobile apps don't support hover (MouseRegion only works on desktop/web)
- Removing hover simplifies code and removes dead code paths
- Pressed state provides sufficient visual feedback for mobile

**Changes Required:**

1. **Remove MouseRegion widgets** from all button files:
   - `sdeck_solid_button.dart`
   - `sdeck_outline_button.dart`
   - `sdeck_text_button.dart`
   - `sdeck_hollow_button.dart` (if still exists)

2. **Remove hover cases** from switch statements:
   - `_getBackgroundColor()` methods
   - `_getTextColor()` methods
   - `_getBorderColor()` methods (outline buttons)

3. **Keep enum value** (for future web support):
   - `SDeckButtonState.hover` stays in enum
   - Just won't be used in switch statements

4. **Keep color tokens** (unused but harmless):
   - `textButtonIconHover`, `textButtonTextHover`, etc.
   - Can be removed later if desired

**Files to Update:**
- `lib/design_system/components/buttons/sdeck_solid_button.dart`
- `lib/design_system/components/buttons/sdeck_outline_button.dart`
- `lib/design_system/components/buttons/sdeck_text_button.dart`

**Expected Result:**
- Simpler code (removes MouseRegion wrappers)
- No hover handlers
- Pressed state still works for tap feedback
- Ready for future web support (enum/tokens exist)

**Implementation Complete:**
- ✅ Removed `MouseRegion` wrappers from all 3 button files
- ✅ Removed hover cases from switch statements (kept enum value for exhaustiveness)
- ✅ Updated `sdeck_solid_button.dart`, `sdeck_outline_button.dart`, `sdeck_text_button.dart`

---

### Phase 4.6: Verification & Refinement ✅

**Tasks:**

1. **Verify Padding Values:** ✅
   - ✅ Verified Figma button heights: Small (44px), Medium (54px), Large (72px)
   - ✅ Calculated vertical padding: Small (12px), Medium (16px), Large (24px)
   - ✅ Verified horizontal padding: Small (8px), Medium (16px), Large (24px)

2. **Verify Font Sizes:** ✅
   - ✅ Verified Figma: Small (16px Body Small), Medium (18px Body Medium), Large (20px Body Large)
   - ✅ Updated all buttons to use `SDeckFontSizes.bodySmall/Medium/Large`

3. **Decide Icon Color Handling:** ✅
   - ✅ Implemented Option B (Auto-Apply State-Aware Colors) in Phase 4.7

4. **Update Implementation:** ✅
   - ✅ Fixed padding: Small (0→12px), Medium (8→16px), Large (16→24px)
   - ✅ Fixed font sizes: Small (14→16px), Medium (16→18px), Large (18→20px)
   - ✅ All values now use exact design system tokens
   - ✅ No TODO comments remaining

**Expected Result:**
- ✅ All values match Figma exactly
- ✅ Icon colors properly handled (implemented in Phase 4.7)
- ✅ No TODO comments remaining

---

### Phase 4.7: Icon Color Handling Decision ✅

**Problem:**
- Figma shows icons should match text colors in all states
- Text colors change dynamically (enabled → pressed → enabled)
- Icon colors are static (set when developer creates icon)
- Multi-colored icons (Google) shouldn't have colors applied

**Decision:** Option B - Auto-Apply State-Aware Colors (Smart Detection) ✅

**Implementation:**

1. **Text Button** (`sdeck_text_button.dart`):
   - ✅ Added `_getIconColor()` method (returns `textButtonIcon`, `textButtonIconPressed`, `textButtonIconDisabled`)
   - ✅ Added `_wrapIconWithColor()` helper method (smart detection)
   - ✅ Updated `_buildButtonContent()` to wrap icons conditionally
   - ✅ Only wraps if `widget.icon` is `SDeckIcon` with `color != null`

2. **Outline Button** (`sdeck_outline_button.dart`):
   - ✅ Added `_getIconColor()` method (returns `outlineButtonIcon` for enabled/pressed, `outlineButtonIconDisabled` for disabled)
   - ✅ Added `_wrapIconWithColor()` helper method (smart detection)
   - ✅ Updated `_buildButtonContent()` to wrap icons conditionally
   - ✅ Only wraps if `widget.icon` is `SDeckIcon` with `color != null`

3. **Solid Button** (`sdeck_solid_button.dart`):
   - ✅ No changes needed (text color is static, so icons don't need to change)

**How It Works:**
- **Monochrome icons** (with `color` set) → Automatically change color with button state ✅
- **Multi-colored icons** (`color: null`) → Preserved as-is ✅
- **Non-SDeckIcon widgets** → Used as-is (safe fallback) ✅

**Result:**
- ✅ Matches Figma behavior automatically
- ✅ No code changes needed from developers
- ✅ Backward compatible
- ✅ Preserves multi-colored icons (Google logo)

---

### Phase 5: Update All Usages (Migration)

**Files Affected:** 21 files (found via grep)

**Migration Pattern:**

1. **Simple Cases (No Icon, No Round):**
   ```dart
   // BEFORE
   SDeckSolidButton.large(
     text: 'Button',
     enabled: true,
     onPressed: () {},
   )
   
   // AFTER
   SDeckSolidButton(
     text: 'Button',
     size: SDeckButtonSize.large,
     enabled: true,
     onPressed: () {},
   )
   ```

2. **With Icons:**
   ```dart
   // BEFORE
   SDeckHollowButton.mediumRoundWithLeftIcon(
     text: 'Continue with Google',
     icon: SDeckIcon.medium(SDeckIcons.google),
     onPressed: () {},
   )
   
   // AFTER
   SDeckOutlineButton(
     text: 'Continue with Google',
     size: SDeckButtonSize.medium,
     shape: SDeckButtonShape.round,
     iconLocation: SDeckButtonIconLocation.left,
     icon: SDeckIcon.medium(SDeckIcons.google),
     onPressed: () {},
   )
   ```

3. **Icon-Only Workarounds:**
   ```dart
   // BEFORE (hack with empty text)
   SDeckHollowButton.mediumRoundWithLeftIcon(
     text: "", // Empty text hack
     icon: SDeckIcon.medium(SDeckIcons.edit),
     onPressed: () {},
   )
   
   // AFTER (proper icon-only)
   SDeckOutlineButton(
     iconLocation: SDeckButtonIconLocation.only,
     size: SDeckButtonSize.medium,
     shape: SDeckButtonShape.round,
     icon: SDeckIcon.medium(SDeckIcons.edit),
     onPressed: () {},
   )
   ```

4. **Class Rename:**
   ```dart
   // BEFORE
   SDeckHollowButton.large(...)
   
   // AFTER
   SDeckOutlineButton(
     size: SDeckButtonSize.large,
     ...
   )
   ```

**Migration Checklist:**
- [ ] `lib/design_system/components/navigation/sdeck_top_navigation_bar.dart`
- [ ] `lib/features/welcome/presentation/pages/welcome_page.dart`
- [ ] `lib/test_pages/test_review_cards_page.dart`
- [ ] `lib/features/onboarding/shared/templates/onboarding_info_template.dart`
- [ ] `lib/test_pages/test_create_deck.dart`
- [ ] `lib/archived/invite_friends_page.dart`
- [ ] `lib/test_pages/adjust_profile_test_page.dart`
- [ ] `lib/test_pages/test_create_deck_bottom_sheet.dart`
- [ ] `lib/test_pages/profile_card_test_page.dart`
- [ ] `lib/test_pages/test_deck_persistence.dart`
- [ ] `lib/test_pages/decks_page.dart`
- [ ] `lib/test_pages/adjust_profile_preview_test_page.dart`
- [ ] `lib/features/onboarding/sign_up/presentation/pages/sign_up_confirm_password.dart`
- [ ] `lib/features/onboarding/profile/presentation/pages/adjust_profile_page.dart`
- [ ] `lib/features/onboarding/shared/templates/onboarding_input_template.dart`
- [ ] `lib/features/onboarding/shared/templates/onboarding_login_template.dart`
- [ ] `lib/features/onboarding/shared/utils/photo_picker_helper.dart`
- [ ] `lib/features/decks/presentation/pages/add_cards_page.dart`
- [ ] `lib/features/home/presentation/pages/home.dart`
- [ ] Plus any other files using buttons

---

### Phase 6: Update Exports

**File:** `lib/design_system/components/index.dart` (or similar)

**Changes:**
```dart
// OLD
export 'buttons/sdeck_solid_button.dart';
export 'buttons/sdeck_hollow_button.dart';

// NEW
export 'buttons/sdeck_solid_button.dart';
export 'buttons/sdeck_outline_button.dart';
export 'buttons/sdeck_text_button.dart';
export 'buttons/button_enums.dart';
```

---

### Phase 7: Remove Old Code

**After Migration Complete:**

1. **Delete Old File:**
   - ❌ `lib/design_system/components/buttons/sdeck_hollow_button.dart`

2. **Verify No References:**
   - Search codebase for `SDeckHollowButton`
   - Search codebase for old constructor patterns
   - Ensure all imports updated

3. **Clean Up:**
   - Remove any deprecated constructors (if we kept them temporarily)
   - Update documentation
   - Verify tests pass

---

## Validation & Testing

### Validation Rules

1. **Icon-Only Validation:**
   ```dart
   assert(
     (iconLocation == SDeckButtonIconLocation.only && icon != null) ||
     (iconLocation != SDeckButtonIconLocation.only && text != null),
     'Icon-only buttons require icon, others require text',
   );
   ```

2. **Property Defaults:**
   - `size`: `SDeckButtonSize.medium`
   - `iconLocation`: `SDeckButtonIconLocation.none`
   - `shape`: `SDeckButtonShape.default_`
   - `enabled`: `true`
   - `fullWidth`: `false`

### Testing Checklist

- [ ] All 3 button types render correctly
- [ ] All sizes work (small, medium, large)
- [ ] All shapes work (default, round)
- [ ] All icon locations work (none, left, right, only)
- [ ] State transitions work (enabled, hover, pressed, disabled)
- [ ] Form validation still works (`enabled: false`)
- [ ] Icon-only buttons render correctly
- [ ] Text buttons have no background/border
- [ ] All 21 migrated files work correctly
- [ ] No runtime errors
- [ ] No linter errors

---

## Performance Impact

**Analysis:**
- ✅ No performance degradation
- ✅ Same StatefulWidget pattern
- ✅ Same switch statements
- ✅ One additional conditional check (icon-only)
- ✅ Same rebuild optimization

**Verdict:** No performance concerns.

---

## Breaking Changes

### What Changes for Developers

1. **Constructor Pattern:**
   - OLD: `SDeckSolidButton.large(...)`
   - NEW: `SDeckSolidButton(size: SDeckButtonSize.large, ...)`

2. **Property Names:**
   - OLD: `radius: SDeckButtonRadius.squared`
   - NEW: `shape: SDeckButtonShape.default_`
   - OLD: `iconConfig: SDeckButtonIconConfig.left`
   - NEW: `iconLocation: SDeckButtonIconLocation.left`

3. **Class Name:**
   - OLD: `SDeckHollowButton`
   - NEW: `SDeckOutlineButton`

### Migration Strategy

**Option A: Big Bang (Recommended)**
- Complete all phases in one PR
- Update all 21 files at once
- Remove old code immediately
- Clean, complete migration

**Option B: Incremental**
- Phase 1-4: New code alongside old
- Phase 5: Migrate files incrementally
- Phase 6-7: Remove old code after all migrated
- More complex, but allows gradual rollout

**Recommendation:** Option A (Big Bang) - cleaner, less confusion.

---

## File Structure After Refactor

```
lib/design_system/components/buttons/
├── button_enums.dart              (Updated enums)
├── sdeck_solid_button.dart        (Refactored - 1 constructor)
├── sdeck_outline_button.dart      (Renamed + refactored)
└── sdeck_text_button.dart         (NEW)
```

---

## Success Criteria

✅ All 288 variants supported (3 types × 3 sizes × 4 states × 4 icon locations × 2 shapes)
✅ Property names match Figma exactly
✅ All 21 files migrated
✅ Old code removed
✅ No breaking changes for end users (only developer API changes)
✅ State management unchanged (works as before)
✅ Performance maintained
✅ Code reduced (~40% fewer lines per button class)

---

## Timeline Estimate

- **Phase 1:** Update enums (30 min)
- **Phase 2:** Refactor Solid button (2 hours)
- **Phase 3:** Refactor Outline button (2 hours)
- **Phase 4:** Create Text button (2 hours)
- **Phase 5:** Migrate all usages (4-6 hours)
- **Phase 6:** Update exports (15 min)
- **Phase 7:** Cleanup (30 min)

**Total:** ~12-14 hours

---

## Notes

- **State Management:** No changes needed - internal state handling works perfectly
- **Figma Alignment:** Property names now match Figma exactly
- **Extensibility:** Easy to add new variants (just add enum values)
- **Developer Experience:** More flexible API, clearer property names
- **Code Quality:** Significant reduction in boilerplate code

---

## Questions Resolved

✅ **State:** Keep internal, no changes needed
✅ **Enums:** Keep enum approach, it's perfect
✅ **Validation:** One simple assertion, minimal overhead
✅ **Performance:** No impact
✅ **Shape:** Use "default_" to match Figma "Default"
✅ **Icon-Only:** Supported via `iconLocation: only`
✅ **Text Button:** New class with same structure

---

## Next Steps

1. Review this plan
2. Approve approach
3. Create GitHub issue
4. Start Phase 1 (Update enums)
5. Proceed through phases sequentially
6. Test thoroughly
7. Create PR
8. Merge and deploy

---

**Last Updated:** [Current Date]
**Status:** Ready for Review

