# ERROR RECORD — Nosok v19.3

## Error

Runtime exception on public application tracking page:

```text
ScaffoldMessenger.showSnackBar was called, but there are currently no descendant Scaffolds to present to.
```

## Trigger

User opened the running web preview and pressed the search button on `/systems/nosok/application-status` with an empty tracking token.

## Root Cause

`NosokPublicSystemShell` used `Directionality + Column + Material` but did not provide a `Scaffold`. Public pages invoked `ScaffoldMessenger.of(context).showSnackBar(...)`, and Flutter requires a descendant `Scaffold` under the active `ScaffoldMessenger` to present snackbars.

## Files Changed

- `lib/features/nosok_system/presentation/widgets/nosok_public_system_shell.dart`

## Resolution

Wrapped the public shell body with `Scaffold(body: Column(...))`. This keeps the shell behavior the same but provides a valid snackbar presentation surface for all public pages.

## Regression Guard

Retest:

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

Then test:

- `/systems/nosok/application-status` empty-token search.
- `/systems/nosok/follow-up` empty-token submit.
- `/systems/nosok/apply` validation/submit warnings.

## Last Stable Baseline

v19.2 had analyzer-clean evidence and web runtime launch; v19.3 fixes the runtime snackbar blocker found after launch.
