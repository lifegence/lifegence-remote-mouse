#!/bin/bash
# Build Android APK

echo "========================================"
echo "Building Remote Mouse APK..."
echo "========================================"

flutter pub get
flutter build apk --release

echo ""
echo "========================================"
echo "Build complete!"
echo "APK file: build/app/outputs/flutter-apk/app-release.apk"
echo "========================================"
