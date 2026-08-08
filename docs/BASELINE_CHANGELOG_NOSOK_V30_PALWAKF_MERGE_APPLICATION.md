# BASELINE CHANGELOG — Nosok v30

**Batch:** Nosok v30 — Full PalWakf Merge Pack Application + Platform Registry Entry + AccessProfile Override Closure + Browser/Role Responsive UAT Inside PalWakf + Nosok Schema Creation Preparation  
**Date:** 2026-05-20  
**Type:** Large merge-readiness/application batch, pre-database, no production SQL.

## حكم الدفعة

```text
staging-stable /
nosok-v30-palwakf-merge-pack-application-ready /
v29-compile-blocker-closed /
platform-registry-entry-prepared /
access-profile-override-closure-plan-ready /
palwakf-browser-role-responsive-uat-required /
nosok-schema-creation-prepared-not-applied /
production-not-approved /
no-waqf-assets-mutation
```

## أهم التغييرات

1. إغلاق blocker نحوي في صفحة v29:
   - `nosok_admin_v29_merge_readiness_page.dart`
   - السبب: وجود literal line break داخل single-quoted Dart string.
   - الحل: استبداله بـ `\n` داخل string.

2. إضافة صفحة v30:
   - `/admin/systems/nosok/v30-palwakf-merge-application`
   - تعرض خطة الدمج مع PalWakf، Registry، RBAC، UAT، وتحضير schema.

3. إضافة contract/controller للدفعة:
   - `nosok_v30_merge_pack_contract.dart`
   - `nosok_v30_merge_pack_controller.dart`

4. تحديث:
   - `system_routes.dart`
   - `nosok_routes.dart`
   - `system_navigation.dart`
   - `system_manifest.dart`

5. إضافة حزمة `platform_v30_merge_application_pack/` لتوجيه الدمج داخل PalWakf.

6. إضافة SQL readiness marker فقط:
   - `sql/32_nosok_v30_schema_creation_preparation_readiness.sql`

## قيود حاكمة

- لا إنشاء لجداول نسك الآن.
- لا SQL apply.
- لا DML.
- لا Repository real binding.
- لا إنتاج.
- لا تعديل على `waqf_assets` أو schema `waqf` أو `awqaf_system`.
