# SESSION HANDOFF — Nosok v09 Semi-Independent Runtime Build

## نقطة البداية للجلسة القادمة
ابدأ من الحزمة:
`nosok_platform_integration_patch_v09_semi_independent_runtime_under_platform.zip`

## التعريف الحاكم
نسك نظام شبه مستقل تحت منصة PalWakf. المنصة هي الأساس السيادي، ونسك يمتلك صفحات ونطاق تشغيل وبيانات وسايدبار داخلي وقوالب أدوار خاصة، لكنه لا يمتلك هوية مستقلة ولا RBAC مستقلًا خارج منصة PalWakf.

## ما يجب عدم كسره
- لا تستخدم `/nosok` كمدخل عام مباشر.
- لا تجعل `/admin/nosok` هو المسار الحاكم؛ هو legacy redirect فقط.
- لا تنشئ جدول مستخدمين داخل `nosok`.
- لا تنقل أو تعدل `waqf_assets` أو `awqaf_system` أو `waqf`.
- لا تجعل `public` مصدر بيانات حاكم؛ public للـ RPC/views wrappers فقط.
- لا تستخدم `legacy.dart` في الملفات الجديدة.

## ما أضيف في v09
1. Shell إداري داخلي لنظام نسك مع sidebar.
2. Shell عام داخلي خفيف لنظام نسك.
3. صفحة عامة للوحدة.
4. صفحات إدارية للوحدات.
5. صفحة المستخدمين والأدوار والصلاحيات.
6. صفحة السايدبار الداخلي.
7. صفحة إعدادات النظام.
8. صفحة الصحة والتشغيل.
9. SQL 08 لعقود التشغيل شبه المستقل.
10. تحديث routes/platform patch ليعتمد `/admin/systems/nosok`.

## خطوات الدمج المقترحة
1. انسخ `lib/features/nosok_system` إلى ريبو PalWakf داخل المسار نفسه أو المسار المعتمد للأنظمة.
2. طبّق `platform_merge_patch` يدويًا على ملفات المنصة الفعلية.
3. أضف imports الخاصة بالصفحات الجديدة إذا كان الريبو الفعلي يستخدم ملف route مركزي مختلف.
4. شغّل SQL بالترتيب من 00 إلى 08 حسب حالة البيئة.
5. شغّل UAT helper:
   `select * from public.rpc_nosok_v09_runtime_contract_uat_v1();`
6. شغّل `dart format .` ثم `flutter analyze`.
7. شغّل Browser UAT للمسارات العامة والإدارية.
8. نفّذ Role UAT لمستخدم superuser ومستخدم محدود.

## بوابات الإنتاج غير المغلقة
- Route guard النهائي حسب AccessProfile.
- إخفاء sidebar items حسب صلاحيات المستخدم فعليًا، لا عرض static فقط.
- ربط صفحات الوحدات بـ `core.org_units` وRPC حقيقي.
- ربط صفحة settings بـ RPC upsert/list محمي.
- ربط صفحة health بـ checks runtime حقيقية.
- Browser Console Review.
- Security/RLS review.

## نقطة العمل التالية
`Nosok v10 — AccessProfile Binding + Runtime Sidebar Filtering + Unit Scope RPC Closure`
