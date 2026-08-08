# BASELINE CHANGELOG — NOSOK V19

**Batch:** Nosok v19 — Lifecycle Enforcement in Application Details + Follow-up Inbox + Notification Provider Adapter UAT  
**Date:** 2026-05-18  
**Position:** نظام نسك شبه مستقل تحت PalWakf، مع preview standalone للفحص فقط.

## Summary
هذه دفعة تشغيلية كبيرة فوق v18، وليست hotfix صغيرًا. هدفها إغلاق ثلاث فجوات إنتاجية مترابطة:

1. فرض دورة حياة الطلب من صفحة التفاصيل الإدارية بدل التحديث اليدوي الحر.
2. إضافة صندوق متابعة المواطن للإجراءات القادمة من `/systems/nosok/follow-up`.
3. إضافة UAT Adapter لمزودات الإشعارات وربطها بعقد خدمة إشعارات المنصة دون إنشاء محرك إشعارات مستقل داخل نسك.

## Added
- `NosokFollowupInboxItem` model.
- `NosokNotificationProviderAdapter` و `NosokNotificationProviderUatResult` models.
- `NosokFollowupInboxController`.
- `NosokNotificationProviderUatController`.
- صفحة `/admin/systems/nosok/follow-up-inbox`.
- صفحة `/admin/systems/nosok/notification-provider-uat`.
- SQL v19 للـ follow-up inbox وnotification provider adapters وUAT results وlifecycle enforcement events.

## Changed
- صفحة تفاصيل الطلب أصبحت تعرض `Lifecycle Enforcement Section` وتنفذ الانتقالات عبر State Machine.
- `NosokSupabaseRepository.transitionApplicationLifecycle` يحاول استدعاء RPC v19 المحكوم ثم fallback إلى v18.
- السايدبار والمسارات والصلاحيات أضيفت لها عناصر v19.
- `NosokInMemoryRepository` أصبح يدعم معاينة صندوق المتابعة وUAT مزودات الإشعارات.

## Governance
- لا إنشاء مستخدمين داخل `nosok`.
- لا صلاحيات مستقلة خارج AccessProfile/RBAC المنصة.
- لا محرك إشعارات مستقل داخل نسك؛ نسك ينشئ Queue/Adapter UAT فقط.
- لا تعديل على `waqf`, `waqf_assets`, `awqaf_system`.

## Status
`staging-ready / large-runtime-batch / lifecycle-enforced-in-details / followup-inbox-enabled / notification-provider-uat-enabled / local-retest-required / production-not-approved`
