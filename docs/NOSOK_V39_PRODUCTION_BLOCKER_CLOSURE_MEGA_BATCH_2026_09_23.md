# Nosok v39 — Production Blocker Closure Mega Batch

Date: 2026-09-23

## Authorization
`SEPARATE_PRODUCTION_BLOCKER_CLOSURE_MEGA_BATCH_AUTHORIZATION`

## Exact base
- Base task head: `3e0577fbb939bd0a2fa694f5e70af7a2b67eeb13`
- Main observed before development: `644ba350a73b413b7ccbe7a46369fa149543d6ce`
- Development branch: `task/NOSOK-V39-PRODUCTION-BLOCKER-CLOSURE-MEGA-BATCH-V1`

## Scope
This batch closes internally controllable production blockers without fabricating external readiness:
1. campaign-based admin runtime aligned to live `nosok.campaigns`;
2. canonical UUID-only operational unit queue RPC;
3. PII submit v2 with Vault-bound encryption and keyed national-ID hash;
4. public campaign→LGU selector with campaign-override semantics;
5. private document/payment storage with no public URL and legacy public policy retirement;
6. no direct public access to private PII storage;
7. external readiness registry for Civil Registry, OTP/SMS, eSadad, company auth/Captcha and official lottery;
8. fail-closed production gate RPC;
9. Flutter repository adapter aligned to campaign/PII v2 with no public direct-table fallback;
10. post-apply read-only UAT pack.

## Security invariants
- `core.org_units.id` is the unit authorization identity.
- `unitSlug` is rejected as queue authorization input.
- No governorate-derived LGU expansion.
- PII is forbidden in application metadata.
- Public submit requires an LGU from the campaign's effective approved scope.
- Citizen uploads use `nosok-private`; no public document URL is generated.
- Encryption secret is never stored in Git; Vault name: `NOSOK_PII_ENCRYPTION_KEY_V1`.
- Missing Vault secret fails closed.
- External integration status cannot become `certified` without superuser + evidence reference.
- Private PII/readiness tables grant no direct anon/authenticated table access.

## External boundary
Civil Registry, OTP/SMS, eSadad, company auth/Captcha and official lottery are not declared certified by this batch. They remain `EXTERNAL_EVIDENCE_REQUIRED` until real provider/runtime evidence is bound.

## Database boundary
`sql/54_nosok_v39_production_blocker_closure_mega_batch_DRAFT.sql` ends with `ROLLBACK`.
No live DDL/DML, secret provisioning, synthetic campaign, production mutation, main merge, or baseline promotion is authorized here.

## Files
- `sql/54_nosok_v39_production_blocker_closure_mega_batch_DRAFT.sql`
- `sql/55_nosok_v39_production_blocker_closure_uat_read_only.sql`
- `lib/features/nosok_system/domain/models/nosok_application_draft.dart`
- `lib/features/nosok_system/data/repositories/nosok_supabase_repository.dart`

## Next gates
format/analyze/static review → exact commit/push/readback → exact-head independent review → separate DB apply authorization → Vault secret provisioning → controlled apply → runtime UAT → external provider evidence → production gate re-decision.
