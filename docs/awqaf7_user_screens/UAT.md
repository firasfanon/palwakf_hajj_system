# UAT — Waqf Assets User Screens

## Local commands

```powershell
flutter pub get
dart format lib/features/waqf_assets/presentation/pages/pwf_waqf_assets_user_screens_page.dart `
  lib/features/waqf_assets/routing/pwf_waqf_assets_route_paths.dart `
  lib/features/waqf_assets/routing/pwf_waqf_assets_routes.dart `
  lib/features/waqf_assets/routing/pwf_waqf_assets_awqaf_system_child_routes.dart `
  lib/features/awqaf_system/awqaf_system_routes.dart `
  lib/features/awqaf_system/awqaf_system_registry.dart `
  lib/features/awqaf_system/application/contracts/awqaf_system_7_waqf_assets_user_screens_contract.dart

flutter analyze
flutter run -d chrome
```

## Browser routes

- Central:
  `/systems/awqaf-system/waqf-assets/user-screens`
- Unit-scoped:
  `/{unitSlug}/systems/awqaf-system/waqf-assets/user-screens`

## Evidence required

| Scenario | Expected |
|---|---|
| platform superuser central | page renders, actor visible, read surfaces load |
| unit-scoped authorized user | unit route renders with correct scope |
| wrong-unit user | platform forbidden / safe Arabic denial |
| logged-out direct route | Platform Access Gateway handles login/forbidden |
| no-awqaf-permission user | denied without data leak |
| Network | only read RPCs, no write RPCs |
| Console | no red runtime errors from this screen |
