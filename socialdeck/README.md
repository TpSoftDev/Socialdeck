# Socialdeck

A modern Flutter mobile application that lets users **build, play, and share** their photo collections through customizable decks. Socialdeck combines social networking with a unique card-based interface for organizing and sharing memories.

## 📱 Overview

Socialdeck is a cross-platform mobile application that transforms photo sharing into an interactive experience. Users can create personalized profile cards, organize photos into decks, and engage with a community through an intuitive, beautifully designed interface.

### Key Features

- **🎴 Deck Creation**: Create custom decks from your photo library with an Instagram-like photo selection interface
- **👤 Profile Management**: Design personalized profile cards with custom avatars and usernames
- **🔐 Secure Authentication**: Firebase Authentication with Google Sign-in support
- **🌓 Theme Support**: Built-in light and dark mode with system preference detection
- **📸 Photo Management**: Advanced camera roll integration with album selection and infinite scroll
- **🎯 Social Features**: Connect with other users and share your decks
- **🏪 Store**: In-app store functionality (in development)

## 🏗️ Architecture

The project follows **Clean Architecture** principles with a feature-based structure:

```
lib/
├── features/              # Feature modules
│   ├── decks/            # Deck creation and management
│   ├── home/             # Home dashboard
│   ├── login/            # Authentication flows
│   ├── onboarding/       # User onboarding (sign up, profile creation)
│   ├── profile/          # User profile management
│   ├── social/           # Social networking features
│   ├── store/            # Store functionality
│   └── welcome/          # Welcome/landing page
├── design_system/        # Reusable UI components
│   ├── components/       # Buttons, cards, inputs, navigation
│   ├── foundations/      # Colors, typography, themes
│   ├── themes/           # Theme configurations
│   └── tokens/           # Design tokens (colors, spacing, shadows)
├── config/               # App configuration
│   └── routes/           # Navigation and routing
└── shared/               # Shared utilities and providers
```

### Architecture Layers

Each feature module is organized into three layers:

- **Presentation Layer**: UI components (pages, widgets) and view models
- **Domain Layer**: Business logic, entities, and validation states
- **Data Layer**: Repositories and data sources (Firebase, local storage)

## 🛠️ Tech Stack

### Core Framework
- **Flutter SDK**: 3.7.2+
- **Dart**: 3.7.2+

### State Management & Navigation
- **flutter_riverpod** (2.6.1): State management
- **riverpod_annotation** (2.6.1): Code generation for providers
- **go_router** (15.1.3): Declarative routing with guards

### Backend & Authentication
- **Firebase Core** (3.13.1): Firebase platform integration
- **Firebase Auth** (5.5.4): User authentication
- **Cloud Firestore** (5.6.8): NoSQL database
- **Firebase Storage** (12.3.4): File storage
- **google_sign_in** (6.2.1): Google authentication

### UI & Design
- **flutter_svg** (2.0.10): SVG rendering
- **auto_size_text** (3.0.0): Responsive text sizing
- **dotted_border** (2.1.0): Decorative borders
- **flutter_native_splash** (2.4.6): Native splash screens

### Media & Permissions
- **image_picker** (1.0.7): Camera/gallery access
- **photo_manager** (3.2.0): Photo library management
- **crop_your_image** (2.0.0): Image cropping
- **flutter_image_compress** (2.1.0): Image optimization
- **permission_handler** (11.3.1): Permission management

### Utilities
- **intl** (0.20.2): Internationalization
- **shared_preferences** (2.2.2): Local data persistence

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.7.2 or higher
- Dart SDK 3.7.2 or higher
- iOS development: Xcode 14+ (for iOS)
- Android development: Android Studio with SDK 21+ (for Android)
- Firebase project with Auth, Firestore, and Storage enabled

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd socialdeck
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Place your `google-services.json` in `android/app/`
   - Place your `GoogleService-Info.plist` in `ios/Runner/`
   - Ensure `firebase_options.dart` is configured correctly

4. **Generate code (for Riverpod providers)**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. **Run the app**
   ```bash
   # iOS
   flutter run -d ios
   
   # Android
   flutter run -d android
   ```

## 📦 Build & Deploy

### Development Build
```bash
flutter run --debug
```

### Release Build

**Android (APK)**
```bash
flutter build apk --release
```

**Android (App Bundle)**
```bash
flutter build appbundle --release
```

**iOS**
```bash
flutter build ios --release
```

## 🎨 Design System

Socialdeck features a comprehensive custom design system with:

- **Color System**: Semantic color tokens supporting light and dark modes
- **Typography**: Poppins font family with 7 weights
- **Components**: Pre-built, reusable UI components
  - Buttons (Solid, Hollow)
  - Cards (Profile, Playing, Display, Adjust)
  - Inputs (Custom text fields)
  - Navigation (Bottom nav, Top nav bars)
  - Icons (Light/Dark variants with fill, stroke, and misc styles)
- **Spacing**: Consistent spacing tokens (x4, x8, x16, etc.)
- **Shadows**: Elevation system for depth
- **Radius**: Consistent corner radius values

### Theme Usage

```dart
// Access theme colors
Theme.of(context).colorScheme.primary

// Access typography
Theme.of(context).textTheme.h6

// Access custom extensions
context.icons.home  // Icon assets
context.spacing     // Spacing values
```

## 📁 Project Structure Highlights

### Features

- **Onboarding Flow**: Welcome → Sign Up → Email Verification → Profile Creation
- **Authentication**: Email/password and Google Sign-in
- **Profile Creation**: Custom profile cards with photo upload and cropping
- **Deck Management**: Instagram-style photo picker with album selection
- **Navigation Guards**: Protected routes based on authentication state

### Routes

The app uses `go_router` with declarative routing:

- `/welcome` - Landing page
- `/sign-up` - Registration flow
- `/login` - Authentication flow
- `/home` - Main dashboard (protected)
- `/profile` - User profile (protected)
- `/decks` - Deck management (protected)
- `/social` - Social features (protected)
- `/store` - Store page (protected)

## 🔒 Security & Permissions

The app requires the following permissions:

### iOS (Info.plist)
- `NSPhotoLibraryUsageDescription`: Access to photo library
- `NSCameraUsageDescription`: Camera access for profile photos

### Android (AndroidManifest.xml)
- `READ_EXTERNAL_STORAGE`: Read photos
- `CAMERA`: Camera access
- `INTERNET`: Network access for Firebase

## 🧪 Testing

Run tests with:

```bash
flutter test
```

Widget tests are located in the `test/` directory.

## 📝 Development Notes

### Code Generation

The project uses code generation for Riverpod providers. After modifying provider files:

```bash
# Watch mode (auto-generates on file changes)
dart run build_runner watch

# One-time generation
dart run build_runner build --delete-conflicting-outputs
```

### Linting

The project follows Flutter lints. Check for issues:

```bash
flutter analyze
```

### Formatting

Format code with:

```bash
flutter format .
```

## 🌐 Platform Support

- ✅ iOS (14.0+)
- ✅ Android (API 21+)
- ⚠️ Web (partial support)
- ⚠️ macOS (partial support)
- ⚠️ Linux (partial support)
- ⚠️ Windows (partial support)

*Primary focus is on iOS and Android platforms*

## 📱 Screenshots

*(Screenshots to be added)*

## 🤝 Contributing

1. Create a feature branch (`git checkout -b feature/AmazingFeature`)
2. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
3. Push to the branch (`git push origin feature/AmazingFeature`)
4. Open a Pull Request

## 📄 License

*(License information to be added)*

## 👥 Team

*(Team information to be added)*

## 🐛 Known Issues & TODOs

- [ ] Profile Creation: Check if username is taken
- [ ] Complete store functionality
- [ ] Add comprehensive test coverage
- [ ] Implement deck sharing functionality
- [ ] Add social feed features

## 📞 Support

For support and questions, please contact *(contact information to be added)*

---

**Built with ❤️ using Flutter**
