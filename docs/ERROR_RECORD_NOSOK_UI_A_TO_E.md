# ERROR RECORD — Nosok UI A–E

## ER-UI-AE-001 — Raw backend error exposure

- **السبب:** بعض صفحات الجمهور والإدارة كانت تعرض `$error` أو `error.toString()` داخل UI.
- **الملفات:** صفحات public/admin متعددة + `nosok_async_view.dart`.
- **ما فشل:** شرط عدم عرض backend raw errors للمواطن أو الموظف.
- **الحل:** استبدال الرسائل الخام برسائل عربية آمنة قابلة للفهم، مع إبقاء إعادة المحاولة أو إرشاد الدعم.
- **آخر baseline مستقر:** `nosok_development_handoff_v26_1_2026_05_19.zip`.

## ER-UI-AE-002 — FAQ خارج مكونات PWF-SIS

- **السبب:** صفحة FAQ كانت تستخدم ListView/ExpansionTile محليًا دون shell/hero موحد.
- **الملفات:** `nosok_faq_page.dart`.
- **الحل:** إعادة بنائها عبر `PwfSisPublicServiceShell`, `PwfSisServiceHero`, `PwfSisFAQAccordion`, `PwfSisPublicHelpCard`.

## ER-UI-AE-003 — Reports/Settings/Groups inconsistent visual surface

- **السبب:** بعض الصفحات الداخلية بقيت على مكونات قديمة أو سطح notice فقط.
- **الملفات:** `nosok_admin_reports_page.dart`, `nosok_admin_settings_page.dart`, `nosok_internal_groups_page.dart`.
- **الحل:** إعادة ضبطها كمجالات تشغيلية/إدارية PWF-SIS مع مؤشرات، جداول responsive، وتحذيرات تكامل آمنة.

## ER-UI-AE-004 — Local toolchain not available in execution container

- **السبب:** Flutter/Dart CLI غير متاح داخل بيئة التنفيذ الحالية.
- **ما فشل:** لم يتم تشغيل `dart format`, `flutter analyze`, `flutter run -d chrome` هنا.
- **الحل:** تسليم baseline مع تعليمات retest محلي إلزامية قبل أي production decision.
