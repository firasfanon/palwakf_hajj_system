# ERROR RECORD — Nosok v28 Lottery Backend Schema/RPC Draft

## Current known issues

### ER-V28-001 — Backend not applied yet

- **Cause:** v28 intentionally delivers draft schema/RPC and UAT, not actual Supabase application.
- **Impact:** Flutter still uses preview provider/data for lottery backend readiness surfaces.
- **Resolution:** run sandbox review/apply in a controlled v28A batch, then attach SQL UAT results.
- **Stable baseline:** v27D-1 passed local format/analyze/Chrome before v28.

### ER-V28-002 — RLS enablement is not full RLS policy finalization

- **Cause:** draft enables RLS but does not finalize all policies.
- **Impact:** cannot approve production.
- **Resolution:** design and test role-specific RLS policies in sandbox after contract approval.

### ER-V28-003 — Mutating RPCs are contract stubs

- **Cause:** freeze/draw mutating RPCs intentionally raise exceptions in the draft until mapping and authorization are reviewed.
- **Impact:** no real draw execution through backend yet.
- **Resolution:** implement actual stored procedure logic only after SQL owner review and UAT.
