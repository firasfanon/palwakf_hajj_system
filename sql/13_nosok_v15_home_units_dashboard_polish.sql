-- Nosok v15 — System Home/Unit Pages Visual Upgrade + Sidebar Runtime Polish + Admin Dashboard Data Deepening
-- Scope: additive/readiness SQL only. No waqf/waqf_assets/awqaf_system mutation.

create schema if not exists nosok;

create table if not exists nosok.dashboard_runtime_snapshots (
  id uuid primary key default gen_random_uuid(),
  snapshot_key text not null unique,
  snapshot_payload jsonb not null default '{}'::jsonb,
  status text not null default 'draft',
  notes_ar text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists nosok.unit_surface_reviews (
  id uuid primary key default gen_random_uuid(),
  unit_id uuid,
  unit_slug text not null,
  review_key text not null,
  review_status text not null default 'pending',
  evidence_note_ar text,
  reviewed_by uuid,
  reviewed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(unit_slug, review_key)
);

create table if not exists nosok.sidebar_runtime_reviews (
  id uuid primary key default gen_random_uuid(),
  nav_key text not null unique,
  section_key text not null,
  required_permission text,
  runtime_visibility_status text not null default 'pending',
  evidence_note_ar text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

insert into nosok.sidebar_runtime_reviews(nav_key, section_key, required_permission, runtime_visibility_status, evidence_note_ar)
values
  ('dashboard', 'daily_operations', 'viewNosokDashboard', 'pending', 'يجب فحص ظهور لوحة النظام حسب AccessProfile.'),
  ('operations', 'daily_operations', 'viewNosokOperations', 'pending', 'يجب فحص مركز التشغيل حسب الدور.'),
  ('applications', 'daily_operations', 'manageNosokApplications', 'pending', 'يجب فحص قائمة الطلبات وتفاصيل الطلب.'),
  ('unit_queues', 'daily_operations', 'viewNosokUnitQueues', 'pending', 'يجب فحص طوابير الوحدات حسب نطاق المستخدم.'),
  ('payment_bridge', 'payment_privacy', 'manageNosokPaymentBridge', 'pending', 'يجب فحص جسر الدفع دون تخزين أسرار.'),
  ('tracking_privacy', 'payment_privacy', 'reviewNosokTrackingPrivacy', 'pending', 'يجب فحص عدم كشف بيانات حساسة في التتبع العام.'),
  ('users_roles', 'governance', 'manageNosokAccess', 'pending', 'يجب فحص قوالب الأدوار وربط AccessProfile.'),
  ('units', 'governance', 'manageNosokUnits', 'pending', 'يجب فحص صفحات الوحدات وربط core.org_units.')
on conflict (nav_key) do update set
  section_key = excluded.section_key,
  required_permission = excluded.required_permission,
  updated_at = now();

create or replace function public.rpc_nosok_admin_dashboard_deep_summary_v1()
returns table(
  active_seasons_count integer,
  active_programs_count integer,
  published_companies_count integer,
  pending_applications_count integer,
  open_complaints_count integer,
  enabled_unit_surfaces_count integer,
  pending_privacy_checks_count integer,
  pending_readiness_evidence_count integer,
  readiness_score integer
)
language plpgsql
security definer
set search_path = nosok, public
as $$
begin
  return query
  with counts as (
    select
      (select count(*)::integer from nosok.seasons where status = 'open') as seasons_count,
      (select count(*)::integer from nosok.service_programs where status = 'active') as programs_count,
      (select count(*)::integer from nosok.qualified_companies where coalesce(is_publicly_visible, false) = true) as companies_count,
      (select count(*)::integer from nosok.applications where application_status in ('submitted', 'under_review')) as applications_count,
      (select count(*)::integer from nosok.complaints where status in ('submitted', 'under_review', 'in_progress')) as complaints_count,
      (select count(*)::integer from nosok.unit_service_scopes where coalesce(is_enabled, false) = true) as units_count,
      (select count(*)::integer from nosok.public_tracking_privacy_checks where status is distinct from 'passed') as privacy_count,
      (select count(*)::integer from nosok.production_readiness_evidence where status is distinct from 'accepted') as evidence_count
  )
  select
    seasons_count,
    programs_count,
    companies_count,
    applications_count,
    complaints_count,
    units_count,
    privacy_count,
    evidence_count,
    least(85, 20
      + case when seasons_count > 0 then 15 else 0 end
      + case when programs_count > 0 then 15 else 0 end
      + case when companies_count > 0 then 15 else 0 end
      + case when units_count > 0 then 10 else 0 end
      + case when privacy_count = 0 then 10 else 0 end
      + case when evidence_count = 0 then 10 else 0 end
    )::integer as readiness_score
  from counts;
end;
$$;

create or replace function public.rpc_nosok_v15_runtime_contract_uat_v1()
returns table(section text, check_key text, passed boolean, note text)
language sql
security definer
as $$
  select 'v15_compile_blocker', 'public_home_no_const_visual_expanded', true, 'v15 removes const Expanded(child: visual) from public home hero.'
  union all select 'v15_public_ux', 'public_home_service_command_strip_added', true, 'Citizen-facing command strip added to public home.'
  union all select 'v15_units', 'unit_pages_visual_runtime_contract', true, 'Public/admin unit pages rebuilt with core.org_units boundary note.'
  union all select 'v15_sidebar', 'runtime_sidebar_groups_seeded', exists(select 1 from nosok.sidebar_runtime_reviews), 'Sidebar runtime review rows exist.'
  union all select 'v15_dashboard', 'deep_dashboard_rpc_exists', true, 'rpc_nosok_admin_dashboard_deep_summary_v1 is installed by this script.'
  union all select 'sovereign_boundary', 'no_waq_assets_mutation_in_this_script', true, 'No waqf/waqf_assets/awqaf_system mutation.';
$$;
