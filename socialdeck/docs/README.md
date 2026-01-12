# Documentation

This folder contains all project documentation, organized by category. This is the single source of truth for all documentation - `.cursor/rules` is a symlink pointing here to maintain compatibility with Cursor.

## Structure

### `/plans/`
Refactoring and implementation plans for major features and system changes.

- **INPUT_REFACTOR_PLAN.md** - Input component refactor plan
- **BUTTON_REFACTOR_PLAN.md** - Button system refactor plan
- **THEME_EXTENSION_MIGRATION_PLAN.md** - ThemeExtension migration plan
- **COLOR_PALETTE_UPDATE_PLAN.md** - Color palette update plan
- **COLOR_PALETTE_FIGMA_MATCH_PLAN.md** - Color palette Figma matching plan
- **COLOR_REFACTOR_PLAN.md** - Color system refactor plan
- **DESIGN_SYSTEM_REFACTOR_PLAN.md** - Design system token refactor plan
- **ICON_REFACTOR_PLAN.md** - Icon system refactor plan
- **WIDGETBOOK_INTEGRATION_PLAN.md** - Widgetbook integration plan

### `/policies/`
Coding standards, style guides, and project policies.

- **CODING_STYLE_GUIDE.md** - Coding style and documentation guide
- **DESIGN_SYSTEM_REFACTOR_PROCESS.md** - Reusable process for future refactoring sessions

### `/cursor/`
Cursor-specific rules and configurations for AI assistants.

- **AI_CODING_SESSION_RULES.md** - Mandatory rules for AI coding sessions
- **QUICK_REFERENCE_CHECKLIST.md** - Quick reference checklist for AI assistants
- **Figma Integration Rules.md** - Rules for integrating Figma designs into the codebase

## Notes

- **`.cursor/rules` is a symlink** pointing to this `docs/` folder - all files are stored here
- Project-specific README files (e.g., `widgetbook/README.md`) remain in their respective directories
- iOS project structure files (e.g., LaunchImage READMEs) remain in their iOS directories

