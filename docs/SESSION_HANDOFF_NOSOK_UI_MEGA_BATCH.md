# SESSION_HANDOFF — Mega Batch Nosok UI

## Current baseline
Built on Nosok v22 full merge role evidence gate package.

## What changed
This batch shifts Nosok from governance-heavy staging screens toward a government service UX split into:

1. Public Service Portal for citizens under `/services/nosok`.
2. Internal Operations Console for staff under `/admin/systems/nosok`.

The old `/systems/nosok` public namespace is retained as redirect compatibility only. Internal old `/admin/nosok` aliases remain redirects.

## Important implementation notes
- PWF-SIS UI components are currently local wrappers named `PwfSis*` inside Nosok to prepare final platform extraction/reuse.
- Components use `Theme.of(context).colorScheme` and Material 3; they should be mapped to canonical PalWakf PWF-SIS components when applied inside the full platform repo.
- No backend execution was introduced in this UI batch. Backend integrations not currently available are presented as disabled/planned visual contracts, not as fake working components.

## New public routes
- `/services/nosok`
- `/services/nosok/hajj`
- `/services/nosok/umrah`
- `/services/nosok/apply`
- `/services/nosok/track`
- `/services/nosok/requirements`
- `/services/nosok/faq`

## New internal routes
- `/admin/systems/nosok/requests`
- `/admin/systems/nosok/review`
- `/admin/systems/nosok/campaigns`
- `/admin/systems/nosok/groups`
- `/admin/systems/nosok/documents`
- `/admin/systems/nosok/messages`

## Local validation required
Run:

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

Browser UAT should cover desktop/tablet/mobile for the route sets listed in `UAT_MATRIX_NOSOK_UI_MEGA_BATCH.md`.

## Production decision
Production is not approved. Full PalWakf repo merge, RBAC provider override, Supabase SQL UAT, Browser Role UAT, and responsive evidence remain required.
