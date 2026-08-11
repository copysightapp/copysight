# Agent learnings

## Build universal release binaries per architecture

- Scope: CopySight macOS release packaging with Swift Package Manager.
- Symptom: a direct multi-architecture SwiftPM release build produced module and symbol collisions.
- Validated route: build `arm64` and `x86_64` in separate scratch paths, combine only the final executables with `lipo`, assemble the app bundle, and sign the completed universal artifacts.
- Evidence: the resulting app reported both architectures, passed Developer ID validation, and the DMG was accepted by Apple notarization.
- Revalidate when: SwiftPM changes its multi-architecture build behavior or the package gains binary resources that must also be merged.

## Enter App Store Connect credentials through controlled Chrome

- Scope: CopySight App Store review work when the authenticated Apple session has expired.
- Symptom: Playwright, DOM CUA, and tab CUA leave Apple's secure password input empty and the sign-in button disabled.
- Validated route: use `chrome:control-chrome`, advance to the password step, focus the secure field, and send `Input.insertText` through the tab's documented `cdp` capability. Never persist or echo the credential, and leave any 2FA step to the user.
- Evidence: App Store Connect loaded the exact CopySight submission, exposed the reviewer message, and accepted the corrected submission in `WAITING_FOR_REVIEW`.
- Revalidate when: Apple changes its login flow or the controlled Chrome runtime changes secure-field handling.

## Verify dotted entitlement keys as literal plist keys

- Scope: CopySight release packaging and verification of signed macOS bundles.
- Symptom: extracting `com.apple.security.app-sandbox` from signed entitlements reported a missing value even though codesign had embedded it.
- Failed approach: `plutil -extract com.apple.security.app-sandbox` treats the dots as key-path separators rather than as part of one literal key.
- Validated route: dump the signed bundle entitlements with `codesign -d --entitlements :-` and select the exact sibling value of the literal key with `xmllint`.
- Evidence: the app mounted from the notarized DMG returned a true sandbox entitlement and passed strict codesign and Gatekeeper validation.
- Revalidate when: `plutil` gains a documented literal-key mode or the entitlement verification tooling changes.
