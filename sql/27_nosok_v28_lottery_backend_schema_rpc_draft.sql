-- Nosok v28 — Lottery Backend Schema/RPC Draft
-- Scope: Hajj lottery backend draft for LGU quota + capacity-aware draw + committee decisions.
-- Safety: this script is non-persistent by default. It opens a transaction and ends with ROLLBACK.
-- To apply in a reviewed sandbox only, replace the final ROLLBACK with COMMIT after approval.
-- Do NOT run against production before RLS/RPC/security review and explicit ministry/platform approval.

begin;

create schema if not exists nosok;

create table if not exists nosok.lottery_policies (
  id uuid primary key default gen_random_uuid(),
  season_id uuid,
  season_code text not null,
  policy_version text not null,
  status text not null default 'draft',
  min_age integer not null default 16 check (min_age >= 0),
  quota_divisor integer not null default 1000 check (quota_divisor > 0),
  max_companions integer not null default 2 check (max_companions >= 0),
  mahram_required boolean not null default true,
  payment_required_before_draw boolean not null default true,
  registration_open_for_eligible_public boolean not null default true,
  cross_lgu_transfer_requires_committee_decision boolean not null default true,
  total_national_hajj_quota integer check (total_national_hajj_quota is null or total_national_hajj_quota >= 0),
  population_source_ar text not null default 'snapshot معتمد قبل القرعة',
  quota_source_ar text not null default 'سياسة وزارة الأوقاف للموسم',
  lgu_address_source_ar text not null default 'العنوان المعتمد في البطاقة الشخصية',
  underfilled_quota_policy text not null default 'committee_decision_required',
  notes_ar text,
  created_by uuid,
  approved_by uuid,
  approved_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (season_code, policy_version)
);

create table if not exists nosok.lgu_quota_snapshots (
  id uuid primary key default gen_random_uuid(),
  policy_id uuid not null references nosok.lottery_policies(id) on delete cascade,
  lgu_code text not null,
  lgu_name_ar text not null,
  governorate_ar text,
  population_snapshot integer not null check (population_snapshot >= 0),
  calculated_quota integer not null check (calculated_quota >= 0),
  manual_quota_override integer check (manual_quota_override is null or manual_quota_override >= 0),
  final_capacity integer not null check (final_capacity >= 0),
  eligible_applications integer not null default 0 check (eligible_applications >= 0),
  eligible_people integer not null default 0 check (eligible_people >= 0),
  selected_applications integer not null default 0 check (selected_applications >= 0),
  selected_people integer not null default 0 check (selected_people >= 0),
  remaining_capacity integer not null default 0 check (remaining_capacity >= 0),
  freeze_status text not null default 'draft',
  snapshot_source_ar text not null default 'LGU population snapshot',
  created_at timestamptz not null default now(),
  locked_at timestamptz,
  unique (policy_id, lgu_code)
);

create table if not exists nosok.lottery_eligibility_snapshots (
  id uuid primary key default gen_random_uuid(),
  policy_id uuid not null references nosok.lottery_policies(id) on delete cascade,
  application_id uuid,
  application_no text not null,
  applicant_display_ar text,
  identity_no_hash text,
  lgu_code text not null,
  lgu_name_ar text not null,
  identity_address_ar text not null,
  total_people_count integer not null check (total_people_count > 0),
  eligibility_status text not null default 'pending_validation',
  exclusion_reasons_ar text[] not null default '{}',
  has_previous_hajj boolean not null default false,
  documents_complete boolean not null default false,
  payment_recorded boolean not null default false,
  rank_seed integer not null default 0,
  frozen_at timestamptz not null default now(),
  unique (policy_id, application_no)
);

create table if not exists nosok.lottery_draw_runs (
  id uuid primary key default gen_random_uuid(),
  policy_id uuid not null references nosok.lottery_policies(id) on delete restrict,
  run_code text not null unique,
  status text not null default 'draft',
  algorithm_version text not null default 'capacity-aware-lgu-v28',
  policy_snapshot_hash text not null,
  operator_user_id uuid,
  operator_scope text,
  started_at timestamptz not null default now(),
  completed_at timestamptz,
  total_lgus integer not null default 0,
  total_eligible_applications integer not null default 0,
  total_selected_people integer not null default 0,
  committee_required_lgus integer not null default 0,
  audit_hash text,
  notes_ar text
);

create table if not exists nosok.lottery_draw_results (
  id uuid primary key default gen_random_uuid(),
  draw_run_id uuid not null references nosok.lottery_draw_runs(id) on delete cascade,
  eligibility_snapshot_id uuid not null references nosok.lottery_eligibility_snapshots(id) on delete restrict,
  lgu_quota_snapshot_id uuid not null references nosok.lgu_quota_snapshots(id) on delete restrict,
  application_no text not null,
  lgu_code text not null,
  total_people_count integer not null check (total_people_count > 0),
  decision text not null,
  rank_no integer not null,
  remaining_capacity_after_decision integer not null check (remaining_capacity_after_decision >= 0),
  reason_ar text,
  public_result_status text not null default 'not_published',
  published_at timestamptz,
  created_at timestamptz not null default now(),
  unique (draw_run_id, eligibility_snapshot_id)
);

create table if not exists nosok.lottery_committee_decisions (
  id uuid primary key default gen_random_uuid(),
  draw_run_id uuid not null references nosok.lottery_draw_runs(id) on delete cascade,
  lgu_quota_snapshot_id uuid not null references nosok.lgu_quota_snapshots(id) on delete restrict,
  decision_type text not null,
  remaining_capacity integer not null check (remaining_capacity >= 0),
  reason_ar text not null,
  evidence_ref text,
  decided_by uuid,
  decided_at timestamptz not null default now(),
  status text not null default 'recorded'
);

create table if not exists nosok.lottery_objections (
  id uuid primary key default gen_random_uuid(),
  application_no text not null,
  tracking_code_hash text,
  objection_type text not null,
  summary_ar text not null,
  attachment_ref text,
  status text not null default 'submitted',
  submitted_at timestamptz not null default now(),
  reviewed_by uuid,
  resolved_at timestamptz,
  resolution_ar text
);

create table if not exists nosok.lottery_audit_events (
  id uuid primary key default gen_random_uuid(),
  entity_type text not null,
  entity_id uuid,
  event_key text not null,
  actor_user_id uuid,
  actor_scope text,
  event_payload jsonb not null default '{}'::jsonb,
  event_hash text,
  created_at timestamptz not null default now()
);

alter table nosok.lottery_policies enable row level security;
alter table nosok.lgu_quota_snapshots enable row level security;
alter table nosok.lottery_eligibility_snapshots enable row level security;
alter table nosok.lottery_draw_runs enable row level security;
alter table nosok.lottery_draw_results enable row level security;
alter table nosok.lottery_committee_decisions enable row level security;
alter table nosok.lottery_objections enable row level security;
alter table nosok.lottery_audit_events enable row level security;

create index if not exists idx_lgu_quota_policy_lgu on nosok.lgu_quota_snapshots(policy_id, lgu_code);
create index if not exists idx_lottery_eligibility_policy_lgu on nosok.lottery_eligibility_snapshots(policy_id, lgu_code, eligibility_status);
create index if not exists idx_lottery_results_run_lgu on nosok.lottery_draw_results(draw_run_id, lgu_code, decision);
create index if not exists idx_lottery_objections_application on nosok.lottery_objections(application_no, status);
create index if not exists idx_lottery_audit_entity on nosok.lottery_audit_events(entity_type, entity_id, created_at desc);

create or replace function public.rpc_nosok_lottery_public_result_v1(
  p_tracking_code text,
  p_identity_token text
)
returns table (
  application_no text,
  lgu_name_ar text,
  result_status text,
  public_message_ar text,
  next_step_ar text
)
language plpgsql
security definer
set search_path = public, nosok
as $$
begin
  -- Draft contract: real implementation must hash/verify p_identity_token and return one request only.
  return query
  select
    r.application_no,
    q.lgu_name_ar,
    r.decision as result_status,
    case
      when r.decision = 'selected' then 'تم اختيار الطلب ضمن حصة التجمع المعتمد.'
      when r.decision = 'waiting_list' then 'الطلب مؤهل وضمن قائمة انتظار التجمع.'
      when r.decision = 'committee_review' then 'توجد حالة تحتاج قرار لجنة الحج.'
      else 'لم يتم اختيار الطلب ضمن القرعة الحالية أو توجد نواقص.'
    end as public_message_ar,
    'تابع قنوات نسك الرسمية للتعليمات التالية.' as next_step_ar
  from nosok.lottery_draw_results r
  join nosok.lgu_quota_snapshots q on q.id = r.lgu_quota_snapshot_id
  where r.application_no = p_tracking_code
  order by r.created_at desc
  limit 1;
end;
$$;

create or replace function public.rpc_nosok_lottery_submit_objection_v1(
  p_application_no text,
  p_tracking_token text,
  p_objection_type text,
  p_summary_ar text,
  p_attachment_ref text default null
)
returns table (accepted boolean, objection_ref uuid, status text, message_ar text)
language plpgsql
security definer
set search_path = public, nosok
as $$
declare
  v_id uuid;
begin
  -- Draft contract: real implementation must verify p_tracking_token before insert.
  insert into nosok.lottery_objections(application_no, objection_type, summary_ar, attachment_ref)
  values (p_application_no, p_objection_type, p_summary_ar, p_attachment_ref)
  returning id into v_id;

  return query select true, v_id, 'submitted'::text, 'تم استلام الاعتراض للمراجعة.'::text;
end;
$$;

create or replace function public.rpc_nosok_lottery_admin_policy_snapshot_v1(p_policy_id uuid default null)
returns table (section text, check_key text, value_text text, note_ar text)
language sql
security definer
set search_path = public, nosok
as $$
  select 'policy'::text, 'policies_count'::text, count(*)::text, 'عدد سياسات القرعة المسجلة.'::text from nosok.lottery_policies
  union all
  select 'lgu_quota'::text, 'lgu_snapshot_count'::text, count(*)::text, 'عدد لقطات LGU الموسمية.'::text from nosok.lgu_quota_snapshots
  union all
  select 'eligibility'::text, 'eligibility_snapshot_count'::text, count(*)::text, 'عدد طلبات الأهلية المجمدة.'::text from nosok.lottery_eligibility_snapshots;
$$;

create or replace function public.rpc_nosok_lottery_admin_freeze_eligibility_v1(p_policy_id uuid)
returns table (accepted boolean, status text, message_ar text)
language plpgsql
security definer
set search_path = public, nosok
as $$
begin
  raise exception 'v28 draft only: eligibility freeze requires reviewed application source mapping before execution';
end;
$$;

create or replace function public.rpc_nosok_lottery_admin_execute_draw_v1(p_policy_id uuid)
returns table (accepted boolean, run_id uuid, status text, message_ar text)
language plpgsql
security definer
set search_path = public, nosok
as $$
begin
  raise exception 'v28 draft only: execute draw requires sandbox UAT and committee authorization before execution';
end;
$$;

create or replace function public.rpc_nosok_lottery_committee_decision_v1(
  p_draw_run_id uuid,
  p_lgu_quota_snapshot_id uuid,
  p_decision_type text,
  p_remaining_capacity integer,
  p_reason_ar text,
  p_evidence_ref text default null
)
returns table (accepted boolean, decision_id uuid, status text, message_ar text)
language plpgsql
security definer
set search_path = public, nosok
as $$
declare
  v_id uuid;
begin
  if coalesce(trim(p_reason_ar), '') = '' then
    raise exception 'committee decision reason is required';
  end if;

  insert into nosok.lottery_committee_decisions(
    draw_run_id,
    lgu_quota_snapshot_id,
    decision_type,
    remaining_capacity,
    reason_ar,
    evidence_ref
  ) values (
    p_draw_run_id,
    p_lgu_quota_snapshot_id,
    p_decision_type,
    p_remaining_capacity,
    p_reason_ar,
    p_evidence_ref
  ) returning id into v_id;

  return query select true, v_id, 'recorded'::text, 'تم تسجيل قرار اللجنة مع أثر تدقيقي.'::text;
end;
$$;

create or replace function public.rpc_nosok_v28_lottery_backend_readiness_v1()
returns table (section text, check_key text, passed boolean, note_ar text)
language sql
security definer
set search_path = public, nosok
as $$
  select 'schema'::text, 'nosok_schema_exists'::text, exists(select 1 from information_schema.schemata where schema_name = 'nosok'), 'Schema nosok متاح.'::text
  union all
  select 'tables', 'lottery_tables_exist',
    (select count(*) = 8 from information_schema.tables where table_schema = 'nosok' and table_name in ('lottery_policies','lgu_quota_snapshots','lottery_eligibility_snapshots','lottery_draw_runs','lottery_draw_results','lottery_committee_decisions','lottery_objections','lottery_audit_events')),
    'الجداول الثمانية الأساسية موجودة.'
  union all
  select 'rpc', 'lottery_rpc_contracts_exist',
    (select count(*) >= 7 from pg_proc p join pg_namespace n on n.oid = p.pronamespace where n.nspname = 'public' and p.proname in ('rpc_nosok_lottery_public_result_v1','rpc_nosok_lottery_submit_objection_v1','rpc_nosok_lottery_admin_policy_snapshot_v1','rpc_nosok_lottery_admin_freeze_eligibility_v1','rpc_nosok_lottery_admin_execute_draw_v1','rpc_nosok_lottery_committee_decision_v1','rpc_nosok_v28_lottery_backend_readiness_v1')),
    'RPC wrappers الأساسية موجودة.'
  union all
  select 'rls', 'rls_enabled_on_lottery_tables',
    (select count(*) = 8 from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'nosok' and c.relname in ('lottery_policies','lgu_quota_snapshots','lottery_eligibility_snapshots','lottery_draw_runs','lottery_draw_results','lottery_committee_decisions','lottery_objections','lottery_audit_events') and c.relrowsecurity),
    'RLS مفعّل على جداول القرعة.'
  union all
  select 'safety', 'no_waqf_assets_mutation_in_this_script', true, 'هذا draft لا يلمس waqf_assets أو schema waqf أو awqaf_system.';
$$;

-- Non-persistent by default.
rollback;
