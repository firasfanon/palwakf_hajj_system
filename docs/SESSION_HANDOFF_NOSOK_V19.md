# SESSION HANDOFF — NOSOK V19

## Latest baseline
`nosok_platform_integration_patch_v19_lifecycle_followup_notification_uat_under_platform.zip`

## Scope delivered
تم تنفيذ Nosok v19 كدفعة تطوير كبيرة فوق v18، تشمل:

- Lifecycle Enforcement داخل صفحة تفاصيل الطلب.
- Follow-up Inbox إداري لطلبات المواطن.
- Notification Provider Adapter UAT.
- SQL Runtime v19.
- تحديث routes/sidebar/permissions/repositories/in-memory preview.

## System position
نسك نظام شبه مستقل تحت PalWakf:

- المسارات العامة تحت `/systems/nosok`.
- المسارات الإدارية تحت `/admin/systems/nosok`.
- PalWakf هو مصدر shell وRBAC وAccessProfile.
- standalone preview موجود للفحص المحلي فقط.

## New routes
- `/admin/systems/nosok/follow-up-inbox`
- `/admin/systems/nosok/notification-provider-uat`

## SQL file
- `sql/17_nosok_v19_lifecycle_followup_notification_uat.sql`

## What to test
1. افتح صفحة تفاصيل طلب:
   - `/admin/systems/nosok/applications/application-001`
   - نفذ انتقال lifecycle.
2. افتح صندوق المتابعة:
   - `/admin/systems/nosok/follow-up-inbox`
   - غيّر حالة طلب متابعة.
3. افتح UAT مزودات الإشعارات:
   - `/admin/systems/nosok/notification-provider-uat`
   - شغّل اختبارات العقد/الطابور/خصوصية النص.

## Production decision
لم يتم اعتماد الإنتاج. يلزم:
- flutter analyze clean.
- Browser UAT.
- SQL UAT.
- Role UAT لأدوار نسك.
- Evidence closure داخل readiness evidence.

## Next recommended batch
**Nosok v20 — Application Reviewer Workspace + Follow-up SLA Dashboard + Notification Dispatch Evidence Closure**

هدف v20:
- بناء مساحة عمل موحدة للمراجع.
- SLA لمتابعات المواطن.
- ربط نتائج UAT مزود الإشعارات بأدلة الجاهزية.
