# PALWAKF_PLATFORM_COMPREHENSIVE_GUIDE — NOSOK APPENDIX V21

## القاعدة الحاكمة
نسك نظام شبه مستقل تحت PalWakf. الدمج الحقيقي لا يعني استقلالًا عن المنصة، بل يعني:

- Auth من PalWakf.
- RBAC من PalWakf.
- Unit scopes من `core.org_units` و`user_scope_assignments`.
- Shell/Chrome من المنصة.
- نسك يملك body/workflows/schema/RPC الخاصة به فقط.

## v21
تضاف طبقة `platform_real_merge_pack` كحزمة تطبيق داخل ريبو المنصة الكامل، مع إبقاء standalone preview منفصلًا للفحص.

## إنتاجية
`production-not-approved` حتى تُغلق SQL UAT وBrowser UAT وRole UAT وEvidence Closure.
