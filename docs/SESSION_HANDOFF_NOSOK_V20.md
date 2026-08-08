# Session Handoff — Nosok v20

## نقطة البداية القادمة
ابدأ من:
`nosok_platform_integration_patch_v20_production_uat_operations_integration_under_platform.zip`

## ما أُنجز
- صفحة `/admin/systems/nosok/production-uat-closure`
- صفحة `/admin/systems/nosok/application-operations`
- صفحة `/admin/systems/nosok/platform-integration-readiness`
- SQL: `sql/18_nosok_v20_production_uat_operations_integration_pack.sql`
- تحديث الصلاحيات والمسارات والسايدبار.

## الاختبار المطلوب
```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

ثم افتح:
- `/admin/systems/nosok/production-uat-closure`
- `/admin/systems/nosok/application-operations`
- `/admin/systems/nosok/platform-integration-readiness`
- `/admin/systems/nosok/applications/application-001`
- `/systems/nosok/application-status`

## SQL UAT
```sql
select * from public.rpc_nosok_v20_runtime_contract_uat_v1();
select * from public.rpc_nosok_v20_production_uat_closure_v1();
select * from public.rpc_nosok_v20_application_operations_sla_v1();
select * from public.rpc_nosok_v20_platform_integration_readiness_v1();
```

## الحكم
Production NOT APPROVED. v20 يغلق حزمة جاهزية وأدلة، لكنه لا يعتمد الإنتاج دون نتائج UAT فعلية.
