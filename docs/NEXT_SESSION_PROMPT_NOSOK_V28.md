تابع من baseline: `nosok_platform_integration_patch_v28_owner_schema_design_guarded_ddl_under_platform.zip`.

الحالة: v28 جهز Owner Schema Design + Guarded DDL Draft Pack فقط. لا SQL تنفيذي، لا DML، لا CREATE SCHEMA، لا CREATE TABLE، ولا production approval.

الخطوة التالية المقترحة:
`Nosok v29 — Owner Schema DDL Authorization Intake + Staging Apply Gate`

لا تنفذ DDL إلا إذا أعطى المشغل تفويضًا صريحًا لإنشاء `nosok` schema وجداول `nosok.*` المحددة فقط.
