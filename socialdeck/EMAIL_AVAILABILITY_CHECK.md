# Email Availability Check with Firebase (Client-Side)

## Why This Approach?
- **Firebase Auth does NOT provide a direct API to check if an email is already registered.**
- For security reasons, you cannot simply ask Firebase "does this email exist?".
- The only way to check is to try to sign in with the email and see what error Firebase returns.

## How Does It Work?
- When the user enters their email and presses Next, we try to sign in with that email and a dummy password (e.g., 'dummyPassword123!').
- We do NOT care about the password—we just want to see what error code Firebase gives us.
- We never actually sign in or create a user with this method.

## What Do the Error Codes Mean?
- **`user-not-found`**: No account exists with this email. The email is available for sign-up.
- **`wrong-password`**: An account exists with this email, but the password is wrong. The email is already registered.
- **`invalid-email`**: The email format is invalid (e.g., missing '@' or '.').
- **Other errors**: Network issues, too many requests, etc. Show a generic error message.

## Why Not Use a Different Method?
- There is no client-side Firebase API to check email existence directly.
- Creating a user with a dummy password is risky (could create unwanted accounts).
- Backend/Admin SDK checks require a secure server, which is overkill for most apps.

## Summary Table
| What We Try                | What Firebase Returns      | What We Learn                |
|----------------------------|---------------------------|------------------------------|
| Email + dummy password     | `user-not-found`          | Email is available           |
| Email + dummy password     | `wrong-password`          | Email is already registered  |
| Email + dummy password     | `invalid-email`           | Email format is invalid      |
| Email + dummy password     | Other error               | Something else went wrong    |

## Notes
- This is a workaround due to Firebase limitations, but is widely used in client-side apps.
- Always handle all error codes and show clear feedback to the user.
- If you ever add a backend, you can use the Firebase Admin SDK for a more robust check. 