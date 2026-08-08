# BASELINE CHANGELOG — Nosok v27B Operational Workflow Deepening

**التاريخ:** 2026-05-19

## النوع
Mega Batch كبير واحد فوق V27A، وليس باتشات صغيرة.

## التغييرات
- إضافة صفحة جاهزية تشغيلية داخل الإدارة: `/admin/systems/nosok/v27b-operational-depth`.
- تعميق مفهوم المساحات التشغيلية الأربع: المواطن، الشركة، الموظف، الإدارة.
- تحسين بوابة الشركات بإضافة Partner Operations Snapshot دون ادعاء Backend فعلي.
- تثبيت سير العمل الموحد: submitted → received → under_review → needs_completion → approved → assigned_to_campaign → in_followup → completed/closed.
- توثيق أن الإنتاج غير معتمد وأن UAT المحلي وSQL/Role/Responsive/Console ما زالت مطلوبة.

## الحدود السيادية
- لا SQL إنتاجي.
- لا DML.
- لا تعديل على `waqf_assets` أو schema `waqf` أو `awqaf_system`.
- لا استخدام `legacy.dart` في الملفات الجديدة.
