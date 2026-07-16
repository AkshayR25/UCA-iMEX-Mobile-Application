---
description: Build a release APK with FVM and rename it to "NexusAir Mobile-<version>-<date>.apk"
allowed-tools: Bash(fvm flutter build apk*), Bash(cp *), Bash(grep *), Bash(date*), Bash(ls *), Read
---

Build the release APK for this project and rename it with the version and today's date.

Steps:

1. Read the version name from `pubspec.yaml` (the part before `+` in the `version:` line) and get today's date as `YYYY-MM-DD`.

2. Build the release APK using the pinned Flutter SDK — **always use `fvm flutter`, never plain `flutter`** (plain `flutter` uses the global SDK which fails to compile this project):

   ```bash
   fvm flutter build apk --release
   ```

3. After the build succeeds, copy `build/app/outputs/flutter-apk/app-release.apk` to a renamed file in the same folder:

   ```
   build/app/outputs/flutter-apk/NexusAir Mobile-<version>-<YYYY-MM-DD>.apk
   ```

   For example, version `1.7.1` on 2026-07-15 → `NexusAir Mobile-1.7.1-2026-07-15.apk`.

4. Report the full path to the renamed APK and its size.

Notes:
- The release build takes a few minutes; run it in the background and monitor for `Built build/app/outputs/flutter-apk/app-release.apk` (success) or `BUILD FAILED` / `Target kernel_snapshot` (failure).
- Do NOT bump the version here — that is a separate step. Only build and rename the current version.
