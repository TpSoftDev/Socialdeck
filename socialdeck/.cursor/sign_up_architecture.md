# Socialdeck Sign-Up Architecture & Flow

---

## 1. **Folder and File Structure: What Goes Where and Why**

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
  Contains UI pages and widgets for each step of the sign-up flow.  
  *Purpose:* Keeps UI logic separate from state and data.

---

### **B. Key Files and Their Roles**

#### **Form Provider (`sign_up_form_provider.dart`)**
- **Tracks:** Synchronous UI state (input values, field visual states, button enabled/disabled).
- **Why:**  
  - Keeps the UI reactive and in sync with user input.
  - Handles simple, immediate updates (e.g., typing in a field, toggling password visibility).
- **Example State:**  
  - Email, password, confirm password, username, profile photo path, etc.
  - Field visual states (hint, filled, error, success).
  - Is "Next" button enabled?

#### **Validation Provider (`sign_up_validation_provider.dart`)**
- **Tracks:** Asynchronous validation state (loading, error, success, field validation).
- **Why:**  
  - Handles async checks (e.g., is email already registered? Is username available?).
  - Manages loading spinners, error messages, and success feedback.
- **Example State:**  
  - Is loading, error message, is validation successful, field visual states.

#### **Form State (`sign_up_form_state.dart`)**
- **Tracks:** Immutable snapshot of all current form values and their UI states.
- **Why:**  
  - Ensures state is predictable and easy to update immutably.
  - Used by the form provider.

#### **Validation State (`sign_up_validation_state.dart`)**
- **Tracks:** Immutable snapshot of all async validation states.
- **Why:**  
  - Keeps validation logic clean and testable.
  - Used by the validation provider.

#### **Repository (`sign_up_repository.dart` and `test_sign_up_repository.dart`)**
- **Tracks:** Data access and validation logic (test data now, Firebase later).
- **Why:**  
  - Abstracts away the data source, making it easy to swap implementations.
  - Handles logic like:  
    - Is email already registered?  
    - Is username available?  
    - Does password meet requirements?  
    - (Later) Send verification email.

---

## 2. **Synchronous vs. Asynchronous State**

- **Synchronous (Form Provider):**  
  - Tracks what the user is typing, field focus, button enabled/disabled, etc.
  - Immediate feedback (e.g., "Next" button lights up when field is filled).

- **Asynchronous (Validation Provider):**  
  - Handles anything that requires waiting (e.g., checking if email is taken, sending verification email).
  - Shows loading spinners, error messages, and success states.

---

## 3. **Analyzing the Onboarding Flow (Based on Screenshots)**

### **A. Sign-Up Flow Steps**
1. **Email Entry:**  
   - User enters email.
   - Async validation: Is email valid? Is it already registered?
   - Error/success feedback.

2. **Password Entry:**  
   - User enters password.
   - Synchronous: Is field filled?
   - Async: Does password meet requirements?

3. **Confirm Password:**  
   - User re-enters password.
   - Synchronous: Do passwords match?

4. **Send Verification:**  
   - User sees their email, clicks "Send Verification."
   - Async: Send verification email (simulated for now).

5. **Redirecting:**  
   - Shows a loading/redirecting screen while waiting for verification.

6. **Profile Creation:**  
   - User creates username (async check for availability).
   - User uploads/adjusts profile photo.

---

### **B. Will This Approach Scale?**

**Yes, Approach 1 will scale well for this flow:**
- Each step can have its own state and validation logic, keeping things modular.
- Async validation (email, username) is handled cleanly in the validation provider.
- Synchronous state (field values, button states) is managed in the form provider.
- The repository pattern makes it easy to swap in Firebase for any async operation.
- The folder structure keeps business logic, state, and UI cleanly separated.
- Adding new steps (e.g., phone verification, additional profile fields) is straightforward—just add new state fields and validation logic as needed.

---

## 4. **Potential Edge Cases and Considerations**
- **Email Verification:**  
  - The validation provider can handle sending the verification email and tracking its status.
  - The redirecting page can be triggered by a state change (e.g., "verification sent").
- **Profile Creation:**  
  - Username and photo can be managed by extending the form/validation state.
  - Async username availability check fits the same pattern as email validation.
- **Error Handling:**  
  - All error messages and field states are tracked in validation state, making UI updates easy.

---

## 5. **Summary Table**

| File/Folder                  | Purpose/Tracks                                      | Synchronous/Async | Why Needed?                                      |
|------------------------------|----------------------------------------------------|-------------------|--------------------------------------------------|
| data/                        | Repositories, test data                            | Async             | Abstracts data source, easy to swap for Firebase |
| domain/                      | State models, enums, business logic                | Both              | Keeps logic and state definitions clean           |
| providers/                   | Riverpod providers (form, validation)              | Both              | Centralizes state management                     |
| presentation/                | UI pages, widgets                                 | N/A               | Keeps UI logic separate                          |
| sign_up_form_provider.dart   | Tracks form field values, button states            | Sync              | UI reactivity, immediate feedback                |
| sign_up_validation_provider.dart | Tracks loading, errors, async validation      | Async             | Handles all async checks and feedback            |
| sign_up_form_state.dart      | Immutable snapshot of form state                   | Sync              | Predictable, testable state                      |
| sign_up_validation_state.dart| Immutable snapshot of validation state             | Async             | Predictable, testable validation                 |
| sign_up_repository.dart      | Abstracts validation logic (email, username, etc.) | Async             | Swappable data source                            |

---

## 6. **Challenge & Next Steps**

- **Does this breakdown make sense to you?**
- **Do you see any steps or states in the screenshots that might require a different approach?**
- **Are there any edge cases or future features you want to plan for now?**

**If you're happy with this plan, I'll break down the implementation into clear, beginner-friendly steps and get your approval before starting.**  
Let me know your thoughts or any questions! 