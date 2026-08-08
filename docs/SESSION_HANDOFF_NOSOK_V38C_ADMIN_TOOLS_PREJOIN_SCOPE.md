# SESSION HANDOFF — Nosok v38C Admin Tools Pre-Join Scope

## نقطة البداية
Baseline سابق: `Nosok v38B — Pre-Join Final Development Closure`.

## القرار الحاكم
نسك لا ينفذ الانضمام إلى PalWakf في هذا المسار. نسك يطوّر ويجهّز نفسه فقط. v38C أضاف أدوات إدارية تحضيرية مطلوبة لأن نسك نظام شبه مستقل، لكن الجداول والـ RPCs لا تُنشأ إلا بعد استضافة PalWakf.

## الملفات المهمة

- `lib/features/nosok_system/domain/models/nosok_prejoin_admin_tools_contract.dart`
- `lib/features/nosok_system/application/nosok_prejoin_admin_tools_controller.dart`
- `lib/features/nosok_system/presentation/pages/admin/nosok_admin_homepage_sections_page.dart`
- `lib/features/nosok_system/presentation/pages/admin/nosok_admin_unit_scope_access_page.dart`
- `lib/features/nosok_system/presentation/pages/admin/nosok_admin_registration_governance_page.dart`
- `lib/features/nosok_system/presentation/pages/admin/nosok_admin_v38c_admin_tools_prejoin_page.dart`
- `lib/features/nosok_system/system_routes.dart`
- `lib/features/nosok_system/system_navigation.dart`
- `lib/features/nosok_system/system_permissions.dart`
- `lib/features/nosok_system/application/access/nosok_access_profile.dart`
- `sql/32_nosok_v38c_admin_tools_homepage_unit_scope_registration_contract.sql`

## المسارات الجديدة

```text
/admin/systems/nosok/homepage-sections
/admin/systems/nosok/unit-scope-access
/admin/systems/nosok/registration-governance
/admin/systems/nosok/v38c-admin-tools-prejoin
```

## الفحص المطلوب

```bash
dart format .
flutter analyze
flutter run -d chrome
```

ثم افتح المسارات الجديدة أعلاه.

## موانع الإنتاج

- لا schema.
- لا SQL apply.
- لا backend binding.
- لا join execution.
- لا production approval.

