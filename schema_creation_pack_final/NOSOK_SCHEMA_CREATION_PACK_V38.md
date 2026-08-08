# NOSOK SCHEMA CREATION READY PACK — v38

هذه حزمة تصميم نهائية غير مطبقة. لا تنشئ جداول في هذه المرحلة.

## Schema

```text
nosok
```

## Tables

1. `nosok.seasons`
2. `nosok.applications`
3. `nosok.applicants`
4. `nosok.companions`
5. `nosok.documents`
6. `nosok.companies`
7. `nosok.campaigns`
8. `nosok.lottery_policies`
9. `nosok.lgu_quota_snapshots`
10. `nosok.lottery_draw_runs`
11. `nosok.lottery_draw_results`
12. `nosok.lottery_committee_decisions`
13. `nosok.lottery_objections`
14. `nosok.lottery_audit_events`

## RPC families

- public safe tracking/result RPCs.
- citizen objection submit RPC.
- admin eligibility freeze RPC.
- admin draw execution RPC.
- committee decision RPC.
- reports/readiness RPCs.

## RLS

- Citizens see only their own request/result via safe RPC.
- Company reps see only assigned company scope.
- Employees see assigned scope.
- Supervisors see scoped operations.
- Superuser has audited override.

## Apply rule

Apply only after actual PalWakf merge and sandbox approval.
