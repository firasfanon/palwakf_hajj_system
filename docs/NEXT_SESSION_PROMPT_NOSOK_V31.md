# Next Prompt — Nosok v31 Result Intake

استكمل من baseline:
`nosok_platform_integration_patch_v31_authorization_token_apply_certification_uat_closure_under_platform.zip`

نفّذ أو استوعب نتائج:
1. `flutter clean && flutter pub get && dart format . && flutter analyze && flutter run -d chrome`
2. فتح مسارات v31 الثلاثة.
3. تشغيل `sql/29_nosok_v31_authorization_apply_certification_read_only.sql` فقط.
4. إذا تم تشغيل operator DDL في staging خارجيًا، أرسل كامل SQL output وpost-apply probe result.

الدفعة التالية:
`Nosok v32 — Controlled Staging DDL Apply Evidence Intake + Post-Apply Census/RLS Result Closure + Production Gate Re-decision`
