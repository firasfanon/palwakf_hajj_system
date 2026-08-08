# ERROR RECORD — Nosok v17

## Previous blocker
لا يوجد compile blocker جديد مستلم قبل v17. v17 بُني فوق v16 بعد استقرار v15.2 runtime material hotfix.

## Risk addressed
كانت صفحات Workbench وService Desk وSeason Command في v16 قريبة من واجهات إرشادية ثابتة، وليست مربوطة ببيانات تشغيلية كافية.

## Fix
- إضافة نماذج Domain وControllers وRepository contracts.
- إضافة RPCs محسوبة للـ Workbench.
- إضافة بحث إداري محمي لمكتب الخدمة.
- إضافة Gate قرار فتح الموسم دون mutation تلقائي.

## Pending verification
- `dart format .`
- `flutter analyze`
- `flutter run -d chrome`
- SQL UAT: `select * from public.rpc_nosok_v17_runtime_contract_uat_v1();`

## Last stable baseline
`nosok_platform_integration_patch_v16_government_ux_admin_productivity_under_platform.zip`
