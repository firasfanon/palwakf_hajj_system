# Error Record — Nosok v15

## Error 1 — v14 public home compile blocker
- File: `lib/features/nosok_system/presentation/pages/public/nosok_public_home_page.dart`
- Symptom: `Error: Not a constant expression. const Expanded(flex: 5, child: visual)`
- Cause: local `visual` was declared as `final visual = const _HeroVisualPanel();`, then referenced inside a const widget constructor.
- Fix: removed `const` from `Expanded(flex: 5, child: visual)`.
- Stable baseline after fix: v15.

## Recurrent guard
Avoid marking a widget tree `const` when one child is a local variable, even if that variable was assigned a const object. Prefer const on the leaf widget only.
