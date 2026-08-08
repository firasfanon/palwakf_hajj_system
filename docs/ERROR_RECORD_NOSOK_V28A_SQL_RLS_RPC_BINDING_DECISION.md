# ERROR RECORD — Nosok v28A

## ER-V28A-001 — SQL Apply Evidence Missing

**Severity:** P0 gate blocker  
**Cause:** The user-provided log contains Flutter/Dart retest evidence only, not Supabase sandbox SQL apply output.  
**Files impacted:** Backend binding decision docs and v28 readiness page/provider.  
**What failed:** Backend binding cannot be approved.  
**Fix/decision:** Mark SQL sandbox apply as pending and defer repository binding.  
**Last stable baseline:** v28 with local Flutter retest passed, now v28A evidence-intake baseline.

## ER-V28A-002 — Production Gate Block Remains

**Severity:** P0 governance blocker  
**Cause:** No readiness RPC result, no RLS proof, no Role/Browser UAT after backend binding.  
**Fix/decision:** Keep `production-not-approved`.
