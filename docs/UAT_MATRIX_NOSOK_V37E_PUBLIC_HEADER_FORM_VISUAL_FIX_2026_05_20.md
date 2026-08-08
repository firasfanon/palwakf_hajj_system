# UAT MATRIX — Nosok v37E

| Area | Route | Expected Result | Status |
|---|---|---|---|
| Public header | `/services/nosok` | Navigation pills are blue/white/neutral only; no pink/rose/purple chip tone | pending local browser UAT |
| Apply page | `/services/nosok/apply` | Desktop uses horizontal stepper; mobile remains vertical | pending local browser UAT |
| Public home | `/services/nosok` | Hero and service cards remain premium and citizen-first | pending local browser UAT |
| Public subpages | `/services/nosok/hajj`, `/services/nosok/requirements`, `/services/nosok/companies` | Premium visual language remains aligned | pending local browser UAT |
| Safety | all public routes | No raw backend errors, no admin governance language | pending local browser UAT |

## Required commands

```bash
dart format .
flutter analyze
flutter run -d chrome
```
