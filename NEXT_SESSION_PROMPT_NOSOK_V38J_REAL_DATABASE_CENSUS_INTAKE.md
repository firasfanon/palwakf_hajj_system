# NEXT SESSION PROMPT — Nosok v38J

Continue from `Nosok v38I-3`.

Task:

```text
Nosok v38J — Real Database Census Result Intake
+ Core/Platform/Public Shape Alignment
+ Safe Schema Apply Re-decision
```

Input required:

- Full output of `sql/38A_nosok_real_database_environment_census_read_only.sql`.

Rules:

- Do not apply schema until census results are reviewed.
- Core remains sovereign source for LGU/governorates/org_units/unit profiles.
- Public is wrappers/RPC/views only.
- No cross-schema writes.
- No production approval.
- No waqf_assets mutation.
