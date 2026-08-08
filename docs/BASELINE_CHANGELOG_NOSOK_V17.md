# BASELINE CHANGELOG — Nosok v17

## Batch
Nosok v17 — Data-Bound Workbench + Service Desk Search + Season Command Gate Enforcement

## Date
2026-05-18

## Scope
تطوير تشغيلي كبير فوق v16، مع إبقاء نسك نظامًا شبه مستقل تحت PalWakf وليس منصة مستقلة.

## Changes
- ربط `workflow-workbench` ببيانات فعلية عبر `NosokWorkflowBucket` وRPC `rpc_nosok_v17_admin_workflow_buckets_bound_v1`.
- إضافة بحث مكتب الخدمة عبر `NosokServiceDeskSearchResult` وRPC `rpc_nosok_v17_service_desk_search_v1`.
- تحويل نصوص مكتب الخدمة إلى بيانات عبر `NosokServiceDeskScript` وRPC `rpc_nosok_v17_service_desk_scripts_v1`.
- تحويل قيادة الموسم من checklist ثابت إلى Gate تشغيلية عبر `NosokSeasonCommandGate` و`NosokSeasonOpenGateDecision`.
- إضافة SQL v17 لعقود workbench/search/gates/UAT.
- تحديث Supabase/InMemory repositories لدعم المعاينة بدون Supabase والتشغيل عبر RPC عند الدمج.

## Status
`staging-ready / data-bound-workbench-enabled / service-desk-search-enabled / season-gate-enforcement-contract / local-retest-required / production-not-approved / no-waqf-assets-mutation`

## Sovereign Boundary
لم يتم لمس `waqf_assets` أو schema `waqf` أو منطق `awqaf_system`.
