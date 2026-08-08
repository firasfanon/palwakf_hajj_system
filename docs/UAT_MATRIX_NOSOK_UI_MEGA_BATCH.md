# UAT_MATRIX — Mega Batch Nosok UI

| Area | Route | Role | Expected result | Status |
|---|---|---|---|---|
| Public Portal | `/services/nosok` | visitor | Citizen-facing portal, no admin terms or audit data | pending |
| Public Apply | `/services/nosok/apply` | citizen | Wizard style, labels/helper text, no raw backend errors | pending |
| Public Track | `/services/nosok/track` | citizen | Safe tracking, no internal notes/audit/RBAC | pending |
| Requirements | `/services/nosok/requirements` | visitor | Requirements panel and privacy notice | pending |
| FAQ | `/services/nosok/faq` | visitor | Public FAQ accessible | pending |
| Internal Console | `/admin/systems/nosok` | superuser | Full operations console visible | pending |
| Requests | `/admin/systems/nosok/requests` | nosok employee | Filtered queue and responsive table/cards | pending |
| Review | `/admin/systems/nosok/review` | reviewer | Decision panel visible only if authorized | pending |
| Campaigns | `/admin/systems/nosok/campaigns` | supervisor/admin | Campaign list, no overloaded cards | pending |
| Messages | `/admin/systems/nosok/messages` | employee/admin | Follow-up inbox/messages preview | pending |
| Documents | `/admin/systems/nosok/documents` | documents officer | Document verification surface | pending |
| Reports | `/admin/systems/nosok/reports` | supervisor/admin | Reports outside home page | pending |
| Responsive | all key routes | mobile | Cards/bottom-safe layout, no overflow | pending |
| Restricted | internal routes | restricted user | read-only/forbidden via NosokAccessGate | pending |
| Visual identity | public + internal | all | Theme/colorScheme based; no independent brand | pending |
