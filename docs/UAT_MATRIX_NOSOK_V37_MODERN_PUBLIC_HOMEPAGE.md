# UAT MATRIX — Nosok v37 Modern Public Homepage Redesign

| Area | Route | Expected Result | Status |
|---|---|---|---|
| Public home | `/services/nosok` | Modern public service landing opens without governance-heavy blocks | pending local browser UAT |
| Main CTA | `/services/nosok/apply` | Citizen can reach application wizard | pending local browser UAT |
| Tracking CTA | `/services/nosok/track` | Citizen can reach tracking page | pending local browser UAT |
| Requirements CTA | `/services/nosok/requirements` | Requirements page opens | pending local browser UAT |
| Lottery result card | `/services/nosok/lottery-results` | Citizen result page opens | pending local browser UAT |
| Waiting list card | `/services/nosok/waiting-list` | Waiting list page opens | pending local browser UAT |
| Objections card | `/services/nosok/objections` | Objection page opens | pending local browser UAT |
| Companies card | `/services/nosok/companies` | Qualified companies page opens | pending local browser UAT |
| Admin entry | `/admin/systems/nosok` | Button opens employee console and remains RBAC governed | pending role UAT |
| Mobile layout | public home | No overflow, no horizontal scroll, cards stack correctly | pending responsive UAT |
| Governance separation | public home | No schema/RPC/RLS/production-gate internal detail in public homepage | review-ready |

## Required Commands

```bash
dart format .
flutter analyze
flutter run -d chrome
```
