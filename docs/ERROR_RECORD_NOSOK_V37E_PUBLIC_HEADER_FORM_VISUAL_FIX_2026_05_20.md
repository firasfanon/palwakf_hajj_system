# ERROR RECORD — Nosok v37E

## Issue 1 — Public Header Visual Drift

**Observed:** Public navigation still used `ChoiceChip`, producing a soft tinted active state and compressed labels in the header screenshots.  
**Root cause:** Material chip theming may inherit current `ColorScheme` values that are not strictly controlled by Nosok public UI palette.  
**Files:**
- `lib/features/nosok_system/presentation/widgets/nosok_public_system_shell.dart`

**Fix:** Replaced `ChoiceChip` with a custom `_NavChip` using explicit sovereign palette values.

## Issue 2 — Apply Page Administrative Stepper Look

**Observed:** The application page still showed a vertical step connector on wide desktop layout, making the citizen form look more administrative.  
**Root cause:** `StepperType.vertical` was forced for all breakpoints.  
**Files:**
- `lib/features/nosok_system/presentation/pages/public/nosok_apply_page.dart`

**Fix:** Wide screens now use `StepperType.horizontal`, while mobile remains vertical.

## Remaining Validation

Run locally:

```bash
dart format .
flutter analyze
flutter run -d chrome
```
