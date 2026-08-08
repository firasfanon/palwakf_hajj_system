# ERROR RECORD — Nosok UI Mega Batch v23.2

## الخطأ
`PwfSisNotice` استُخدم في `nosok_requirements_page.dart` مع parameter باسم `icon`، بينما تعريف المكوّن لا يحتوي على هذا المعامل.

## ملف الخطأ
`lib/features/nosok_system/presentation/pages/public/nosok_requirements_page.dart`

## السجل المحلي
- `dart format .` نجح.
- `flutter analyze` أعاد 3 issues، بينها error مانع: `The named parameter 'icon' isn't defined`.
- `flutter run -d chrome` فشل لنفس السبب.

## السبب
عدم توافق صفحة المتطلبات مع signature الحالية لمكوّن `PwfSisNotice` في `pwf_sis_nosok_components.dart`.

## الحل
إزالة `icon` من `PwfSisNotice` والإبقاء على الرسالة النصية الخاصة بتطبيق مناسكنا كإرشاد عام.

## آخر baseline مستقر نسبيًا
v23.1 مع وجود blocker موضعي في صفحة المتطلبات.

## الحكم بعد الحل
hotfix-ready / local-retest-required / production-not-approved.
