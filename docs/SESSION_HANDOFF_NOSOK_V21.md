# SESSION_HANDOFF_NOSOK_V21

## نقطة البداية للجلسة التالية
ابدأ من: `nosok_platform_integration_patch_v21_real_platform_merge_rbac_sql_uat_under_platform.zip`.

## ما أُنجز في v21
- حزمة دمج فعلية داخل `platform_real_merge_pack`.
- صفحات إدارية جديدة للدمج الحقيقي وRBAC وSQL UAT.
- SQL v21 لعقود readiness وRBAC override وSQL UAT intake.
- تحديث المسارات والسايدبار والصلاحيات.

## ما يجب اختباره محليًا
```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

## المسارات المطلوبة للفحص
- `/admin/systems/nosok/real-platform-merge`
- `/admin/systems/nosok/rbac-provider-override`
- `/admin/systems/nosok/sql-uat-intake`
- `/admin/systems/nosok/platform-integration-readiness`

## SQL UAT
```sql
select * from public.rpc_nosok_v21_runtime_contract_uat_v1();
select * from public.rpc_nosok_v21_platform_merge_readiness_v1();
select * from public.rpc_nosok_v21_rbac_override_contract_v1();
select * from public.rpc_nosok_v21_sql_uat_result_intake_v1('nosok_v21_runtime_contract','passed','...',null);
```

## القرار
لا production approval قبل تشغيل SQL UAT في Supabase وBrowser/Role UAT داخل ريبو PalWakf الكامل.
