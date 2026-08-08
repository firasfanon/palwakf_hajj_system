# Next Prompt — Nosok v29

Continue from `nosok_platform_integration_patch_v29_ddl_authorization_staging_gate_preflight_under_platform.zip`.

First run:

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

Then run only:

```sql
\i sql/27_nosok_v29_authorization_preflight_read_only.sql
```

Do not run guarded DDL unless explicit owner authorization ID and backup confirmation are provided.

Next pack:

```text
Nosok v30 — Staging DDL Apply Result Intake + RLS/RPC/Negative UAT Evidence Closure + Production Gate Re-decision
```
