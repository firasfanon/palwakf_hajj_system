تابع مشروع PalWakf / Nosok من baseline v30.

آخر قرار:

```text
V30_CONTROLLED_APPLY_RESULT_INTAKE_PREPARED_APPLY_NOT_AUTHORIZED
```

ابدأ من:

```text
nosok_platform_integration_patch_v30_authorization_apply_result_uat_gate_under_platform.zip
```

لا تنفذ DDL ما لم يزود المستخدم صراحةً:

1. owner_authorization_id
2. staging target confirmation
3. backup/snapshot evidence
4. full operator intent to run guarded apply

الخطوة التالية بعد الأدلة:

```text
Nosok v31 — Owner Authorization Token Evidence Intake
+ Controlled Staging DDL Apply Result Certification
+ Post-Apply RLS/RPC Negative UAT Closure
```
