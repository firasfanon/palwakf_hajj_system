# Nosok v38B — Role/Responsive Matrix Completion

## الأدوار

| الدور | نطاق الاختبار | أحجام الشاشة |
|---|---|---|
| visitor | صفحات عامة فقط | 390 / 768 / 1366 / wide |
| citizen | طلبه ونتيجته واعتراضه فقط | 390 / 768 / 1366 / wide |
| company_representative | نطاق الشركة فقط | 390 / 768 / 1366 / wide |
| nosok_employee | الطوابير المسندة | 768 / 1366 / wide |
| nosok_supervisor | نطاق إشرافي وقرعة/انتظار حسب الصلاحية | 768 / 1366 / wide |
| system_admin | إعدادات وتقارير | 1366 / wide |
| superuser | كل المسارات ومركز الأدلة | 1366 / wide |
| restricted_user | forbidden أو read-only | 390 / 768 / 1366 / wide |

## معايير القبول

- المواطن لا يرى لوحة الموظف.
- الشركة لا ترى شركات أخرى.
- الموظف لا يرى الأدلة التاريخية إلا بصلاحية مناسبة.
- restricted user لا يحصل على Page Not Found لمسار معروف؛ بل forbidden/login مضبوط داخل المنصة.
- لا overflow ولا RenderFlex ولا صفحة بيضاء.
