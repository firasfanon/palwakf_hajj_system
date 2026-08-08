# ERROR RECORD — Nosok v37B-1 Public Subpage Compile Fix

## Error

`dart format`, `flutter analyze`, and `flutter run -d chrome` failed after v37B due to syntax errors:

```text
Expected to find ','
```

Affected files:

- `nosok_application_status_page.dart`
- `nosok_apply_page.dart`
- `nosok_citizen_followup_page.dart`

## Cause

The v37B public UX alignment modified `NosokPageScaffold` named parameters and left `subtitle:` strings without a comma before the following `children:` named parameter.

## Fix

Added missing commas after the `subtitle:` strings.

## Stability status

The patch is syntactic and localized. Local retest is still required on the user's machine:

```bash
dart format .
flutter analyze
flutter run -d chrome
```

## Last known stable evidence

Before v37B, v36.1 had `analyzer-clean` and `chrome-startup-passed` evidence. v37B introduced the three syntax blockers, now targeted by v37B-1.
