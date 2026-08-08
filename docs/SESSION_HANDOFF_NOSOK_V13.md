# Session Handoff — Nosok v13

## Current baseline

`nosok_platform_integration_patch_v13_billing_provider_privacy_readiness_under_platform.zip`

## Architectural position

Nosok remains a semi-independent system under PalWakf. It has its own system body, routes, pages, repositories, and SQL schema, but it does not replace platform RBAC, platform users, billing_system, or sovereign platform shells.

## What v13 completed

1. Billing provider adapter hardening.
2. Adapter health checks and health event logging.
3. Public tracking privacy review matrix.
4. Public tracking RPC privacy override.
5. Production readiness evidence intake.
6. New admin surfaces:
   - `/admin/systems/nosok/billing-adapters`
   - `/admin/systems/nosok/tracking-privacy`
   - `/admin/systems/nosok/readiness-evidence`
7. Platform merge patch route additions for the same surfaces.

## Required local retest

Run:

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

Then test:

```text
/systems/nosok/application-status
/admin/systems/nosok/billing-adapters
/admin/systems/nosok/tracking-privacy
/admin/systems/nosok/readiness-evidence
/admin/systems/nosok/operations
/admin/systems/nosok/payment-bridge
```

## Required SQL order

Apply scripts in order from `00` to `12`, or apply `12` on top of a database already carrying v12.

Then run:

```sql
select * from public.rpc_nosok_v13_runtime_contract_uat_v1();
```

Expected key checks:

- `adapters_seeded = true`
- `privacy_checks_seeded = true`
- `status_rpc_overridden = true`
- `evidence_table_exists = true`
- `no_waq_assets_mutation_in_this_script = true`

## Production gate

Not approved. Required evidence remains:

- Browser UAT screenshots/logs.
- Role UAT evidence for superuser, limited user, payments officer, unit officer.
- Console review.
- SQL UAT result.
- Public tracking privacy screenshot showing no sensitive fields.
- Billing adapter health result.

## Next batch recommendation

**Nosok v14 — Browser/SQL UAT Result Intake + Billing Adapter Evidence Closure + Production Gate Re-decision**

Do not mark production approved before real evidence is provided.
