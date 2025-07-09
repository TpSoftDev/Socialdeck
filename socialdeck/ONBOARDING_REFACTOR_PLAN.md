# Onboarding Refactor Plan

This document tracks the step-by-step plan for refactoring the onboarding flow to be robust, Firebase-backed, and production-ready. Use this as a checklist and reference for implementation.

---

## Step-by-Step Plan

- [ ] **1. Early Email Availability Check**
  - Validate email format and check if the email is already registered on the email entry page.
  - Show errors immediately if the email is taken or invalid.
  - (Optional) Check email deliverability.
  - **Notes:**
    - 

- [ ] **2. Password Validation**
  - Validate password strength as soon as the user enters it.
  - Show errors immediately for weak passwords.
  - **Notes:**
    - 

- [ ] **3. User Creation Timing**
  - Create the Firebase user as soon as both email and password are valid and available.
  - Handle errors and show feedback immediately.
  - **Notes:**
    - 

- [ ] **4. Email Verification Flow**
  - Send verification email after user creation.
  - Poll for verification status.
  - If not verified after X minutes, allow user to change email or restart.
  - **Notes:**
    - 

- [ ] **5. Profile Data Collection**
  - After verification, collect username, photo, and other profile data.
  - Validate username uniqueness (check in Firestore).
  - **Notes:**
    - 

- [ ] **6. Onboarding Submission to Firestore**
  - Implement a real `OnboardingSubmissionRepository` that writes profile data to Firestore, linked to the Firebase user’s UID.
  - Aggregate all onboarding data and store it under the user’s UID.
  - Handle errors and show feedback.
  - **Notes:**
    - 

- [ ] **7. State Persistence**
  - Save onboarding progress locally (e.g., with shared_preferences or secure storage).
  - On app restart, resume where the user left off.
  - **Notes:**
    - 

- [ ] **8. Security Enhancements**
  - Add rate limiting and bot protection (e.g., reCAPTCHA, Firebase App Check).
  - **Notes:**
    - 

---

## Additional Notes & Edge Cases
- 

---

**Update this file as you complete each step or discover new requirements!** 