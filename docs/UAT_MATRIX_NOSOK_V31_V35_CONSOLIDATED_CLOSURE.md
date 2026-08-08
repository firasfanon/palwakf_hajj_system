# UAT MATRIX — Nosok v31-v35

## Flutter local

- `dart format .` — required after applying this baseline.
- `flutter analyze` — required.
- `flutter run -d chrome` — required.

## Public routes

- `/services/nosok`
- `/services/nosok/apply`
- `/services/nosok/track`
- `/services/nosok/lottery-results`
- `/services/nosok/waiting-list`
- `/services/nosok/objections`

## Admin routes

- `/admin/systems/nosok`
- `/admin/systems/nosok/requests`
- `/admin/systems/nosok/review`
- `/admin/systems/nosok/lottery`
- `/admin/systems/nosok/lottery/eligibility`
- `/admin/systems/nosok/lottery/draw`
- `/admin/systems/nosok/lottery/waiting-list`
- `/admin/systems/nosok/lottery/committee`
- `/admin/systems/nosok/lottery/audit`
- `/admin/systems/nosok/v31-v35-production-closure`

## Role UAT

- visitor: public only.
- citizen: own application/result only.
- company partner: own scope only.
- employee: assigned/scoped operations.
- supervisor: scoped oversight.
- hajj committee: committee decisions/audit.
- system admin: settings/schema readiness.
- superuser: full audit.
- restricted: forbidden/read-only.

## Responsive UAT

Desktop/tablet/mobile with no overflow, no hit-test errors, no raw backend errors.
