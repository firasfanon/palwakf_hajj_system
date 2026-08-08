# UAT MATRIX — Nosok v26.1 Session Close

## Local runtime

| Check | Status | Evidence |
|---|---|---|
| `flutter clean` | previously passed in user logs | latest logs before v26 show successful command flow |
| `flutter pub get` | previously passed | dependency notices only |
| `dart format .` | previously passed | many files formatted |
| `flutter analyze` | retest required for v26 | v26 fixed warning; must rerun |
| `flutter run -d chrome` | previously passed | Debug Service reached in logs |

## Public Browser UAT

| Route | Expected | Status |
|---|---|---|
| `/services/nosok` | public service portal | pending retest |
| `/services/nosok/apply` | wizard form | pending retest |
| `/services/nosok/track` | citizen tracking only | pending retest |
| `/services/nosok/requirements` | requirements + Manasikna mention | pending retest |
| `/services/nosok/faq` | FAQ accordion | pending retest |

## Internal Browser UAT

| Route | Expected | Status |
|---|---|---|
| `/admin/systems/nosok` | operations console | pending retest |
| `/admin/systems/nosok/requests` | requests workspace | pending retest |
| `/admin/systems/nosok/review` | review queue | pending retest |
| `/admin/systems/nosok/campaigns` | campaigns | pending retest |
| `/admin/systems/nosok/documents` | document console | pending retest |
| `/admin/systems/nosok/messages` | follow-up/messages | pending retest |
| `/admin/systems/nosok/reports` | reports | pending retest |

## Role UAT

| Role | Expected UI | Status |
|---|---|---|
| Visitor | public only | pending |
| Citizen | own request/track/follow-up only | pending |
| Nosok employee | assigned/scope requests | pending |
| Nosok supervisor | scoped operations | pending |
| System admin | settings/reports | pending |
| Superuser | all with audit | pending |
| Restricted user | read-only/forbidden | pending |

## Responsive UAT

| Device class | Status |
|---|---|
| Desktop | pending evidence |
| Laptop | pending evidence |
| Tablet | pending evidence |
| Mobile | pending evidence |

## SQL UAT

| Script | Type | Status |
|---|---|---|
| `sql/24_nosok_v26_read_only_evidence_result_redecision_uat.sql` | read-only | pending Supabase run |

## Production gate

```text
production-not-approved
```
