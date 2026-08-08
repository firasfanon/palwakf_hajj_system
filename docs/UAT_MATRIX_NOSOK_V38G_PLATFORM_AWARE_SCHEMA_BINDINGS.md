# UAT Matrix — Nosok v38G

| route | expected | status |
|---|---|---|
| `/admin/systems/nosok/platform-schema-bindings` | Displays platform source binding contract | local retest required |
| `/admin/systems/nosok/v38g-platform-schema-binding` | Displays same contract as evidence page | local retest required |
| `/admin/systems/nosok/homepage-sections` | Remains available | unchanged |
| `/admin/systems/nosok/dynamic-pages` | Remains available | unchanged |
| `/services/nosok` | Public homepage unchanged | unchanged |

## Local checks

```bash
dart format .
flutter analyze
flutter run -d chrome
```
