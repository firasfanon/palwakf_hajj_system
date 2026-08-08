# PALWAKF PLATFORM COMPREHENSIVE GUIDE — Nosok Appendix v26.1

## حاكم جديد/مؤكد

- نسك للحج والعمرة نظام شبه مستقل تحت PalWakf.
- لا هوية مستقلة عن المنصة؛ الالتزام بـ PWF-SIS إلزامي.
- صفحة الجمهور يجب أن تذكر تطبيق **مناسكنا** كقناة إرشادية مساندة، لا كتكامل backend وهمي ما لم يُنفذ فعليًا.
- `/services/nosok` هو مدخل الجمهور الحديث.
- `/admin/systems/nosok` هو مدخل الموظف/الإدارة.
- المسارات القديمة `/systems/nosok` يجب الحفاظ عليها compatibility أو redirect.
- الإنتاج غير معتمد حتى إغلاق Full PalWakf Merge + RBAC + SQL UAT + Browser/Role/Responsive evidence.

## حدود التكامل

- `billing_system`: bridge/contract فقط إلى أن يثبت backend.
- `assistant`: planned/visual unless real service is bound.
- `tasks`: planned unless real task creation is bound.
- `document_intelligence`: planned for document quality/classification.
- `media_center`: planned for الحج/العمرة announcements.

## سيادة البيانات

- لا تكرار لـ core org units.
- لا RBAC محلي مستقل.
- لا لمس لـ `waqf_assets`.
