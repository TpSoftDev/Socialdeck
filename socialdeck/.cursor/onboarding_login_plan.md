# Onboarding Login Flow: Implementation Plan & Checklist

## **Overview**
This document outlines the comprehensive plan for implementing the onboarding login flow in the Socialdeck app using Riverpod and clean architecture. It covers not only provider setup, but also all supporting layers, UI integration, and testing. This plan is designed to be referenced throughout development and whenever work resumes on this feature.

---

## **Project Goals**
- Build a scalable, maintainable, and testable login flow using Riverpod.
- Follow clean architecture: separate data, domain, provider, and presentation layers.
- Ensure the architecture is reusable for sign-up and profile flows.
- Start with fake/test data, but make it easy to swap in Firebase later.
- Match the Figma design and UX exactly.

---

## **Architecture Overview**

### **Provider Layer (State Management)**
- **LoginFormProvider:** Manages UI state (input values, button enabled, field visuals).
- **LoginValidationProvider:** Handles async validation (e.g., username existence, password check), loading, and error states.
- **LoginNavigationProvider:** Controls which screen is shown (username, card display, password), and persists data between steps.

### **Domain Layer**
- Models for form state, validation state, and navigation state.
- Use cases for validation and business logic.

### **Data Layer**
- Fake/test data sources (e.g., `TestUserDatabase`, `TestAuthService`).
- Repository abstraction (`LoginRepository`).

### **Presentation Layer**
- UI screens and widgets (using existing templates).
- Connects to providers for state and actions.

---

## **Implementation Steps & Checklist**

### **1. Domain & Data Layer Setup**
- [ ] Define domain models for login form, validation, and navigation state.
- [ ] Create fake/test data sources for users and authentication.
- [ ] Implement repository abstraction for login logic.

### **2. Provider Layer Setup**
- [ ] Create `LoginFormProvider` (StateNotifier) and state class.
- [ ] Create `LoginValidationProvider` (StateNotifier/FutureProvider) and state class.
- [ ] Create `LoginNavigationProvider` (StateNotifier) and state class.
- [ ] Wire up provider dependencies (e.g., validation watches form, navigation watches validation).

### **3. Presentation Layer Refactor**
- [ ] Refactor login pages to use providers instead of local state.
- [ ] Connect UI templates to provider state and actions.
- [ ] Ensure error messages, loading states, and navigation are handled via providers.

### **4. UI/UX Polish**
- [ ] Ensure all Figma design details are matched (spacing, error visuals, button states).
- [ ] Test all edge cases (invalid username, wrong password, async loading, etc.).

### **5. Testing**
- [ ] Write unit tests for providers and domain logic.
- [ ] Write widget tests for login flow.

### **6. Documentation & Handoff**
- [ ] Update this plan/checklist as progress is made.
- [ ] Document any architectural decisions or deviations.
- [ ] Ensure code is commented and easy to pick up later.

---

## **How to Use This Plan**
- Reference this file at any time to see the current status and next steps.
- Check off items as they are completed.
- If you pause work, update the checklist and leave notes for future resumption.
- If you add new features or flows (e.g., sign-up, profile), copy and adapt this plan.

---

## **Notes**
- This plan is for the login flow, but the same architecture will be used for sign-up and profile onboarding.
- If you ever need to swap in Firebase or another backend, only the data/repository layer needs to change.
- If you have questions or need to onboard a new developer, start with this file! 