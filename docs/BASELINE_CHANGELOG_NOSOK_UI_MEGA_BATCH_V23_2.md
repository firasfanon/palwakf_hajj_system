# BASELINE CHANGELOG — Nosok UI Mega Batch v23.2

## الحالة
hotfix-ready / requirements-page-compile-blocker-fixed / manasikna-public-mention-preserved / analyzer-retest-required / production-not-approved / no-waqf-assets-mutation

## سبب الدفعة
بعد v23.1 أظهر الفحص المحلي أن `flutter analyze` و`flutter run -d chrome` يتوقفان بسبب تمرير named parameter غير موجود `icon` إلى `PwfSisNotice` في صفحة متطلبات نسك العامة.

## التعديل
- تعديل `lib/features/nosok_system/presentation/pages/public/nosok_requirements_page.dart`.
- إزالة `icon: Icons.phone_iphone_outlined` من `PwfSisNotice` لأن المكوّن الحالي يدعم `title/message/tone` فقط.
- إزالة `const` الزائدة الناتجة عن nesting داخل `const PwfSisPublicServiceShell`.
- الإبقاء على ذكر تطبيق مناسكنا كقناة إرشادية مساندة في شاشة الجمهور دون تحويله إلى تكامل backend وهمي.

## حدود السلامة
- لا SQL إنتاجي.
- لا DML.
- لا تعديل على `waqf_assets`.
- لا تعديل على schema `waqf`.
- لا تغيير في routes أو RBAC.

## المطلوب بعد التسليم
تشغيل:

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

ثم فتح:

```text
/services/nosok/requirements
/services/nosok
/services/nosok/apply
/services/nosok/track
/admin/systems/nosok
```
