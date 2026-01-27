# Socialdeck

A multiplayer mobile card game built with Flutter where players use photos from their camera roll to create playable cards and compete in game sessions.

## Tech Stack

- **Flutter/Dart** (SDK 3.7.2+)
- **Riverpod** (State Management with code generation)
- **Firebase** (Authentication, Firestore, Storage)
- **GoRouter** (Navigation)
- **Widgetbook** (Design System Documentation)

## Prerequisites

Before setting up the project, ensure you have the following installed:

### Required
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.7.2 or higher)
- [Git](https://git-scm.com/downloads)
- IDE: [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)

### Android Development
- [Android Studio](https://developer.android.com/studio)
- Android SDK (minimum SDK 23)
- Java 11 or higher
- Android emulator or physical device

### iOS Development (macOS only)
- [Xcode](https://developer.apple.com/xcode/)
- [CocoaPods](https://cocoapods.org/) (`sudo gem install cocoapods`)
- iOS Simulator or physical device

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/TpSoftDev/Socialdeck.git
cd Socialdeck/socialdeck
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Generate Code (Required)

This project uses Riverpod code generation. You **must** run this step or the app won't compile:

```bash
flutter pub run build_runner build
```

This generates `lib/config/routes/routes.g.dart` from Riverpod annotations.

**Note:** Re-run this command whenever you modify `@riverpod` providers.

### 4. Platform-Specific Setup

#### iOS (macOS only)

```bash
cd ios
pod install
cd ..
```

#### Android

No additional setup required. Firebase configuration files are already included.

### 5. Run the App

```bash
flutter run
```

Make sure you have an emulator running or a physical device connected.

## Firebase Configuration

Firebase configuration files are already included in the repository:
- `lib/firebase_options.dart` - Contains API keys and project configuration
- `android/app/google-services.json` - Android Firebase config
- `ios/Runner/GoogleService-Info.plist` - iOS Firebase config

**Firebase Project:** `socialdeck-onboarding-test`

No additional Firebase setup is required. The configs are committed to the repository.

## Widgetbook (Design System Documentation)

This project includes Widgetbook for viewing and testing design system components.

### Setup Widgetbook

```bash
cd widgetbook
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Run Widgetbook

```bash
flutter run -d chrome
```

Widgetbook automatically deploys to GitHub Pages when changes are pushed to `main` branch (see `.github/workflows/deploy_widgetbook.yml`).

## Project Structure

```
lib/
├── config/          # App configuration (routes, constants)
├── design_system/   # Design tokens and reusable components
├── features/        # Feature modules (onboarding, decks, etc.)
│   └── [feature]/
│       ├── data/    # Data layer (repositories, API calls)
│       ├── domain/  # Domain layer (models, state)
│       └── presentation/ # UI layer (pages, widgets)
├── shared/          # Shared providers and utilities
└── test_pages/      # Test/development pages
```

### Architecture

This project follows **Clean Architecture** principles:
- **Feature-based organization** - Each feature is self-contained
- **Separation of concerns** - Data, domain, and presentation layers
- **Design system** - Token-based design system created from Figma

## Development Workflow

### Code Generation

After modifying any `@riverpod` providers, regenerate code:

```bash
flutter pub run build_runner build
```

Or use watch mode for automatic regeneration:

```bash
flutter pub run build_runner watch
```

### Code Style

- Follow the coding style guide in `docs/policies/CODING_STYLE_GUIDE.md`
- Every file should have a header comment block
- Use `SDeck` prefix for design system components
- Match Figma variable names exactly

### Running Tests

```bash
flutter test
```

## Common Issues & Troubleshooting

### App won't compile after cloning

**Solution:** Run code generation:
```bash
flutter pub run build_runner build
```

### iOS build fails

**Solution:** Make sure CocoaPods are installed and up to date:
```bash
cd ios
pod install
cd ..
```

### Firebase errors

**Solution:** Verify Firebase config files exist:
- `lib/firebase_options.dart`
- `android/app/google-services.json` (Android)
- `ios/Runner/GoogleService-Info.plist` (iOS)

### Widgetbook won't run

**Solution:** Make sure you're in the widgetbook directory and have run build_runner:
```bash
cd widgetbook
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

## Verification

To verify your setup is working:

1. ✅ Run `flutter doctor` - Should show no critical issues
2. ✅ Run `flutter pub get` - Should complete without errors
3. ✅ Run `flutter pub run build_runner build` - Should generate files
4. ✅ Run `flutter run` - App should launch on emulator/device
5. ✅ Navigate through onboarding flow - Should work end-to-end

## Documentation

- **Coding Standards:** `docs/policies/CODING_STYLE_GUIDE.md`
- **Design System Process:** `docs/policies/DESIGN_SYSTEM_REFACTOR_PROCESS.md`
- **Figma Integration:** `docs/cursor/Figma Integration Rules.md`
- **Project Plans:** `docs/plans/`

## Contributing

1. Create a feature branch from `main`
2. Make your changes following the coding standards
3. Run code generation if you modified `@riverpod` providers
4. Test your changes
5. Submit a pull request

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
