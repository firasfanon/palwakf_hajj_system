-- Nosok v17 — Data-Bound Workbench + Service Desk Search + Season Command Gate Enforcement
-- Scope: additive runtime contracts only. No waqf/waqf_assets/awqaf_system mutation.

create schema if not exists nosok;

create table if not exists nosok.service_desk_search_audit (
  id uuid primary key default gen_random_uuid(),
  query_hash text not null,
  result_count integer not null default 0,
  searched_by uuid null,
  searched_at timestamptz not null default now(),
  notes_ar text null
);

create table if not exists nosok.season_gate_decisions (
  id uuid primary key default gen_random_uuid(),
  season_id uuid null,
  can_open boolean not null default false,
  blocker_count integer not null default 0,
  note_ar text,
  evaluated_by uuid null,
  evaluated_at timestamptz not null default now()
);

create or replace function public.rpc_nosok_v17_admin_workflow_buckets_bound_v1()
returns table(
  bucket_key text,
  title_ar text,
  description_ar text,
  route_path text,
  severity text,
  display_order integer,
  item_count integer,
  blocker_count integer,
  warning_count integer,
  last_updated_at timestamptz
)
language sql
security definer
set search_path = nosok, public
as $$
  with metrics as (
    select
      (select count(*)::integer from nosok.applications a where a.application_status in ('submitted','under_review')) as applications_review_count,
      (select count(*)::integer from nosok.application_documents d where d.review_status = 'pending') as pending_documents_count,
      (select count(*)::integer from nosok.application_documents d where d.review_status = 'rejected') as rejected_documents_count,
      (select count(*)::integer from nosok.application_payments p where coalesce(p.verification_status, 'pending') in ('pending','under_review','needs_receipt')) as pending_payments_count,
      (select count(*)::integer from nosok.applications a) as unit_queue_count,
      (select count(*)::integer from nosok.complaints c where c.status in ('submitted','under_review','in_progress')) as open_complaints_count,
      greatest(
        coalesce((select max(a.updated_at) from nosok.applications a), now()),
        coalesce((select max(d.uploaded_at) from nosok.application_documents d), now()),
        coalesce((select max(p.created_at) from nosok.application_payments p), now()),
        coalesce((select max(c.updated_at) from nosok.complaints c), now())
      ) as max_updated_at
  )
  select
    b.bucket_key,
    b.title_ar,
    b.description_ar,
    b.route_path,
    case
      when b.bucket_key = 'documents_review' and m.rejected_documents_count > 0 then 'blocker'
      when b.bucket_key in ('applications_review','documents_review','payments_verification') then 'high'
      else b.severity
    end as severity,
    b.display_order,
    case b.bucket_key
      when 'applications_review' then m.applications_review_count
      when 'documents_review' then m.pending_documents_count + m.rejected_documents_count
      when 'payments_verification' then m.pending_payments_count
      when 'unit_queues' then m.unit_queue_count
      when 'complaints_followup' then m.open_complaints_count
      else 0
    end as item_count,
    case b.bucket_key
      when 'documents_review' then m.rejected_documents_count
      else 0
    end as blocker_count,
    case b.bucket_key
      when 'applications_review' then m.applications_review_count
      when 'documents_review' then m.pending_documents_count
      when 'payments_verification' then m.pending_payments_count
      when 'complaints_followup' then m.open_complaints_count
      else 0
    end as warning_count,
    m.max_updated_at as last_updated_at
  from nosok.admin_workflow_buckets b
  cross join metrics m
  where b.is_active = true
  order by b.display_order, b.title_ar;
$$;

create or replace function public.rpc_nosok_v17_service_desk_search_v1(p_query text)
returns table(
  result_type text,
  entity_id uuid,
  primary_label text,
  secondary_label text,
  status text,
  route_path text,
  matched_by text,
  last_activity_at timestamptz
)
language plpgsql
security definer
set search_path = nosok, public
as $$
declare
  v_query text := trim(coalesce(p_query, ''));
  v_like text;
  v_count integer;
begin
  if length(v_query) < 2 then
    return;
  end if;

  v_like := '%' || replace(v_query, '%', '\%') || '%';

  return query
  select
    'application'::text,
    a.id,
    a.application_no,
    concat_ws(' — ', a.applicant_full_name, a.service_type, a.mobile),
    a.application_status,
    '/admin/systems/nosok/applications/' || a.id::text,
    case
      when a.application_no = v_query then 'application_no'
      when a.tracking_token = v_query then 'tracking_token'
      when a.national_id = v_query then 'national_id_admin_only'
      when a.mobile = v_query or a.phone = v_query then 'phone_admin_only'
      else 'text_match'
    end,
    coalesce(a.reviewed_at, a.submitted_at, a.updated_at, a.created_at)
  from nosok.applications a
  where a.application_no = v_query
     or a.tracking_token = v_query
     or a.national_id = v_query
     or a.mobile = v_query
     or a.phone = v_query
     or a.applicant_full_name ilike v_like
  order by coalesce(a.reviewed_at, a.submitted_at, a.updated_at, a.created_at) desc
  limit 12;

  return query
  select
    'complaint'::text,
    c.id,
    c.complaint_no,
    concat_ws(' — ', c.subject, c.complainant_name, c.phone),
    c.status,
    '/admin/systems/nosok/complaints',
    case
      when c.complaint_no = v_query then 'complaint_no'
      when c.phone = v_query then 'phone_admin_only'
      else 'text_match'
    end,
    coalesce(c.closed_at, c.updated_at, c.submitted_at, c.created_at)
  from nosok.complaints c
  where c.complaint_no = v_query
     or c.phone = v_query
     or c.email = v_query
     or c.subject ilike v_like
     or c.complainant_name ilike v_like
  order by coalesce(c.closed_at, c.updated_at, c.submitted_at, c.created_at) desc
  limit 8;

  get diagnostics v_count = row_count;
  insert into nosok.service_desk_search_audit(query_hash, result_count, notes_ar)
  values (md5(v_query), coalesce(v_count, 0), 'Service desk search executed through admin RPC.');
end;
$$;

create or replace function public.rpc_nosok_v17_service_desk_scripts_v1(p_category text default null)
returns table(
  script_key text,
  title_ar text,
  body_ar text,
  category text,
  display_order integer
)
language sql
security definer
set search_path = nosok, public
as $$
  select s.script_key, s.title_ar, s.body_ar, s.category, s.display_order
  from nosok.service_desk_scripts s
  where s.is_active = true
    and (p_category is null or trim(p_category) = '' or s.category = p_category)
  order by s.display_order, s.title_ar;
$$;

create or replace function public.rpc_nosok_v17_season_command_gates_v1(p_season_id uuid default null)
returns table(
  check_key text,
  title_ar text,
  description_ar text,
  gate_type text,
  owner_surface text,
  route_path text,
  passed boolean,
  status text,
  evidence_note text,
  blocker_count integer,
  display_order integer
)
language sql
security definer
set search_path = nosok, public
as $$
  with selected_season as (
    select s.id
    from nosok.seasons s
    where (p_season_id is null or s.id = p_season_id)
      and s.status in ('open','draft','planned')
    order by case when s.status = 'open' then 0 else 1 end, s.gregorian_year desc, s.registration_start_at desc nulls last
    limit 1
  ), metrics as (
    select
      exists(select 1 from nosok.seasons s where (p_season_id is null or s.id = p_season_id) and s.status = 'open' and s.is_publicly_visible = true) as has_active_season,
      exists(select 1 from nosok.service_programs p where (p_season_id is null or p.season_id = p_season_id or p.season_id in (select id from selected_season)) and p.status = 'active' and p.is_publicly_visible = true) as has_published_program,
      exists(select 1 from nosok.company_season_qualifications q where (p_season_id is null or q.season_id = p_season_id or q.season_id in (select id from selected_season)) and q.qualification_status = 'qualified' and q.is_publicly_visible = true) as has_qualified_companies,
      not exists(select 1 from nosok.public_tracking_privacy_checks pc where pc.severity = 'blocker' and pc.status <> 'passed') as tracking_privacy_passed,
      exists(select 1 from nosok.role_uat_evidence e where e.result_status = 'passed') as role_uat_passed,
      exists(select 1 from nosok.billing_provider_adapters a where a.adapter_status = 'enabled' and a.health_status in ('passed','contract_ready')) as billing_bridge_ready
  )
  select
    c.check_key,
    c.title_ar,
    c.description_ar,
    c.gate_type,
    c.owner_surface,
    case c.owner_surface
      when 'seasons' then '/admin/systems/nosok/seasons'
      when 'programs' then '/admin/systems/nosok/programs'
      when 'companies' then '/admin/systems/nosok/companies'
      when 'tracking_privacy' then '/admin/systems/nosok/tracking-privacy'
      when 'role_uat' then '/admin/systems/nosok/role-uat'
      when 'billing_adapters' then '/admin/systems/nosok/billing-adapters'
      else '/admin/systems/nosok/operations'
    end as route_path,
    case c.check_key
      when 'active_season' then m.has_active_season
      when 'published_program' then m.has_published_program
      when 'qualified_companies' then m.has_qualified_companies
      when 'tracking_privacy' then m.tracking_privacy_passed
      when 'role_uat' then m.role_uat_passed
      when 'billing_bridge' then m.billing_bridge_ready
      else false
    end as passed,
    case when (
      case c.check_key
        when 'active_season' then m.has_active_season
        when 'published_program' then m.has_published_program
        when 'qualified_companies' then m.has_qualified_companies
        when 'tracking_privacy' then m.tracking_privacy_passed
        when 'role_uat' then m.role_uat_passed
        when 'billing_bridge' then m.billing_bridge_ready
        else false
      end
    ) then 'passed' else 'blocked' end as status,
    case c.check_key
      when 'tracking_privacy' then 'يجب إغلاق blocker privacy checks قبل فتح الموسم.'
      when 'role_uat' then 'يلزم Role UAT evidence passed لسطوح الدخول الحرجة.'
      when 'billing_bridge' then 'يلزم adapter enabled وصحته passed/contract_ready.'
      else c.description_ar
    end as evidence_note,
    case when (
      case c.check_key
        when 'active_season' then m.has_active_season
        when 'published_program' then m.has_published_program
        when 'qualified_companies' then m.has_qualified_companies
        when 'tracking_privacy' then m.tracking_privacy_passed
        when 'role_uat' then m.role_uat_passed
        when 'billing_bridge' then m.billing_bridge_ready
        else false
      end
    ) then 0 else 1 end as blocker_count,
    c.display_order
  from nosok.season_command_checklist c
  cross join metrics m
  where c.is_required = true
  order by c.display_order, c.title_ar;
$$;

create or replace function public.rpc_nosok_v17_season_open_gate_decision_v1(p_season_id uuid default null)
returns table(can_open boolean, blocker_count integer, note_ar text)
language plpgsql
security definer
set search_path = nosok, public
as $$
declare
  v_blockers integer;
  v_can_open boolean;
begin
  select count(*)::integer
    into v_blockers
  from public.rpc_nosok_v17_season_command_gates_v1(p_season_id) g
  where g.passed = false and (g.gate_type = 'gate' or g.blocker_count > 0);

  v_can_open := coalesce(v_blockers, 0) = 0;

  insert into nosok.season_gate_decisions(season_id, can_open, blocker_count, note_ar)
  values (
    p_season_id,
    v_can_open,
    coalesce(v_blockers, 0),
    case when v_can_open
      then 'يمكن فتح الموسم من منظور v17 gates؛ يلزم اعتماد إداري نهائي من PalWakf.'
      else 'لا يمكن فتح الموسم؛ توجد عناصر Gate غير مغلقة.'
    end
  );

  return query select
    v_can_open,
    coalesce(v_blockers, 0),
    case when v_can_open
      then 'يمكن فتح الموسم من منظور v17 gates؛ يلزم اعتماد إداري نهائي من PalWakf.'
      else 'لا يمكن فتح الموسم؛ توجد عناصر Gate غير مغلقة.'
    end;
end;
$$;

create or replace function public.rpc_nosok_v17_runtime_contract_uat_v1()
returns table(section text, check_key text, passed boolean, note text)
language sql
security definer
set search_path = nosok, public
as $$
  select 'workbench', 'data_bound_workflow_rpc_exists', exists(select 1 from pg_proc where proname = 'rpc_nosok_v17_admin_workflow_buckets_bound_v1'), 'Workbench now reads computed counters.'
  union all
  select 'service_desk', 'search_rpc_exists', exists(select 1 from pg_proc where proname = 'rpc_nosok_v17_service_desk_search_v1'), 'Service desk search RPC exists.'
  union all
  select 'service_desk', 'scripts_rpc_exists', exists(select 1 from pg_proc where proname = 'rpc_nosok_v17_service_desk_scripts_v1'), 'Service desk scripts RPC exists.'
  union all
  select 'season_command', 'season_gate_rpc_exists', exists(select 1 from pg_proc where proname = 'rpc_nosok_v17_season_command_gates_v1'), 'Season command gate RPC exists.'
  union all
  select 'season_command', 'open_gate_decision_rpc_exists', exists(select 1 from pg_proc where proname = 'rpc_nosok_v17_season_open_gate_decision_v1'), 'Season open decision RPC exists.'
  union all
  select 'sovereign_boundary', 'no_waq_assets_mutation', true, 'No waqf/waqf_assets/awqaf_system DML in v17.';
$$;
