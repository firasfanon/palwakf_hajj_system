# Nosok v12 — Billing System Bridge Execution + Unit-Scoped Application Queues + Role UAT Evidence Intake

## التاريخ
2026-05-17

## نطاق الدفعة
دفعة تشغيلية فوق v11 داخل نظام نسك شبه المستقل تحت PalWakf.

## التغييرات
- إضافة تنفيذ أولي لجسر الدفع مع `billing_system` عبر execute/sync RPC wrappers.
- إضافة طوابير طلبات مقيدة بالوحدة/المديرية عبر `unit_id/unit_slug` مع صفحة إدارية جديدة.
- إضافة استيعاب أدلة Role UAT وربطها بمصفوفة الاختبار.
- تحديث sidebar/routes/permissions للنطاقات الجديدة.
- إضافة SQL v12 runtime contract UAT.

## الحدود السيادية
- لا تعديل على `waqf_assets`.
- لا تعديل على schema `waqf`.
- لا تعديل على `awqaf_system`.
- `core.org_units` يبقى مصدر الوحدات السيادي في الدمج الفعلي.
- `billing_system` يبقى محرك الدفع السيادي؛ نسك يستهلكه عبر bridge فقط.
