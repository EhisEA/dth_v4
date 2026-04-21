# Makefile reference

This project’s `Makefile` wraps **FVM-managed Flutter** (`fvm flutter`) so everyone runs the same toolchain. Entry points are **flavored** (`dev` / `prod`) and map to:

| Flavor | Dart entrypoint        |
|--------|------------------------|
| `dev`  | `lib/main_dev.dart`    |
| `prod` | `lib/main_prod.dart` |

**Prerequisites:** [FVM](https://fvm.app/) installed and the project’s Flutter version available (`fvm use` / `fvm install` as documented in the repo). Android/iOS SDK setup as required by Flutter for each build type.

---

## Run (local device / simulator)

| Command        | What it does |
|----------------|----------------|
| `make run-dev` | `flutter run` with **dev** flavor and `lib/main_dev.dart`. |
| `make run-prod` | `flutter run` with **prod** flavor and `lib/main_prod.dart`. |

---

## Android builds

| Command            | What it does |
|--------------------|----------------|
| `make build-apk-dev` | Release **APK** for **dev** (`build apk`, dev flavor). |
| `make build-apk-prod` | Release **APK** for **prod**. |
| `make build-aab-dev` | **App bundle** (AAB) for Play Store–style uploads, **dev**. |
| `make build-aab-prod` | **AAB** for **prod**. |

**Interactive variants** (prompts for `dev` or `prod`):

| Command        | What it does |
|----------------|----------------|
| `make build-apk` | Builds APK for the flavor you type. |
| `make build-aab` | Builds app bundle for the flavor you type. |
| `make build-app-split` | APK with **obfuscation** and **split debug symbols** written under `build/app/outputs/symbols` (good for smaller APKs / symbol upload workflows). |

---

## iOS builds

| Command              | What it does |
|----------------------|----------------|
| `make build-ios-dev` | `flutter build ios` **debug**, **dev** flavor. |
| `make build-ios-prod` | Same for **prod**. |
| `make build-ipa-dev` | **IPA** archive for **dev** (distribution-style build). |
| `make build-ipa-prod` | **IPA** for **prod**. |

**Interactive variant:**

| Command        | What it does |
|----------------|----------------|
| `make build-ios` | Debug iOS build; prompts for flavor. |
| `make build-ipa` | IPA build; prompts for flavor. |

> **Note:** iOS builds need a configured Xcode project, signing, and (for IPA) valid export options / certificates on the machine running the command.

---

## Other targets

| Command           | What it does |
|-------------------|----------------|
| `make run-app`    | Interactive `flutter run`: you enter `dev` or `prod`; runs with matching flavor and main file. |
| `make analyze-app` | Builds a **dev** APK for **android-arm64** with **`--analyze-size`**. Use this to inspect app size breakdown (not necessarily what you ship). |
| `make clean-get`  | `flutter clean` then `flutter pub get` — resets build artifacts and refreshes dependencies. |

---

## Quick copy-paste cheat sheet

```bash
# Run
make run-dev
make run-prod

# Android
make build-apk-dev
make build-apk-prod
make build-aab-dev
make build-aab-prod

# iOS
make build-ios-dev
make build-ios-prod
make build-ipa-dev
make build-ipa-prod

# Housekeeping / analysis
make clean-get
make analyze-app
```

For targets that prompt (`run-app`, `build-apk`, `build-aab`, `build-ios`, `build-ipa`, `build-app-split`), run `make <target>` and answer `dev` or `prod` when asked.
