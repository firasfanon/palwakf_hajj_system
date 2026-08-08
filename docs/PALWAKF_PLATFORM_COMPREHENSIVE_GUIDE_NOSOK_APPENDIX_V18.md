# PalWakf Comprehensive Guide Appendix — Nosok v18

Nosok v18 extends the semi-independent system contract by adding controlled application lifecycle management, public citizen follow-up, and notification dispatch bridging.

## Governing rules
- `tracking_token` remains the only public follow-up key.
- Public follow-up must not expose identity, phone, email, documents, or payment receipt URLs.
- Application status changes must go through lifecycle rules and be audit logged.
- Notifications are queued by Nosok but dispatched by the platform notification service.
- User/role enforcement remains under PalWakf AccessProfile/RBAC.

## New operational surfaces
- Public follow-up: `/systems/nosok/follow-up`
- Admin lifecycle: `/admin/systems/nosok/application-lifecycle`
- Notification dispatch bridge: `/admin/systems/nosok/notification-dispatch`

## Required future closure
- Bind lifecycle transitions into the application details page as the only approved status mutation path.
- Build follow-up inbox for administrators.
- Connect dispatch queue with platform notification provider adapter.
- Add role-based browser UAT evidence.
