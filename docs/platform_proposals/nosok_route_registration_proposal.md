# Nosok Route Registration Proposal — v09

## Public/System Entry
- `/switch/nosok`
- `/systems/nosok`

## Public child routes
- `/systems/nosok/hajj`
- `/systems/nosok/umrah`
- `/systems/nosok/companies`
- `/systems/nosok/complaints`
- `/systems/nosok/faq`
- `/systems/nosok/apply`
- `/systems/nosok/application-status`
- `/systems/nosok/units/:unitSlug`
- `/systems/nosok/news`
- `/systems/nosok/announcements`
- `/systems/nosok/activities`

## Admin routes
- `/admin/systems/nosok`
- `/admin/systems/nosok/seasons`
- `/admin/systems/nosok/programs`
- `/admin/systems/nosok/companies`
- `/admin/systems/nosok/applications`
- `/admin/systems/nosok/applications/:applicationId`
- `/admin/systems/nosok/complaints`
- `/admin/systems/nosok/content`
- `/admin/systems/nosok/reports`
- `/admin/systems/nosok/units`
- `/admin/systems/nosok/units/:unitId`
- `/admin/systems/nosok/users-roles`
- `/admin/systems/nosok/sidebar`
- `/admin/systems/nosok/settings`
- `/admin/systems/nosok/health`

## Legacy redirects only
- `/admin/nosok` → `/admin/systems/nosok`
- `/admin/nosok/*` → matching `/admin/systems/nosok/*`

## Routing rule
لا يعود نسك إلى `/nosok` كمسار عام مباشر؛ ذلك قد يتعارض مع `/:unitSlug` في المنصة.
