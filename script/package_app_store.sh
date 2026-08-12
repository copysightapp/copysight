#!/usr/bin/env bash
set -euo pipefail

APP_NAME="CopySight"
VERSION="1.1.1"
BUILD_NUMBER="5"
BUNDLE_ID="app.copysight.mac"
MIN_SYSTEM_VERSION="14.0"
APP_IDENTITY="${COPY_SIGHT_APP_STORE_IDENTITY:-Apple Distribution: Guillermo López (99S8SSZP82)}"
INSTALLER_IDENTITY="${COPY_SIGHT_INSTALLER_IDENTITY:-3rd Party Mac Developer Installer: Guillermo López (99S8SSZP82)}"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTPUT_DIR="$ROOT_DIR/appstore"
PROFILE="$OUTPUT_DIR/CopySight_AppStore.provisionprofile"
APP_BUNDLE="$OUTPUT_DIR/$APP_NAME.app"
CONTENTS="$APP_BUNDLE/Contents"
MACOS_DIR="$CONTENTS/MacOS"
RESOURCES_DIR="$CONTENTS/Resources"
PKG_PATH="$OUTPUT_DIR/$APP_NAME-$VERSION-$BUILD_NUMBER.pkg"
ARM_SCRATCH="$ROOT_DIR/.build/app-store-arm64"
X86_SCRATCH="$ROOT_DIR/.build/app-store-x86_64"

[[ -f "$PROFILE" ]] || { echo "Missing App Store provisioning profile: $PROFILE" >&2; exit 1; }

cd "$ROOT_DIR"
swift build -c release --arch arm64 --scratch-path "$ARM_SCRATCH"
swift build -c release --arch x86_64 --scratch-path "$X86_SCRATCH"
ARM_BIN="$(swift build -c release --arch arm64 --scratch-path "$ARM_SCRATCH" --show-bin-path)/$APP_NAME"
X86_BIN="$(swift build -c release --arch x86_64 --scratch-path "$X86_SCRATCH" --show-bin-path)/$APP_NAME"

rm -rf "$APP_BUNDLE"
rm -f "$PKG_PATH"
mkdir -p "$MACOS_DIR" "$RESOURCES_DIR"
/usr/bin/lipo -create "$ARM_BIN" "$X86_BIN" -output "$MACOS_DIR/$APP_NAME"
chmod +x "$MACOS_DIR/$APP_NAME"
cp "$PROFILE" "$CONTENTS/embedded.provisionprofile"

ICON_WORK="$(mktemp -d)"
trap 'rm -rf "$ICON_WORK"' EXIT
swift "$ROOT_DIR/script/generate_icon.swift" "$ICON_WORK/icon_1024x1024.png"
mkdir -p "$ICON_WORK/CopySight.iconset"
for points in 16 32 128 256 512; do
  /usr/bin/sips -z "$points" "$points" "$ICON_WORK/icon_1024x1024.png" --out "$ICON_WORK/CopySight.iconset/icon_${points}x${points}.png" >/dev/null
  pixels=$((points * 2))
  /usr/bin/sips -z "$pixels" "$pixels" "$ICON_WORK/icon_1024x1024.png" --out "$ICON_WORK/CopySight.iconset/icon_${points}x${points}@2x.png" >/dev/null
done
/usr/bin/iconutil -c icns "$ICON_WORK/CopySight.iconset" -o "$RESOURCES_DIR/CopySight.icns"
cp -R Sources/CopySight/Resources/en.lproj Sources/CopySight/Resources/es.lproj "$RESOURCES_DIR/"

INFO_PLIST="$CONTENTS/Info.plist"
/usr/bin/plutil -create xml1 "$INFO_PLIST"
/usr/bin/plutil -insert CFBundleDevelopmentRegion -string en "$INFO_PLIST"
/usr/bin/plutil -insert CFBundleExecutable -string "$APP_NAME" "$INFO_PLIST"
/usr/bin/plutil -insert CFBundleIdentifier -string "$BUNDLE_ID" "$INFO_PLIST"
/usr/bin/plutil -insert CFBundleIconFile -string CopySight.icns "$INFO_PLIST"
/usr/bin/plutil -insert CFBundleName -string "$APP_NAME" "$INFO_PLIST"
/usr/bin/plutil -insert CFBundleLocalizations -json '["en","es"]' "$INFO_PLIST"
/usr/bin/plutil -insert CFBundlePackageType -string APPL "$INFO_PLIST"
/usr/bin/plutil -insert CFBundleShortVersionString -string "$VERSION" "$INFO_PLIST"
/usr/bin/plutil -insert CFBundleVersion -string "$BUILD_NUMBER" "$INFO_PLIST"
/usr/bin/plutil -insert LSApplicationCategoryType -string public.app-category.utilities "$INFO_PLIST"
/usr/bin/plutil -insert LSMinimumSystemVersion -string "$MIN_SYSTEM_VERSION" "$INFO_PLIST"
/usr/bin/plutil -insert ITSAppUsesNonExemptEncryption -bool false "$INFO_PLIST"
/usr/bin/plutil -insert LSUIElement -bool true "$INFO_PLIST"
/usr/bin/plutil -insert NSHighResolutionCapable -bool true "$INFO_PLIST"
/usr/bin/plutil -insert NSPrincipalClass -string NSApplication "$INFO_PLIST"
/usr/bin/plutil -insert NSScreenCaptureUsageDescription -string "CopySight captures only the screen region you select so it can recognize its text." "$INFO_PLIST"

/usr/bin/codesign --force --timestamp --options runtime --entitlements "$OUTPUT_DIR/CopySight.entitlements" --sign "$APP_IDENTITY" "$APP_BUNDLE"
/usr/bin/codesign --verify --deep --strict --verbose=2 "$APP_BUNDLE"
/usr/bin/productbuild --component "$APP_BUNDLE" /Applications --sign "$INSTALLER_IDENTITY" "$PKG_PATH"
/usr/sbin/pkgutil --check-signature "$PKG_PATH"
/usr/bin/file "$MACOS_DIR/$APP_NAME"
/usr/bin/shasum -a 256 "$PKG_PATH"

if [[ "${1:-}" == "--upload" ]]; then
  /usr/bin/xcrun altool --validate-app -f "$PKG_PATH" -t macos --apiKey "$APPSTORE_KEY_ID" --apiIssuer "$APPSTORE_ISSUER_ID"
  /usr/bin/xcrun altool --upload-app -f "$PKG_PATH" -t macos --apiKey "$APPSTORE_KEY_ID" --apiIssuer "$APPSTORE_ISSUER_ID"
fi
