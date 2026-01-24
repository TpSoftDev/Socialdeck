# Social Deck – Figma Integration Rules

## Project Context

- **Project Name**: Social Deck  
- **Tech Stack**: Flutter (Dart)  
- **Design Source**: Figma  
- **Workflow**: Incremental integration of design elements from Figma into a clean, scalable, professional Flutter codebase

## Architecture Philosophy

- Organize all code using **industry-standard Flutter architecture** best practices
- Only create folders when they serve a clear organizational purpose (e.g., typography, constants, widgets, themes)
- Every Figma element should be evaluated individually and mapped to the most appropriate location in the codebase based on its **role**, **purpose**, and **expected reusability**

## Folder and File Placement Guidelines

- Think critically about what is being imported from Figma, and assign it to a logical location in the project hierarchy
- Do not rely solely on examples or previously used structures — use established Flutter conventions
- Example folders you may see in this project include:
  ```
  lib/
    ├── constants/
    ├── themes/
    ├── typography/
    ├── widgets/
    ├── screens/
    ├── utils/
  ```
- These are examples only. Actual folder structure should be based on what best serves clarity and long-term scalability

## Naming Conventions

- Prefix all class names with `SDeck` (e.g., `SDeckAppColors`, `SDeckButtonPrimary`, `SDeckSpacing`) to support easy searching and consistency
- Use clear, descriptive names that align with Flutter development norms and reflect the component’s function and source

## Code Style and Formatting

All code must match the formatting, spacing, structure, and commenting style used in the following two reference files from this project:
- `app_colors.dart`
- `color_palette.dart`

Specifically:
- Follow the same indentation patterns
- Use consistent inline and block comments
- Organize content using clear, logical groupings
- Match how classes and constants are named, spaced, and documented

These two files serve as the **style baseline** for all new code written in this project.

## Visual Fidelity

- All design details in Figma must be **replicated exactly**
- This includes:
  - Spacing values
  - Radius
  - Font sizes and styles
  - Colors
  - Layout positioning
  - Naming conventions
- Do not estimate, reinterpret, or skip values — use the **exact values and structure as defined in the Figma component**
- The goal is to recreate the design as precisely as possible in Flutter

## Asset and Token Integration

- All Figma assets (icons, images) are already imported into the codebase
- Reference assets using existing paths and names; do not re-fetch or rename arbitrarily
- Group related design tokens (e.g., spacing, radius, shadows, colors) using appropriate static classes and assign them to a meaningful location in the codebase (e.g., `constants/`, `themes/`)

## Development Process

- Bring in one design element at a time from Figma (e.g., a color palette, a text style, an icon)
- For each element:
  - Evaluate its nature (e.g., token, widget, layout rule)
  - Place it in a file and folder that would be expected in a scalable Flutter project
  - Follow naming, structure, and format based on both this repo and Flutter community standards

## Foundational Code and Collaboration

- The existing code in the GitHub repo is treated as a **starting point** or foundation
- Suggestions to improve formatting, structure, comments, or naming conventions are encouraged
- All improvement suggestions must be run by the project owner before any changes are made
- If there is a clearer or more efficient way to organize code for easier screen composition, it should be proposed
- Better comments or organization that improve clarity are welcome — the goal is to optimize for reusability, understanding, and maintainability

## Constraints

- Do not generate placeholder UI, mockups, or speculative components unless explicitly instructed
- Do not attempt to bundle multiple unrelated Figma components together
- When a Figma link is provided, build only what is explicitly shown in the link

## Style Guide Source

Use the following GitHub repository as the **foundation and reference** for all style, formatting, structure, and naming conventions:

**GitHub Repo**: [Socialdeck-DesignSystem-Colors](https://github.com/TpSoftDev/Socialdeck-DesignSystem-Colors)

Specifically:
- Follow formatting and spacing patterns used in:
  - `app_colors.dart`
  - `color_palette.dart`
- Use consistent structure, indentation, comments, and file naming based on the examples in this repo
- This repository represents the baseline for how code should look and feel across the project
- If any element in the repo can be improved for clarity, organization, or alignment with Figma, suggest changes — all improvements must be approved by the project owner before implementation