# ERROR RECORD — Nosok v27D

## E-v27C-1

- **السبب:** `NosokLguQuotaStatus`/`labelAr` كانا يسببان compile blocker في صفحة waiting list قبل v27C-1.
- **الحل السابق:** إضافة import الناقص في `nosok_waiting_list_page.dart`.
- **أثر v27D:** تم تقليل مخاطر تكرار المشكلة بإضافة imports مباشرة للـ model في الصفحات التي تستخدم enum extensions.

## E-v27D-local-retest-required

- **السبب:** بيئة الحاوية لا تحتوي Flutter/Dart.
- **ما فشل:** لم يتم تشغيل `flutter analyze` أو `flutter run -d chrome` داخل الحاوية.
- **الحل:** يجب تشغيل أوامر retest محليًا بعد فك baseline.
- **آخر baseline مستقر قبل الدفعة:** `nosok_v27c1_lottery_compile_fix_2026_05_19.zip`.
