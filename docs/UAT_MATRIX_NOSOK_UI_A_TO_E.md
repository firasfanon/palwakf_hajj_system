# UAT MATRIX — Nosok UI A–E

| المجال | الحالة | ملاحظات |
|---|---|---|
| Public routes | ready-for-local-retest | `/services/nosok`, `/apply`, `/track`, `/requirements`, `/faq` |
| Internal routes | ready-for-local-retest | `/admin/systems/nosok`, `/requests`, `/review`, `/campaigns`, `/groups`, `/documents`, `/messages`, `/reports`, `/settings` |
| PWF-SIS components | applied/hardened | FAQ/reports/settings/groups + safe async errors |
| Role-Based UI | preserved/pending-browser-evidence | `NosokAccessGate` لم يُكسر؛ مطلوب UAT أدوار فعلي |
| Responsive | implementation-applied/pending-browser-evidence | tables/cards/adaptive grids؛ مطلوب فتح mobile/tablet/desktop |
| Raw backend errors | reduced/static-pass-for-known-patterns | لا توجد `$error` في presentation بعد الفحص النصي |
| SQL UAT | not-run | لا SQL إنتاجي ولا DML |
| Analyzer | not-run-in-container | مطلوب تشغيل محلي |
| Chrome startup | not-run-in-container | مطلوب تشغيل محلي |
| Production gate | blocked | P0 evidence غير مكتملة |
