# UAT MATRIX — Nosok v38B

## Flutter local retest

| الفحص | الحالة |
|---|---|
| `dart format .` | مطلوب محليًا بعد الحزمة |
| `flutter analyze` | مطلوب محليًا بعد الحزمة |
| `flutter run -d chrome` | مطلوب محليًا بعد الحزمة |

## Public runtime

| المسار | الفحص |
|---|---|
| `/services/nosok` | واجهة عامة حديثة / لا لغة تقنية |
| `/services/nosok/apply` | لا صفحة بيضاء / لا Stepper runtime crash |
| `/services/nosok/track` | lookup آمن |
| `/services/nosok/lottery-results` | نتيجة المواطن فقط |
| `/services/nosok/waiting-list` | انتظار المواطن فقط |
| `/services/nosok/objections` | نموذج اعتراض واضح |
| `/services/nosok/companies` | دليل شركات عام |

## Admin readiness

| المسار | الفحص |
|---|---|
| `/admin/systems/nosok/evidence-center` | مركز أدلة موحد |
| `/admin/systems/nosok/v38b-prejoin-closure` | صفحة الإغلاق التحضيري |

## Role/Responsive matrix

الأدوار: visitor, citizen, company_representative, nosok_employee, nosok_supervisor, system_admin, superuser, restricted_user.

الشاشات: 390px, 768px, 1366px, desktop wide.
