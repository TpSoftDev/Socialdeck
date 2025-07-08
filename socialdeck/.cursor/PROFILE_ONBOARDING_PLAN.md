# Profile Onboarding Refactor & Cleanup Plan

## 1. Current State
- UI pages use local state and navigation-based state passing (URL params).
- Temporary/test code exists (display page, test_profile_storage).
- Providers and state classes are set up but not yet integrated into the UI.
- Photo picker service is a utility, not integrated with providers.

## 2. Cleanup Tasks
- Remove `display_profile_page.dart` if not needed.
- Remove `test_profile_storage.dart` and any device storage logic.
- Remove all navigation-based state passing (URL params for imagePath, scale, etc.).

## 3. Refactor Plan
- **Username Page:**
  - Use `ProfileFormProvider` for the username value.
  - Use `ProfileValidationProvider` for validation and feedback.
- **Add Card Page:**
  - On photo pick, update `ProfileFormProvider` with the image path.
- **Adjust Page:**
  - On adjustment, update `ProfileFormProvider` with scale, panX, panY.
  - No more passing data via navigation or device storage.
- **Submission:**
  - At the end, all profile data is in the provider—ready for Firebase or further processing.

## 4. Image Storage & Retrieval
- For now: Store image path and transform data in the provider.
- For Firebase: Implement image upload in the repository, store download URL and transform data in Firestore.

## 5. Testing Strategy
- Use providers and mock repos for onboarding flow testing.
- Move to Firebase integration for real data and login/profile linkage when ready.

## 6. Best Order of Events
1. Clean up placeholder/test code and remove unnecessary files.
2. Refactor UI to use providers for all state and validation.
3. Test onboarding flow with providers and mock repos.
4. Add Firebase integration for real data storage and retrieval.
5. Test login/profile integration with real backend data.

---
*This file is a living reference for the current plan. Update as you make progress or change direction.* 