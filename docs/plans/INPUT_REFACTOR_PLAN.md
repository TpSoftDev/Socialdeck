# Input Component Refactor Plan - Socialdeck

## Overview
This plan outlines the step-by-step refactor of the Input component (`SDeckTextField` → `SDeckInput`) to match Figma's design system exactly. The refactor includes integrated Label and Supporting Text, **provider-managed state** (single source of truth), updated visual specifications, and icon system updates.

## Architecture Decision: Provider-Managed State
**Key Principle**: Design system components are "blind" - they display what providers tell them. All business logic and state management lives in providers.

- **Component**: `StatelessWidget` - displays state, no internal logic
- **Provider**: Manages all state (hint, focused, filled, error, disabled)
- **Focus Detection**: Provider uses `FocusNode` to detect keyboard focus
- **State Calculation**: Provider automatically calculates hint → focused → filled
- **Single Source of Truth**: Provider is the only place that manages state

## Project Rules (Remember)
1. Teaching in baby steps - break into small, clear steps
2. No automatic execution - always wait for explicit approval
3. No coding without approval - propose ideas first
4. Brainstorm before presenting approaches
5. Plan before implementation - get approval first
6. Slow, guided implementation - explain and review
7. Respect user's role as engineer
8. Always read documentation first

---

## Phase 1: Enum Updates

### Step 1.1: Create New Enums
**Goal**: Create new enum definitions matching Figma

**Actions**:
- Create new file: `lib/design_system/components/inputs/input_enums.dart`
- Define `SDeckInputState` enum:
  - Values: `hint`, `focused`, `filled`, `disabled`, `error`
  - Remove `success` (not in Figma)
  - Add `focused` (automatic state)
  - Add `disabled` (manual override)
- Define `SDeckInputSize` enum:
  - Values: `medium`, `large`
  - Remove `small` (not in Figma)

**Verification**: New enum file exists with correct values

---

### Step 1.2: Update Component Export
**Goal**: Export new enums from components index

**Actions**:
- Update `lib/design_system/components/index.dart`
- Export `inputs/input_enums.dart`

**Verification**: Enums accessible via `import 'package:socialdeck/design_system/index.dart'`

---

## Phase 2: Component Refactor

### Step 2.1: Create New Component File
**Goal**: Create new `SDeckInput` component file

**Actions**:
- Create new file: `lib/design_system/components/inputs/sdeck_input.dart`
- Copy structure from `sdeck_text_field.dart` as starting point
- Update file header comments

**Verification**: New file exists with basic structure

---

### Step 2.2: Update Component Class Definition
**Goal**: Rename class and keep as StatelessWidget (component is "blind")

**Actions**:
- Rename class: `SDeckTextField` → `SDeckInput`
- **Keep as `StatelessWidget`** (component displays what provider tells it)
- Add `focusNode: FocusNode?` property (provider provides this)
- Component receives state from provider (no internal state management)

**Verification**: Component is StatelessWidget, receives state from provider

---

### Step 2.3: Update Component Properties
**Goal**: Add new properties matching Figma

**Actions**:
- Add `label: String?` property (optional)
- Add `supportingText: String?` property (optional)
- Add `iconLeft: Widget?` property (optional)
- Add `iconRight: Widget?` property (optional)
- Update `size` property type: `SDeckTextFieldSize` → `SDeckInputSize`
- Update `state` property type: `SDeckTextFieldState` → `SDeckInputState` (required - provider always provides state)
- Add `focusNode: FocusNode?` property (provider provides FocusNode for focus detection)
- Keep existing properties: `placeholder`, `controller`, `onChanged`, `obscureText`, `keyboardType`, `readOnly`, etc.

**Verification**: All properties defined correctly

---

### Step 2.4: Update Constructor
**Goal**: Replace named constructors with single parameterized constructor

**Actions**:
- Remove all named constructors (`.small()`, `.medium()`, `.large()`)
- Create single constructor with defaults:
  ```dart
  const SDeckInput({
    super.key,
    required this.state,  // Required - provider always provides state
    this.size = SDeckInputSize.medium,
    this.focusNode,  // Provider provides FocusNode
    this.label,
    this.supportingText,
    this.iconLeft,
    this.iconRight,
    this.placeholder,
    this.controller,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType,
    this.readOnly = false,
    // ... other properties
  });
  ```

**Verification**: Single constructor works, named constructors removed

---

### Step 2.5: Update TextField to Use Provider's FocusNode
**Goal**: Connect TextField to provider's FocusNode

**Actions**:
- In `_buildInputField()`, use `widget.focusNode` for TextField's `focusNode` property
- Component doesn't manage FocusNode - just uses what provider provides
- TextField will trigger focus changes that provider listens to

**Verification**: TextField uses provider's FocusNode correctly

---

### Step 2.6: Update Visual Specifications
**Goal**: Match Figma visual specs exactly

**Actions**:
- Update border width: 3px → 4px
- Refactor container structure: nested → single container
- Update Medium padding: 12px horizontal → 16px horizontal (keep 12px vertical)
- Keep Large padding: 16px all around
- Update border radius: verify 8px (should already be correct)
- Update all color references to use component-specific colors

**Verification**: Visual appearance matches Figma

---

### Step 2.7: Implement Label Rendering
**Goal**: Add integrated label above input

**Actions**:
- Create `_buildLabel()` method
- Render label if `label != null`
- Typography: 14px Caption (18px line height)
- Color: `context.component.inputLabel`
- Padding: 8px horizontal (from Figma)
- Add 4px gap between label and input

**Verification**: Label displays correctly when provided

---

### Step 2.8: Implement Supporting Text Rendering
**Goal**: Add integrated supporting text below input

**Actions**:
- Create `_buildSupportingText()` method
- Render supporting text if `supportingText != null`
- Typography: 12px Label Small (16px line height)
- Color logic:
  - Normal: `context.component.inputSupportingText`
  - Error: `context.component.inputSupportingTextError` (when `state == error`)
  - Disabled: `context.component.inputSupportingTextDisabled` (when `state == disabled`)
- Padding: 8px horizontal (from Figma)
- Add 4px gap between input and supporting text

**Verification**: Supporting text displays correctly with proper colors

---

### Step 2.9: Update Icon System
**Goal**: Add left/right icon support and update password toggle

**Actions**:
- Update password toggle to use Figma icons:
  - When `obscureText = true`: `SDeckIcon.medium(SDeckIcons.closedEye)`
  - When `obscureText = false`: `SDeckIcon.medium(SDeckIcons.eye)`
- Icon size: 24px (from Figma)
- Icon color: `context.component.inputIcon`
- Add left icon rendering (if `iconLeft != null`)
- Add right icon rendering (if `iconRight != null` or password toggle)
- Icon gap: 4px between icon and text (from Figma)

**Verification**: Icons display correctly, password toggle uses Figma icons

---

### Step 2.10: Update Container Structure
**Goal**: Refactor from nested to single container

**Actions**:
- Remove outer container with border
- Remove inner container with background
- Create single container with:
  - Border: 4px width
  - Border color: based on state
  - Background color: based on state
  - Border radius: 8px
- Update TextField decoration to work with single container

**Verification**: Single container structure matches Figma

---

### Step 2.11: Update State Color Logic
**Goal**: Update color methods to use new enum and component colors

**Actions**:
- Update `_getBorderColor()` method:
  - `hint`: `context.component.inputBorder`
  - `focused`: `context.component.inputBorderFocused`
  - `filled`: `context.component.inputBorder`
  - `disabled`: `context.component.inputBorderDisabled`
  - `error`: `context.component.inputBorderError`
- Update `_getBackgroundColor()` method:
  - `error`: `context.component.inputSurfaceError`
  - `disabled`: `context.component.inputSurfaceDisabled`
  - Default: `context.component.inputSurface`
- Update `_getTextColor()` method:
  - `hint`: `context.component.inputTextHint`
  - `disabled`: `context.component.inputTextDisabled`
  - Default: `context.component.inputText`

**Verification**: Colors match Figma for all states

---

### Step 2.12: Update Typography
**Goal**: Verify and update text styles to match Figma

**Actions**:
- Verify Label uses: `textTheme.caption` (14px, 18px line height)
- Verify Input uses: `textTheme.bodyLarge` (20px, 24px line height)
- Verify Supporting Text uses: `textTheme.labelSmall` (12px, 16px line height)
- Update if needed to match exactly

**Verification**: All typography matches Figma specifications

---

### Step 2.13: Build Complete Component Structure
**Goal**: Assemble all pieces into final component

**Actions**:
- Build method structure:
  ```dart
  Column(
    children: [
      if (label != null) _buildLabel(),
      _buildInputField(),
      if (supportingText != null) _buildSupportingText(),
    ],
  )
  ```
- Ensure 4px gaps between all elements
- Test all combinations of properties

**Verification**: Complete component renders correctly

---

## Phase 3: Update Form Providers (Add Focus Detection & State Management)

### Step 3.1: Update Login Form Provider
**Goal**: Add FocusNode and automatic state calculation

**Actions**:
- Open `lib/features/login/providers/login_form_provider.dart`
- Add `FocusNode` properties:
  ```dart
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  ```
- Add focus listeners in constructor:
  ```dart
  LoginFormProvider() {
    usernameFocusNode.addListener(_handleUsernameFocusChange);
    passwordFocusNode.addListener(_handlePasswordFocusChange);
  }
  ```
- Implement focus change handlers:
  ```dart
  void _handleUsernameFocusChange() {
    _updateUsernameFieldState();
  }
  ```
- Update `updateUsernameOrEmail()` to call state calculation:
  ```dart
  void updateUsernameOrEmail(String value) {
    state = state.copyWith(usernameOrEmail: value);
    _updateUsernameFieldState();  // Auto-calculate state
  }
  ```
- Implement automatic state calculation:
  ```dart
  void _updateUsernameFieldState() {
    final isFilled = state.usernameOrEmail.isNotEmpty;
    final isFocused = usernameFocusNode.hasFocus;
    
    final newState = isFocused
      ? SDeckInputState.focused
      : (isFilled ? SDeckInputState.filled : SDeckInputState.hint);
    
    state = state.copyWith(
      usernameFieldState: newState,
      isNextEnabled: isFilled,
    );
  }
  ```
- Dispose FocusNodes in provider dispose (if needed, or handle in widget)
- Update enum references: `SDeckTextFieldState` → `SDeckInputState`

**Verification**: Provider automatically calculates hint/focused/filled states

---

### Step 3.2: Update Sign Up Form Provider
**Goal**: Add FocusNode and automatic state calculation

**Actions**:
- Open `lib/features/onboarding/sign_up/providers/sign_up_form_provider.dart`
- Add `FocusNode` properties for email, password, confirmPassword fields
- Add focus listeners in constructor
- Implement automatic state calculation methods (same pattern as login)
- Update enum references: `SDeckTextFieldState` → `SDeckInputState`

**Verification**: Provider automatically calculates states for all fields

---

### Step 3.3: Update Profile Form Provider
**Goal**: Add FocusNode and automatic state calculation

**Actions**:
- Open `lib/features/onboarding/profile/providers/profile_form_provider.dart` (if exists)
- Add `FocusNode` for username field
- Add focus listeners and automatic state calculation
- Update enum references: `SDeckTextFieldState` → `SDeckInputState`

**Verification**: Provider automatically calculates state

---

### Step 3.4: Update Validation Providers (Keep Error State Management)
**Goal**: Validation providers only set error state, form providers handle hint/focused/filled

**Actions**:
- Open `lib/features/login/providers/login_validation_provider.dart`
- Keep all `error` state assignments (this is correct - validation sets errors)
- Remove any `hint` or `filled` state assignments (form provider handles these)
- Update enum references: `SDeckTextFieldState` → `SDeckInputState`
- Repeat for `sign_up_validation_provider.dart` and `profile_validation_provider.dart`

**Verification**: Validation providers only set error state, form providers handle normal states

---

## Phase 4: Update Validation State Classes

### Step 4.1: Update Login Validation State
**Goal**: Update enum references

**Actions**:
- Open `lib/features/login/domain/login_validation_state.dart`
- Update property types: `SDeckTextFieldState` → `SDeckInputState`
- Update default values to `SDeckInputState.hint`
- Remove any `success` state references

**Verification**: State class uses new enum

---

### Step 4.2: Update Sign Up Validation State
**Goal**: Update enum references

**Actions**:
- Open `lib/features/sign_up/domain/sign_up_validation_state.dart`
- Update property types: `SDeckTextFieldState` → `SDeckInputState`
- Update default values
- Remove any `success` state references

**Verification**: State class uses new enum

---

### Step 4.3: Update Profile Validation State
**Goal**: Update enum references

**Actions**:
- Open `lib/features/onboarding/profile/domain/profile_validation_state.dart`
- Update property types: `SDeckTextFieldState` → `SDeckInputState`
- Update default values
- Remove any `success` state references

**Verification**: State class uses new enum

---

## Phase 5: Update UI Templates

### Step 5.1: Update Onboarding Input Template
**Goal**: Use integrated label and supporting text, pass FocusNode from provider

**Actions**:
- Open `lib/features/onboarding/shared/templates/onboarding_input_template.dart`
- Remove separate `Text` widget for `fieldLabel` (lines ~172-177)
- Remove `SDeckMessageCard` usage (lines ~191-206)
- Update component usage:
  - Change `SDeckTextField.large()` → `SDeckInput(size: SDeckInputSize.large)`
  - Add `label: fieldLabel` parameter
  - Add `supportingText: errorMessage ?? noteMessage` parameter
  - Add `state: fieldState` parameter (from provider)
  - Add `focusNode: ref.read(loginFormProvider.notifier).usernameFocusNode` (pass provider's FocusNode)
- Update enum references: `SDeckTextFieldState` → `SDeckInputState`

**Verification**: Template uses integrated label/supporting text, passes provider's FocusNode

---

### Step 5.2: Update Onboarding Login Template
**Goal**: Use integrated label and supporting text

**Actions**:
- Open `lib/features/onboarding/shared/templates/onboarding_login_template.dart`
- Remove separate `Text` widget for password label
- Remove `SDeckMessageCard` usage
- Update component usage to use `label` and `supportingText` properties
- Update enum references

**Verification**: Template uses integrated components

---

### Step 5.3: Update All Other Input Usages
**Goal**: Update remaining files that use SDeckTextField

**Actions**:
- Search for all `SDeckTextField` usages
- Update each file:
  - Change `SDeckTextField` → `SDeckInput`
  - Update named constructors to use `size` parameter
  - Update enum references
  - Add `label` and `supportingText` where appropriate

**Files to check:**
- `lib/features/onboarding/sign_up/presentation/pages/sign_up_confirm_password.dart`
- `lib/features/onboarding/profile/presentation/pages/profile_username.dart`
- Any other files using `SDeckTextField`

**Verification**: All usages updated

---

## Phase 6: Update Component Export

### Step 6.1: Update Components Index
**Goal**: Export new component instead of old

**Actions**:
- Open `lib/design_system/components/index.dart`
- Update export: `inputs/sdeck_text_field.dart` → `inputs/sdeck_input.dart`
- Verify `input_enums.dart` is exported

**Verification**: New component exported correctly

---

## Phase 7: Cleanup

### Step 7.1: Remove Old Component File
**Goal**: Delete old component file

**Actions**:
- Delete `lib/design_system/components/inputs/sdeck_text_field.dart`
- Verify no references remain (search codebase)

**Verification**: Old file deleted, no references remain

---

### Step 7.2: Verify No Broken References
**Goal**: Ensure all references updated

**Actions**:
- Search codebase for `SDeckTextField`
- Search codebase for `SDeckTextFieldState`
- Search codebase for `SDeckTextFieldSize`
- Fix any remaining references

**Verification**: No old references remain

---

## Phase 8: Testing & Verification

### Step 8.1: Visual Testing
**Goal**: Verify component matches Figma visually

**Actions**:
- Test all size variants (medium, large)
- Test all states (hint, focused, filled, disabled, error)
- Test with/without label
- Test with/without supporting text
- Test with/without icons
- Test password toggle
- Verify border width (4px)
- Verify padding values
- Verify typography
- Verify colors for all states

**Verification**: Visual appearance matches Figma exactly

---

### Step 8.2: Functional Testing
**Goal**: Verify all functionality works

**Actions**:
- Test focus detection (automatic state transitions)
- Test text input
- Test password toggle
- Test error state (provider override)
- Test disabled state
- Test read-only mode
- Test keyboard types
- Test validation flow

**Verification**: All functionality works correctly

---

### Step 8.3: Integration Testing
**Goal**: Verify integration with existing features

**Actions**:
- Test login flow
- Test sign-up flow
- Test profile creation flow
- Verify error messages display correctly
- Verify state management works with providers

**Verification**: All features work with new component

---

## Checklist Summary

### Phase 1: Enum Updates
- [ ] Create `input_enums.dart` with `SDeckInputState` and `SDeckInputSize`
- [ ] Export enums from components index

### Phase 2: Component Refactor
- [ ] Create new `sdeck_input.dart` file
- [ ] Rename class and keep as StatelessWidget (component is "blind")
- [ ] Add new properties (label, supportingText, iconLeft, iconRight, focusNode)
- [ ] Update constructor (single parameterized, state is required)
- [ ] Update TextField to use provider's FocusNode
- [ ] Update visual specifications (border, padding, container)
- [ ] Implement label rendering
- [ ] Implement supporting text rendering
- [ ] Update icon system (password toggle, left/right icons)
- [ ] Update container structure (single container)
- [ ] Update state color logic
- [ ] Update typography
- [ ] Build complete component structure

### Phase 3: Update Form Providers (Add Focus Detection & State Management)
- [ ] Update login form provider (add FocusNode, automatic state calculation)
- [ ] Update sign-up form provider (add FocusNode, automatic state calculation)
- [ ] Update profile form provider (add FocusNode, automatic state calculation)
- [ ] Update validation providers (keep error state, remove hint/filled)

### Phase 4: Update Validation State Classes
- [ ] Update login validation state
- [ ] Update sign-up validation state
- [ ] Update profile validation state

### Phase 5: Update UI Templates
- [ ] Update onboarding input template
- [ ] Update onboarding login template
- [ ] Update all other input usages

### Phase 6: Update Component Export
- [ ] Update components index

### Phase 7: Cleanup
- [ ] Delete old component file
- [ ] Verify no broken references

### Phase 8: Testing & Verification
- [ ] Visual testing
- [ ] Functional testing
- [ ] Integration testing

---

## Notes

### State Management Logic
- **Provider manages all states**: `hint`, `focused`, `filled`, `error`, `disabled`
- **Provider automatically calculates**: `hint` → `focused` → `filled` based on focus and text
- **Provider uses FocusNode**: Listens to focus changes to detect keyboard open/close
- **Component is "blind"**: Just displays what provider tells it (StatelessWidget)
- **Single Source of Truth**: Provider is the only place that manages state

### Visual Specifications
- Border: 4px width
- Border Radius: 8px
- Padding Medium: 16px horizontal, 12px vertical
- Padding Large: 16px all around
- Gap between elements: 4px

### Typography
- Label: 14px Caption (18px line height)
- Input: 20px Body Large (24px line height)
- Supporting: 12px Label Small (16px line height)

### Icons
- Password toggle: `SDeckIcons.eye` / `SDeckIcons.closedEye`
- Icon size: 24px
- Icon color: `inputIcon`

### Colors
- All colors use component-specific color tokens
- Supporting text colors change based on state (normal/error/disabled)

---

## Design References

- **Figma Input Component**: [Input Expanded](https://www.figma.com/design/NrBw4c0veZI1pb9jNldO2C/Socialdeck---Design-System?node-id=5532-4040&m=dev)
- **Figma Input Variants**: [Input Component](https://www.figma.com/design/NrBw4c0veZI1pb9jNldO2C/Socialdeck---Design-System?node-id=5532-5706&m=dev)
- **Figma Usage Example**: [Email Input](https://www.figma.com/design/lTsjQvJLBg22eFwwPRlC5z/Socialdeck---Onboarding?node-id=357-8496&m=dev)
- **Figma Password Icons**: [Password Input Examples](https://www.figma.com/design/lTsjQvJLBg22eFwwPRlC5z/Socialdeck---Onboarding?node-id=365-7186&m=dev)

---

## Related Work

- Button refactor (#12) - follows same single constructor pattern
- Component-Specific Color Palette (#2) - provides input color tokens
- Icon System refactor (#4) - provides monochrome icons for password toggle

