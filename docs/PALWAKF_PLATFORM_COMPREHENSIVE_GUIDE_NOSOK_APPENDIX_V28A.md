# PALWAKF PLATFORM COMPREHENSIVE GUIDE — Nosok Appendix v28A

## Binding rule

Nosok lottery backend must not bind to real Supabase runtime repositories until all of the following are true:

1. Sandbox SQL apply result is provided.
2. Readiness RPC returns expected checks.
3. RLS/RPC security UAT passes.
4. Role/browser UAT passes after binding.
5. Production gate is explicitly approved.

## Public schema rule

Public RPCs may expose only safe wrappers. No direct public read/write access to lottery tables is allowed.

## LGU lottery rule

LGU quota selection remains capacity-aware and policy-configurable. Underfilled quotas require committee decision; no automatic cross-LGU transfer.

## Current status

```text
staging-stable /
nosok-v28a-sql-rls-rpc-security-review-applied /
v28-local-flutter-retest-passed /
sandbox-sql-apply-result-not-provided /
backend-binding-deferred /
production-not-approved /
no-waqf-assets-mutation
```
