# SESSION HANDOFF — Nosok v18

## Current baseline
`nosok_platform_integration_patch_v18_application_lifecycle_notifications_under_platform.zip`

## What changed
1. Added application lifecycle models/controllers/pages.
2. Added public citizen follow-up action flow.
3. Added notification dispatch queue bridge.
4. Added SQL v18 for lifecycle rules, transition log, follow-up requests, and dispatch queue.
5. Updated routes/navigation/permissions and platform merge proposals.

## Most important files
- `lib/features/nosok_system/domain/models/nosok_application_lifecycle_transition.dart`
- `lib/features/nosok_system/domain/models/nosok_citizen_followup_action.dart`
- `lib/features/nosok_system/domain/models/nosok_notification_dispatch.dart`
- `lib/features/nosok_system/application/nosok_application_lifecycle_controller.dart`
- `lib/features/nosok_system/application/nosok_citizen_followup_controller.dart`
- `lib/features/nosok_system/application/nosok_notification_dispatch_controller.dart`
- `lib/features/nosok_system/presentation/pages/admin/nosok_admin_application_lifecycle_page.dart`
- `lib/features/nosok_system/presentation/pages/admin/nosok_admin_notification_dispatch_page.dart`
- `lib/features/nosok_system/presentation/pages/public/nosok_citizen_followup_page.dart`
- `sql/16_nosok_v18_application_lifecycle_followup_notification_bridge.sql`

## Retest paths
- `/systems/nosok/application-status`
- `/systems/nosok/follow-up`
- `/admin/systems/nosok/application-lifecycle`
- `/admin/systems/nosok/notification-dispatch`
- `/admin/systems/nosok/applications`

## Next recommended batch
Nosok v19 — Lifecycle Enforcement in Application Details + Follow-up Inbox + Notification Provider Adapter UAT

## Production gate
Still not approved. Required:
- Local analyzer clean.
- Browser UAT for public follow-up and admin lifecycle.
- SQL UAT for v18.
- Role UAT for lifecycle/dispatch permissions.
