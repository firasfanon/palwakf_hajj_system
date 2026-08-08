# BASELINE CHANGELOG — NOSOK V15.2

## Batch
Nosok v15.2 — Public Material Ancestor Runtime Hotfix

## Date
2026-05-18

## Based On
Nosok v15.1 — Sidebar Compile Hotfix

## User Evidence
Browser runtime screenshot showed the public `/systems/nosok` page failing with:

`No Material widget found. Chip widgets require a Material widget ancestor.`

The stack pointed to `_HeroBadge` inside the public home hero.

## Changes Applied
1. `nosok_public_system_shell.dart`
   - Wrapped the route child area with `Material(type: MaterialType.transparency)`.
   - This gives all public child pages a valid Material ancestor while preserving platform/public shell visuals.

2. `nosok_public_home_page.dart`
   - Replaced `_HeroBadge` implementation from `Chip` to a decorated pill widget using `DecoratedBox`, `Padding`, `Row`, `Icon`, and `Text`.

3. `nosok_public_unit_page.dart`
   - Replaced public unit hero `Chip` widgets with `_UnitHeroBadge` decorated pill widgets.

## Non-Changes
- No SQL changes.
- No Supabase table/RPC changes.
- No platform route restructuring.
- No RBAC/access contract changes.
- No changes to `waqf`, `waqf_assets`, or `awqaf_system`.

## Status
`hotfix-ready / public-material-runtime-blocker-addressed / local-retest-required / production-not-approved / no-waqf-assets-mutation`

## Required Local Retest
```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

## Pages To Retest
- `/systems/nosok`
- `/systems/nosok/units/demo-unit`
- `/admin/systems/nosok`
