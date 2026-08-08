# Session Handoff — Nosok v15

## Current baseline
`nosok_platform_integration_patch_v15_system_home_units_dashboard_under_platform.zip`

## What changed
1. Fixed the v14 compile blocker in the public home page.
2. Added a public service command strip to make the home page more user-service oriented.
3. Rebuilt the public unit page with a government UX hero, user actions, service cards, and governance boundaries.
4. Rebuilt the admin units page as a unit-scope operational console.
5. Grouped the internal admin sidebar into operational sections:
   - Daily operations
   - Season/services
   - Payment/privacy
   - Governance/readiness
6. Added deeper admin dashboard panels for pressure, season readiness, and production gates.
7. Added SQL v15 runtime evidence script.

## Required local test
```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

## Required pages to test
- `/systems/nosok`
- `/systems/nosok/units/demo-unit`
- `/admin/systems/nosok`
- `/admin/systems/nosok/units`
- `/admin/systems/nosok/unit-queues`
- `/admin/systems/nosok/sidebar`

## SQL UAT
Run:
```sql
select * from public.rpc_nosok_v15_runtime_contract_uat_v1();
```

## Production status
Production is not approved. Browser UAT, SQL UAT, Role UAT, privacy review, and billing adapter evidence must still be closed.
