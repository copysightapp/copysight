# Contributing to CopySight

CopySight accepts reproducible bug fixes and focused improvements to native screen-region OCR on macOS.

## Before you start

- Search existing issues before opening a new one.
- Keep proposals within the app's scope: fast, private, on-device text capture.
- Discuss a large behavioral or architectural change in an issue before implementing it.
- Report security problems privately through GitHub's **Security → Report a vulnerability** flow.

## Development setup

You need macOS 14 or later and a Swift 5.10 toolchain.

```sh
git clone https://github.com/copysightapp/copysight.git
cd copysight
swift test
./script/build_and_run.sh --verify
```

The development app is written to `dist/CopySight.app`.

## Submit a change

1. Create a focused branch.
2. Add or update tests for observable behavior.
3. Run the project checks:

   ```sh
   swift test
   node web/test.mjs
   ```

4. Open a pull request that explains the problem, the change, and how you verified it.

Do not include captured screen content, credentials, signing material, notarization output, or unrelated generated artifacts in a commit.
