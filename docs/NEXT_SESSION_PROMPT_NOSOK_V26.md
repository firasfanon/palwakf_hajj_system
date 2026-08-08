You are continuing Nosok under PalWakf after v26.
Start from `nosok_platform_integration_patch_v26_evidence_result_redecision_under_platform.zip`.
First ingest local retest results for:
- flutter clean
- flutter pub get
- dart format .
- flutter analyze
- flutter run -d chrome
Then ingest:
- Browser console review
- Role UAT screenshots/logs
- Responsive UAT evidence
- Full PalWakf merge apply result
- Supabase SQL UAT result
Do not approve production unless all P0 gates are closed.
Do not touch waqf_assets, schema waqf, or awqaf_system.
