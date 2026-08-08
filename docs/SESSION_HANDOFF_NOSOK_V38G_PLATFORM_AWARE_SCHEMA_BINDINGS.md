# SESSION HANDOFF — Nosok v38G Platform-Aware Schema + Data Bindings

## آخر baseline

Nosok v38G — Platform-Aware Schema + Data Bindings Preparation.

## نقطة الاستئناف

ابدأ من هذا baseline لتطوير نسك فقط. لا تنفذ الانضمام إلى PalWakf ولا تنشئ schema فعليًا قبل الاستضافة.

## ما تم تثبيته

- يمكن الاستفادة من قراءة ملفات PalWakf التي تمت في v39 الملغاة لمسار نسك.
- مصادر الربط الأساسية:
  - `public.admin_users` للهوية الإدارية.
  - `platform.system_user_roles/permissions` للصلاحيات الديناميكية.
  - `core.org_units` و`public.org_units`/RPC wrappers لنطاق الوحدات.
  - GIS/LGU/Governorates تحتاج shape discovery قبل apply.
- تم تجهيز draft schema لنسك مع homepage_sections/page_registry/user_unit_scope/lgu snapshots.

## الموانع

- لا SQL apply.
- لا schema creation.
- لا backend binding.
- لا PalWakf join execution.
- لا production approval.
- لا waqf_assets mutation.
