# Top Navigation Bar Refactor Plan

## Overview

Align `SDeckTopNavigationBar` with the Figma Design System component **topBar (Rive)** so that variants, spacing, and API match the design spec. This plan is for devs to implement later; it does not require immediate implementation.

**Goal:** One top bar component that mirrors Figma’s prop-driven model (Type + Title? + Left Icon? + Right Icon?) and uses Figma’s spacing/sizing tokens, while keeping existing call sites working during migration.

**Figma source:** Socialdeck — Design System, node `topBar (Rive)` (e.g. node-id=5509-1953).

---

## Current State Analysis

### What We Have Now

**File:** `lib/design_system/components/navigation/sdeck_top_navigation_bar.dart`

**Architecture:**
- One class `SDeckTopNavigationBar`, **six named constructors**.
- Internal `SDeckTopNavVariant` enum drives two switches: `_buildLeftSection`, `_buildRightSection`.
- Properties: `_variant`, `onBackPressed`, `title`, `onActionPressed` (not all used by every constructor).

**Constructors (code-side naming):**

| Constructor              | Left                    | Right              |
|--------------------------|-------------------------|--------------------|
| `backWithLogo`           | Back chevron            | Logo 48×48         |
| `logoWithTitle`         | Logo + title           | Optional icon 48×48 |
| `logoWithSkip`          | Logo                   | "Skip" + chevron   |
| `logoWithoutBack`       | Empty (48px)           | Logo               |
| `backWithTitle`         | Back + title           | "Save" button      |
| `backWithTitleAndIcon`  | Back + title           | Icon 48×48         |

**Spacing/sizing in code:**
- Container padding: `EdgeInsets.fromLTRB(0, 16, 16, 8)` (left 0, right 16, top 16, bottom 8).
- Back button: 48×48; chevron size 48.
- Gap between back and title: `SDeckSpace.gap4` (4px).
- No variant for “back + title only” (no right widget).

### Gaps vs Figma

| Aspect              | Figma                          | Current code                         |
|---------------------|--------------------------------|-------------------------------------|
| **Model**           | One component, props           | Six constructors, enum               |
| **Variant choice**  | Type + Title? + Left? + Right?  | Pick one constructor                 |
| **Back + title only** | Yes (Right Icon? = OFF)      | No; both back+title show right      |
| **Padding**         | px 16, pt 16, pb 12             | L 0, R 16, T 16, B 8                |
| **Left icon frame** | Width 20, height 48             | 48×48                               |
| **Back–title gap**  | 12px                           | 4px (gap4)                          |
| **Right placeholder** | 36×36 (when icon)             | 48×48                               |
| **Naming**          | Page / Subpage / Page w/ Profile | backWithLogo / logoWithTitle etc. |

---

## Figma Property Mapping

### Figma topBar (Rive) Properties

| Figma property | Type   | Values / meaning |
|---------------|--------|-------------------|
| **Type**      | enum   | Page, Subpage, Page w/ Profile, Subpage w/ Profile, Subpage w/ Button |
| **Title?**   | bool   | Show/hide title text |
| **Title**    | string | Title text (e.g. "Page Title") |
| **Left Icon?** | bool | Show/hide back chevron |
| **Right Icon?** | bool | Show/hide right slot |
| **Right Icon**  | slot  | Placeholder (36×36) / avatar (48×48) / button, depending on Type |
| **Variable modes** | theme | Color - Brand, Color - Semantic (e.g. Auto Light Mode) |

### Figma layout / tokens (from inspect)

- **Container:** padding top 16, bottom 12, horizontal 16.
- **Left “Page Details”:** flex, gap 12, height 48; back chevron frame width 20, height 48.
- **Title:** H4 for Page/Page w/ Profile, H5 for Subpage variants.
- **Right:** 36×36 circle (placeholder) or 48×48 (profile) or button, depending on Type.

---

## Reference: Padding (LTRB) and Figma

**What LTRB is:** In Flutter, `EdgeInsets.fromLTRB(left, top, right, bottom)` — the four numbers are always in that order: **L**eft, **T**op, **R**ight, **B**ottom.

| Position | Meaning        | Figma (Design System topBar) | Code equivalent     |
|----------|----------------|------------------------------|---------------------|
| 1st (L)  | Left padding   | 16                           | `fromLTRB(16, …)`   |
| 2nd (T)  | Top padding    | 16                           | `fromLTRB(…, 16, …)`|
| 3rd (R)  | Right padding  | 16                           | `fromLTRB(…, 16, …)`|
| 4th (B)  | Bottom padding | 12                           | `fromLTRB(…, 12)`   |

So Figma’s padding **16, 16, 16, 12** (left, top, right, bottom) in code is:  
`EdgeInsets.fromLTRB(16, 16, 16, 12)`.

**Why there’s a ternary in the code:** We use different padding per variant. The **titleOnly** variant (Onboarding / Invite Friends) should match the Design System topBar, so it uses Figma’s padding. All other variants keep the original bar padding (left 0 so the back button can sit at the edge). So in code we do:

- **If** variant is `titleOnly` **then** padding = `fromLTRB(16, 16, 16, 12)` (Figma).
- **Else** padding = `fromLTRB(0, 16, 16, 8)` (original).

That way only the title-only bar gets the 16 left / 12 bottom from Figma; the rest are unchanged.

---

## Refactor Approach (For Devs Later)

### Option A: Single parameterized constructor (Figma-aligned)

Introduce a constructor that mirrors Figma’s props:

```dart
SDeckTopNavigationBar({
  Key? key,
  required SDeckTopBarType type,     // Page | Subpage | PageWithProfile | ...
  bool showTitle = true,
  String? title,
  bool showLeftIcon = true,
  bool showRightSlot = false,
  Widget? rightWidget,                // optional custom right (icon/avatar/button)
  VoidCallback? onBackPressed,
  VoidCallback? onRightPressed,
});
```

- **Left:** If `showLeftIcon` → back chevron (Figma-sized frame 20×48, gap 12 to title). If `showTitle` && `title != null` → title (H4/H5 by type).
- **Right:** If `showRightSlot` → `rightWidget` or default placeholder/avatar/button by `type`; otherwise empty (SizedBox to avoid layout shift if desired).
- **Padding:** LTRB 16, 16, 16, 12 (or use tokens: padding16, padding12 for bottom).

Keep existing named constructors as **forwarding factories** that call this constructor with the right args, so existing call sites don’t break.

### Option B: Keep constructors, add missing variant only

- Add one new variant: **back + title only** (e.g. `backWithTitleOnly` or use a flag).
- Optionally adjust padding/sizing in one pass to match Figma (16/12/16, back 20×48, gap 12).
- Less structural change; Figma alignment can be done incrementally later.

### Recommendation

- **Short term (demo):** Add a single constructor for “back + title only” (see “Demo-only change” below).
- **Later (full refactor):** Implement Option A with Figma spacing/sizes and migrate existing constructors to forward to it; document mapping from Figma Type + booleans to constructor params.

---

## Implementation Checklist (When Refactor Is Done)

- [ ] Introduce design tokens for top bar: horizontal padding 16, top 16, bottom 12 (or use existing SDeckSpace if values match).
- [ ] Back chevron: container width 20, height 48; gap between chevron and title 12.
- [ ] Title: H4 vs H5 by type (Page vs Subpage) using theme text styles.
- [ ] Right slot: support “none” / 36×36 placeholder / 48×48 avatar / button.
- [ ] Single constructor (or primary constructor) with Type + booleans + optional right widget.
- [ ] Existing named constructors reimplemented as factories calling the new constructor.
- [ ] Update call sites only if renaming (e.g. to `SDeckTopBarType.page`) or if behavior changes.
- [ ] Design system docs: table mapping Figma (Type, Title?, Left Icon?, Right Icon?) to code usage.

---

## Demo-Only Change (Do This for Teaching)

For the Invite Friends demo screen, we need a top bar that matches Figma’s **Subpage** with **Title? = ON, Left Icon? = ON, Right Icon? = OFF**: back chevron + title, nothing on the right.

**Add one new constructor** (and one new enum value) so devs don’t have to refactor the whole component yet:

- **Enum:** e.g. `backWithTitleOnly` (or `subpage` if you prefer Figma-style naming).
- **Constructor:** e.g. `SDeckTopNavigationBar.backWithTitleOnly({ required String title, VoidCallback? onBackPressed })`.
- **Left:** Same as existing `backWithTitle` (back + title).
- **Right:** Empty — e.g. `SizedBox(width: 48)` or `SizedBox.shrink()` so layout doesn’t jump; no Save, no icon.

**Usage on Invite Friends page:**

```dart
SDeckTopNavigationBar.backWithTitleOnly(
  title: 'Invite Friends',
  onBackPressed: () => Navigator.pop(context),
)
```

This gives the demo the correct Figma-like bar without touching the rest of the refactor. The full refactor plan above remains the single source of truth for when devs align the whole component with Figma.
