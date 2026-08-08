# ERROR RECORD — Nosok v28B

## ER-V28B-001 — SQL evidence missing

**Symptom:** The requested batch title implies actual sandbox SQL apply evidence, but the attached log only contains Flutter format/analyze/run results.  
**Cause:** No Supabase SQL Editor result or readiness RPC output was provided.  
**Files impacted:**
- `lib/features/nosok_system/application/nosok_lottery_backend_controller.dart`
- `lib/features/nosok_system/presentation/pages/admin/nosok_admin_v28_lottery_backend_readiness_page.dart`
- `sql/30_nosok_v28b_actual_sandbox_apply_readiness_result_intake.sql`

**Resolution:** Added explicit v28B evidence gates and kept backend binding deferred.  
**Stable baseline:** v28B.

## ER-V28B-002 — Backend binding must not infer database readiness

**Symptom:** Frontend is clean but backend schema application is unproven.  
**Cause:** Flutter success does not prove Supabase schema/RPC/RLS readiness.  
**Resolution:** No repository binding enabled. Backend remains preview/contract-only until SQL evidence is attached.

## ER-V28B-003 — Sovereign boundary preservation

**Symptom:** Lottery backend work must not mutate `waqf_assets`, `waqf`, or `awqaf_system`.  
**Resolution:** v28B SQL file is read-only and explicitly includes a sovereign boundary check.
