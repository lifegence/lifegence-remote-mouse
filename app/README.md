# Remote Mouse App

Remote mouse app for Android (Flutter).

## Requirements

- Flutter SDK 3.10 or higher
- Android SDK

## Setup

```bash
flutter pub get
```

## Run

```bash
flutter run
```

## Build

### Debug Build

```bash
flutter build apk --debug
```

### Release Build

```bash
flutter build apk --release
```

Generated APK: `build/app/outputs/flutter-apk/app-release.apk`

## File Structure

```
lib/
├── main.dart              # Entry point
├── screens/
│   ├── home_screen.dart   # Connection screen (IP input / QR scan)
│   └── touchpad_screen.dart # Touchpad screen
├── services/
│   └── websocket_service.dart # WebSocket communication
└── widgets/
    └── touchpad_widget.dart   # Touchpad UI
```

## Features

- Connect via IP input or QR code scan
- Mouse control with touchpad
- Tap for left click
- Long press for right click
- Two-finger swipe for scrolling
