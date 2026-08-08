# Session Handoff — Nosok v10.1

## نقطة البداية

استكمالًا من `Nosok v10 — AccessProfile Binding + Runtime Sidebar Filtering + Unit Scope RPC Closure`.

## سبب الدفعة

استيعاب سجل تشغيل محلي أظهر أن الحزمة أصبحت تملك `pubspec.yaml` و`main.dart` لكن لم تكن مكتملة للـ Web preview، كما احتوت على compile blockers في Widgets إدارية.

## ما تم تصحيحه

- إضافة ملفات Web preview.
- توسيع `NosokSectionCard` لدعم `actions`.
- توسيع `NosokStatCard` لدعم `label`.
- إضافة `_companyField` داخل Dialog الشركات.

## ما لم يتغير

- لا SQL جديد.
- لا تعديل في route positioning.
- لا تعديل في AccessProfile contract.
- لا waqf_assets mutation.

## أوامر إعادة الاختبار المطلوبة محليًا

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

ثم افتح:

- `/systems/nosok`
- `/admin/systems/nosok`
- `/admin/systems/nosok/applications`
- `/admin/systems/nosok/companies`
- `/admin/systems/nosok/reports`

## الحكم

`hotfix-ready / local-retest-required / production-not-approved`.
