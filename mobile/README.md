# safetyquest_mobile

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Server address

The app's school server address is `API_BASE_URL` in `backend/.env`, the
project's only .env file. The Android build (`android/app/build.gradle.kts`)
reads just that one value on every build, so a plain `flutter run`, F5 in
VS Code, or `flutter build apk` all pick it up. The rest of `backend/.env` holds
server secrets and never enters the app.

After changing the address, stop the app and run it again (hot reload does not
pick up a new value). The address ships inside the app, so it is public.

## Random emergency practice

After state loads, a practice alert is scheduled after a random 2–5 minutes.
It is offered once per signed-in HomeShell session, only while Home is visible
and the app is active. If a lesson or dialog is open, it waits another random
interval. Home's **Try random drill** button opens the same flow immediately.
Each drill randomly selects one existing simulation activity, avoids immediately
repeating the last activity, and does not submit scores or spend school attempts.
These are in-app practice alerts; they do not notify a closed/background app.

For defense verification, dismiss an automatic alert, launch a manual drill,
answer it and return Home. Confirm school scores and tries remain unchanged.

## iPhone web image verification

Interactive scenes share Flutter's image cache for dimensions and display rather
than decoding a second full-size copy. Image listeners release their resources
when a scene changes or closes. Failed scene images show a retry action and do
not accept invisible hotspot answers.

Build using the GitHub Pages workflow (which supplies the repository base path
and API address). After deploying, open the new build in iPhone Safari and from
the installed Home Screen app. Check the logo, Home art, lesson story images,
and interactive scenes across several modules, including returning to earlier
scenes. A physical iPhone check is still required to verify the reported issue;
local asset validation and a successful web build do not establish Safari behavior.
