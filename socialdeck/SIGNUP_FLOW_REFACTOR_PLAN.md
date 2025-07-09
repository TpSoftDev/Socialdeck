# Socialdeck Sign-Up Flow Refactor Plan

## Goal
Refactor the sign-up flow to be robust, production-ready, and fully integrated with Firebase. Ensure the UI and backend are tightly aligned, and provide a seamless onboarding experience for users.

---

## 1. Email Verification Flow

### **Current Issues**
- Uses artificial delays after sending verification email.
- Users can proceed without actually verifying their email.
- No real-time check for email verification status.

### **Target Flow**
- After account creation, user lands on "Verify Account" screen.
- User presses "Send Verification" → triggers Firebase to send the email.
- User is taken to a "Waiting for Verification" (Redirecting) screen.
- **App polls Firebase** every few seconds to check if the user has verified their email.
- **Manual "Check Again" button** for user to trigger a check immediately.
- **Resend Verification Email** button for lost/missed emails.
- **Only after real verification** does the user proceed to the next onboarding step (e.g., profile/username).

---

## 2. Error Handling & Debugging
- Add clear error messages for all Firebase actions (sending email, polling, etc).
- Show loading indicators during async actions.
- Log errors to console for easier debugging.
- Allow user to change email if they made a mistake.

---

## 3. Test Repository
- **Archive** the test repository (move to `archived/` or similar).
- Keep code in the repo for possible future use (local dev, automated tests), but do not include in production builds.

---

## 4. Screen-by-Screen Review
- Review each onboarding screen to ensure:
  - UI and backend are in sync.
  - All transitions happen at the correct time.
  - Error states are handled gracefully.

---

## 5. Implementation Steps
1. Update Redirecting screen to poll for verification and add manual controls.
2. Add error handling and logging to all Firebase actions.
3. Archive the test repo.
4. Review and update each onboarding screen as needed.

---

## 6. Optional Tweaks
- Add analytics/logging for sign-up events.
- Add rate limiting for resend email.
- Add support for deep links (auto-detect verification from email link).

---

**This plan will guide the refactor to ensure a smooth, production-ready onboarding experience!** 