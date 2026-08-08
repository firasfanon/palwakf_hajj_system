# Nosok v32 — Controlled Staging DDL Apply Evidence Intake + Post-Apply Census/RLS Result Closure + Production Gate Re-decision

**Date:** 2026-06-04  
**Status:** Evidence intake and decision gate.  
**Decision:** `V32_APPLY_EVIDENCE_INTAKE_PREPARED_CONTROLLED_APPLY_STILL_REQUIRED`

## Accepted evidence

- v31 read-only gate returned `nosok_present=false` and all expected `nosok.*` base tables are still absent.
- Public service base table guard is still clean: no `public.nosok*`, `public.hajj*`, or `public.umrah*` base tables were detected.
- `flutter analyze` returned `No issues found!`.
- `flutter run -d chrome` reached startup, but browser runtime failed because CanvasKit could not be fetched from `gstatic`.

## Runtime blocker

The observed error is:

```text
TypeError: Failed to fetch dynamically imported module: canvaskit.js
```

This is treated as a CDN/network runtime blocker, not a Dart compile blocker. Browser runtime certification remains pending until Chrome launches and renders without this CanvasKit fetch failure.

## Operator file decision

| File | Decision |
|---|---|
| `00_READ_ME_V31_OPERATOR_ONLY.md` | Read first. Safe. |
| `01_nosok_owner_schema_controlled_staging_apply_OPERATOR_ONLY_NOT_RUN.sql` | Run only on staging after backup/restore point and operator confirmation. |
| `02_nosok_v31_post_apply_rls_rpc_negative_uat_READ_ONLY.sql` | Run only after `01` succeeds. |
| `03_nosok_v31_controlled_rollback_DRAFT_NOT_RUN.sql` | Do not run unless rollback is required after a failed/undesired apply. |

## Production gate

Production remains blocked. No full production decision can be granted until controlled apply evidence, post-apply census, RLS/RPC negative UAT, and browser runtime evidence are all accepted.
