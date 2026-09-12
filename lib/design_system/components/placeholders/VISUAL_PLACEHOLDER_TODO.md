# SDeckVisualPlaceholder — API Fix Required

## The Problem

`height` is currently a **required** `double` parameter. This forces every caller to hardcode a pixel value, which breaks responsiveness on different screen sizes.

```dart
// current API — forces hardcoded pixels
const SDeckVisualPlaceholder(height: 100) // ← never responds to screen size
```

## The Fix

Make `height` optional. When null, default to `double.infinity` so the widget fills whatever its parent constrains it to. Callers that need a fixed size still pass `height:` explicitly — nothing breaks.

```dart
// after fix — two clean patterns
SDeckVisualPlaceholder(height: 48)             // fixed, same as before
AspectRatio(aspectRatio: 1, child: SDeckVisualPlaceholder()) // responsive
```

**Change is 2 lines in `sdeck_visual_placeholder.dart`:**
1. `required this.height` → `this.height`
2. `height: height` → `height: height ?? double.infinity`

## Why This Is Right

Figma uses `size-full` when the placeholder should fill its parent — the parent defines the size, the widget just fills it. The current API can't express that without `heightForGridRow()` workarounds.

## Callers That Need Review After Fix

| File | Current call | Problem | Fix |
|---|---|---|---|
| `sdeck_friend_preview_card.dart` | `height: 100` inside `Expanded` | Height fixed, width flexes → becomes rectangle on wide screens | Wrap with `AspectRatio(aspectRatio: 1)`, remove `height` |
| `social_inbox_page.dart` | `height: 96, borderRadiusZero` | Hardcoded height — check Figma screen first | TBD after Figma check |
| `login_reset_password_page.dart` | `height: 92` | Hardcoded — check Figma screen first | TBD after Figma check |
| `login_reset_password_confirm_page.dart` | `height: 92` | Hardcoded — check Figma screen first | TBD after Figma check |
| `sdeck_inbox_people_tile.dart` | `width: 48, height: 48, borderRadius4` | Wrong border radius AND Figma's basicTarget has no avatar at all | Remove the placeholder entirely |

## Callers That Are Already Good (No Change Needed)

| File | Why it's fine |
|---|---|
| `sdeck_social_user_tile.dart` | Fixed 48×48 in a rigid row — correct |
| `login_confirm_profile_page.dart` | Caller passes `size` from outside — parent owns the decision |
| `login_load_into_main_menu_page.dart` | Same pattern as above |
| `onboarding_input_template.dart` | Uses `heightForGridRow()` — responsive via screen width calculation |
| `sdeck_image_target.dart` | Uses `height: double.infinity` inside `Positioned.fill` — correct |

## Also Note

`heightForGridRow()` static helper can stay — it's useful for grid layouts — but after the fix it becomes less necessary since `AspectRatio` handles most cases cleaner.
