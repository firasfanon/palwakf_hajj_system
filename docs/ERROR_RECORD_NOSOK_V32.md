# ERROR RECORD — NOSOK v32

## Runtime issue

`flutter analyze` passed, but `flutter run -d chrome` failed at browser runtime due to CanvasKit CDN fetch failure:

```text
TypeError: Failed to fetch dynamically imported module: canvaskit.js
```

## Classification

`environment-network-cdn-runtime-blocker / not-dart-compile-error / browser-render-evidence-pending`

## Recommended retest

```powershell
flutter precache --web --force
flutter clean
flutter pub get
flutter run -d chrome
```

If the same issue persists, retry from a network that allows `https://www.gstatic.com/flutter-canvaskit/` or run with a locally cached web SDK/assets environment.
