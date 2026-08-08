# BASELINE CHANGELOG — Nosok v10

## العنوان
Nosok v10 — AccessProfile Binding + Runtime Sidebar Filtering + Unit Scope RPC Closure + Operational Standalone Host

## فوق baseline
v09 — Semi-Independent Runtime under PalWakf.

## التغييرات
1. إضافة `pubspec.yaml` و`lib/main.dart` لتشغيل معاينة standalone/preview.
2. إضافة fallback repository آمن: `NosokInMemoryRepository` عند غياب Supabase.
3. تعديل `nosokRepositoryProvider` ليستخدم Supabase عند توفره، أو mock preview عند التشغيل المستقل.
4. إضافة `NosokAccessProfile` و`nosokAccessProfileProvider` كنقطة ربط مع AccessProfile الحقيقي من المنصة.
5. إضافة `NosokAccessGate` لحراسة الصفحات الإدارية حسب الصلاحيات.
6. تصفية سايدبار نسك runtime حسب الصلاحيات عبر `visibleAdminItems(profile)`.
7. إضافة `NosokUnitScope` وcontrollers للوحدات.
8. ربط صفحات الوحدات العامة والإدارية بـ RPC/Repository بدل قوائم demo ثابتة.
9. إضافة SQL: `09_nosok_access_profile_sidebar_unit_scope_closure.sql`.
10. إضافة مقترح ربط provider داخل المنصة.

## الحدود السيادية
- لا إنشاء مستخدمين داخل `nosok`.
- لا نقل RBAC إلى نسك.
- لا تعديل `waqf_assets` أو `waqf` أو `awqaf_system`.
- PalWakf هي host الإنتاجي، وstandalone مجرد preview/development harness.

## الحالة
staging-ready / operational-preview-ready / access-binding-contract-ready / production-not-approved.
