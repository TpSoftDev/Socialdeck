# Color Palette Figma Exact Match Plan (Option 1)

## Goal
Make code an **exact match** of Figma - same order, same names, no extra properties. Figma is the single source of truth.

## Strategy: Option 1 - Remove Container Properties
- Remove all Container properties (not in Figma)
- Remove all extra properties not in Figma
- Match Figma order exactly
- Match Figma names exactly

---

## Phase 0: Remove Non-Figma Properties

### Phase 0.1: Remove Container Properties from Main Semantic
**Remove from `colors_main_semantic.dart`:**
- `primaryContainer()` and `onPrimaryContainer()`
- `secondaryContainer()` and `onSecondaryContainer()`
- `tertiaryContainer()` and `onTertiaryContainer()`
- `errorContainer()` and `onErrorContainer()`
- `successContainer()` and `onSuccessContainer()`

**Reason:** These don't exist in Figma Main Semantic Color Palette.

### Phase 0.2: Fix Error and Success Colors
**Fix in `colors_main_semantic.dart`:**
- `error()`: Change from `brightCoralLightest/brightCoralDarkest` → `brightCoral` (both modes)
- `success()`: Change from `mintGreenLightest/mintGreenDarkest` → `mintGreen` (both modes)

**Reason:** Figma shows `error` = `brightCoral`, `success` = `mintGreen` (not Lightest/Darkest variants).

### Phase 0.3: Remove Container Properties from ColorScheme
**Remove from `color_schemes.dart` (both light and dark):**
- `primaryContainer:` and `onPrimaryContainer:`
- `secondaryContainer:` and `onSecondaryContainer:`
- `tertiaryContainer:` and `onTertiaryContainer:`
- `errorContainer:` and `onErrorContainer:`

**Reason:** Not in Figma, Flutter will use defaults.

### Phase 0.4: Remove Extra Properties from ColorScheme
**Remove from `color_schemes.dart` (both light and dark):**
- `primaryFixed:`, `primaryFixedDim:`, `onPrimaryFixed:`, `onPrimaryFixedVariant:`
- `secondaryFixed:`, `secondaryFixedDim:`, `onSecondaryFixed:`, `onSecondaryFixedVariant:`
- `tertiaryFixed:`, `tertiaryFixedDim:`, `onTertiaryFixed:`, `onTertiaryFixedVariant:`
- `surfaceDim:`, `surfaceBright:`
- `surfaceContainerLowest:`, `surfaceContainerLow:`, `surfaceContainer:`, `surfaceContainerHigh:`, `surfaceContainerHighest:`
- `inversePrimary:`, `surfaceTint:`

**Reason:** These don't exist in Figma Main Semantic Color Palette.

### Phase 0.5: Fix inverseSurface in ColorScheme
**Fix in `color_schemes.dart`:**
- Change `inverseSurface:` → use `SDeckMainSemanticColors.surfaceInverse()` (not `inverseSurface()`)

**Reason:** Figma uses `surfaceInverse`, not `inverseSurface`.

### Phase 0.6: Fix shadow and scrim in ColorScheme
**Fix in `color_schemes.dart`:**
- Change `shadow:` → use `SDeckMainSemanticColors.shadow()` (not brand color directly)
- Change `scrim:` → use `SDeckMainSemanticColors.scrim()` (not brand color directly)

**Reason:** Should use Main Semantic methods, not brand colors directly.

### Phase 0.7: Fix outline colors in ColorScheme
**Fix in `color_schemes.dart`:**
- Verify `outline:` uses `SDeckMainSemanticColors.outline()` with correct opacity (#F0F0F0 @ 20% light, #F5F5F5 @ 20% dark)
- Verify `outlineVariant:` uses `SDeckMainSemanticColors.outlineVariant()` with correct opacity (#F5F5F5 @ 20% light, #1F1F1F @ 20% dark)

**Reason:** Match Figma opacity values exactly.

### Phase 0.8: Convert Main Semantic to Extension Architecture
**Architectural Change:**

**Problem:** Currently Main Semantic is a static class, so developers can't call `colorScheme.surfaceError`. They'd need `SDeckMainSemanticColors.surfaceError(brightness)`, which doesn't match Figma naming.

**Solution:** Convert Main Semantic to an extension (like Component-Specific) so developers can call `colorScheme.surfaceError` (matches Figma).

**Changes:**

1. **Convert `colors_main_semantic.dart` from class → extension:**
   - Change `class SDeckMainSemanticColors` → `extension SDeckMainSemanticColors on ColorScheme`
   - Change all `static Color methodName(Brightness brightness)` → `Color get methodName`
   - Use `brightness` property from `ColorScheme` instead of parameter
   - Example: `static Color surface(Brightness brightness)` → `Color get surface => brightness == Brightness.light ? SDeckBrandColors.warmOffWhite(brightness) : SDeckBrandColors.slateGray(brightness);`

2. **Update `color_schemes.dart` to build ColorScheme using Brand colors directly:**
   - Replace `SDeckMainSemanticColors.primary(Brightness.light)` → `SDeckBrandColors.coolGrayDarkest(Brightness.light)` (for light mode)
   - Replace `SDeckMainSemanticColors.primary(Brightness.dark)` → `SDeckBrandColors.coolGrayLightest(Brightness.dark)` (for dark mode)
   - Apply same pattern for all ColorScheme properties (primary, secondary, tertiary, error, surface, etc.)
   - Use the same Brand color mappings that Main Semantic currently uses (duplicate the logic)

3. **Update `colors_component_specific.dart` to use Main Semantic extension:**
   - Replace `SDeckMainSemanticColors.primary(brightness)` → `primary` (using extension)
   - Replace `SDeckMainSemanticColors.surface(brightness)` → `surface` (using extension)
   - Apply same pattern for all Main Semantic references

**Result:**
- Developers call: `colorScheme.surfaceError` ✅ (matches Figma)
- Developers call: `colorScheme.solidButtonPrimarySurface` ✅ (matches Figma)
- Developers call: `colorScheme.primary` ✅ (built-in Flutter)
- All through ColorScheme - single access point ✅

**Reason:** Matches Component-Specific architecture, allows developers to use Figma names directly via ColorScheme.

---

## Phase 1: Reorder Main Semantic to Match Figma

**Figma Order (exact):**
1. **Background & Surface**: surface, onSurface, surfaceVariant, onSurfaceVariant, surfaceInverse, onInverseSurface, surfaceError, surfaceSuccess, surfaceWarning, surfaceInfo, surfaceLink, surfaceNote
2. **Primary Colors**: primary, onPrimary
3. **Secondary Colors**: secondary, secondaryVariant
4. **Tertiary Colors**: tertiary, tertiaryVariant
5. **Outline & Misc**: outline, outlineVariant, shadow, scrim
6. **Error Colors**: error, onError
7. **Success Colors**: success
8. **Warning Colors**: warning
9. **Information Colors**: info
10. **Link Colors**: link
11. **Note Colors**: note

**Action:** Reorder `colors_main_semantic.dart` to match this exact order.

---

## Phase 2: Reorder Component-Specific to Match Figma

**Figma Order (exact):**
1. **Solid Button**: solidButtonPrimarySurface, solidButtonPrimarySurfaceHover, solidButtonPrimarySurfacePressed, solidButtonSurfaceDisabled, solidButtonIcon, solidButtonText, solidButtonBorder
2. **Outline Button**: outlineButtonPrimarySurface, outlineButtonIcon, outlineButtonIconDisabled, outlineButtonText, outlineButtonTextDisabled, outlineButtonBorder, outlineButtonBorderHover, outlineButtonBorderPressed, outlineButtonBorderDisabled
3. **Text Button**: textButtonIcon, textButtonIconHover, textButtonIconPressed, textButtonIconDisabled, textButtonText, textButtonTextHover, textButtonTextPressed, textButtonTextDisabled
4. **Dialog**: dialogSurface, dialogIcon, dialogText, dialogTitle, dialogOutline
5. **Navigation**: navPrimarySurface, navIcon, navText
6. **Icon (Standalone)**: iconPrimary, iconSecondary, iconTertiary, iconDisabled, iconError
7. **Text (Standalone)**: textPrimary, textSecondary, textTertiary, textDisabled, textError, textLink
8. **Toast**: toastSurfaceError, toastSurfaceSuccess, toastSurfaceWarning, toastSurfaceInfo, toastSurfaceLink, toastSurfaceNote, toastIconError, toastIconSuccess, toastIconWarning, toastIconInfo, toastIconLink, toastIconNote, toastTextError, toastTextSuccess, toastTextWarning, toastTextInfo, toastTextLink, toastTextNote
9. **Input**: inputSurface, inputSurfaceDisabled, inputSurfaceError, inputIcon, inputIconError, inputIconDisabled, inputText, inputTextHint, inputTextDisabled, inputLabel, inputSupportingText, inputSupportingTextError, inputSupportingTextDisabled, inputOutline, inputOutlineFocused, inputOutlineDisabled, inputOutlineError

**Action:** Reorder `colors_component_specific.dart` to match this exact order. Add missing components (Dialog, Navigation, Icon, Text, Toast).

---

## Phase 3: Fix Component-Specific Mappings

**Fix in `colors_component_specific.dart`:**
- Keep brand color references where Figma explicitly references brand colors (e.g., `coolGrayDark`, `coolGray`, `skyBlue`)
- Ensure all mappings match Figma "Referenced Semantic" column exactly
- Add missing components: Dialog, Navigation, Icon (Standalone), Text (Standalone), Toast

**Reason:** Match Figma references exactly - some reference semantic, some reference brand.

---

## Phase 4: Fix Components Using errorContainer

**Files to update:**
- `lib/design_system/components/messages/sdeck_message_card.dart` (line 58)
- `lib/design_system/components/inputs/sdeck_text_field.dart` (line 223)

**Action:** 
- Replace `colorScheme.errorContainer` → `colorScheme.surfaceError` (via extension)
- Replace `colorScheme.onErrorContainer` → use appropriate semantic color
- Replace `colorScheme.successContainer` → `colorScheme.surfaceSuccess` (via extension)

**Reason:** `errorContainer` doesn't exist in Figma, use `surfaceError` instead.

---

## Phase 5: Final Verification

**Checklist:**
- [ ] Main Semantic matches Figma order exactly
- [ ] Main Semantic has no Container properties
- [ ] Main Semantic Error = brightCoral (not Lightest/Darkest)
- [ ] Main Semantic Success = mintGreen (not Lightest/Darkest)
- [ ] Component-Specific matches Figma order exactly
- [ ] Component-Specific has all components from Figma
- [ ] Component-Specific mappings match Figma references
- [ ] ColorScheme only has properties that exist in Figma
- [ ] ColorScheme has no Container properties
- [ ] ColorScheme has no Fixed properties
- [ ] ColorScheme has no extra surfaceContainer* properties
- [ ] All components updated to use Figma names (surfaceError, not errorContainer)
- [ ] Code compiles without errors
- [ ] No linter errors

---

## Implementation Approach
- **Slow and steady**: One phase at a time
- **Review between steps**: User reviews each change before proceeding
- **Small changes**: Don't change everything at once
- **Exact match**: Order, names, everything matches Figma

