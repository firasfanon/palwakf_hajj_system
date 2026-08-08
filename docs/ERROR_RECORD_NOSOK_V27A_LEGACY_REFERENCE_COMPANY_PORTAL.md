# ERROR RECORD — Nosok V27A_LEGACY_REFERENCE_COMPANY_PORTAL

## ER-001 — Legacy portal content risk

- **السبب:** بوابة نسك الحالية تعرض محتوى وخدمات مهمة لكن بتصميم قديم وصفحات PHP-style.
- **المعالجة:** تم نقل المنطق والمحتوى فقط إلى PWF-SIS، دون نقل التصميم القديم.
- **الملفات:** `nosok_public_home_page.dart`, `nosok_hajj_page.dart`, `nosok_requirements_page.dart`.
- **الحالة:** mitigated.

## ER-002 — Company portal could be mistaken as active backend

- **السبب:** وجود رابط دخول شركات في البوابة الحالية قد يوحي بأن مساحة الشريك مفعّلة بالكامل داخل baseline.
- **المعالجة:** تم بناء صفحة Partner Workspace بعلامات `pending/planned/disabled` دون ادعاء وجود backend.
- **الملفات:** `nosok_company_portal_page.dart`.
- **الحالة:** mitigated.

## ER-003 — Local retest unavailable in container

- **السبب:** أدوات `flutter` و`dart` غير متاحة داخل بيئة التنفيذ الحالية.
- **المعالجة:** تم توثيق retest كمانع محلي واجب قبل أي اعتماد.
- **الأوامر المطلوبة:** `flutter clean`, `flutter pub get`, `dart format .`, `flutter analyze`, `flutter run -d chrome`.
- **الحالة:** open-local-retest-required.
