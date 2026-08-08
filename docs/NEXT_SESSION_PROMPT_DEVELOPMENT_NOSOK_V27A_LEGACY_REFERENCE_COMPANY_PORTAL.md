# NEXT SESSION PROMPT — تطوير نسك للحج والعمرة — V27A_LEGACY_REFERENCE_COMPANY_PORTAL

ابدأ من baseline الناتج عن V27A.

## نفذ أولًا

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

## ثم افتح المسارات

```text
/services/nosok
/services/nosok/hajj
/services/nosok/requirements
/services/nosok/companies
/services/nosok/company-login
/services/nosok/contact
```

## الدفعة التالية المقترحة

```text
Nosok v27B — Local Retest Result Intake + Company Portal RBAC Contract + Legacy Portal Content Seed Decision
```

## قواعد حاكمة

- لا تستخدم legacy.dart في الملفات الجديدة.
- لا SQL إنتاجي دون تصريح.
- لا waqf_assets mutation.
- لا production approval دون إغلاق P0.
