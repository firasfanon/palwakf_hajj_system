# BASELINE CHANGELOG — Nosok v37H Public Transaction Forms Premium UX

**التاريخ:** 2026-05-21  
**النوع:** Public UI/UX refinement only  
**آخر baseline:** `nosok_v37g_apply_stepper_runtime_layout_fix_2026_05_20.zip`

## الحكم

```text
staging-stable /
nosok-v37h-public-transaction-forms-premium-ux-applied /
apply-form-visual-redesign-applied /
track-form-alignment-applied /
citizen-progress-bar-applied /
input-field-styling-applied /
mobile-form-hardening-applied /
local-flutter-retest-required /
production-not-approved /
no-waqf-assets-mutation
```

## التغييرات البرمجية

1. استبدال `Stepper` الافتراضي في صفحة `/services/nosok/apply` بتجربة `Citizen Progress Bar` مخصصة.
2. إزالة الاعتماد على `StepperType.horizontal` داخل `Scrollable` لتجنب أخطاء `RenderFlex unbounded height`.
3. إعادة بناء نموذج التقديم إلى:
   - شريط تقدم مواطن responsive.
   - رأس خطوة واضح.
   - حقول إدخال بنمط سيادي.
   - أزرار متابعة/رجوع full-width على الموبايل.
4. تحسين صفحة متابعة الطلب `/services/nosok/track` بتصميم تحقق آمن حديث.
5. إضافة `PwfSisTransactionLookupPanel` لاستخدامه في صفحات النتائج/الانتظار/الاعتراضات.
6. إضافة lookup panels للصفحات:
   - `/services/nosok/lottery-results`
   - `/services/nosok/waiting-list`
   - `/services/nosok/objections`
7. تحديث `PwfSisServiceCard` و`PwfSisTrackingCard` لتجنب ألوان Theme قد تولد زهري/وردي، والاعتماد على الأزرق السيادي والذهبي الوقفي.

## حدود الدفعة

- لا SQL.
- لا Backend.
- لا إنشاء schema.
- لا تعديل على `waqf_assets`.
- لا تغيير في RBAC.

## retest المطلوب

```bash
dart format .
flutter analyze
flutter run -d chrome
```

ثم فتح:

```text
/services/nosok/apply
/services/nosok/track
/services/nosok/lottery-results
/services/nosok/waiting-list
/services/nosok/objections
```
