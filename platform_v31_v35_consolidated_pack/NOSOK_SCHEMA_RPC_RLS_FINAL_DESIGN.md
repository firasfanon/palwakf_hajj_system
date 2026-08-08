# Nosok Schema/RPC/RLS Final Design — v31-v35

## Schemas

- `nosok`: الملكية التشغيلية لنسك.
- `public`: RPC wrappers/views العامة فقط.
- `core/platform`: RBAC, org units, dynamic registry, audit envelope.

## Core tables

- `nosok.seasons`
- `nosok.applications`
- `nosok.applicants`
- `nosok.companions`
- `nosok.documents`
- `nosok.companies`
- `nosok.campaigns`
- `nosok.groups`
- `nosok.messages`
- `nosok.reviews`

## Lottery tables

- `nosok.lottery_policies`
- `nosok.lgu_quota_snapshots`
- `nosok.lottery_eligibility_snapshots`
- `nosok.lottery_draw_runs`
- `nosok.lottery_draw_results`
- `nosok.lottery_waiting_list`
- `nosok.lottery_committee_decisions`
- `nosok.lottery_objections`
- `nosok.lottery_audit_events`

## RPC surface

Public safe:

- `public.rpc_nosok_public_service_home_v1`
- `public.rpc_nosok_application_submit_v1`
- `public.rpc_nosok_track_application_v1`
- `public.rpc_nosok_lottery_result_get_v1`
- `public.rpc_nosok_waiting_list_status_get_v1`
- `public.rpc_nosok_objection_submit_v1`

Internal:

- `nosok.rpc_admin_requests_snapshot_v1`
- `nosok.rpc_lottery_admin_snapshot_v1`
- `nosok.rpc_lottery_freeze_eligibility_snapshot_v1`
- `nosok.rpc_lottery_draw_execute_v1`
- `nosok.rpc_lottery_committee_decision_record_v1`
- `nosok.rpc_readiness_v1`

## RLS principles

- المواطن يرى طلبه فقط عبر RPC.
- الشركة ترى نطاقها فقط.
- الموظف يرى نطاقه حسب AccessProfile.
- لجنة الحج تملك قرارات موثقة فقط لا تعديلات صامتة.
- Superuser يرى audit ولا يتجاوز السجل.
- لا public table مباشر.
