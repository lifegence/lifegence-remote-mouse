# Android App Setup Guide

Setup guide for the Android app.

## Installation

### Option 1: Download APK (Recommended)

1. Download the latest `remote-mouse.apk` from [Releases](https://github.com/lifegence/lifegence-remote-mouse/releases)
2. Enable "Install from unknown sources" on your phone
3. Install the APK

### Option 2: Build from Source

#### Requirements
- Flutter SDK 3.10 or higher
- Android SDK

#### Build Steps

```bash
cd app
flutter pub get
flutter build apk --release
```

Generated APK: `app/build/app/outputs/flutter-apk/app-release.apk`

## Permissions

The app uses the following permissions:

| Permission | Purpose |
|------------|---------|
| Internet | Communication with PC server |
| Camera | QR code scanning |

## Usage

1. Start the server on PC
2. Open the app
3. Scan QR code or enter IP address
4. Tap "Connect"
5. Use the touchpad screen to control the mouse

## Controls

| Action | Function |
|--------|----------|
| Drag | Mouse movement |
| Tap | Left click |
| Long press (0.5s) | Right click |
| Two-finger swipe | Scroll |
| Bottom buttons | Left/Right click |

## Troubleshooting

### Cannot Connect

1. Ensure PC and phone are on the same WiFi network
2. Verify port 8765 is allowed in PC firewall
3. Check the IP address is correct

### Slow Response

- Check WiFi signal strength
- Use 5GHz WiFi (faster than 2.4GHz)
