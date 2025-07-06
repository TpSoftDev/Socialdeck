# Socialdeck Onboarding Architecture & Flow

---

## 1. Folder & File Structure: What Goes Where and Why

### **A. Folders**
- **data/**:  
  Holds repositories and test/mock data.  
  *Purpose:* Abstracts data source (test data now, Firebase later).

- **domain/**:  
  Contains state models (form state, validation state), enums, and business logic.  
  *Purpose:* Keeps business logic and state definitions separate from UI and data.

- **providers/**:  
  Houses Riverpod providers (StateNotifiers) for managing state and validation.  
  *Purpose:* Centralizes state management, making it easy to test and maintain.

- **presentation/**:  
  Contains UI pages and widgets for each step of the onboarding flow.  
  *Purpose:* Keeps UI logic separate from state and data.

---

### **B. Key Files and Their Roles**

| File/Filename                        | Purpose/Tracks                                      | Synchronous/Async | Why Needed?                                      |
|--------------------------------------|----------------------------------------------------|-------------------|--------------------------------------------------|
| sign_up_form_provider.dart           | Tracks form field values, button states             | Sync              | UI reactivity, immediate feedback                |
| sign_up_validation_provider.dart     | Tracks loading, errors, async validation            | Async             | Handles all async checks and feedback            |
| sign_up_form_state.dart              | Immutable snapshot of form state                    | Sync              | Predictable, testable state                      |
| sign_up_validation_state.dart        | Immutable snapshot of validation state              | Async             | Predictable, testable validation                 |
| sign_up_repository.dart              | Abstracts validation logic (email, username, etc.)  | Async             | Swappable data source                            |

---

## 2. State Management: Synchronous vs. Asynchronous

- **Synchronous (Form Provider):**  
  Tracks what the user is typing, field focus, button enabled/disabled, etc.  
  Immediate feedback (e.g., "Next" button lights up when field is filled).

- **Asynchronous (Validation Provider):**  
  Handles anything that requires waiting (e.g., checking if email is taken, sending verification email).  
  Shows loading spinners, error messages, and success states.

---

## 3. Onboarding Flow (Screens & Navigation)

### **A. Login Flow**
- Username/email entry
- Password entry
- (Optional) "Is this your card?" confirmation
- **Edge Cases:** Invalid username/password, resets state on back navigation

### **B. Sign-Up Flow**
- Email entry (async: is email valid/registered?)
- Password entry (sync: field filled, async: requirements met)
- Confirm password (sync: passwords match)
- Email verification (send verification, change email)
- Redirecting (loading)
- Profile creation (username, photo upload, adjust photo, display photo)
- Invite friends (final step, can skip)
- **Edge Cases:** Email already registered, password requirements, passwords don't match, username taken, photo selection errors, skip invite

### **C. Profile Creation**
- Username entry (async check for availability)
- Add profile card (photo upload)
- Adjust profile photo
- Display final profile card
- **Edge Cases:** Can go back and re-adjust photo, data saved for login testing

### **D. Shared Templates**
- OnboardingInputTemplate: Used for all input screens
- OnboardingInfoTemplate: Used for info/verification/loading screens
- OnboardingProfileCardTemplate: Used for profile photo steps

---

## 4. Edge Cases & Special Flows
- Invite Friends: Final onboarding step, can be skipped or completed
- Photo Picker: Handles camera/gallery selection, errors, and permissions
- Profile Data Persistence: Profile photo adjustments/data saved for later use
- Back Navigation: Custom logic to reset state and clear errors
- Loading/Redirecting: Dedicated screen for async operations
- Change Email: Option to go back and change email before verification

---

## 5. Why This Architecture is Sufficient & Scalable
- **Separation of Concerns:** UI, state, and data are cleanly separated
- **Provider Pattern:** Synchronous and async state are managed independently
- **Repository Abstraction:** Easy to swap test data for Firebase or other sources
- **Extensibility:** New steps, fields, or flows can be added with minimal refactoring
- **Edge Case Handling:** All navigation and error scenarios are covered by the current structure
- **Reusability:** UI templates and state patterns can be reused for future onboarding or auth flows

---

## 6. Future Considerations
- Invite friends functionality can be expanded using the same provider/repository approach
- Additional verification steps (e.g., phone) can be added by extending state and validation logic
- All async operations (e.g., email verification, username check) can be swapped to real backend/Firebase with minimal changes

---

*This document serves as a reference for onboarding architecture, state management, and flow. Update as the project evolves!* 