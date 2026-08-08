# UAT Matrix — Nosok v27.1

| Area | Expected Result | Status |
|---|---|---|
| `flutter analyze` | No undefined route/permission constants | Retest required |
| Chrome startup | Application compiles and starts | Retest required |
| v27 schema census page | Renders | Retest required |
| v27 existing object reconciliation | Renders | Retest required |
| v27 owner schema diff plan | Renders | Retest required |
| v27 safe SQL gate | Renders | Retest required |
| Public compatibility links | No compile failure from route constants | Patch prepared |
| Admin pre-join links | No compile failure from route constants | Patch prepared |
| DB safety | No write/DDL/DML | Passed by packaging boundary |
