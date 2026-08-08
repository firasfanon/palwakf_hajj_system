# BASELINE CHANGELOG — Nosok v09 Semi-Independent Runtime Build

## التاريخ
2026-05-17

## آخر baseline سابق
`nosok_platform_integration_patch_v08_v73_aligned_under_platform.zip`

## baseline الحالي
`nosok_platform_integration_patch_v09_semi_independent_runtime_under_platform.zip`

## سبب الدفعة
طلب تطوير نسك باعتباره مشروعًا/نظامًا شبه مستقلًا تحت العقد الحاكم للمنصة، بحيث يشمل جميع احتياجات التشغيل شبه المستقل: الصفحات الجديدة، صفحات الوحدات، لوحة التحكم، السايدبار، المستخدمين، الأدوار، الصلاحيات، ونطاقات التشغيل.

## القرارات الحاكمة
1. PalWakf هي المنصة الأم والأساس السيادي.
2. Nosok نظام شبه مستقل تحت PalWakf، وليس تطبيقًا مستقلًا ولا نظامًا فوق المنصة.
3. public entry يبقى داخل `/systems/nosok` ولا يعود إلى `/nosok` حتى لا يتعارض مع `/:unitSlug`.
4. admin entry الحاكم يصبح `/admin/systems/nosok`.
5. `/admin/nosok` legacy redirect فقط.
6. لا يوجد جدول مستخدمين داخل `nosok`; الهوية والصلاحيات من منصة PalWakf.
7. superuser/platformAdmin يجب أن يملك override أعلى من أدوار نسك المحلية.
8. صفحات الوحدات في نسك لا تنشئ source-of-truth جديدًا للوحدات؛ `core.org_units` هو المرجع.

## ملفات مضافة
- `lib/features/nosok_system/system_navigation.dart`
- `lib/features/nosok_system/presentation/widgets/nosok_admin_system_shell.dart`
- `lib/features/nosok_system/presentation/widgets/nosok_public_system_shell.dart`
- `lib/features/nosok_system/presentation/pages/public/nosok_public_unit_page.dart`
- `lib/features/nosok_system/presentation/pages/admin/nosok_admin_units_page.dart`
- `lib/features/nosok_system/presentation/pages/admin/nosok_admin_unit_page.dart`
- `lib/features/nosok_system/presentation/pages/admin/nosok_admin_users_roles_page.dart`
- `lib/features/nosok_system/presentation/pages/admin/nosok_admin_sidebar_page.dart`
- `lib/features/nosok_system/presentation/pages/admin/nosok_admin_settings_page.dart`
- `lib/features/nosok_system/presentation/pages/admin/nosok_admin_health_page.dart`
- `sql/08_nosok_semi_independent_runtime.sql`

## ملفات معدلة
- `lib/features/nosok_system/system_routes.dart`
- `lib/features/nosok_system/system_permissions.dart`
- `lib/features/nosok_system/system_manifest.dart`
- `lib/features/nosok_system/presentation/routes/nosok_routes.dart`
- `lib/features/nosok_system/presentation/pages/admin/nosok_admin_dashboard_page.dart`
- `platform_merge_patch/lib/app/routing/app_routes.dart`
- `platform_merge_patch/lib/app/routing/go_router_config.dart`
- `platform_merge_patch/lib/app/routing/route_groups/public_routes_group.dart`
- `platform_merge_patch/lib/app/routing/route_groups/admin_routes_group.dart`

## UAT المطلوب
- SQL 08 execution.
- تشغيل `public.rpc_nosok_v09_runtime_contract_uat_v1()`.
- Browser UAT:
  - `/switch/nosok`
  - `/systems/nosok`
  - `/systems/nosok/units/home`
  - `/admin/systems/nosok`
  - `/admin/systems/nosok/units`
  - `/admin/systems/nosok/users-roles`
  - `/admin/systems/nosok/sidebar`
  - `/admin/systems/nosok/settings`
  - `/admin/systems/nosok/health`
- Role UAT:
  - superuser يرى ويدخل النظام.
  - مستخدم محدود لا يرى/لا يدخل إلا حسب صلاحياته.

## الحكم الحالي
`staging-ready / semi-independent-runtime-build / platform-integration-patch / production-not-approved / no-waqf-assets-mutation`
