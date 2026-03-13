#!/bin/bash
set -e

echo "==> Cleaning previous build..."
fvm flutter clean

echo "==> Getting dependencies..."
fvm flutter pub get

echo "==> Building release APK..."
fvm flutter build apk --release

APK_PATH="build/app/outputs/flutter-apk/app-release.apk"

if [ -f "$APK_PATH" ]; then
  echo ""
  echo "✓ Release APK created successfully:"
  echo "  $APK_PATH"
  echo "  Size: $(du -sh "$APK_PATH" | cut -f1)"
else
  echo "✗ Build failed: APK not found at $APK_PATH"
  exit 1
fi