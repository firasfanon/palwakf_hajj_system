# Nosok v34 UAT Matrix

## Actors

- visitor
- citizen
- company partner
- nosok employee
- nosok supervisor
- hajj committee
- system admin
- superuser
- restricted user

## Routes

Public:

- `/services/nosok`
- `/services/nosok/apply`
- `/services/nosok/track`
- `/services/nosok/lottery-results`
- `/services/nosok/waiting-list`
- `/services/nosok/objections`

Internal:

- `/admin/systems/nosok`
- `/admin/systems/nosok/requests`
- `/admin/systems/nosok/review`
- `/admin/systems/nosok/lottery`
- `/admin/systems/nosok/lottery/draw`
- `/admin/systems/nosok/lottery/committee`
- `/admin/systems/nosok/v31-v35-production-closure`

## Required checks

- no raw backend errors.
- no overflow/render errors.
- role guard passes.
- citizen privacy passes.
- company scope passes.
- committee decision required for underfilled quota.
- production remains blocked until evidence.
