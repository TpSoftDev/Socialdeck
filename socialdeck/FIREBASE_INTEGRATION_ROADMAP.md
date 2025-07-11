# Firebase Integration Roadmap for Socialdeck

## 📊 **Current Integration Status**

### ✅ **Already Implemented**
- [x] Firebase Core setup and initialization
- [x] Firebase Auth user creation (email/password)
- [x] Email verification sending and polling
- [x] Firebase project configuration (`socialdeck-onboarding-test`)
- [x] Android/iOS configuration files
- [x] UI components for Google/Apple sign-in buttons
- [x] Dependencies: `firebase_core`, `firebase_auth`, `cloud_firestore`

### ⚠️ **Partially Implemented**
- [ ] Auth state management (still using manual boolean provider)
- [ ] Email availability checking (documented but not implemented)
- [ ] Profile data storage (test repositories only)

### ❌ **Not Started**
- [ ] Google OAuth integration
- [ ] Apple OAuth integration  
- [ ] Firestore user profile storage
- [ ] Firebase Storage for images
- [ ] Real login with Firebase Auth
- [ ] Username uniqueness checking in Firestore

---

## 🎯 **Implementation Phases**

### **Phase 1: Core Authentication (High Priority)**

#### Task 1.1: Replace Auth State Provider with Firebase Auth Stream
**Location**: `lib/features/onboarding/shared/providers/auth_state_provider.dart`

**Current Issue**: Using manual boolean state instead of Firebase Auth state
```dart
// Current (manual)
final authStateProvider = StateNotifierProvider<AuthStateNotifier, bool>

// Target (Firebase-connected)
final authStateProvider = StreamProvider<User?>
```

**Implementation Steps**:
- [ ] Replace `AuthStateNotifier` with `StreamProvider` that listens to `FirebaseAuth.instance.authStateChanges()`
- [ ] Update auth guards to use `User?` instead of `bool`
- [ ] Update all UI components that check auth state
- [ ] Test login/logout flows

**Files to Modify**:
- `lib/features/onboarding/shared/providers/auth_state_provider.dart`
- `lib/config/routes/guards/auth_guards.dart`
- `lib/features/home/presentation/pages/home.dart`
- `lib/features/login/presentation/pages/login_password_page.dart`

---

#### Task 1.2: Implement Google OAuth Sign-In
**Dependencies Needed**:
```yaml
dependencies:
  google_sign_in: ^6.1.5
```

**Implementation Steps**:
- [ ] Add `google_sign_in` dependency to `pubspec.yaml`
- [ ] Configure Google Sign-In in Firebase Console
- [ ] Create `GoogleAuthService` class
- [ ] Update button in `OnboardingInputTemplate` to call actual Google sign-in
- [ ] Handle Google sign-in errors and edge cases
- [ ] Test on both Android and iOS

**Files to Create/Modify**:
- `lib/features/onboarding/shared/services/google_auth_service.dart` (new)
- `lib/features/onboarding/shared/templates/onboarding_input_template.dart`

**Code Example**:
```dart
// Replace this in onboarding_input_template.dart:
onPressed: () => print('Continue with Google'),

// With this:
onPressed: () => ref.read(googleAuthProvider.notifier).signInWithGoogle(),
```

---

#### Task 1.3: Implement Apple OAuth Sign-In
**Dependencies Needed**:
```yaml
dependencies:
  sign_in_with_apple: ^5.0.0
```

**Implementation Steps**:
- [ ] Add `sign_in_with_apple` dependency to `pubspec.yaml`
- [ ] Configure Apple Sign-In in Firebase Console and Apple Developer Portal
- [ ] Create `AppleAuthService` class
- [ ] Update button in `OnboardingInputTemplate` to call actual Apple sign-in
- [ ] Handle Apple sign-in errors and edge cases
- [ ] Test on iOS (Apple sign-in not available on Android)

**Files to Create/Modify**:
- `lib/features/onboarding/shared/services/apple_auth_service.dart` (new)
- `lib/features/onboarding/shared/templates/onboarding_input_template.dart`

---

#### Task 1.4: Implement Email Availability Check
**Reference**: Your `EMAIL_AVAILABILITY_CHECK.md` document

**Implementation Steps**:
- [ ] Create `EmailAvailabilityService` class
- [ ] Implement dummy password sign-in attempt method
- [ ] Handle Firebase Auth error codes (`user-not-found`, `wrong-password`, etc.)
- [ ] Integrate with sign-up email validation provider
- [ ] Add loading states and user feedback

**Files to Create/Modify**:
- `lib/features/onboarding/sign_up/services/email_availability_service.dart` (new)
- `lib/features/onboarding/sign_up/providers/sign_up_validation_provider.dart`

**Code Implementation Preview**:
```dart
Future<bool> isEmailAvailable(String email) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email, 
      password: 'dummyPassword123!'
    );
    return false; // Email exists (shouldn't reach here)
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') return true; // Email available
    if (e.code == 'wrong-password') return false; // Email taken
    if (e.code == 'invalid-email') throw 'Invalid email format';
    throw 'Network error';
  }
}
```

---

### **Phase 2: Data Persistence (Medium Priority)**

#### Task 2.1: Create Firebase Profile Repository
**Target**: Replace `TestProfileRepository` with `FirebaseProfileRepository`

**Implementation Steps**:
- [ ] Create `FirebaseProfileRepository` class implementing `ProfileRepository`
- [ ] Design Firestore collection structure for user profiles
- [ ] Implement username uniqueness checking in Firestore
- [ ] Implement profile data storage/retrieval
- [ ] Link profiles to Firebase Auth UID
- [ ] Update providers to use Firebase repository

**Firestore Structure Design**:
```
users/{uid}/
  ├── email: string
  ├── username: string  
  ├── profileImageUrl: string
  ├── createdAt: timestamp
  ├── verified: boolean
  └── onboardingCompleted: boolean

usernames/{username}/
  └── uid: string  // For username uniqueness checking
```

**Files to Create/Modify**:
- `lib/features/onboarding/profile/data/firebase_profile_repository.dart` (new)
- `lib/features/onboarding/profile/providers/profile_validation_provider.dart`

---

#### Task 2.2: Implement Firebase Storage for Profile Images
**Implementation Steps**:
- [ ] Add Firebase Storage rules in Firebase Console
- [ ] Create `ProfileImageService` class
- [ ] Implement image upload to Firebase Storage
- [ ] Generate and store download URLs
- [ ] Update profile repository to handle image URLs
- [ ] Add image compression/optimization
- [ ] Handle upload progress and errors

**Files to Create/Modify**:
- `lib/features/onboarding/profile/services/firebase_storage_service.dart` (new)
- `lib/features/onboarding/profile/presentation/services/profile_photo_picker_service.dart`

---

#### Task 2.3: Create Firebase Onboarding Submission Repository
**Target**: Replace `TestOnboardingSubmissionRepository`

**Implementation Steps**:
- [ ] Create `FirebaseOnboardingSubmissionRepository`
- [ ] Aggregate sign-up and profile data
- [ ] Store complete user profile in Firestore
- [ ] Mark onboarding as completed
- [ ] Handle transaction failures and rollbacks
- [ ] Update submission provider to use Firebase repository

**Files to Create/Modify**:
- `lib/features/onboarding/shared/data/firebase_onboarding_submission_repository.dart` (new)
- `lib/features/onboarding/shared/providers/onboarding_submission_provider.dart`

---

### **Phase 3: Login Integration (Lower Priority)**

#### Task 3.1: Create Firebase Login Repository
**Target**: Replace `TestLoginRepository` with real Firebase queries

**Implementation Steps**:
- [ ] Create `FirebaseLoginRepository` class
- [ ] Implement email/password sign-in with Firebase Auth
- [ ] Query user profiles from Firestore after authentication
- [ ] Handle login errors and edge cases
- [ ] Update login providers to use Firebase repository
- [ ] Test integration with OAuth sign-in methods

**Files to Create/Modify**:
- `lib/features/login/data/firebase_login_repository.dart` (new)
- `lib/features/login/providers/login_validation_provider.dart`

---

### **Phase 4: Polish & Advanced Features (Future)**

#### Task 4.1: State Persistence & Recovery
- [ ] Save onboarding progress with `shared_preferences`
- [ ] Resume incomplete flows on app restart
- [ ] Handle network connectivity issues
- [ ] Implement retry mechanisms

#### Task 4.2: Security & Rate Limiting
- [ ] Add Firebase App Check for bot protection
- [ ] Implement rate limiting for auth attempts
- [ ] Add input validation and sanitization
- [ ] Configure security rules for Firestore

#### Task 4.3: Analytics & Monitoring
- [ ] Add Firebase Analytics for user journey tracking
- [ ] Implement Crashlytics for error monitoring
- [ ] Add performance monitoring
- [ ] Track conversion rates for different auth methods

---

## 🛠 **Development Guidelines**

### **Testing Strategy**
1. **Unit Tests**: Test each repository and service independently
2. **Integration Tests**: Test auth flows end-to-end
3. **Platform Tests**: Test OAuth on both Android and iOS
4. **Error Handling**: Test network failures and edge cases

### **Code Organization**
- Keep Firebase-specific code in separate services/repositories
- Maintain interface abstractions for easy testing
- Use dependency injection for repository swapping
- Follow existing folder structure patterns

### **Deployment Considerations**
- Test with real Firebase project before production
- Configure proper security rules for Firestore
- Set up different Firebase projects for dev/staging/prod
- Monitor costs for Storage and Firestore usage

---

## 📋 **Quick Reference Checklist**

### **Phase 1: Core Auth** 
- [ ] Firebase Auth State Provider
- [ ] Google OAuth Implementation  
- [ ] Apple OAuth Implementation
- [ ] Email Availability Check

### **Phase 2: Data Storage**
- [ ] Firebase Profile Repository
- [ ] Firebase Storage for Images
- [ ] Firebase Onboarding Submission

### **Phase 3: Login Integration**
- [ ] Firebase Login Repository
- [ ] OAuth + Email Login Integration

### **Phase 4: Advanced Features**
- [ ] State Persistence
- [ ] Security & Rate Limiting
- [ ] Analytics & Monitoring

---

## 🎯 **Next Action**
**Recommended Starting Point**: Begin with Task 1.1 (Replace Auth State Provider) as it's the foundation for all other Firebase auth features.

---

*Last Updated: [Current Date]*
*Project: Socialdeck Onboarding*
*Firebase Project: socialdeck-onboarding-test* 