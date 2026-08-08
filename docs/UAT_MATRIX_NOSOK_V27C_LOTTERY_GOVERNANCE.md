# UAT MATRIX — Nosok v27C Lottery Governance

## أوامر محلية مطلوبة

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

## Public Browser UAT

| Route | Expected |
|---|---|
| `/services/nosok/lottery-results` | صفحة نتيجة قرعة للمواطن دون كشف بيانات الآخرين |
| `/services/nosok/waiting-list` | قائمة انتظار حسب LGU مع منع النقل التلقائي |
| `/services/nosok/objections` | صفحة اعتراضات آمنة staging |

## Internal Browser UAT

| Route | Expected |
|---|---|
| `/admin/systems/nosok/lottery` | لوحة حوكمة القرعة وحصص LGU |
| `/admin/systems/nosok/lottery/eligibility` | قواعد أهلية قابلة للتعديل حسب سياسة الموسم |
| `/admin/systems/nosok/lottery/draw` | شرح تنفيذ capacity-aware draw دون تشغيل إنتاجي |
| `/admin/systems/nosok/lottery/waiting-list` | إدارة انتظار لكل تجمع |
| `/admin/systems/nosok/lottery/committee` | قرارات لجنة الحج للحصص غير المستكملة |
| `/admin/systems/nosok/lottery/audit` | أدلة تدقيق draw/policy snapshot |

## SQL UAT

```sql
\i sql/25_nosok_v27c_lottery_governance_read_only_uat.sql
```

## Role UAT

| Role | Expected |
|---|---|
| visitor/citizen | يرى نتيجة طلبه فقط بعد التحقق |
| nosok employee | يرى أهلية/مراجعة حسب الصلاحية |
| nosok supervisor | يرى waiting list ونطاقه |
| nosok lottery manager | يرى lottery/draw/committee |
| superuser | يرى audit |
| restricted | read-only أو forbidden |
