# SESSION HANDOFF — NOSOK V22

## نقطة البداية القادمة
ابدأ من الحزمة: `nosok_platform_integration_patch_v22_full_merge_role_evidence_gate_under_platform.zip`.

## آخر حالة مثبتة قبل v22
- v21 أضاف Real Platform Merge Pack وRBAC override contract وSQL UAT intake.
- سجل المستخدم أثبت أن preview host نجح في `flutter analyze` بلا issues و`flutter run -d chrome` أقلع بنجاح.

## ما أضافته v22
1. Browser/Role Evidence Intake.
2. Production Gate Decision.
3. Remaining Work Register.
4. SQL v22 لجداول الأدلة والقرار.
5. Full PalWakf Apply Runbook.

## الحكم الحالي
`production-not-approved` لأن الريبو الكامل وSupabase UAT وRole/Browser Evidence لم تُغلق بعد.

## أوامر الفحص
```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

## مسارات الفحص
- `/admin/systems/nosok/browser-role-evidence`
- `/admin/systems/nosok/production-gate-decision`
- `/admin/systems/nosok/remaining-work`
- `/admin/systems/nosok/real-platform-merge`
- `/admin/systems/nosok/sql-uat-intake`

## SQL UAT
```sql
select * from public.rpc_nosok_v22_runtime_contract_uat_v1();
select * from public.rpc_nosok_v22_full_platform_merge_execution_v1();
select * from public.rpc_nosok_v22_remaining_work_register_v1();
select * from public.rpc_nosok_v22_production_gate_decision_v1();
```

## ما يجب عدم فعله
- لا تعتمد الإنتاج من preview host فقط.
- لا تنشئ RBAC محلي داخل نسك.
- لا تنقل Auth أو core.org_units إلى نسك.
- لا تلمس waqf/waqf_assets/awqaf_system.
