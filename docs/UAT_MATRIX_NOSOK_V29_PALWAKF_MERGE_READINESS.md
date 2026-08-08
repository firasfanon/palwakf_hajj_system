# UAT MATRIX — Nosok v29

## Local Flutter UAT

| Check | Required | Status |
|---|---:|---|
| `dart format .` | yes | pending local retest after v29 |
| `flutter analyze` | yes | pending local retest after v29 |
| `flutter run -d chrome` | yes | pending local retest after v29 |

## v29 route UAT

| Route | Expected |
|---|---|
| `/admin/systems/nosok/v29-merge-readiness` | Opens merge readiness surface without runtime error |
| `/admin/systems/nosok` | Admin dashboard remains accessible by RBAC |
| `/services/nosok` | Public portal remains citizen-facing |
| `/services/nosok/apply` | Wizard remains visible |
| `/services/nosok/lottery-results` | Public result surface remains citizen-only contract |
| `/admin/systems/nosok/lottery` | Lottery console remains governance-sensitive |

## Database UAT

Not required in v29. The database schema is not created by design until PalWakf merge.

## Role UAT after merge

| Role | Required after merge |
|---|---|
| Visitor | public only |
| Citizen | own request/result/objection only |
| Nosok employee | assigned/scoped operational surfaces |
| Supervisor | unit/scoped queue and eligibility surfaces |
| Hajj committee | committee decisions only with reason/evidence |
| Admin/Superuser | readiness/audit/gate surfaces |
| Restricted user | read-only/forbidden according to contract |
