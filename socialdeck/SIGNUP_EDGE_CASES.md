# Sign-Up Flow Edge Cases

This document tracks important edge cases to consider and handle in the Socialdeck sign-up flow. Update this file as new edge cases are discovered.

---

## 1. User Enters Fake or Undeliverable Email

**Description:**
- The user enters an email address that does not exist or cannot receive mail.
- The app creates a Firebase user and sends a verification email, but the user never receives or clicks the link.
- The app polls Firebase forever, waiting for `emailVerified` to become `true`, but it never will.

**Why It Happens:**
- Firebase allows account creation with any email address, even if it is not real or deliverable.
- There is no built-in check for email deliverability before account creation.
- The app currently has no timeout or escape for this scenario.

**Recommended Solutions:**
- Add a polling timeout (e.g., stop after 2–3 minutes) and show a message: "Still waiting for verification? Please check your email or try a different one."
- Provide a "Change Email" or "Restart" button so the user can go back and enter a new email address.
- (Optional) Use a third-party service to check email deliverability before creating the user.

---

## 2. [Add more edge cases here]

- 