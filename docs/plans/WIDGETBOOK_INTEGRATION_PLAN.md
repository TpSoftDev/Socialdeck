# Widgetbook Integration Plan - Socialdeck

## Overview
This plan outlines the step-by-step integration of Widgetbook into the Socialdeck project, focusing on completing Colors Foundation and GitHub Actions workflow end-to-end before moving to additional features.

## Package Configuration
- **Widgetbook Package Name**: `socialdeck_widgetbook`
- **Main App Package Name**: `socialdeck`
- **Structure**: Separate `widgetbook/` directory with path dependency to main app
- **Note**: Main app files are at repository root (standard Flutter practice for single-app repos)

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

## Phase 1: Setup and Configuration

### Step 1.1: Create Widgetbook Directory Structure
**Goal**: Create the basic directory structure for Widgetbook

**Actions**:
- Create `widgetbook/` directory in project root
- This will be a separate Flutter project

**Verification**: Directory exists at `widgetbook/` (at repository root)

---

### Step 1.2: Initialize Flutter Project in Widgetbook Directory
**Goal**: Set up Widgetbook as a Flutter project

**Actions**:
- Navigate to `widgetbook/` directory
- Run: `flutter create . --empty` (or appropriate command per Widgetbook docs)
- This creates minimal Flutter project structure

**Verification**: `widgetbook/lib/`, `widgetbook/pubspec.yaml` exist

---

### Step 1.3: Configure widgetbook/pubspec.yaml
**Goal**: Set up package name, dependencies, and path to main app

**Configuration Needed**:
```yaml
name: socialdeck_widgetbook
description: Widgetbook catalog for Socialdeck design system

dependencies:
  flutter:
    sdk: flutter
  widgetbook: ^[latest_version]
  widgetbook_annotation: ^[latest_version]
  socialdeck:
    path: ../

dev_dependencies:
  widgetbook_generator: ^[latest_version]
  build_runner: ^[version]
```

**Actions**:
- Set package name to `socialdeck_widgetbook`
- Add Widgetbook dependencies (check latest versions from docs)
- Add `socialdeck` as path dependency pointing to parent directory
- Run `flutter pub get` in widgetbook directory

**Verification**: Dependencies resolve correctly, no conflicts

---

### Step 1.4: Create Basic widgetbook/lib/main.dart
**Goal**: Create minimal Widgetbook entry point

**Actions**:
- Create `widgetbook/lib/main.dart`
- Set up basic Widgetbook structure following official documentation
- Import from `package:socialdeck/design_system/...` to verify path dependency works

**Verification**: File created, imports resolve

---

### Step 1.5: Test Basic Setup
**Goal**: Verify Widgetbook runs and can import from main app

**Actions**:
- Run Widgetbook: `flutter run -d chrome` (or web)
- Verify it launches without errors
- Verify imports from `package:socialdeck/...` work

**Verification**: Widgetbook runs successfully, no import errors

---

## Phase 2: Foundation - Colors (Complete End-to-End)

### Step 2.1: Set Up Theme Addon for Light/Dark Mode
**Goal**: Configure Widgetbook to support theme switching

**Actions**:
- Add Theme Addon to Widgetbook configuration
- Configure to use `SDeckAppTheme.light` and `SDeckAppTheme.dark`
- Follow Widgetbook documentation for Theme Addon setup

**Verification**: Theme switcher appears in Widgetbook UI, themes apply correctly

---

### Step 2.2: Create Colors Category Structure
**Goal**: Mirror your design system hierarchy in Widgetbook

**Structure to Create**:
```
WidgetbookApp
└── Tokens (Category - created by file path: tokens/)
    └── Colors (Folder - created by file path: tokens/colors/)
        ├── Base Color Palette (Component)
        │   ├── Bright Coral (Use Case) → Shows all shades 50-950
        │   ├── Tangerine (Use Case) → Shows all shades 50-950
        │   ├── Vibrant Yellow (Use Case) → Shows all shades 50-950
        │   ├── Mint Green (Use Case) → Shows all shades 50-950
        │   ├── Sky Blue (Use Case) → Shows all shades 50-950
        │   └── Lavender (Use Case) → Shows all shades 50-950
        ├── Neutral Base Color Palette (Component)
        │   ├── Warm Off White (Use Case) → Shows all shades 50-950
        │   ├── Cool Gray (Use Case) → Shows all shades 50-950
        │   ├── Slate Gray (Use Case) → Shows all shades 50-950
        │   ├── Black (Use Case) → Single swatch
        │   └── White (Use Case) → Single swatch
        ├── Brand Colors (Component)
        ├── Semantic Colors (Component)
        └── Color Schemes (Component)
```

**Approach Decision**:
- **One Component per Color Type** (Base Colors, Brand Colors, etc.)
- **Multiple Use Cases per Component** (one use case per individual color)
- This provides clean sidebar navigation while allowing focused viewing of each color

**Actions**:
- Create file structure: `widgetbook/lib/tokens/colors/` (creates Tokens → Colors folder)
- Create `BaseColorPalette` and `NeutralBaseColorPalette` component classes
- Create use cases for each base color (one per color)
- Follow Widgetbook documentation: use `@widgetbook.UseCase` annotations

**Verification**: Structure appears in Widgetbook sidebar matching your hierarchy

---

### Step 2.3: Display Base Colors
**Goal**: Show all Base Color MaterialColor swatches

**Display Pattern** (matching Widgetbook demo):
- Each use case shows one color's complete shade scale
- Display all MaterialColor shades in a row: 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950
- Each swatch displays:
  - Color square (visual representation)
  - Shade number (50, 100, etc.)
  - Hex value (e.g., #FE6F61)

**Actions**:
- Create visual widget to display color swatches with hex values
- Implement for each base color:
  - brightCoral
  - tangerine
  - vibrantYellow
  - mintGreen
  - skyBlue
  - lavender
  - warmOffWhite
  - coolGray
  - slateGray
  - black (single swatch)
  - white (single swatch)

**Verification**: All base colors display with all shades visible, matches Widgetbook demo pattern

---

### Step 2.4: Display Brand Colors
**Goal**: Show Brand Colors with light/dark mode variations

**Actions**:
- Create use cases for `SDeckBrandColors`
- Display each brand color showing:
  - Light mode value
  - Dark mode value
  - Visual swatch
- Group by color family (brightCoral, tangerine, etc.)

**Verification**: Brand colors display correctly, light/dark mode switching works

---

### Step 2.5: Display Semantic Colors and Color Schemes
**Goal**: Show semantic color mappings and complete color schemes

**Actions**:
- Create use cases for `SDeckMainSemanticColors`
- Display semantic colors (primary, secondary, error, etc.)
- Create use case for `SDeckColorSchemes.light` and `SDeckColorSchemes.dark`
- Show complete ColorScheme objects

**Verification**: Semantic colors and schemes display correctly

---

### Step 2.6: Test Light/Dark Mode Switching
**Goal**: Verify theme switching works throughout color displays

**Actions**:
- Test switching between light and dark themes
- Verify all color displays update correctly
- Verify colors match expected values for each theme

**Verification**: Theme switching works, all colors update correctly

---

## Phase 3: GitHub Actions Workflow (Complete End-to-End)

### Step 3.1: Create GitHub Actions Workflow File
**Goal**: Set up basic GitHub Actions workflow

**Actions**:
- Create `.github/workflows/deploy-widgetbook.yml`
- Set up basic workflow structure (on push to main)
- Add checkout step
- Add Flutter setup step

**Verification**: Workflow file created, basic structure in place

---

### Step 3.2: Configure Build Steps for Widgetbook
**Goal**: Add steps to build Widgetbook for web

**Actions**:
- Add step to navigate to `widgetbook/` directory
- Add `flutter pub get` step
- Add `dart run build_runner build` step (if using annotations)
- Add `flutter build web` step targeting `widgetbook/lib/main.dart`

**Verification**: Build steps configured correctly

---

### Step 3.3: Configure Deployment to GitHub Pages
**Goal**: Deploy built Widgetbook to GitHub Pages

**Actions**:
- Add step to deploy `widgetbook/build/web/` to GitHub Pages
- Use GitHub Actions Pages deployment action
- Configure to deploy on successful build

**Verification**: Deployment step configured

---

### Step 3.4: Test Auto-Deployment on Push to Main
**Goal**: Verify workflow triggers and deploys automatically

**Actions**:
- Push changes to main branch
- Monitor GitHub Actions workflow
- Verify build succeeds
- Verify deployment succeeds

**Verification**: Workflow runs automatically, deployment successful

---

### Step 3.5: Verify Widgetbook Accessible via GitHub Pages
**Goal**: Confirm Widgetbook is live and accessible

**Actions**:
- Access GitHub Pages URL
- Verify Widgetbook loads correctly
- Test color displays work in deployed version
- Test theme switching works

**Verification**: Widgetbook accessible, all features work in production

---

## Success Criteria

### Phase 1 Complete When:
- ✅ Widgetbook directory created and configured
- ✅ Widgetbook runs locally
- ✅ Can import from `package:socialdeck/...`

### Phase 2 Complete When:
- ✅ All color tokens display in Widgetbook
- ✅ Light/dark mode switching works
- ✅ Structure mirrors design system hierarchy
- ✅ Colors match expected values

### Phase 3 Complete When:
- ✅ GitHub Actions workflow works
- ✅ Widgetbook deploys automatically on push
- ✅ Widgetbook accessible via GitHub Pages
- ✅ All features work in deployed version

---

## Next Steps (After This Plan)
Once Colors + GitHub Actions are complete and the process is refined:
- Add Typography foundation
- Add Spacing foundation
- Add Effects foundation
- Add Themes display
- Add Components (one by one)

---

## Notes
- Always follow Widgetbook official documentation
- Mirror exact naming from design system (Tokens, not Foundation)
- Test each step before moving to next
- Document any deviations or learnings
- Keep process simple and repeatable

---

**Plan Created**: [Date]
**Status**: Ready for Implementation
**Next Action**: Begin Phase 1, Step 1.1

