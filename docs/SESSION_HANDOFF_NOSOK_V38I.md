# SESSION HANDOFF — Nosok v38I

## آخر baseline

`nosok_v38i_standalone_real_supabase_development_binding_2026_05_21.zip`

## الحالة

```text
staging-stable /
nosok-v38i-standalone-real-supabase-development-binding-applied /
core-reference-shape-discovery-ready /
nosok-schema-creation-pack-ready-not-applied /
public-rpc-wrappers-prepared /
repository-mode-switch-prepared /
production-not-approved /
no-waqf-assets-mutation
```

## نقطة الاستئناف

تشغيل SQL discovery أولًا:

```text
sql/38_nosok_v38i_core_reference_shape_discovery_read_only.sql
```

ثم إرسال النتائج قبل تعديل أي FK/core wrapper نهائي.

## قرار حاكم

نسك يعمل كـ Standalone Real DB Development مؤقتًا. هذا لا يعني إنتاج ولا انضمام فعلي. بيانات نسك في `nosok`; مراجع LGU/governorates/org_units في `core`; `public` wrappers فقط.
