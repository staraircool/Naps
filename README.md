# NAPCOIN Flutter App

A playful sleep-to-earn crypto mining mobile application built with Flutter.

## Features

- **Sleep-to-Earn Mining**: Earn NAP tokens while you sleep
- **Background Mining**: Mining continues even when the app is closed
- **Referral System**: Invite friends to increase your mining rate
- **Beautiful UI**: Lofi animations and smooth transitions
- **Local Storage**: All data stored securely on your device

## App Flow

1. **Onboarding Screen**: "EARN WHILE NAP" with swipe up transition
2. **Welcome Screen**: Sign up/Sign in with animated panda
3. **Home Screen**: View balance, mining rate, and start nap sessions
4. **Sleep Screen**: Dark theme with sleeping panda and countdown timer
5. **Navigation**: Drawer with Home, Invite, Withdraw, FAQ, and Sign Out

## Mining Logic

- **Base Rate**: 4.33333 NAP/hour
- **Session Length**: 12 hours
- **Referral Bonus**: +1.33333 NAP/hour per friend invited
- **Background Mining**: Continues even when app is closed

## Technical Details

- **Framework**: Flutter 3.24.5
- **Local Storage**: SharedPreferences
- **Dependencies**: 
  - shared_preferences: ^2.2.2
  - uuid: ^4.2.1
  - url_launcher: ^6.2.2

## Setup Instructions

1. **Install Flutter**: Make sure Flutter SDK is installed and configured
2. **Get Dependencies**: Run `flutter pub get` in the project directory
3. **Run the App**: Use `flutter run` to start the application

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── services/
│   └── mining_service.dart   # Background mining logic
├── screens/
│   ├── onboarding_screen.dart
│   ├── welcome_screen.dart
│   ├── home_screen.dart
│   ├── sleep_screen.dart
│   ├── invite_screen.dart
│   ├── faq_screen.dart
│   └── referral_input_screen.dart
└── assets/
    └── images/               # UI design assets
```

## FAQ

**Q: Do I need to keep the app open for mining?**
A: No. Once the nap session starts, mining continues even if you close the app.

**Q: Can I earn more NAP?**
A: Yes! Invite friends and increase your mining rate with each referral.

**Q: How long is each mining session?**
A: Each mining session lasts for 12 hours.

## Future Features

- Supabase integration for authentication
- Cloud data backup
- Withdrawal functionality
- Sound effects and enhanced animations

## Development Notes

This is the frontend implementation. Backend integration with Supabase will be added in future updates. The app currently uses local storage for all data persistence.

---

**Built for the Dreamers, Not the Grinders** 🐼💤

