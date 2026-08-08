-- Nosok v38I — Standalone Real Supabase Development Schema Creation Pack
-- DEVELOPMENT/STAGING ONLY. Not production approval.
-- Apply only after reviewing 38_nosok_v38i_core_reference_shape_discovery_read_only.sql results.
-- This script creates nosok-owned objects and public RPC wrappers. It does not mutate core/platform/gis/waqf/awqaf_system.

begin;

create extension if not exists pgcrypto;
create schema if not exists nosok;

comment on schema nosok is 'Nosok operational schema. Owns Nosok data only. References core/platform/gis by read-only wrappers and snapshots, with no cross-schema mutation.';

create table if not exists nosok.homepage_sections (
  id uuid primary key default gen_random_uuid(),
  section_key text not null unique,
  title_ar text not null,
  subtitle_ar text,
  body_ar text,
  section_type text not null default 'content',
  icon_key text,
  route_path text,
  display_order integer not null default 100,
  status text not null default 'draft' check (status in ('draft','published','hidden','archived')),
  scope_key text not null default 'public',
  season_key text,
  unit_slug text,
  metadata jsonb not null default '{}'::jsonb,
  published_at timestamptz,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists nosok.page_registry (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  title_ar text not null,
  description_ar text,
  template_key text not null default 'public_content_page',
  route_path text not null unique,
  status text not null default 'draft' check (status in ('draft','published','hidden','archived')),
  requires_auth boolean not null default false,
  admin_permission_key text,
  metadata jsonb not null default '{}'::jsonb,
  published_at timestamptz,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists nosok.page_sections (
  id uuid primary key default gen_random_uuid(),
  page_id uuid not null references nosok.page_registry(id) on delete cascade,
  section_key text not null,
  title_ar text,
  body_ar text,
  section_type text not null default 'rich_text',
  display_order integer not null default 100,
  status text not null default 'draft' check (status in ('draft','published','hidden','archived')),
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(page_id, section_key)
);

create table if not exists nosok.registration_governance_windows (
  id uuid primary key default gen_random_uuid(),
  season_key text not null,
  window_key text not null,
  title_ar text not null,
  opens_at timestamptz,
  closes_at timestamptz,
  status text not null default 'planned' check (status in ('planned','open','closed','frozen','archived')),
  legal_basis_ar text,
  policy_metadata jsonb not null default '{}'::jsonb,
  created_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(season_key, window_key)
);

create table if not exists nosok.applications (
  id uuid primary key default gen_random_uuid(),
  season_key text not null,
  service_type text not null check (service_type in ('hajj','umrah')),
  tracking_token text not null unique default encode(gen_random_bytes(8), 'hex'),
  primary_applicant_name_ar text not null,
  national_id text,
  phone text,
  governorate_ref text,
  lgu_ref text,
  address_text text,
  total_people_count integer not null default 1 check (total_people_count between 1 and 3),
  application_status text not null default 'submitted',
  eligibility_status text not null default 'pending_validation',
  source_channel text not null default 'public_portal',
  metadata jsonb not null default '{}'::jsonb,
  submitted_at timestamptz not null default now(),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists nosok.applicants (
  id uuid primary key default gen_random_uuid(),
  application_id uuid not null references nosok.applications(id) on delete cascade,
  full_name_ar text not null,
  national_id text,
  birth_date date,
  gender text,
  person_role text not null default 'primary' check (person_role in ('primary','mahram','companion')),
  previous_hajj_flag boolean not null default false,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create table if not exists nosok.companies (
  id uuid primary key default gen_random_uuid(),
  company_name_ar text not null,
  license_no text,
  phone text,
  governorate_ref text,
  address_text text,
  qualification_status text not null default 'pending' check (qualification_status in ('pending','qualified','suspended','archived')),
  is_publicly_visible boolean not null default false,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists nosok.lottery_policies (
  id uuid primary key default gen_random_uuid(),
  season_key text not null unique,
  regulation_key text not null default 'hajj_regulation_15_2025',
  algorithm_policy_version text not null default 'legal_lottery_algorithm_v1',
  min_age integer not null default 16,
  max_companions integer not null default 2,
  policy_json jsonb not null default '{}'::jsonb,
  status text not null default 'draft' check (status in ('draft','approved','archived')),
  created_by uuid,
  approved_by uuid,
  approved_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists nosok.lgu_quota_snapshots (
  id uuid primary key default gen_random_uuid(),
  season_key text not null,
  governorate_ref text,
  lgu_ref text not null,
  lgu_name_ar text,
  population_snapshot integer,
  quota_value integer not null,
  quota_source text not null default 'ministry_policy',
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  unique(season_key, lgu_ref)
);

create table if not exists nosok.lottery_draw_runs (
  id uuid primary key default gen_random_uuid(),
  season_key text not null,
  run_key text not null unique,
  run_status text not null default 'draft' check (run_status in ('draft','simulation','executed','cancelled')),
  algorithm_policy_version text not null,
  audit_hash text,
  metadata jsonb not null default '{}'::jsonb,
  executed_by uuid,
  executed_at timestamptz,
  created_at timestamptz not null default now()
);

create table if not exists nosok.lottery_draw_results (
  id uuid primary key default gen_random_uuid(),
  draw_run_id uuid not null references nosok.lottery_draw_runs(id) on delete cascade,
  application_id uuid not null references nosok.applications(id) on delete cascade,
  lgu_ref text not null,
  result_status text not null check (result_status in ('selected','waiting_list','excluded','committee_decision_required')),
  waiting_rank integer,
  legal_branch_key text,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  unique(draw_run_id, application_id)
);

create table if not exists nosok.lottery_objections (
  id uuid primary key default gen_random_uuid(),
  application_id uuid references nosok.applications(id) on delete set null,
  tracking_token text,
  objection_type text not null default 'general',
  body_ar text not null,
  status text not null default 'submitted' check (status in ('submitted','under_review','approved','rejected','closed')),
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists nosok.audit_events (
  id uuid primary key default gen_random_uuid(),
  event_key text not null,
  entity_type text,
  entity_id uuid,
  actor_id uuid,
  actor_scope text,
  note_ar text,
  payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create index if not exists idx_nosok_homepage_sections_public on nosok.homepage_sections(status, display_order);
create index if not exists idx_nosok_applications_tracking on nosok.applications(tracking_token);
create index if not exists idx_nosok_applications_lgu on nosok.applications(season_key, lgu_ref);
create index if not exists idx_nosok_lottery_results_application on nosok.lottery_draw_results(application_id);

alter table nosok.homepage_sections enable row level security;
alter table nosok.page_registry enable row level security;
alter table nosok.page_sections enable row level security;
alter table nosok.registration_governance_windows enable row level security;
alter table nosok.applications enable row level security;
alter table nosok.applicants enable row level security;
alter table nosok.companies enable row level security;
alter table nosok.lottery_policies enable row level security;
alter table nosok.lgu_quota_snapshots enable row level security;
alter table nosok.lottery_draw_runs enable row level security;
alter table nosok.lottery_draw_results enable row level security;
alter table nosok.lottery_objections enable row level security;
alter table nosok.audit_events enable row level security;

-- Development policies: authenticated users may read admin tables in staging. Harden with PalWakf RBAC before production.
do $$
begin
  if not exists (select 1 from pg_policies where schemaname = 'nosok' and tablename = 'homepage_sections' and policyname = 'nosok_homepage_sections_public_select') then
    create policy nosok_homepage_sections_public_select on nosok.homepage_sections for select using (status = 'published' or auth.uid() is not null);
  end if;
  if not exists (select 1 from pg_policies where schemaname = 'nosok' and tablename = 'homepage_sections' and policyname = 'nosok_homepage_sections_auth_write') then
    create policy nosok_homepage_sections_auth_write on nosok.homepage_sections for all using (auth.uid() is not null) with check (auth.uid() is not null);
  end if;
  if not exists (select 1 from pg_policies where schemaname = 'nosok' and tablename = 'applications' and policyname = 'nosok_applications_auth_select_dev') then
    create policy nosok_applications_auth_select_dev on nosok.applications for select using (auth.uid() is not null);
  end if;
  if not exists (select 1 from pg_policies where schemaname = 'nosok' and tablename = 'applications' and policyname = 'nosok_applications_auth_write_dev') then
    create policy nosok_applications_auth_write_dev on nosok.applications for all using (auth.uid() is not null) with check (auth.uid() is not null);
  end if;
end $$;

create or replace function public.rpc_nosok_homepage_sections_public_v1(p_scope_key text default 'public', p_season_key text default null)
returns table(
  section_key text,
  title_ar text,
  subtitle_ar text,
  body_ar text,
  section_type text,
  icon_key text,
  route_path text,
  display_order integer,
  metadata jsonb
)
language sql
security definer
set search_path = public, nosok
as $$
  select section_key, title_ar, subtitle_ar, body_ar, section_type, icon_key, route_path, display_order, metadata
  from nosok.homepage_sections
  where status = 'published'
    and (p_scope_key is null or scope_key = p_scope_key)
    and (p_season_key is null or season_key is null or season_key = p_season_key)
  order by display_order, title_ar;
$$;

create or replace function public.rpc_nosok_admin_homepage_sections_list_v1()
returns setof nosok.homepage_sections
language sql
security definer
set search_path = public, nosok
as $$
  select * from nosok.homepage_sections order by display_order, created_at desc;
$$;

create or replace function public.rpc_nosok_admin_homepage_sections_upsert_v1(
  p_section_key text,
  p_title_ar text,
  p_subtitle_ar text default null,
  p_body_ar text default null,
  p_section_type text default 'content',
  p_icon_key text default null,
  p_route_path text default null,
  p_display_order integer default 100,
  p_status text default 'draft',
  p_scope_key text default 'public',
  p_season_key text default null,
  p_metadata jsonb default '{}'::jsonb
)
returns nosok.homepage_sections
language plpgsql
security definer
set search_path = public, nosok
as $$
declare
  v_row nosok.homepage_sections;
begin
  if auth.uid() is null then
    raise exception 'Authentication required';
  end if;

  insert into nosok.homepage_sections(
    section_key, title_ar, subtitle_ar, body_ar, section_type, icon_key, route_path,
    display_order, status, scope_key, season_key, metadata, updated_by, published_at
  ) values (
    p_section_key, p_title_ar, p_subtitle_ar, p_body_ar, p_section_type, p_icon_key, p_route_path,
    p_display_order, p_status, p_scope_key, p_season_key, coalesce(p_metadata, '{}'::jsonb), auth.uid(),
    case when p_status = 'published' then now() else null end
  )
  on conflict (section_key) do update set
    title_ar = excluded.title_ar,
    subtitle_ar = excluded.subtitle_ar,
    body_ar = excluded.body_ar,
    section_type = excluded.section_type,
    icon_key = excluded.icon_key,
    route_path = excluded.route_path,
    display_order = excluded.display_order,
    status = excluded.status,
    scope_key = excluded.scope_key,
    season_key = excluded.season_key,
    metadata = excluded.metadata,
    updated_by = auth.uid(),
    updated_at = now(),
    published_at = case when excluded.status = 'published' then coalesce(nosok.homepage_sections.published_at, now()) else nosok.homepage_sections.published_at end
  returning * into v_row;

  insert into nosok.audit_events(event_key, entity_type, entity_id, actor_id, note_ar, payload)
  values ('homepage_section_upserted', 'homepage_section', v_row.id, auth.uid(), 'تعديل قسم صفحة رئيسية في بيئة تطوير نسك', jsonb_build_object('section_key', p_section_key, 'status', p_status));

  return v_row;
end;
$$;

create or replace function public.rpc_nosok_public_application_submit_v1(
  p_season_key text,
  p_service_type text,
  p_primary_applicant_name_ar text,
  p_national_id text default null,
  p_phone text default null,
  p_governorate_ref text default null,
  p_lgu_ref text default null,
  p_address_text text default null,
  p_total_people_count integer default 1,
  p_metadata jsonb default '{}'::jsonb
)
returns table(application_id uuid, tracking_token text, application_status text)
language plpgsql
security definer
set search_path = public, nosok
as $$
declare
  v_id uuid;
  v_token text;
begin
  insert into nosok.applications(
    season_key, service_type, primary_applicant_name_ar, national_id, phone,
    governorate_ref, lgu_ref, address_text, total_people_count, metadata
  ) values (
    p_season_key, p_service_type, p_primary_applicant_name_ar, p_national_id, p_phone,
    p_governorate_ref, p_lgu_ref, p_address_text, greatest(1, least(coalesce(p_total_people_count, 1), 3)), coalesce(p_metadata, '{}'::jsonb)
  ) returning id, tracking_token into v_id, v_token;

  return query select v_id, v_token, 'submitted'::text;
end;
$$;

create or replace function public.rpc_nosok_public_application_track_v1(p_tracking_token text)
returns table(
  tracking_token text,
  season_key text,
  service_type text,
  application_status text,
  eligibility_status text,
  submitted_at timestamptz
)
language sql
security definer
set search_path = public, nosok
as $$
  select a.tracking_token, a.season_key, a.service_type, a.application_status, a.eligibility_status, a.submitted_at
  from nosok.applications a
  where a.tracking_token = p_tracking_token
  limit 1;
$$;

-- These core wrappers are intentionally placeholders until shape discovery identifies exact core object names.
-- Replace their bodies after reviewing 38_nosok_v38i_core_reference_shape_discovery_read_only.sql.
create or replace function public.rpc_nosok_core_governorates_lookup_v1()
returns table(reference_key text, name_ar text, metadata jsonb)
language sql
security definer
set search_path = public, core
as $$
  select null::text as reference_key, null::text as name_ar, jsonb_build_object('status','shape_discovery_required') as metadata
  where false;
$$;

create or replace function public.rpc_nosok_core_lgus_lookup_v1(p_governorate_ref text default null)
returns table(reference_key text, name_ar text, governorate_ref text, metadata jsonb)
language sql
security definer
set search_path = public, core
as $$
  select null::text as reference_key, null::text as name_ar, null::text as governorate_ref, jsonb_build_object('status','shape_discovery_required') as metadata
  where false;
$$;

insert into nosok.homepage_sections(section_key, title_ar, subtitle_ar, section_type, route_path, display_order, status, metadata)
values
  ('hero', 'خدمات نسك للحج والعمرة', 'قدّم طلبك، تابع حالته، واستكمل متطلبات الحج والعمرة من مكان واحد.', 'hero', '/services/nosok/apply', 10, 'published', '{"seed":"v38I"}'::jsonb),
  ('primary_actions', 'الخدمات الأساسية', 'تقديم طلب، متابعة طلب، نتائج القرعة، وقائمة الانتظار.', 'service_cards', '/services/nosok', 20, 'published', '{"seed":"v38I"}'::jsonb),
  ('legal_transparency', 'شفافية وعدالة', 'التسجيل والقرعة يخضعان للعنوان المعتمد والسياسة القانونية المعتمدة.', 'trust', '/services/nosok/legal-regulation', 80, 'published', '{"seed":"v38I"}'::jsonb)
on conflict (section_key) do nothing;

notify pgrst, 'reload schema';

commit;
