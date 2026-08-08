# Nosok v37 Runtime Switch Candidate — Review Only

هذه الحزمة لا تحتوي apply SQL. الربط هنا Flutter-side controlled candidate فقط.

## المسموح

- تشغيل SQL read-only: `sql/36_nosok_v37_runtime_binding_browser_evidence_read_only.sql`.
- فتح صفحات v37 الثلاث.
- فحص Network للأربعة RPCs.

## المحجوب

- production approval.
- platformHosted repository switch.
- direct `nosok.*` access من Flutter.
- استخدام `service_role`.
- إنشاء public base tables.
- Admin repository binding قبل Admin RPC/RLS batch مستقل.
