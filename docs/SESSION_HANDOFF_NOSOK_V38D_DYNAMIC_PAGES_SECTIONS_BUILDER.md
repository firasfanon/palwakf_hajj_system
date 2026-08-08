# Session Handoff — Nosok v38D Dynamic Pages + Sections Builder

## نقطة البداية
Baseline سابق: `Nosok v38C — Admin Tools Pre-Join Scope`.

## سبب الدفعة
أوضح المستخدم أن نسك كنظام شبه مستقل يجب أن يستطيع إضافة صفحات وأقسام جديدة مستقبلًا من لوحة الإدارة دون الرجوع للمطور، مع استمرار الفصل بين الصفحات العامة والصفحات الإدارية حسب الصلاحيات.

## القرار
تمت إضافة قدرة تحضيرية لإدارة الصفحات والأقسام الديناميكية، لكنها بقيت contract/pre-join فقط. التنفيذ الحقيقي يحتاج PalWakf hosting ثم schema/RPC/RLS.

## المسارات الجديدة
- `/admin/systems/nosok/dynamic-pages`
- `/admin/systems/nosok/v38d-dynamic-pages-prejoin`

## الملفات الأساسية
- `lib/features/nosok_system/domain/models/nosok_prejoin_admin_tools_contract.dart`
- `lib/features/nosok_system/application/nosok_prejoin_admin_tools_controller.dart`
- `lib/features/nosok_system/presentation/pages/admin/nosok_admin_dynamic_pages_page.dart`
- `lib/features/nosok_system/presentation/pages/admin/nosok_admin_v38d_dynamic_pages_prejoin_page.dart`
- `lib/features/nosok_system/presentation/routes/nosok_routes.dart`
- `lib/features/nosok_system/system_routes.dart`
- `lib/features/nosok_system/system_navigation.dart`
- `lib/features/nosok_system/system_permissions.dart`
- `lib/features/nosok_system/application/access/nosok_access_profile.dart`

## الفحص المطلوب محليًا
```bash
dart format .
flutter analyze
flutter run -d chrome
```

ثم فتح:
- `/admin/systems/nosok/dynamic-pages`
- `/admin/systems/nosok/v38d-dynamic-pages-prejoin`
- `/admin/systems/nosok/homepage-sections`

## الحكم
`production-not-approved / no-waqf-assets-mutation`.
