# BASELINE CHANGELOG — Nosok v38C Admin Tools Pre-Join Scope

## التاريخ
2026-05-21

## نوع الدفعة
Development / Preparation Only — Admin Tools Contracts + UI Surfaces

## التغييرات

- إضافة عقد `NosokPrejoinAdminToolsContract`.
- إضافة provider: `nosokPrejoinAdminToolsContractProvider`.
- إضافة صفحة إدارة أقسام الصفحة الرئيسية:
  - `/admin/systems/nosok/homepage-sections`
- إضافة صفحة نطاق الموظفين حسب slug/LGU:
  - `/admin/systems/nosok/unit-scope-access`
- إضافة صفحة قيود التسجيل والنزاهة:
  - `/admin/systems/nosok/registration-governance`
- إضافة صفحة ملخص v38C:
  - `/admin/systems/nosok/v38c-admin-tools-prejoin`
- تحديث routes/navigation/permissions/AccessProfile contract.
- إضافة SQL draft غير مطبق:
  - `sql/32_nosok_v38c_admin_tools_homepage_unit_scope_registration_contract.sql`
- إضافة حزمة توثيق:
  - `admin_tools_prejoin_pack/NOSOK_V38C_ADMIN_TOOLS_PREJOIN_SCOPE.md`

## ما لم يتم

- لا تنفيذ انضمام إلى PalWakf.
- لا إنشاء schema.
- لا SQL apply.
- لا DML.
- لا backend binding.
- لا تعديل waqf_assets.

## الحكم

```text
staging-stable /
nosok-v38c-admin-tools-prejoin-scope-applied /
homepage-sections-admin-contract-ready /
unit-slug-lgu-access-contract-ready /
registration-governance-locks-contract-ready /
schema-draft-not-applied /
production-not-approved /
no-waqf-assets-mutation
```
