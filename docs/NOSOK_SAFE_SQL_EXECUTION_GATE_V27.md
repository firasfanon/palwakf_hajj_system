# NOSOK_SAFE_SQL_EXECUTION_GATE_V27

## Final gate

```text
SQL_EXECUTION_BLOCKED_OWNER_REVIEW_AND_EXPLICIT_AUTHORIZATION_REQUIRED
```

## Allowed now

- Read-only SQL validation.
- Owner schema design.
- Reconciliation matrix.
- Guarded-not-applied DDL draft preparation.
- Flutter preview/admin pages that display the gate state.

## Blocked now

- `CREATE SCHEMA nosok` without explicit authorization.
- `CREATE TABLE nosok.*` without explicit authorization.
- `CREATE TABLE public.*` permanently blocked.
- Any DML to `core`, `platform_access`, `billing_system`, `public`, `waqf`, or `awqaf_system`.
- Any production lottery/payment/application opening.

## Next authorization phrase required

```text
أفوض تفويضًا محصورًا تجهيز/تنفيذ Nosok owner schema staging DDL داخل nosok.* فقط، دون public base tables، ودون DML إنتاجي، ودون تشغيل قرعة أو دفع، مع RLS/RPC/UAT/rollback.
```
