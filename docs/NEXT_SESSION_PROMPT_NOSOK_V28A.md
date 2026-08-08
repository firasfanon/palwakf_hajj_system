# NEXT SESSION PROMPT — Nosok v28B

ابدأ من:

```text
nosok_v28a_sql_rls_rpc_binding_decision_2026_05_20.zip
```

اقرأ أولًا:

1. `docs/SESSION_HANDOFF_NOSOK_V28A_SQL_RLS_RPC_BINDING_DECISION.md`
2. `docs/BASELINE_CHANGELOG_NOSOK_V28A_SQL_RLS_RPC_BINDING_DECISION.md`
3. `docs/UAT_MATRIX_NOSOK_V28A_SQL_RLS_RPC_BINDING_DECISION.md`
4. `docs/ERROR_RECORD_NOSOK_V28A_SQL_RLS_RPC_BINDING_DECISION.md`
5. `sql/29_nosok_v28a_rls_rpc_security_review_read_only_uat.sql`

## المهمة التالية

```text
Nosok v28B — Actual Sandbox SQL Apply Evidence + Readiness RPC Result Intake + Backend Binding Gate Re-decision
```

## لا تنفذ

- لا Production SQL.
- لا DML خارج sandbox.
- لا backend binding قبل SQL evidence.
- لا waqf_assets mutation.

## المطلوب

1. استيعاب نتيجة تطبيق SQL sandbox الفعلية.
2. تشغيل read-only security UAT.
3. مراجعة RLS/RPC outputs.
4. إعادة قرار backend binding.
