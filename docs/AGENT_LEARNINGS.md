# Agent learnings

## Build universal release binaries per architecture

- Scope: CopySight macOS release packaging with Swift Package Manager.
- Symptom: a direct multi-architecture SwiftPM release build produced module and symbol collisions.
- Validated route: build `arm64` and `x86_64` in separate scratch paths, combine only the final executables with `lipo`, assemble the app bundle, and sign the completed universal artifacts.
- Evidence: the resulting app reported both architectures, passed Developer ID validation, and the DMG was accepted by Apple notarization.
- Revalidate when: SwiftPM changes its multi-architecture build behavior or the package gains binary resources that must also be merged.
