# Lesson: The Contract and View API

**Purpose:** Teach how the frontend view and backend wiring stay in sync using a clear **contract** (the view’s API). Backend owns the contract; frontend builds the view to match it.

---

## 1. What is the contract?

The **contract** is the list of **inputs** the presentational widget (the “view”) accepts:

- **Data** – values the UI needs to render (e.g. `isLoading`, `inviteSent`).
- **Callbacks** – functions the UI calls when the user acts (e.g. `onSendInvite`, `onGetStarted`).

In code, the contract **is** the view widget’s constructor: the same parameter list. Backend writes it down (in the issue or a comment) so both sides know it; frontend implements a widget with exactly those parameters.

**Why it matters:**

- Frontend can focus on Figma and the design system; they don’t need to know Riverpod or providers.
- Backend can focus on domain, data, and providers; they don’t need to touch layout.
- One person (backend) defines “what the view receives”; no back-and-forth to “agree.”

---

## 2. Who owns the contract?

- **Backend** owns the contract: they define what data and callbacks the view will receive.
- Backend writes the contract in the issue (or a short spec) before or at the start of the task.
- Frontend builds the view to that contract; backend implements the provider and the Consumer page that passes those props.

---

## 3. How to look at a screen and know what the contract needs

Backend (or whoever writes the contract) can derive it from Figma in two steps.

### Step 1: What can change on the screen? (data)

Look at the UI and ask: *“What could be different at different times?”*

| What you see | Contract (data) |
|--------------|------------------|
| A button that shows a spinner or “Send” | `isLoading` (bool) |
| A success or error message | `message` (String?) or `inviteSent` (bool) |
| Pre-filled text (e.g. email) | `initialEmail` (String) |
| Button disabled until form is valid | Often derived from other state (e.g. `!isLoading`) |

### Step 2: What can the user do? (callbacks)

For every tap, submit, or clear action:

| User action | Contract (callback) |
|-------------|---------------------|
| Tap “Send Invite” | `onSendInvite` () → void |
| Tap “Get Started” | `onGetStarted` () → void |
| Tap “Skip” | `onSkip` () → void |
| Tap “Back” | `onBack` () → void |

### Step 3: Write it down

Combine into a short list: **Data** and **Callbacks**. That list is the contract. Put it in the issue so frontend and backend both work to the same API.

---

## 4. Example 1: Invite Friends

### Screen (from Figma)

- Title: “Invite Friends”
- Placeholder area
- Text: “Invite some friends to get the party started!”
- Button: “Send Invite” (can show loading)
- Button: “Get Started”

### Contract (backend writes this)

```text
CONTRACT: InviteFriendsView

Data:
  - isLoading (bool)        → true while "Send Invite" is in progress
  - inviteSent (bool)       → true after invite was sent (optional success state)

Callbacks:
  - onSendInvite () → void  → called when user taps "Send Invite"
  - onGetStarted () → void  → called when user taps "Get Started"
```

### Frontend: the view (StatelessWidget)

The view’s constructor **is** the contract. Frontend builds this and matches Figma.

```dart
// invite_friends_view.dart – frontend owns this
class InviteFriendsView extends StatelessWidget {
  const InviteFriendsView({
    super.key,
    required this.isLoading,
    required this.inviteSent,
    required this.onSendInvite,
    required this.onGetStarted,
  });

  final bool isLoading;
  final bool inviteSent;
  final VoidCallback onSendInvite;
  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Title, placeholder, text from Figma...
            SDeckSolidButton(
              text: isLoading ? 'Sending...' : 'Send Invite',
              onPressed: isLoading ? null : onSendInvite,
            ),
            SDeckOutlineButton(
              text: 'Get Started',
              onPressed: onGetStarted,
            ),
          ],
        ),
      ),
    );
  }
}
```

### Backend: the page (ConsumerWidget)

Backend “fulfills” the contract by passing state and notifier methods into the view.

```dart
// invite_friends_page.dart – backend owns this
class InviteFriendsPage extends ConsumerWidget {
  const InviteFriendsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(inviteFriendsProvider);

    return InviteFriendsView(
      isLoading: state.isLoading,
      inviteSent: state.inviteSent,
      onSendInvite: () => ref.read(inviteFriendsProvider.notifier).sendInvite(),
      onGetStarted: () => ref.read(inviteFriendsProvider.notifier).getStarted(),
    );
  }
}
```

---

## 5. Example 2: Opening Screen

### Screen (from Figma)

- Hero/placeholder
- Logo + “Socialdeck”
- Button: “Sign Up”
- Button: “Log In”
- Footer: Terms & Privacy links

### Contract (backend writes this)

```text
CONTRACT: OpeningScreenView

Data:
  (none – static screen; no loading or message that changes)

Callbacks:
  - onSignUp () → void   → called when user taps "Sign Up"
  - onLogIn () → void    → called when user taps "Log In"
  - onTermsTap () → void → called when user taps Terms (optional)
  - onPrivacyTap () → void → called when user taps Privacy (optional)
```

### Frontend: the view

```dart
// opening_screen_view.dart
class OpeningScreenView extends StatelessWidget {
  const OpeningScreenView({
    super.key,
    required this.onSignUp,
    required this.onLogIn,
    this.onTermsTap,
    this.onPrivacyTap,
  });

  final VoidCallback onSignUp;
  final VoidCallback onLogIn;
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Hero, logo, text from Figma...
            SDeckSolidButton(text: 'Sign Up', onPressed: onSignUp),
            SDeckOutlineButton(text: 'Log In', onPressed: onLogIn),
            // Footer with onTermsTap, onPrivacyTap
          ],
        ),
      ),
    );
  }
}
```

### Backend: the page

```dart
// opening_screen_page.dart
class OpeningScreenPage extends ConsumerWidget {
  const OpeningScreenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OpeningScreenView(
      onSignUp: () => context.push('/sign-up'),
      onLogIn: () => context.push('/login'),
      onTermsTap: () => { /* open terms */ },
      onPrivacyTap: () => { /* open privacy */ },
    );
  }
}
```

(Here the “state” might be minimal; the page can use `context` for navigation. If you later add analytics or feature flags, backend adds that to the contract and the page.)

---

## 6. Example 3: Confirm Profile (with data)

### Screen (from Figma)

- Profile image/placeholder
- Username/handle (e.g. “eth6nhunt”)
- Text: “Is this your profile card?”
- Button: “That’s me!”

### Contract (backend writes this)

```text
CONTRACT: ConfirmProfileView

Data:
  - profileImageUrl (String?)  → url or null (show placeholder)
  - username (String)          → e.g. "eth6nhunt"
  - isLoading (bool)          → true while confirming

Callbacks:
  - onConfirm () → void       → called when user taps "That's me!"
```

### Frontend: the view

```dart
// confirm_profile_view.dart
class ConfirmProfileView extends StatelessWidget {
  const ConfirmProfileView({
    super.key,
    required this.profileImageUrl,
    required this.username,
    required this.isLoading,
    required this.onConfirm,
  });

  final String? profileImageUrl;
  final String username;
  final bool isLoading;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Image (or placeholder), username, "Is this your profile card?"
            SDeckSolidButton(
              text: "That's me!",
              onPressed: isLoading ? null : onConfirm,
            ),
          ],
        ),
      ),
    );
  }
}
```

### Backend: the page

```dart
// confirm_profile_page.dart
class ConfirmProfilePage extends ConsumerWidget {
  const ConfirmProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(confirmProfileProvider);

    return ConfirmProfileView(
      profileImageUrl: state.profileImageUrl,
      username: state.username,
      isLoading: state.isLoading,
      onConfirm: () => ref.read(confirmProfileProvider.notifier).confirm(),
    );
  }
}
```

---

## 7. Quick reference: contract checklist

**Backend (contract owner):**

1. Look at Figma: what changes on screen? → list **data** (name + type + one-line meaning).
2. Look at Figma: what can the user do? → list **callbacks** (name + “called when…”).
3. Put the list in the issue (or a comment) as the **Contract**.
4. Implement domain + provider so the state has those fields and actions.
5. Implement the **page** (ConsumerWidget) that passes `ref.watch(provider)` and `ref.read(provider.notifier)` into the view.

**Frontend:**

1. Read the contract in the issue.
2. Create a **StatelessWidget** (e.g. `XxxView`) whose constructor has exactly those parameters.
3. Build the layout to match Figma; use the design system. Use the data for what’s shown and the callbacks for `onPressed` / `onTap`.

---

## 8. Summary

| Concept | Meaning |
|--------|---------|
| **Contract** | The list of data + callbacks the view accepts. Same as the view’s constructor. |
| **Owner** | Backend defines the contract; frontend implements the view to it. |
| **How to derive** | (1) What can change? → data. (2) What can the user do? → callbacks. |
| **Frontend** | StatelessWidget with those parameters; match Figma; no `ref`. |
| **Backend** | ConsumerWidget page that passes provider state and notifier methods into the view. |

Use this lesson when onboarding new devs or when adding a new screen so everyone uses the same contract pattern.
