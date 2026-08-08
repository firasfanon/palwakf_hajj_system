# SESSION HANDOFF — تطوير نسك للحج والعمرة — V27A_LEGACY_REFERENCE_COMPANY_PORTAL

## الحالة الحالية

```text
staging-stable /
legacy-nosok-portal-reference-intake-applied /
company-partner-workspace-added /
public-contact-support-added /
hajj-season-content-model-enhanced /
production-not-approved /
local-flutter-retest-required /
no-waqf-assets-mutation
```

## ما تم تنفيذه

تم تنفيذ دفعة واحدة فوق baseline السابق لاستيعاب روابط بوابة نسك الحالية، خصوصًا الصفحة الرئيسية، الحج، الشركات المؤهلة، دخول الشركات، واتصل بنا. تم الحفاظ على PWF-SIS وعدم نقل التصميم القديم.

## نقطة الاستئناف التالية

```text
Nosok v27B — Local Retest Result Intake + Company Portal RBAC Contract + Legacy Portal Content Seed Decision
```

## المطلوب أولًا في الجلسة القادمة

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

ثم اختبار:

```text
/services/nosok
/services/nosok/hajj
/services/nosok/requirements
/services/nosok/companies
/services/nosok/company-login
/services/nosok/contact
```

## تحذيرات

- لا production-ready قبل analyzer/Chrome/Browser/Responsive/Role UAT.
- لا SQL إنتاجي دون تصريح.
- لا لمس لـ `waqf_assets` أو schema `waqf` أو `awqaf_system`.
