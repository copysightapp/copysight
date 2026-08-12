#!/usr/bin/env bash
set -euo pipefail

APP_NAME="CopySight"
VERSION="1.1.1"
BUNDLE_ID="app.copysight.mac"
MIN_SYSTEM_VERSION="14.0"
DEVELOPER_ID="${COPY_SIGHT_DEVELOPER_ID:-Developer ID Application: Guillermo López (99S8SSZP82)}"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RELEASE_DIR="$ROOT_DIR/release"
APP_BUNDLE="$RELEASE_DIR/$APP_NAME.app"
CONTENTS="$APP_BUNDLE/Contents"
MACOS_DIR="$CONTENTS/MacOS"
RESOURCES_DIR="$CONTENTS/Resources"
ARM_SCRATCH="$ROOT_DIR/.build/release-arm64"
X86_SCRATCH="$ROOT_DIR/.build/release-x86_64"
DMG_PATH="$RELEASE_DIR/$APP_NAME-$VERSION.dmg"
ENTITLEMENTS="$ROOT_DIR/script/CopySight.entitlements"

cd "$ROOT_DIR"
swift build -c release --arch arm64 --scratch-path "$ARM_SCRATCH"
swift build -c release --arch x86_64 --scratch-path "$X86_SCRATCH"
ARM_BIN="$(swift build -c release --arch arm64 --scratch-path "$ARM_SCRATCH" --show-bin-path)"
X86_BIN="$(swift build -c release --arch x86_64 --scratch-path "$X86_SCRATCH" --show-bin-path)"

rm -rf "$APP_BUNDLE"
rm -f "$DMG_PATH"
mkdir -p "$MACOS_DIR" "$RESOURCES_DIR"
/usr/bin/lipo -create "$ARM_BIN/CopySight" "$X86_BIN/CopySight" -output "$MACOS_DIR/CopySight"
chmod +x "$MACOS_DIR/CopySight"

ICON_WORK="$(mktemp -d)"
DMG_ROOT="$(mktemp -d)"
trap 'rm -rf "$ICON_WORK" "$DMG_ROOT"' EXIT
swift "$ROOT_DIR/script/generate_icon.swift" "$ICON_WORK/icon_1024x1024.png"
mkdir -p "$ICON_WORK/CopySight.iconset"
for points in 16 32 128 256 512; do
  /usr/bin/sips -z "$points" "$points" "$ICON_WORK/icon_1024x1024.png" --out "$ICON_WORK/CopySight.iconset/icon_${points}x${points}.png" >/dev/null
  pixels=$((points * 2))
  /usr/bin/sips -z "$pixels" "$pixels" "$ICON_WORK/icon_1024x1024.png" --out "$ICON_WORK/CopySight.iconset/icon_${points}x${points}@2x.png" >/dev/null
done
/usr/bin/iconutil -c icns "$ICON_WORK/CopySight.iconset" -o "$RESOURCES_DIR/CopySight.icns"
cp -R Sources/CopySight/Resources/en.lproj Sources/CopySight/Resources/es.lproj "$RESOURCES_DIR/"

cat >"$CONTENTS/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>CFBundleDevelopmentRegion</key><string>en</string>
  <key>CFBundleExecutable</key><string>$APP_NAME</string>
  <key>CFBundleIdentifier</key><string>$BUNDLE_ID</string>
  <key>CFBundleIconFile</key><string>CopySight.icns</string>
  <key>CFBundleName</key><string>$APP_NAME</string>
  <key>CFBundleLocalizations</key><array><string>en</string><string>es</string></array>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>$VERSION</string>
  <key>CFBundleVersion</key><string>5</string>
  <key>LSMinimumSystemVersion</key><string>$MIN_SYSTEM_VERSION</string>
  <key>ITSAppUsesNonExemptEncryption</key><false/>
  <key>LSUIElement</key><true/>
  <key>NSHighResolutionCapable</key><true/>
  <key>NSPrincipalClass</key><string>NSApplication</string>
  <key>LSApplicationCategoryType</key><string>public.app-category.utilities</string>
  <key>NSScreenCaptureUsageDescription</key><string>CopySight captures only the screen region you select so it can recognize its text.</string>
</dict></plist>
PLIST

/usr/bin/codesign --force --options runtime --timestamp --entitlements "$ENTITLEMENTS" --sign "$DEVELOPER_ID" "$APP_BUNDLE"
/usr/bin/codesign --verify --deep --strict --verbose=2 "$APP_BUNDLE"
[[ "$(/usr/bin/codesign -d --entitlements :- "$APP_BUNDLE" 2>/dev/null | /usr/bin/xmllint --xpath "boolean(/plist/dict/key[.='com.apple.security.app-sandbox']/following-sibling::*[1][self::true])" - 2>/dev/null)" == "true" ]] || {
  echo "App Sandbox entitlement is missing from $APP_BUNDLE" >&2
  exit 1
}

cp -R "$APP_BUNDLE" "$DMG_ROOT/"
ln -s /Applications "$DMG_ROOT/Applications"
/usr/bin/hdiutil create -quiet -volname "$APP_NAME" -srcfolder "$DMG_ROOT" -ov -format UDZO "$DMG_PATH"
/usr/bin/codesign --force --timestamp --sign "$DEVELOPER_ID" "$DMG_PATH"

if [[ -n "${APPSTORE_PRIVATE_KEY_PATH:-}" && -n "${APPSTORE_KEY_ID:-}" && -n "${APPSTORE_ISSUER_ID:-}" ]]; then
  NOTARY_KEY_PATH="$APPSTORE_PRIVATE_KEY_PATH"
  if [[ ! -f "$NOTARY_KEY_PATH" ]]; then
    NOTARY_KEY_PATH="$HOME/.appstoreconnect/private_keys/$(basename "$APPSTORE_PRIVATE_KEY_PATH")"
  fi
  if [[ ! -f "$NOTARY_KEY_PATH" ]]; then
    echo "App Store Connect private key file not found" >&2
    exit 1
  fi
  /usr/bin/xcrun notarytool submit "$DMG_PATH" \
    --key "$NOTARY_KEY_PATH" \
    --key-id "$APPSTORE_KEY_ID" \
    --issuer "$APPSTORE_ISSUER_ID" \
    --wait
  /usr/bin/xcrun stapler staple "$DMG_PATH"
  /usr/bin/xcrun stapler validate "$DMG_PATH"
fi

/usr/sbin/spctl --assess --type open --context context:primary-signature --verbose=2 "$DMG_PATH"
/usr/bin/hdiutil verify "$DMG_PATH"
/usr/bin/file "$MACOS_DIR/CopySight"
/usr/bin/shasum -a 256 "$DMG_PATH"
