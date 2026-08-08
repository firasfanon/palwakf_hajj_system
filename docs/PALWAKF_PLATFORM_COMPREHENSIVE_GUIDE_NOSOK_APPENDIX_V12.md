# PalWakf Comprehensive Guide Appendix — Nosok v12

نسك نظام شبه مستقل تحت PalWakf. في v12 تم اعتماد ثلاثة عقود تشغيلية:

1. **Billing Bridge Execution**
   - نسك لا يملك بوابة دفع مستقلة.
   - `billing_system` هو المحرك المالي السيادي.
   - نسك يرسل طلبات bridge ويستوعب المراجع والحالات.

2. **Unit Scoped Queues**
   - كل طلب يمكن أن يحمل `unit_id/unit_slug`.
   - طابور الوحدة لا ينشئ وحدات مستقلة.
   - `core.org_units` يبقى المصدر الحاكم في الإنتاج.

3. **Role UAT Evidence Intake**
   - فتح الصفحة لا يكفي.
   - يجب إدخال دليل role-based لكل surface قبل الإنتاج.

الحكم: v12 يرفع نسك من تشغيل إداري عام إلى تشغيل شبه مستقل مقيد بالوحدة والفوترة والأدلة.
