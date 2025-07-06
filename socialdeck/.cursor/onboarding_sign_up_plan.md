# Onboarding Sign-Up Flow: Implementation Plan & Checklist

## **Overview**
This document outlines the comprehensive plan for implementing the onboarding sign-up flow in the Socialdeck app using Riverpod and clean architecture. It is designed to be referenced throughout development and whenever work resumes on this feature, providing all necessary context for any developer to pick up the work.

---

## **Project Goals**
- Build a scalable, maintainable, and testable sign-up flow using Riverpod.
- Follow clean architecture: separate data, domain, provider, and presentation layers.
- Ensure the architecture is reusable for future backend integration (Firebase, etc.).
- Start with test/mock data, but make it easy to swap in Firebase later.
- Match the Figma design and UX exactly.
- Enforce correct navigation and flow sequence (no skipping steps).

---

## **What Already Exists**
- **UI Screens:**
  - Email entry (`sign_up_email.dart`)
  - Password entry (`sign_up_password_page.dart`)
  - Confirm password (`sign_up_confirm_password.dart`)
  - Email verification prompt (`sign_up_verify.dart`)
  - Redirecting/loading (`sign_up_redirecting.dart`)
- **Routing:**
  - Modularized GoRoute setup in `sign_up_routes.dart` and main router.
  - Route constants in `route_constants.dart`.
- **State:**
  - All screens currently use local state (no shared provider/state management yet).
- **Guards:**
  - Global auth guard exists, but no sign-up flow-specific guard yet.

---

## **Architecture Overview**

### **Provider Layer (State Management)**
- **SignUpFormProvider:** Manages UI state (input values, button enabled, field visuals).
- **SignUpValidationProvider:** Handles async validation (e.g., email taken, password rules), loading, and error states.

### **Domain Layer**
- Models for form state and validation state (immutable, with copyWith).

### **Data Layer**
- Test/mock data sources for email and password validation.
- Repository abstraction (`SignUpRepository`).

### **Presentation Layer**
- UI screens and widgets (using existing templates).
- Connects to providers for state and actions.

### **Routing & Guards**
- Modularized GoRoute setup for each sign-up step.
- Planned: sign-up flow guard to enforce correct step sequence.

---

## **Implementation Steps & Checklist**

### **1. Domain & Data Layer Setup**
- [ ] Define domain models for sign-up form and validation state.
- [ ] Create test/mock data sources for email and password validation.
- [ ] Implement repository abstraction for sign-up logic.

### **2. Provider Layer Setup**
- [ ] Create `SignUpFormProvider` (StateNotifier) and state class.
- [ ] Create `SignUpValidationProvider` (StateNotifier/FutureProvider) and state class.
- [ ] Wire up provider dependencies (validation watches form, etc.).

### **3. Presentation Layer Refactor**
- [ ] Refactor sign-up pages to use providers instead of local state.
- [ ] Connect UI templates to provider state and actions.
- [ ] Ensure error messages, loading states, and navigation are handled via providers.

### **4. Validation Logic Implementation**
- [ ] Email: format check, already registered check (via repository), error/loading states.
- [ ] Password: rules (length, complexity), error/loading states.
- [ ] Confirm password: match check, error state.
- [ ] Simulate send verification email (loading, then success/failure).

### **5. Navigation & Flow Control**
- [ ] Only allow navigation to next step if current input is valid (as per provider state).
- [ ] Reset relevant provider state on back navigation or input change.
- [ ] Ensure error and loading states are surfaced to UI and cleared appropriately.

### **6. Add Sign-Up Flow Guard**
- [ ] Create `sign_up_flow_guards.dart` to prevent direct access to later sign-up steps unless previous steps are completed.
- [ ] Integrate this guard into the main router, similar to login flow guards.

### **7. Testing**
- [ ] Test the entire sign-up flow end-to-end: valid/invalid emails, passwords, confirm passwords.
- [ ] Check all error, loading, and success states are displayed correctly.
- [ ] Attempt to skip steps or access screens out of order to verify guard works.
- [ ] Simulate verification and ensure redirecting works as expected.

### **8. Documentation & Handoff**
- [ ] Update this plan/checklist as progress is made.
- [ ] Document any architectural decisions or deviations.
- [ ] Ensure code is commented and easy to pick up later.

---

## **Best Practices & Notes**
- **Separation of Concerns:** Keep form, validation, and repository logic separate.
- **Immutability:** Use immutable state models and `copyWith`.
- **Repository Abstraction:** All async logic goes through repository for easy backend swap.
- **UI/State Decoupling:** UI only interacts with providers, not directly with data.
- **Consistent Error Handling:** All errors and loading states are handled and displayed.
- **Extensibility:** When ready to add Firebase, only the repository and validation provider need to change.
- **Guards:** Enforce correct flow sequence to prevent skipping steps or direct access.

---

## **How to Use This Plan**
- Reference this file at any time to see the current status and next steps.
- Check off items as they are completed.
- If you pause work, update the checklist and leave notes for future resumption.
- If you add new features or flows, copy and adapt this plan.
- If onboarding a new developer, start with this file! 