# BASELINE_CHANGELOG — Mega Batch Nosok UI

## Scope
Mega Batch Nosok UI — Public Service Portal + Internal Operations Console + PWF-SIS Compliance + Responsive Anti-Overload UX + Visual Identity Admin Compatibility + Role-Based UI Separation.

## Applied changes
- Repositioned preferred public routes to `/services/nosok/*` while keeping `/systems/nosok/*` as backwards-compatible redirects.
- Added PWF-SIS compatible reusable UI components under `presentation/widgets/pwf_sis_nosok_components.dart`.
- Rebuilt public home as a citizen service portal with hero, service cards, requirements preview, workflow stepper, tracking card, FAQ accordion, and help card.
- Added `/services/nosok/requirements` page.
- Rebuilt internal dashboard as operations console with role/runtime badges, quick status strip, primary action zone, review queue preview, workflow preview, access-aware block, and governance strip.
- Added internal routes and pages: requests, review, campaigns, groups, documents, messages.
- Updated system routes, navigation, and permission keys for role-based UI separation.
- Added read-only SQL UAT contract `sql/21_nosok_ui_pwf_sis_read_only_uat.sql`.

## Guardrails
- No SQL production DDL/DML executed.
- No waqf_assets mutation.
- No schema waqf mutation.
- No legacy.dart introduced.
- UI uses Flutter Material/ThemeData/colorScheme and PWF-SIS-style components.

## Status
staging-stable / nosok-public-internal-ui-separated / pwf-sis-compliance-pack-applied / responsive-uat-pending / role-based-ui-pending / production-not-approved / no-waqf-assets-mutation
