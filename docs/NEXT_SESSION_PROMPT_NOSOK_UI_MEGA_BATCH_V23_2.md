# NEXT SESSION PROMPT — Nosok UI Mega Batch v23.2

ابدأ من baseline:
`nosok_platform_integration_patch_v23_2_requirements_compile_hotfix_under_platform.zip`

المطلوب:
1. استيعاب نتائج `flutter analyze` و`flutter run -d chrome` بعد v23.2.
2. إذا كان analyzer clean وChrome startup passed، انتقل إلى Browser UAT للمسارات العامة والداخلية.
3. افحص responsive overflow لصفحات:
   - `/services/nosok`
   - `/services/nosok/apply`
   - `/services/nosok/track`
   - `/services/nosok/requirements`
   - `/admin/systems/nosok`
   - `/admin/systems/nosok/requests`
4. لا تنفذ SQL إنتاجي أو DML دون طلب صريح.
5. لا تمس `waqf`, `waqf_assets`, `awqaf_system`.
6. حافظ على أن نسك نظام شبه مستقل تحت PalWakf ويستخدم PWF-SIS، ولا يملك هوية بصرية مستقلة.
