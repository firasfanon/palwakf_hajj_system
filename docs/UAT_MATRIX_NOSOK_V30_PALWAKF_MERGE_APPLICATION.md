# UAT MATRIX — Nosok v30

| البند | المسار/النطاق | المطلوب | الحالة |
|---|---|---|---|
| v29 compile blocker | `/admin/systems/nosok/v29-merge-readiness` | يجب أن يفتح دون Dart parse errors | local retest required |
| v30 page | `/admin/systems/nosok/v30-palwakf-merge-application` | عرض Registry/RBAC/UAT/Schema prep | local retest required |
| Public portal | `/services/nosok` | لا أدوات موظفين، CTA واضح | PalWakf UAT pending |
| Admin console | `/admin/systems/nosok` | RBAC guard حقيقي داخل PalWakf | pending merge |
| Lottery draw | `/admin/systems/nosok/lottery/draw` | لا تشغيل فعلي قبل DB، governance state واضح | pending merge |
| Responsive | public/admin/lottery | desktop/tablet/mobile no overflow | pending evidence |
| Role UAT | visitor/citizen/employee/supervisor/committee/admin/superuser/restricted | كل دور يرى نطاقه فقط | pending evidence |
| Database | `nosok schema` | لا إنشاء قبل الدمج | not-created-by-design |
