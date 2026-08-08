# Session Handoff — Nosok v37

## Status

```text
staging-stable / v37-controlled-development-applied / browser-render-evidence-partial-accepted / signature-aware-wrapper-census-added / public-repository-binding-runtime-switch-candidate-prepared / global-repository-switch-not-enabled / network-rpc-evidence-required / production-not-approved / no-waqf-assets-mutation
```

## Accepted evidence

- `/services/nosok` rendered.
- `/admin/systems/nosok` rendered.
- `/admin/systems/nosok/users-roles` rendered.
- Supabase init completed in browser console.
- SQL v36 final gate confirms wrappers/RPC present overall and repository binding still requires Browser/Role/Scope UAT.

## Pending

- Network RPC calls for campaigns/requirements.
- public submit/track privacy evidence.
- authenticated no-role negative evidence.
- wrong-unit scope negative evidence.

## Next

Run:

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

Then run:

```sql
\i sql/36_nosok_v37_runtime_binding_browser_evidence_read_only.sql
```

Next recommended mega batch:

```text
Nosok v38 — Public Campaigns/Requirements Runtime Adapter Integration + Network RPC Evidence Closure + Production Gate Re-decision
```
