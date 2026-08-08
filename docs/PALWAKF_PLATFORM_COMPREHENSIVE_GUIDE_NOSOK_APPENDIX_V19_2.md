# PalWakf Guide Appendix — Nosok v19.2

## Rule Added
عند تسليم نظام شبه مستقل مع preview host، يجب فصل ملفات التكامل المقترحة مع المنصة عن تحليل standalone preview.

## Governance
- المنصة PalWakf هي الأساس.
- نسك تابع تحت المنصة.
- مجلدات platform overlay ليست مصدر تشغيل داخل preview host.
- لا يتم اعتبار أخطاء imports في overlay blockers داخل standalone إلا عند تطبيقها داخل ريبو PalWakf الحقيقي.

## Analyzer Boundary
Standalone preview analyzes:
- `lib/**`
- `web/**`
- project runtime files

Standalone preview excludes:
- `platform_merge_patch/**`
- `platform_finalization_proposals/**`

## Lifecycle Rule
تغيير حالة طلب نسك يجب أن يتم عبر Lifecycle State Machine، لا عبر تحديث status حر قد يتجاوز transitions.
