# UAT MATRIX — Nosok v38

## Local evidence accepted

| البند | النتيجة |
|---|---|
| dart format . | passed / 0 changed |
| flutter analyze | No issues found |
| flutter run -d chrome | Chrome startup passed |

## Public routes to verify

- `/services/nosok`
- `/services/nosok/apply`
- `/services/nosok/track`
- `/services/nosok/lottery-results`
- `/services/nosok/waiting-list`
- `/services/nosok/objections`
- `/services/nosok/companies`
- `/services/nosok/contact`
- `/services/nosok/complaints`
- `/services/nosok/faq`

## Admin routes to verify

- `/admin/systems/nosok`
- `/admin/systems/nosok/requests`
- `/admin/systems/nosok/review`
- `/admin/systems/nosok/lottery`
- `/admin/systems/nosok/campaigns`
- `/admin/systems/nosok/companies`
- `/admin/systems/nosok/documents`
- `/admin/systems/nosok/messages`
- `/admin/systems/nosok/reports`
- `/admin/systems/nosok/evidence-center`

## Role matrix

| الدور | مطلوب التحقق |
|---|---|
| visitor | يرى الخدمات العامة فقط |
| citizen | يرى طلبه ونتيجته فقط |
| company_rep | يرى نطاق شركته فقط |
| nosok_employee | يرى الطلبات المسندة فقط |
| nosok_supervisor | يرى نطاقه التشغيلي |
| system_admin | يرى الإعدادات والتقارير حسب الصلاحية |
| superuser | يرى evidence center وaudit |
| restricted | read-only/forbidden |

## Responsive matrix

- 390px mobile
- 768px tablet
- 1366px laptop
- desktop wide

## Production gate

Not approved until actual PalWakf merge, nosok schema creation, RLS/RPC apply, role UAT, responsive UAT, and console review.
