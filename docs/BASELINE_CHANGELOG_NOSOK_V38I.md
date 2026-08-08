# BASELINE CHANGELOG — Nosok v38I

## الدفعة

Nosok v38I — Standalone Real Supabase Development Binding + Core Reference Shape Discovery + Nosok Schema Creation Pack + Public RPC Wrappers + Homepage Sections Runtime Admin + Repository Adapter + No Production Approval.

## التغييرات

- إضافة عقد Dart لربط Standalone Real Supabase Development.
- إضافة صفحة إدارية:
  - `/admin/systems/nosok/standalone-supabase-development`
  - `/admin/systems/nosok/v38i-standalone-supabase-development`
- إضافة وضع تشغيل Repository جديد عبر `NOSOK_DATA_MODE`:
  - `preview`
  - `standaloneSupabaseDevelopment`
  - `platformHosted`
- تجهيز SQL shape discovery لـ `core`.
- تجهيز SQL إنشاء schema نسك للتطوير فقط.
- تجهيز SQL UAT read-only بعد إنشاء schema.
- تثبيت أن `core` هو مصدر LGU/governorates/org_units، وأن `public` wrappers فقط.

## لم يتم

- لم يتم تشغيل SQL.
- لم يتم إنشاء schema فعليًا داخل هذه الجلسة.
- لم يتم تنفيذ انضمام إلى PalWakf.
- لم يتم اعتماد الإنتاج.
- لم يتم تعديل `waqf_assets`.
