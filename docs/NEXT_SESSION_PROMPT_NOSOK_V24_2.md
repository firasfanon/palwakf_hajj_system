# NEXT_SESSION_PROMPT_NOSOK_V24_2

ابدأ من baseline:

`nosok_platform_integration_patch_v24_2_analyzer_chrome_evidence_intake_under_platform.zip`

الحالة:

`staging-stable / analyzer-clean / chrome-startup-passed / browser-pages-reported-working / production-not-approved / no-waqf-assets-mutation`

المطلوب التالي:

**Nosok v25 — Evidence Intake + Full PalWakf Merge Application Result Intake + Production Candidate Decision**

نفّذ دفعة كبيرة تشمل:

1. استيعاب Browser UAT screenshots/logs للمسارات العامة والداخلية.
2. استيعاب Role UAT للأدوار: visitor, citizen, nosok employee, supervisor, system admin, superuser, restricted user.
3. استيعاب Responsive UAT للـ desktop/laptop/tablet/mobile.
4. تطبيق أو استيعاب نتيجة تطبيق `platform_real_merge_pack` داخل ريبو PalWakf الكامل.
5. استيعاب SQL UAT من Supabase، خصوصًا `sql/22_nosok_v24_read_only_uat_pack.sql` وما بعده.
6. إصدار قرار production gate: production-candidate أو production-blocked مع سبب واضح.

قواعد ثابتة:

- PalWakf هي المنصة الأم.
- نسك نظام شبه مستقل تحت المنصة.
- لا SQL إنتاجي/DML إلا بتصريح صريح.
- لا لمس لـ `waqf`, `waqf_assets`, أو `awqaf_system`.
- تحديث changelog/session handoff/UAT matrix/Error Record/Comprehensive Guide appendix بعد كل نتيجة ناجحة.
