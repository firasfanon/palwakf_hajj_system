# Nosok v29 — Frontend Runtime Completion

The frontend remains usable before database creation through preview repositories/contracts. Runtime backend binding is deferred until PalWakf merge and `nosok` schema creation.

## Public surfaces

- `/services/nosok`
- `/services/nosok/apply`
- `/services/nosok/track`
- `/services/nosok/requirements`
- `/services/nosok/faq`
- `/services/nosok/companies`
- `/services/nosok/contact`
- `/services/nosok/lottery-results`
- `/services/nosok/waiting-list`
- `/services/nosok/objections`

## Admin surfaces

- `/admin/systems/nosok`
- `/admin/systems/nosok/requests`
- `/admin/systems/nosok/review`
- `/admin/systems/nosok/lottery`
- `/admin/systems/nosok/lottery/eligibility`
- `/admin/systems/nosok/lottery/draw`
- `/admin/systems/nosok/lottery/waiting-list`
- `/admin/systems/nosok/lottery/committee`
- `/admin/systems/nosok/lottery/audit`
- `/admin/systems/nosok/v29-merge-readiness`

## Required post-merge UAT

- Browser click-through UAT
- Role-based UAT
- Responsive UAT
- Browser console review
- SQL/RPC/RLS UAT after schema creation
