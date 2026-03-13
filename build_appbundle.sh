#!/bin/bash
set -e

echo "==> Cleaning previous build..."
fvm flutter clean

echo "==> Getting dependencies..."
fvm flutter pub get

echo "==> Building release App Bundle..."
fvm flutter build appbundle --release

BUNDLE_PATH="build/app/outputs/bundle/release/app-release.aab"

if [ -f "$BUNDLE_PATH" ]; then
  echo ""
  echo "✓ App Bundle created successfully:"
  echo "  $BUNDLE_PATH"
  echo "  Size: $(du -sh "$BUNDLE_PATH" | cut -f1)"
else
  echo "✗ Build failed: App Bundle not found at $BUNDLE_PATH"
  exit 1
fi