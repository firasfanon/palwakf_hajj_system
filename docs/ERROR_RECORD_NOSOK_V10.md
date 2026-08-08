# ERROR RECORD — Nosok v10

## الخطأ/الفجوة
الحزمة السابقة كانت feature patch غير مكتملة تشغيليًا؛ لا تحتوي على `main.dart` ولا `pubspec.yaml`، كما كان سايدبار نسك يعرض عناصر ثابتة دون تصفية فعلية من AccessProfile.

## السبب
تم التعامل مع نسك كحزمة دمج فقط، بينما شرط النظام شبه المستقل يتطلب حزمة قابلة للمعاينة والتشغيل المرحلي، مع نقطة ربط واضحة لصلاحيات المنصة.

## ما فشل
- لا يمكن تشغيل preview مستقل.
- لا توجد نقطة injection واضحة لـ AccessProfile.
- صفحات الوحدات كانت demo static.
- السايدبار لا يعكس صلاحيات المستخدم.

## الحل
- إضافة `pubspec.yaml` و`lib/main.dart`.
- إضافة `NosokInMemoryRepository` للمعاينة.
- إضافة `NosokAccessProfile` و`NosokAccessGate`.
- تصفية السايدبار حسب الصلاحيات.
- إغلاق unit scope عبر RPCs ونموذج Flutter.

## آخر baseline مستقر
`nosok_platform_integration_patch_v10_access_runtime_operational_under_platform.zip`
