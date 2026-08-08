# Next Prompt — Nosok v31

ابدأ من baseline:

```text
nosok_platform_integration_patch_v30_1_apply_result_read_only_intake_under_platform.zip
```

نفّذ:

```text
Nosok v31 — Owner Authorization Token Evidence Intake
+ Controlled Staging DDL Apply Result Certification
+ Post-Apply RLS/RPC Negative UAT Closure
```

السياق الحاكم:

- v30.1 استوعب نتيجة SQL read-only التي أكدت أن `nosok_present=false` وأن جداول `nosok.*` المرشحة غير موجودة بعد.
- `public.*` base table creation محظور.
- `flutter analyze` نظيف وChrome يعمل وSupabase init مكتمل.
- لم يتم تنفيذ guarded DDL apply بعد.

لا تشغل أي DDL قبل وجود تفويض صريح يتضمن:

```text
owner_authorization_id
staging target confirmation
backup confirmation
create schema nosok authorized
create approved nosok.* tables only
public base table creation remains blocked
```
