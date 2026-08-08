# UAT MATRIX — Nosok v37F

| Area | Route / File | Expected Result | Status |
|---|---|---|---|
| Analyzer cleanup | `nosok_public_system_shell.dart` | no unused palette warnings | pending local retest |
| Analyzer cleanup | `pwf_sis_nosok_components.dart` | no unused private widget warning | pending local retest |
| Chrome startup evidence intake | root app | Previous run reached Chrome Debug Service | passed by submitted log |
| Public homepage | `/services/nosok` | premium public UI, no pink/rose tones, clear CTA | pending visual UAT |
| Apply page | `/services/nosok/apply` | desktop stepper refined, mobile stepper usable | pending visual UAT |
| Public subpages | all `/services/nosok/*` public routes | aligned premium citizen-facing style | pending visual UAT |
| Console | browser console | no Flutter layout/runtime errors; monitor AppInspector context warning | pending final UAT |
| Sovereign boundary | repo | no SQL/backend/waqf_assets change | passed by scope |

## Commands

```bash
dart format .
flutter analyze
flutter run -d chrome
```
