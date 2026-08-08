# ERROR RECORD — Nosok v37 Modern Public Homepage Redesign

## Issue

The public homepage had become too administrative/governance-oriented for a citizen-facing service entry.

## Root Cause

Previous batches correctly added readiness, merge, backend, lottery, and seasonal governance surfaces, but some public homepage language retained too much system-facing context.

## Fix

Rebuilt `nosok_public_home_page.dart` to show a modern citizen service journey:

- Modern hero.
- Seasonal landing.
- Primary citizen actions.
- Journey preview.
- Public tracking/support strip.
- Trust/transparency messaging.
- Compact admin entry only.

## Guardrails Preserved

- Public/internal separation preserved.
- Admin route still protected by RBAC/Route Guard.
- No SQL changes.
- No schema creation.
- No backend binding.
- No `waqf_assets` mutation.

## Retest Status

Retest required after v37:

```bash
dart format .
flutter analyze
flutter run -d chrome
```
