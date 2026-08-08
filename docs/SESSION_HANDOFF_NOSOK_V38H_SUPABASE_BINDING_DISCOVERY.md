# SESSION HANDOFF — Nosok v38H

## الحالة الحالية

```text
staging-stable /
nosok-v38h-supabase-binding-contract-discovery-applied /
platform-client-adapter-prepared /
rpc-repository-binding-design-ready /
shape-discovery-sql-readiness-added /
schema-draft-not-applied /
palwakf-join-execution-deferred /
production-not-approved /
no-waqf-assets-mutation
```

## نقطة الاستئناف

ابدأ من baseline:

`nosok_v38h_supabase_binding_contract_discovery_2026_05_21.zip`

## ما تم

1. تثبيت أن نسك لا ينشئ SupabaseClient مستقلًا.
2. تثبيت أن الربط الحقيقي بعد الاستضافة يكون عبر PalWakf SupabaseService/supabaseServiceProvider.
3. إضافة صفحة اكتشاف عقد Supabase.
4. تجهيز RPC-first contracts.
5. تجهيز shape discovery read-only SQL.

## ما لا يتم بعد

- لا schema creation.
- لا SQL apply.
- لا backend binding.
- لا انضمام فعلي إلى PalWakf.
- لا production approval.

## الفحص المطلوب محليًا

```bash
dart format .
flutter analyze
flutter run -d chrome
```

ثم افتح:

```text
/admin/systems/nosok/supabase-binding-discovery
/admin/systems/nosok/v38h-supabase-binding
/admin/systems/nosok/platform-schema-bindings
/services/nosok
```

## التالي المقترح

`Nosok v38I — Final Pre-Join Package Freeze + Handoff for Platform Track`
