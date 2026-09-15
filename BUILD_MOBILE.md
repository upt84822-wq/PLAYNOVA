# PLAYNOVA — Mobile-only build

This source is designed for a phone-first workflow.

1. Upload the whole `playnova` folder to a Git repository.
2. Use a Flutter-capable cloud build service.
3. Build Android APK in release mode.
4. Download the APK to the phone and install it.

If the cloud builder reports missing generated Flutter/Gradle platform files,
run this once in the project root before building:

    flutter create --platforms=android .

Then:

    flutter pub get
    flutter build apk --release

PLAYNOVA currently uses free in-app virtual coins only. No real-money
deposit, withdrawal, cash betting, or cash-out functionality is included.
