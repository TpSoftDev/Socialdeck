# ThemeExtension Migration Plan

## Executive Summary

**Goal:** Migrate from `ColorScheme` extensions to `ThemeExtension` to:
1. Enable smooth theme transitions (via `lerp()`)
2. Preserve exact Figma naming conventions
3. Separate custom design tokens from Material's `ColorScheme`
4. **Eventually remove ColorScheme entirely** - use only ThemeExtensions (single source of truth matching Figma Collections)

**Impact:** 
- **118 usages** across **33 files** need updating
- **3 ColorScheme extensions** need to be converted to ThemeExtension classes
- **ColorScheme itself will be removed** after migrating Material widgets (BottomNavigationBar, SnackBar)
- **Large codebase change** - requires careful planning and incremental migration

**Risk Level:** HIGH - This is a foundational change affecting the entire design system

---

## Part 1: Understanding ThemeExtension

### What is ThemeExtension?

`ThemeExtension` is Flutter's official way to add custom properties to `ThemeData`. It's different from `ColorScheme` extensions in key ways:

#### Current Approach (ColorScheme Extensions)
```dart
extension SDeckColorScheme on ColorScheme {
  Color get buttonPrimaryHover => 
    brightness == Brightness.light 
      ? SDeckBaseColors.coolGray[950]!
      : SDeckBaseColors.coolGray[100]!;
}

// Usage:
Theme.of(context).colorScheme.buttonPrimaryHover
```

**Problems:**
- ❌ No `lerp()` - theme changes are instant (no animation)
- ❌ Extends Material's `ColorScheme` (mixing custom with Material)
- ❌ Computed getters (can't interpolate between values)

#### New Approach (ThemeExtension)
```dart
class SDeckColorExtension extends ThemeExtension<SDeckColorExtension> {
  final Color buttonPrimaryHover;
  final Color inputIcon;
  final Color surfaceError;
  // ... all custom colors as properties

  const SDeckColorExtension({
    required this.buttonPrimaryHover,
    required this.inputIcon,
    required this.surfaceError,
    // ...
  });

  @override
  ThemeExtension<SDeckColorExtension> copyWith({
    Color? buttonPrimaryHover,
    Color? inputIcon,
    Color? surfaceError,
    // ...
  }) {
    return SDeckColorExtension(
      buttonPrimaryHover: buttonPrimaryHover ?? this.buttonPrimaryHover,
      inputIcon: inputIcon ?? this.inputIcon,
      surfaceError: surfaceError ?? this.surfaceError,
      // ...
    );
  }

  @override
  ThemeExtension<SDeckColorExtension> lerp(
    ThemeExtension<SDeckColorExtension>? other,
    double t,
  ) {
    if (other is! SDeckColorExtension) return this;
    
    return SDeckColorExtension(
      buttonPrimaryHover: Color.lerp(buttonPrimaryHover, other.buttonPrimaryHover, t)!,
      inputIcon: Color.lerp(inputIcon, other.inputIcon, t)!,
      surfaceError: Color.lerp(surfaceError, other.surfaceError, t)!,
      // ...
    );
  }
}

// Usage:
Theme.of(context).extension<SDeckColorExtension>()?.buttonPrimaryHover
```

**Benefits:**
- ✅ `lerp()` enables smooth theme transitions
- ✅ Separate from Material's `ColorScheme`
- ✅ Actual Color objects (can interpolate)

### Key Concepts

1. **copyWith()**: Creates a new instance with some properties changed
   - Used by Flutter internally for theme updates
   - Required for ThemeExtension

2. **lerp()**: Linearly interpolates between two theme states
   - `t = 0.0` → current theme
   - `t = 1.0` → other theme
   - `t = 0.5` → halfway between (for smooth transitions)
   - This is what enables animated theme switching!

3. **Type Safety**: `ThemeExtension<T>` ensures type safety
   - `Theme.of(context).extension<SDeckColorExtension>()` returns `SDeckColorExtension?`
   - Can be null if not provided in theme

---

## Part 2: Current State Analysis

### Current ColorScheme Extensions

1. **SDeckColorScheme** (`color_extensions.dart`)
   - Component-specific colors: `buttonPrimaryHover`, `noteContainer`, `createProfileCardBackground`, etc.
   - ~15 custom colors

2. **SDeckMainSemanticColors** (`colors_main_semantic.dart`)
   - Semantic colors: `surfaceError`, `surfaceSuccess`, `primary`, `onSurface`, etc.
   - ~30 semantic colors

3. **SDeckComponentSpecificColors** (`colors_component_specific.dart`)
   - Component-specific: `inputIcon`, `solidButtonPrimarySurface`, `toastSurfaceError`, etc.
   - ~50 component-specific colors

**Total:** ~95 custom color properties

### Usage Statistics

- **118 usages** across **33 files**
- Most common patterns:
  - `Theme.of(context).colorScheme.surfaceError`
  - `Theme.of(context).colorScheme.inputIcon`
  - `Theme.of(context).colorScheme.buttonPrimaryHover`

### Files Most Affected

**Design System Components (High Impact):**
- `lib/design_system/components/inputs/sdeck_text_field.dart` (16 usages)
- `lib/design_system/components/messages/sdeck_message_card.dart` (4 usages)
- `lib/design_system/components/navigation/sdeck_top_navigation_bar.dart` (8 usages)
- `lib/design_system/components/cards/*` (multiple files)

**Feature Pages (Medium Impact):**
- `lib/features/profile/presentation/profile_page.dart` (7 usages)
- `lib/features/onboarding/shared/templates/*` (multiple files)
- `lib/test_pages/*` (multiple files)

---

## Part 3: Migration Strategy Options

### Option A: Collection-Based ThemeExtensions (RECOMMENDED - Matches Figma Exactly)

**Structure:**
```dart
// Matches Figma Collection: "Color - Semantic"
class SDeckSemanticColors extends ThemeExtension<SDeckSemanticColors> {
  // Background & Surface
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color surfaceError;
  final Color surfaceSuccess;
  // ... all semantic colors
  
  // Primary, Secondary, Tertiary, Error, Success, etc.
  final Color primary;
  final Color onPrimary;
  // ... all semantic colors
}

// Matches Figma Collection: "Color - Component-Specific"
class SDeckComponentColors extends ThemeExtension<SDeckComponentColors> {
  // Button Colors
  final Color solidButtonPrimarySurface;
  final Color solidButtonPrimarySurfaceHover;
  // ... button colors
  
  // Input Colors
  final Color inputSurface;
  final Color inputIcon;
  final Color inputIconError;
  // ... input colors
  
  // Toast, Dialog, Navigation, etc.
  // ... all component-specific colors
}
```

**Access Pattern:**
```dart
// Semantic colors (from "Color - Semantic" collection)
context.semanticColors.surfaceError
context.semanticColors.primary

// Component colors (from "Color - Component-Specific" collection)
context.componentColors.inputIcon
context.componentColors.solidButtonPrimarySurface
```

**Pros:**
- ✅ **Matches Figma Collections exactly** - "Color - Semantic" and "Color - Component-Specific"
- ✅ **Clear organization** - Developers can look at Figma collection and know which extension to use
- ✅ **Self-documenting** - Collection name in Figma = extension name in code
- ✅ **Maintainable** - Smaller, focused classes
- ✅ **Matches Figma structure** - Direct 1:1 mapping with Figma organization
- ✅ **Easy to find colors** - Look at Figma collection → use corresponding extension

**Cons:**
- ❌ Two extensions to access (but matches Figma structure)
- ❌ Developers need to know which collection a color is in (but Figma shows this clearly)

### Option B: Multiple ThemeExtensions (Organized)

**Structure:**
```dart
// Semantic colors
class SDeckSemanticColors extends ThemeExtension<SDeckSemanticColors> {
  final Color surfaceError;
  final Color surfaceSuccess;
  final Color primary;
  // ... semantic colors
}

// Component-specific colors
class SDeckComponentColors extends ThemeExtension<SDeckComponentColors> {
  final Color buttonPrimaryHover;
  final Color inputIcon;
  final Color solidButtonPrimarySurface;
  // ... component colors
}
```

**Pros:**
- ✅ Organized by purpose
- ✅ Smaller, focused classes
- ✅ Matches Figma structure (Semantic vs Component-Specific)

**Cons:**
- ❌ Multiple extensions to access
- ❌ More complex setup

### Option C: Hybrid (Recommended)

**Structure:**
```dart
// Main semantic colors (matches Figma "Main Schematic Color Palette")
class SDeckSemanticColors extends ThemeExtension<SDeckSemanticColors> {
  // Background & Surface
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color surfaceError;
  final Color surfaceSuccess;
  // ... all semantic colors
}

// Component-specific colors (matches Figma "Component-Specific Color Palette")
class SDeckComponentColors extends ThemeExtension<SDeckComponentColors> {
  // Button colors
  final Color solidButtonPrimarySurface;
  final Color solidButtonPrimarySurfaceHover;
  // Input colors
  final Color inputIcon;
  final Color inputIconError;
  // ... all component colors
}
```

**Pros:**
- ✅ Matches Figma structure exactly
- ✅ Organized and maintainable
- ✅ Clear separation of concerns
- ✅ Can migrate incrementally (semantic first, then component)

**Cons:**
- ❌ Two extensions to manage
- ❌ Slightly more complex access pattern

**Recommendation:** **Option A (Collection-Based)** - Matches Figma exactly:
- **Direct mapping to Figma Collections** - "Color - Semantic" → `semanticColors`, "Color - Component-Specific" → `componentColors`
- **Self-documenting** - Developers look at Figma collection → know which extension to use
- **Clear organization** - Matches how designer organizes colors in Figma
- **Easy to maintain** - Smaller, focused classes

---

## Part 4: Detailed Migration Plan

### Phase 1: Preparation & Understanding (No Code Changes)

**Goal:** Ensure we fully understand ThemeExtension before making changes

**Steps:**
1. ✅ Read ThemeExtension documentation
2. ✅ Understand `copyWith()` and `lerp()` methods
3. ✅ Review Figma structure to match naming
4. ✅ Create this plan document
5. ⏳ Review plan with team/self
6. ⏳ Create test strategy

**Deliverable:** Complete understanding of ThemeExtension, approved plan

---

### Phase 2: Create ThemeExtension Classes (New Files)

**Goal:** Create new ThemeExtension classes WITHOUT removing old extensions yet

**Files to Create:**
1. `lib/design_system/tokens/colors/theme_extensions/sdeck_semantic_colors.dart` (matches Figma: "Color - Semantic")
2. `lib/design_system/tokens/colors/theme_extensions/sdeck_component_colors.dart` (matches Figma: "Color - Component-Specific")

**Structure:**
```dart
// sdeck_semantic_colors.dart
// Matches Figma Collection: "Color - Semantic"
class SDeckSemanticColors extends ThemeExtension<SDeckSemanticColors> {
  // Background & Surface
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color surfaceInverse;
  final Color onInverseSurface;
  final Color surfaceError;
  final Color surfaceSuccess;
  final Color surfaceWarning;
  final Color surfaceInfo;
  final Color surfaceLink;
  final Color surfaceNote;
  
  // Primary Colors
  final Color primary;
  final Color onPrimary;
  
  // Secondary Colors
  final Color secondary;
  final Color onSecondary;
  final Color secondaryVariant;
  
  // Tertiary Colors
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryVariant;
  
  // Error, Success, Warning, Info, Link, Note
  final Color error;
  final Color onError;
  final Color success;
  final Color warning;
  final Color info;
  final Color link;
  final Color note;
  
  // Outline & Misc
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;

  const SDeckSemanticColors({
    required this.surface,
    required this.onSurface,
    // ... all semantic properties
  });

  @override
  ThemeExtension<SDeckSemanticColors> copyWith({...}) { ... }

  @override
  ThemeExtension<SDeckSemanticColors> lerp(...) { ... }
}

// sdeck_component_colors.dart
// Matches Figma Collection: "Color - Component-Specific"
class SDeckComponentColors extends ThemeExtension<SDeckComponentColors> {
  // Button Colors
  final Color solidButtonPrimarySurface;
  final Color solidButtonPrimarySurfaceHover;
  final Color solidButtonPrimarySurfacePressed;
  final Color solidButtonSurfaceDisabled;
  final Color solidButtonIcon;
  final Color solidButtonText;
  final Color soildButtonBorder;
  // ... more button colors
  
  // Input Colors
  final Color inputSurface;
  final Color inputSurfaceDisabled;
  final Color inputSurfaceError;
  final Color inputIcon;
  final Color inputIconError;
  final Color inputIconDisabled;
  final Color inputText;
  final Color inputTextHint;
  final Color inputTextDisabled;
  final Color inputLabel;
  final Color inputSupportingText;
  final Color inputSupportingTextError;
  final Color inputSupportingTextDisabled;
  final Color inputOutline;
  final Color inputOutlineFocused;
  final Color inputOutlineDisabled;
  final Color inputOutlineError;
  // ... more input colors
  
  // Toast, Dialog, Navigation, Icon, Text colors...
  // ... all component-specific colors

  const SDeckComponentColors({
    required this.solidButtonPrimarySurface,
    required this.inputIcon,
    // ... all component properties
  });

  @override
  ThemeExtension<SDeckComponentColors> copyWith({...}) { ... }

  @override
  ThemeExtension<SDeckComponentColors> lerp(...) { ... }
}
```

**Key Points:**
- Copy ALL properties from current extensions
- Implement `copyWith()` for all properties
- Implement `lerp()` for all properties
- Use `const` constructor where possible
- Add comprehensive documentation

**Deliverable:** Two new ThemeExtension classes ready to use

---

### Phase 3: Integrate ThemeExtensions into ThemeData

**Goal:** Add ThemeExtensions to `SDeckAppTheme` without breaking existing code

**File:** `lib/design_system/themes/sdeck_app_theme.dart`

**Changes:**
```dart
static ThemeData _buildTheme(ColorScheme colorScheme) {
  return ThemeData(
    colorScheme: colorScheme,
    extensions: <ThemeExtension<dynamic>>[
      // Semantic colors - matches Figma Collection: "Color - Semantic"
      colorScheme.brightness == Brightness.light
        ? SDeckSemanticColors.light
        : SDeckSemanticColors.dark,
      // Component-specific colors - matches Figma Collection: "Color - Component-Specific"
      colorScheme.brightness == Brightness.light
        ? SDeckComponentColors.light
        : SDeckComponentColors.dark,
    ],
    // ... rest of theme
  );
}
```

**Key Points:**
- Add extensions to `ThemeData.extensions`
- Create static `light` and `dark` getters in each ThemeExtension class
- Keep existing ColorScheme extensions (for now)
- Test that both old and new access methods work

**Deliverable:** ThemeExtensions available in ThemeData (but not used yet)

---

### Phase 4: Create Helper Extension (Optional but Recommended)

**Goal:** Make ThemeExtension access easier and more readable

**File:** `lib/design_system/tokens/colors/theme_extensions/theme_extensions_helper.dart`

**Structure:**
```dart
extension SDeckThemeExtension on BuildContext {
  /// Semantic colors - Matches Figma Collection: "Color - Semantic"
  /// Use for: surface, primary, error, success, etc.
  SDeckSemanticColors get semanticColors =>
    Theme.of(this).extension<SDeckSemanticColors>()!;
  
  /// Component-specific colors - Matches Figma Collection: "Color - Component-Specific"
  /// Use for: inputIcon, solidButtonPrimarySurface, toastSurfaceError, etc.
  SDeckComponentColors get componentColors =>
    Theme.of(this).extension<SDeckComponentColors>()!;
}

// Usage becomes:
context.semanticColors.surfaceError      // from "Color - Semantic" collection
context.semanticColors.primary           // from "Color - Semantic" collection
context.componentColors.inputIcon        // from "Color - Component-Specific" collection
context.componentColors.solidButtonPrimarySurface  // from "Color - Component-Specific" collection
```

**Alternative (if you prefer explicit Theme.of):**
```dart
extension SDeckThemeExtension on ThemeData {
  /// Semantic colors - Matches Figma Collection: "Color - Semantic"
  SDeckSemanticColors get semanticColors =>
    extension<SDeckSemanticColors>()!;
  
  /// Component-specific colors - Matches Figma Collection: "Color - Component-Specific"
  SDeckComponentColors get componentColors =>
    extension<SDeckComponentColors>()!;
}

// Usage:
Theme.of(context).semanticColors.surfaceError
Theme.of(context).componentColors.inputIcon
```

**Key Points:**
- **Matches Figma Collections exactly** - Collection name = extension name
- **Self-documenting** - Look at Figma → see collection → use corresponding extension
- **Clear organization - Direct mapping to Figma structure
- Can use `!` (non-null assertion) if we guarantee extensions are always present
- Or handle null gracefully if needed

**How to Use:**
1. Look at color in Figma
2. Check which Collection it's in ("Color - Semantic" or "Color - Component-Specific")
3. Use corresponding extension in code (`semanticColors` or `componentColors`)

**Deliverable:** Helper extensions matching Figma Collections

---

### Phase 5: Incremental Migration (File by File)

**Goal:** Migrate files one at a time, testing after each

**Strategy:**
1. Start with design system components (most important)
2. Then feature pages
3. Finally test pages

**Migration Pattern for Each File:**

**Before:**
```dart
Theme.of(context).colorScheme.surfaceError
Theme.of(context).colorScheme.inputIcon
Theme.of(context).colorScheme.solidButtonPrimarySurface
```

**After:**
```dart
// Check Figma: "Background & Surface/surfaceError" → Collection: "Color - Semantic"
context.semanticColors.surfaceError

// Check Figma: "Input/inputIcon" → Collection: "Color - Component-Specific"
context.componentColors.inputIcon

// Check Figma: "Button/Solid Button/solidButtonPrimarySurface" → Collection: "Color - Component-Specific"
context.componentColors.solidButtonPrimarySurface
```

**Key Benefit:** Direct mapping to Figma Collections - developers look at Figma collection → know which extension to use!

**Process:**
1. Pick one file
2. Update all color accesses
3. Test that file
4. Commit
5. Move to next file

**Files to Migrate (Priority Order):**

**High Priority (Design System):**
1. `lib/design_system/components/inputs/sdeck_text_field.dart`
2. `lib/design_system/components/messages/sdeck_message_card.dart`
3. `lib/design_system/components/navigation/sdeck_top_navigation_bar.dart`
4. `lib/design_system/components/cards/*`
5. `lib/design_system/components/sheets/sdeck_bottom_sheet.dart`

**Medium Priority (Features):**
6. `lib/features/profile/presentation/profile_page.dart`
7. `lib/features/onboarding/shared/templates/*`
8. Other feature files

**Low Priority (Tests):**
9. `lib/test_pages/*`

**Deliverable:** All files migrated to use ThemeExtensions

---

### Phase 6: Remove Old ColorScheme Extensions

**Goal:** Clean up old extensions after migration is complete

**Files to Update:**
1. `lib/design_system/tokens/colors/color_extensions.dart` - Delete or deprecate
2. `lib/design_system/tokens/colors/colors_main_semantic.dart` - Delete or deprecate
3. `lib/design_system/tokens/colors/colors_component_specific.dart` - Delete or deprecate

**Strategy:**
- First: Mark as `@Deprecated` with migration message
- Then: Remove after confirming no usage

**Deliverable:** Old extensions removed, codebase clean

---

### Phase 7: Remove ColorScheme Entirely (Final Cleanup)

**Goal:** Remove ColorScheme completely since all colors are now in ThemeExtensions

**Rationale:**
- All custom colors are now in ThemeExtensions (matches Figma Collections)
- ColorScheme was only needed for Material widgets (BottomNavigationBar, SnackBar)
- After migrating those widgets to ThemeExtensions, ColorScheme is no longer needed
- Simplifies theme structure - single source of truth (ThemeExtensions)

**Current ColorScheme Usage Found:**
1. **BottomNavigationBar** (`lib/design_system/components/navigation/sdeck_bottom_nav_bar.dart`):
   - Line 77: `backgroundColor: Theme.of(context).colorScheme.surface`
   - Line 78: `selectedItemColor: Theme.of(context).colorScheme.primary`
   - Line 79: `unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant`

2. **Scaffold**: Does NOT require ColorScheme (only needs `scaffoldBackgroundColor`)

3. **SnackBar**: Uses ColorScheme but can be replaced with ThemeExtensions

**Steps:**

**Step 7.1: Migrate BottomNavigationBar to ThemeExtensions**
- File: `lib/design_system/components/navigation/sdeck_bottom_nav_bar.dart`
- Replace:
  - `colorScheme.surface` → `semanticColors.surface`
  - `colorScheme.primary` → `semanticColors.primary`
  - `colorScheme.onSurfaceVariant` → `semanticColors.secondaryVariant` (or appropriate semantic color)
- Ensure helper extension is available (`context.semanticColors`)

**Step 7.2: Migrate SnackBar usages to ThemeExtensions**
- Search for all `SnackBar` usages
- Replace ColorScheme references with ThemeExtensions
- Files to check:
  - `lib/features/onboarding/sign_up/presentation/pages/sign_up_redirecting.dart`
  - `lib/features/home/presentation/pages/home.dart`
  - `lib/features/onboarding/shared/services/google_auth_service.dart`
  - `lib/features/onboarding/profile/presentation/pages/adjust_profile_page.dart`

**Step 7.3: Update Theme Building Method**
- File: `lib/design_system/themes/sdeck_app_theme.dart`
- Remove `ColorScheme` parameter from `_buildTheme()`
- Remove `colorScheme:` from `ThemeData` constructor
- Update `scaffoldBackgroundColor` to use `semanticColors.surface` instead of `colorScheme.surface`
- Determine brightness from ThemeExtension instead of ColorScheme
- Update `SDeckAppTheme.light` and `SDeckAppTheme.dark` to not require ColorScheme

**Step 7.4: Remove ColorScheme File**
- File: `lib/design_system/tokens/colors/color_schemes.dart`
- Delete entire file (no longer needed)
- Update `lib/design_system/tokens/colors/index.dart` to remove export

**Step 7.5: Verify No ColorScheme Dependencies**
- Search codebase for any remaining `colorScheme.` usages
- Ensure all Material widgets that needed ColorScheme have been migrated
- Test theme switching still works

**Deliverable:** 
- ColorScheme completely removed
- All colors accessed via ThemeExtensions only
- Cleaner, simpler theme structure
- Single source of truth (ThemeExtensions matching Figma Collections)

**Note:** This phase should be done AFTER Phase 5 (migrating all components) and Phase 6 (removing old extensions) are complete.

---

## Part 5: Impact Analysis

### Code Changes Required

**New Files:**
- `lib/design_system/tokens/colors/theme_extensions/sdeck_semantic_colors.dart` (matches Figma: "Color - Semantic")
- `lib/design_system/tokens/colors/theme_extensions/sdeck_component_colors.dart` (matches Figma: "Color - Component-Specific")
- `lib/design_system/tokens/colors/theme_extensions/theme_extensions_helper.dart` (optional helper)

**Modified Files:**
- `lib/design_system/themes/sdeck_app_theme.dart` (add extensions)
- **33 files** with color usages (update access pattern)

**Deleted Files:**
- `lib/design_system/tokens/colors/color_extensions.dart` (after migration)
- `lib/design_system/tokens/colors/colors_main_semantic.dart` (after migration)
- `lib/design_system/tokens/colors/colors_component_specific.dart` (after migration)

### Breaking Changes

**Access Pattern Change:**
- **Before:** `Theme.of(context).colorScheme.surfaceError`
- **After:** 
  - Semantic colors: `context.semanticColors.surfaceError` (matches Figma: "Color - Semantic")
  - Component colors: `context.componentColors.inputIcon` (matches Figma: "Color - Component-Specific")
- **Benefit:** Direct mapping to Figma Collections - look at Figma → see collection → use corresponding extension!

**Impact:** All 118 usages need updating

### Non-Breaking Aspects

- ✅ Color values stay the same
- ✅ Light/dark mode behavior stays the same
- ✅ Component behavior stays the same
- ✅ Only access pattern changes

### Testing Strategy

**Unit Tests:**
- Test `copyWith()` for all properties
- Test `lerp()` interpolation
- Test light/dark theme creation

**Integration Tests:**
- Test theme switching (should be smooth now!)
- Test all components still render correctly
- Test all color usages work

**Visual Regression:**
- Compare before/after screenshots
- Ensure no visual changes (except smooth transitions)

---

## Part 6: Risk Mitigation

### Risk 1: Large Codebase Change

**Mitigation:**
- ✅ Incremental migration (file by file)
- ✅ Keep old extensions during migration
- ✅ Test after each file
- ✅ Can rollback individual files if needed

### Risk 2: Missing Colors

**Mitigation:**
- ✅ Comprehensive list of all colors before starting
- ✅ Copy all properties from extensions
- ✅ Test that all colors are accessible

### Risk 3: Breaking Existing Code

**Mitigation:**
- ✅ Keep old extensions until migration complete
- ✅ Can use both old and new during transition
- ✅ Gradual migration reduces risk

### Risk 4: Performance Impact

**Mitigation:**
- ✅ ThemeExtension is Flutter's recommended approach
- ✅ No performance concerns (actually better for transitions)
- ✅ Test performance if concerned

### Risk 5: Team Understanding

**Mitigation:**
- ✅ Comprehensive documentation
- ✅ Helper extensions for easier access
- ✅ Code examples in plan
- ✅ Training/documentation for team

---

## Part 7: Rollback Strategy

### If Migration Fails

**Option 1: Partial Rollback**
- Keep migrated files
- Revert ThemeExtension classes
- Keep using ColorScheme extensions

**Option 2: Full Rollback**
- Revert all changes
- Keep using ColorScheme extensions
- Plan new approach

**Option 3: Hybrid Approach**
- Keep ThemeExtensions for new code
- Keep ColorScheme extensions for old code
- Migrate gradually over time

---

## Part 8: Success Criteria

### Migration is Successful When:

1. ✅ All ThemeExtension classes created and tested
2. ✅ All 33 files migrated to new access pattern
3. ✅ All components render correctly
4. ✅ Theme switching is smooth (animated)
5. ✅ No visual regressions
6. ✅ Old extensions removed
7. ✅ Codebase is cleaner and more maintainable
8. ✅ Team understands new pattern

---

## Part 9: Timeline Estimate

**Phase 1 (Preparation):** 1-2 days
- Understanding ThemeExtension
- Reviewing plan
- Creating test strategy

**Phase 2 (Create Classes):** 2-3 days
- Creating ThemeExtension classes
- Implementing copyWith() and lerp()
- Testing classes

**Phase 3 (Integrate):** 1 day
- Adding to ThemeData
- Testing integration

**Phase 4 (Helper Extension):** 0.5 days
- Creating helper
- Testing helper

**Phase 5 (Migration):** 5-10 days
- Migrating 33 files
- Testing each file
- Fixing issues

**Phase 6 (Cleanup):** 1 day
- Removing old extensions
- Final testing

**Total Estimate:** 10-18 days (depending on complexity and testing)

---

## Part 10: Questions to Answer Before Starting

1. **Do we want helper extensions?** (Recommended: Yes)
2. **Single or multiple ThemeExtensions?** (Recommended: Multiple - matches Figma)
3. **Migration strategy?** (Recommended: Incremental, file by file)
4. **How to handle null safety?** (Use `!` if guaranteed, or handle null)
5. **Testing approach?** (Unit tests + integration tests + visual regression)
6. **Rollback plan?** (Keep old extensions until complete)

---

## Next Steps

1. **Review this plan** - Make sure you understand everything
2. **Answer the questions** in Part 10
3. **Approve the approach** - Confirm you want to proceed
4. **Start Phase 1** - Preparation and understanding
5. **Begin implementation** - One phase at a time

---

## Appendix: Code Examples

### Example 1: Creating Collection-Based ThemeExtensions

```dart
// sdeck_semantic_colors.dart
// Matches Figma Collection: "Color - Semantic"
class SDeckSemanticColors extends ThemeExtension<SDeckSemanticColors> {
  final Color surface;
  final Color surfaceError;
  final Color primary;

  const SDeckSemanticColors({
    required this.surface,
    required this.surfaceError,
    required this.primary,
  });

  // Light theme factory
  static const light = SDeckSemanticColors(
    surface: Color(0xFFFDFBF5), // warmOffWhite
    surfaceError: Color(0xFFFFE3E0), // brightCoralLightest
    primary: Color(0xFF1F1F1F), // coolGrayDarkest
  );

  // Dark theme factory
  static const dark = SDeckSemanticColors(
    surface: Color(0xFF0C1118), // slateGray
    surfaceError: Color(0xFF470600), // brightCoralDarkest
    primary: Color(0xFFEBEBEB), // coolGrayLightest
  );

  @override
  ThemeExtension<SDeckSemanticColors> copyWith({
    Color? surface,
    Color? surfaceError,
    Color? primary,
  }) {
    return SDeckSemanticColors(
      surface: surface ?? this.surface,
      surfaceError: surfaceError ?? this.surfaceError,
      primary: primary ?? this.primary,
    );
  }

  @override
  ThemeExtension<SDeckSemanticColors> lerp(
    ThemeExtension<SDeckSemanticColors>? other,
    double t,
  ) {
    if (other is! SDeckSemanticColors) return this;

    return SDeckSemanticColors(
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceError: Color.lerp(surfaceError, other.surfaceError, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
    );
  }
}

// sdeck_component_colors.dart
// Matches Figma Collection: "Color - Component-Specific"
class SDeckComponentColors extends ThemeExtension<SDeckComponentColors> {
  final Color inputIcon;
  final Color inputIconError;
  final Color solidButtonPrimarySurface;

  const SDeckComponentColors({
    required this.inputIcon,
    required this.inputIconError,
    required this.solidButtonPrimarySurface,
  });

  // Light theme factory
  static const light = SDeckComponentColors(
    inputIcon: Color(0xFF1F1F1F), // primary
    inputIconError: Color(0xFFFE6F61), // error
    solidButtonPrimarySurface: Color(0xFF1F1F1F), // primary
  );

  // Dark theme factory
  static const dark = SDeckComponentColors(
    inputIcon: Color(0xFFEBEBEB), // primary
    inputIconError: Color(0xFFFE6F61), // error
    solidButtonPrimarySurface: Color(0xFFEBEBEB), // primary
  );

  @override
  ThemeExtension<SDeckComponentColors> copyWith({
    Color? inputIcon,
    Color? inputIconError,
    Color? solidButtonPrimarySurface,
  }) {
    return SDeckComponentColors(
      inputIcon: inputIcon ?? this.inputIcon,
      inputIconError: inputIconError ?? this.inputIconError,
      solidButtonPrimarySurface: solidButtonPrimarySurface ?? this.solidButtonPrimarySurface,
    );
  }

  @override
  ThemeExtension<SDeckComponentColors> lerp(
    ThemeExtension<SDeckComponentColors>? other,
    double t,
  ) {
    if (other is! SDeckComponentColors) return this;

    return SDeckComponentColors(
      inputIcon: Color.lerp(inputIcon, other.inputIcon, t)!,
      inputIconError: Color.lerp(inputIconError, other.inputIconError, t)!,
      solidButtonPrimarySurface: Color.lerp(solidButtonPrimarySurface, other.solidButtonPrimarySurface, t)!,
    );
  }
}
```

### Example 2: Using Collection-Based ThemeExtensions

```dart
// Before (ColorScheme extension):
Container(
  color: Theme.of(context).colorScheme.surfaceError,
)
Icon(color: Theme.of(context).colorScheme.inputIcon)

// After (Collection-Based ThemeExtension):
// Step 1: Check Figma - "Background & Surface/surfaceError" → Collection: "Color - Semantic"
Container(
  color: context.semanticColors.surfaceError, // from "Color - Semantic" collection
)

// Step 2: Check Figma - "Input/inputIcon" → Collection: "Color - Component-Specific"
Icon(color: context.componentColors.inputIcon) // from "Color - Component-Specific" collection

// OR without helper:
Container(
  color: Theme.of(context).extension<SDeckSemanticColors>()!.surfaceError,
)
Icon(color: Theme.of(context).extension<SDeckComponentColors>()!.inputIcon)
```

### Example 3: How to Find the Right Extension

**Workflow:**
1. Look at color in Figma (e.g., "Input/inputIcon")
2. Check the Collection field: "Color - Component-Specific"
3. Use `componentColors` extension in code
4. Access the color: `context.componentColors.inputIcon`

**Another Example:**
1. Look at color in Figma (e.g., "Background & Surface/surfaceError")
2. Check the Collection field: "Color - Semantic"
3. Use `semanticColors` extension in code
4. Access the color: `context.semanticColors.surfaceError`

### Example 3: Theme Switching Animation

```dart
// This will now be smooth because of lerp()!
AnimatedTheme(
  data: isDark ? SDeckAppTheme.dark : SDeckAppTheme.light,
  duration: Duration(milliseconds: 300),
  child: YourWidget(),
)
```

---

**End of Plan**

