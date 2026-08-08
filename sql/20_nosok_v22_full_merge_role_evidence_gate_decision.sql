-- Nosok v22 — Full Platform Merge Evidence + Browser Role Evidence + Production Gate Decision
-- Scope: staging / evidence / readiness. No waqf_assets, waqf, or awqaf_system mutation.

create schema if not exists nosok;

create table if not exists nosok.full_platform_merge_execution (
  id uuid primary key default gen_random_uuid(),
  execution_key text not null unique,
  status text not null default 'pending' check (status in ('pending','in_progress','passed','partial','blocked','failed')),
  applied_by uuid null,
  applied_at timestamptz null,
  evidence_url text null,
  notes_ar text null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists nosok.browser_role_evidence (
  id uuid primary key default gen_random_uuid(),
  evidence_key text not null,
  actor_label text not null,
  route_path text not null,
  expected_result text not null,
  actual_result text null,
  result_status text not null default 'pending' check (result_status in ('pending','passed','failed','blocked')),
  evidence_url text null,
  notes_ar text null,
  created_by uuid null,
  created_at timestamptz not null default now()
);

create table if not exists nosok.production_gate_decisions (
  id uuid primary key default gen_random_uuid(),
  decision_key text not null unique,
  decision_status text not null default 'not_approved' check (decision_status in ('not_approved','controlled_staging','pilot_approved','production_approved','blocked')),
  decision_reason_ar text not null,
  decided_by uuid null,
  decided_at timestamptz null,
  evidence_summary jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create table if not exists nosok.remaining_work_register (
  id uuid primary key default gen_random_uuid(),
  work_key text not null unique,
  priority text not null check (priority in ('P0','P1','P2')),
  title_ar text not null,
  status text not null default 'pending' check (status in ('pending','in_progress','passed','blocked','deferred')),
  owner_system text not null default 'nosok',
  notes_ar text null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

insert into nosok.full_platform_merge_execution (execution_key, status, notes_ar)
values
  ('copy_feature_to_palwakf_repo','pending','نسخ lib/features/nosok_system إلى الريبو الكامل.'),
  ('wire_routes_in_real_route_groups','pending','تسجيل NosokRoutes داخل route groups الحقيقية للمنصة.'),
  ('override_access_profile_provider','pending','ربط nosokAccessProfileProvider بمصدر AccessProfile الحقيقي.'),
  ('register_dynamic_system_registry','pending','تسجيل system_key=nosok وroute/admin bases.'),
  ('register_rbac_permissions','pending','تسجيل صلاحيات نسك في RBAC المنصة.'),
  ('run_sql_uat','pending','تشغيل كل UAT RPCs داخل Supabase.')
on conflict (execution_key) do nothing;

insert into nosok.remaining_work_register (work_key, priority, title_ar, status, owner_system, notes_ar)
values
  ('full_repo_apply','P0','تطبيق حزمة الدمج داخل ريبو PalWakf الكامل','pending','platform','لا يمكن إغلاقه من preview host وحده.'),
  ('sql_uat_evidence','P0','تشغيل SQL UAT وحفظ الدليل','pending','nosok','تشغيل rpc_nosok_v22_runtime_contract_uat_v1 وما قبله.'),
  ('browser_role_evidence','P0','أدلة Browser/Role UAT','pending','nosok','superuser/restricted/unit/public tracking.'),
  ('rbac_provider_override','P0','ربط AccessProfile الحقيقي','pending','platform','Override من AccessProfile المنصة.'),
  ('billing_bridge_real_adapter','P1','إثبات جسر الدفع الحقيقي','pending','billing_system','لا أسرار دفع داخل نسك.'),
  ('notification_bridge_real_adapter','P1','إثبات جسر الإشعارات الحقيقي','pending','platform_notifications','لا محرك إشعارات مستقل داخل نسك.'),
  ('unit_scope_real_data','P1','ربط الوحدات الحقيقية','pending','core','مصدر الوحدات core.org_units.'),
  ('storage_policy_review','P1','مراجعة سياسات Storage','pending','platform_storage','وثائق الطلبات وسندات الدفعات.'),
  ('analytics_reports_deepening','P2','تعميق التقارير الموسمية','deferred','nosok','مرحلة تحسين بعد pilot.')
on conflict (work_key) do nothing;

create or replace function public.rpc_nosok_v22_full_platform_merge_execution_v1()
returns table(
  execution_key text,
  status text,
  evidence_url text,
  notes_ar text
)
language sql
security definer
set search_path = public, nosok
as $$
  select execution_key, status, evidence_url, notes_ar
  from nosok.full_platform_merge_execution
  order by created_at, execution_key;
$$;

create or replace function public.rpc_nosok_v22_browser_role_evidence_v1()
returns table(
  evidence_key text,
  actor_label text,
  route_path text,
  expected_result text,
  actual_result text,
  result_status text,
  evidence_url text,
  notes_ar text
)
language sql
security definer
set search_path = public, nosok
as $$
  select evidence_key, actor_label, route_path, expected_result, actual_result, result_status, evidence_url, notes_ar
  from nosok.browser_role_evidence
  order by created_at desc;
$$;

create or replace function public.rpc_nosok_v22_browser_role_evidence_upsert_v1(
  p_evidence_key text,
  p_actor_label text,
  p_route_path text,
  p_expected_result text,
  p_actual_result text,
  p_result_status text,
  p_evidence_url text default null,
  p_notes_ar text default null
)
returns uuid
language plpgsql
security definer
set search_path = public, nosok
as $$
declare
  v_id uuid;
begin
  insert into nosok.browser_role_evidence(
    evidence_key, actor_label, route_path, expected_result, actual_result, result_status, evidence_url, notes_ar
  ) values (
    p_evidence_key, p_actor_label, p_route_path, p_expected_result, p_actual_result,
    coalesce(nullif(p_result_status,''),'pending'), p_evidence_url, p_notes_ar
  )
  returning id into v_id;

  return v_id;
end;
$$;

create or replace function public.rpc_nosok_v22_remaining_work_register_v1()
returns table(
  work_key text,
  priority text,
  title_ar text,
  status text,
  owner_system text,
  notes_ar text
)
language sql
security definer
set search_path = public, nosok
as $$
  select work_key, priority, title_ar, status, owner_system, notes_ar
  from nosok.remaining_work_register
  order by priority, created_at, work_key;
$$;

create or replace function public.rpc_nosok_v22_production_gate_decision_v1(
  p_decision_status text default 'not_approved',
  p_decision_reason_ar text default 'لم تكتمل أدلة الدمج الحقيقي وSQL UAT وBrowser/Role UAT بعد.',
  p_evidence_summary jsonb default '{}'::jsonb
)
returns table(
  decision_key text,
  decision_status text,
  decision_reason_ar text,
  evidence_summary jsonb
)
language plpgsql
security definer
set search_path = public, nosok
as $$
begin
  insert into nosok.production_gate_decisions(decision_key, decision_status, decision_reason_ar, evidence_summary, decided_at)
  values ('nosok_v22_gate', coalesce(nullif(p_decision_status,''),'not_approved'), p_decision_reason_ar, coalesce(p_evidence_summary,'{}'::jsonb), now())
  on conflict (decision_key) do update set
    decision_status = excluded.decision_status,
    decision_reason_ar = excluded.decision_reason_ar,
    evidence_summary = excluded.evidence_summary,
    decided_at = now();

  return query
  select d.decision_key, d.decision_status, d.decision_reason_ar, d.evidence_summary
  from nosok.production_gate_decisions d
  where d.decision_key = 'nosok_v22_gate';
end;
$$;

create or replace function public.rpc_nosok_v22_runtime_contract_uat_v1()
returns table(section text, check_key text, passed boolean, note text)
language sql
security definer
set search_path = public, nosok
as $$
  select 'v22_tables', 'full_platform_merge_execution_exists', to_regclass('nosok.full_platform_merge_execution') is not null, 'Full merge execution register.'
  union all select 'v22_tables', 'browser_role_evidence_exists', to_regclass('nosok.browser_role_evidence') is not null, 'Browser/Role UAT evidence register.'
  union all select 'v22_tables', 'production_gate_decisions_exists', to_regclass('nosok.production_gate_decisions') is not null, 'Production gate decision register.'
  union all select 'v22_tables', 'remaining_work_register_exists', to_regclass('nosok.remaining_work_register') is not null, 'Remaining work register.'
  union all select 'v22_rpcs', 'full_platform_merge_rpc_exists', to_regprocedure('public.rpc_nosok_v22_full_platform_merge_execution_v1()') is not null, 'Merge execution RPC.'
  union all select 'v22_rpcs', 'browser_role_evidence_rpc_exists', to_regprocedure('public.rpc_nosok_v22_browser_role_evidence_v1()') is not null, 'Browser role evidence RPC.'
  union all select 'v22_rpcs', 'production_gate_decision_rpc_exists', to_regprocedure('public.rpc_nosok_v22_production_gate_decision_v1(text,text,jsonb)') is not null, 'Production decision RPC.'
  union all select 'sovereign_boundary', 'no_waqf_assets_mutation_in_this_script', true, 'This script does not touch waqf/waqf_assets/awqaf_system.';
$$;
