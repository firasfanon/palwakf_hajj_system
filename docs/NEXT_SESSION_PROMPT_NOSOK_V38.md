# NEXT SESSION PROMPT — Nosok v38

Start from:

```text
nosok_v37_modern_public_homepage_redesign_2026_05_20.zip
```

Status:

```text
staging-stable /
nosok-v37-modern-public-homepage-applied /
local-flutter-retest-required /
production-not-approved /
no-waqf-assets-mutation
```

Required first commands:

```bash
dart format .
flutter analyze
flutter run -d chrome
```

Then inspect:

```text
/services/nosok
/services/nosok/apply
/services/nosok/track
/services/nosok/lottery-results
/services/nosok/waiting-list
/services/nosok/objections
/admin/systems/nosok
```

Recommended next batch:

```text
Nosok v38 — Public Form UX Refinement + Citizen Tracking Runtime Polish + Mobile Browser Evidence Intake
```

Rules:

- No SQL apply.
- No schema creation before PalWakf merge.
- No backend binding before `nosok schema` exists.
- No `waqf_assets` mutation.
- Keep public homepage citizen-first.
