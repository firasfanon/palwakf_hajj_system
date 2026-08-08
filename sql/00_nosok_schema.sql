begin;

create schema if not exists nosok;

create extension if not exists pgcrypto;

-- =========================================================
-- ENUM-LIKE CHECKS عبر text + check لتقليل تعقيد الهجرة
-- =========================================================

create table if not exists nosok.seasons (
  id uuid primary key default gen_random_uuid(),
  season_code text not null unique,
  title_ar text not null,
  title_en text,
  service_type text not null check (service_type in ('hajj', 'umrah', 'mixed')),
  hijri_year integer,
  gregorian_year integer,
  registration_start_at timestamptz,
  registration_end_at timestamptz,
  status text not null default 'draft' check (status in ('draft', 'open', 'closed', 'archived')),
  notes text,
  is_publicly_visible boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid,
  updated_by uuid
);

create index if not exists idx_nosok_seasons_status on nosok.seasons(status);
create index if not exists idx_nosok_seasons_visible on nosok.seasons(is_publicly_visible);

create table if not exists nosok.service_programs (
  id uuid primary key default gen_random_uuid(),
  season_id uuid not null references nosok.seasons(id) on delete cascade,
  code text not null,
  title_ar text not null,
  title_en text,
  service_type text not null check (service_type in ('hajj', 'umrah')),
  description text,
  registration_start_at timestamptz,
  registration_end_at timestamptz,
  max_companions integer not null default 0,
  notes text,
  status text not null default 'draft' check (status in ('draft', 'active', 'inactive', 'archived')),
  is_publicly_visible boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (season_id, code)
);

create table if not exists nosok.qualified_companies (
  id uuid primary key default gen_random_uuid(),
  company_name_ar text not null,
  company_name_en text,
  license_no text,
  phone text,
  mobile text,
  email text,
  address_text text,
  governorate_id uuid,
  unit_id uuid,
  status text not null default 'draft' check (status in ('draft', 'qualified', 'suspended', 'inactive')),
  is_publicly_visible boolean not null default false,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid,
  updated_by uuid
);

create index if not exists idx_nosok_companies_status on nosok.qualified_companies(status);
create index if not exists idx_nosok_companies_visible on nosok.qualified_companies(is_publicly_visible);

create table if not exists nosok.company_season_qualifications (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references nosok.qualified_companies(id) on delete cascade,
  season_id uuid not null references nosok.seasons(id) on delete cascade,
  qualification_status text not null default 'draft'
    check (qualification_status in ('draft', 'qualified', 'suspended', 'withdrawn')),
  qualification_notes text,
  starts_at timestamptz,
  ends_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (company_id, season_id)
);

create sequence if not exists nosok.application_no_seq start with 1000 increment by 1;

create or replace function nosok.generate_application_no()
returns text
language plpgsql
as $$
begin
  return 'NSK-' || to_char(now(), 'YYYY') || '-' || lpad(nextval('nosok.application_no_seq')::text, 6, '0');
end;
$$;

create or replace function nosok.generate_tracking_token()
returns text
language plpgsql
as $$
declare
  v_token text;
begin
  loop
    v_token := 'NSK-TRK-' || upper(encode(gen_random_bytes(6), 'hex'));
    exit when not exists (
      select 1
      from nosok.applications
      where tracking_token = v_token
    );
  end loop;
  return v_token;
end;
$$;

create table if not exists nosok.applications (
  id uuid primary key default gen_random_uuid(),
  season_id uuid references nosok.seasons(id) on delete set null,
  program_id uuid references nosok.service_programs(id) on delete set null,
  application_no text not null default nosok.generate_application_no() unique,
  tracking_token text not null default nosok.generate_tracking_token() unique,
  tracking_token_issued_at timestamptz not null default now(),
  service_type text not null check (service_type in ('hajj', 'umrah')),
  applicant_full_name text not null,
  national_id text not null,
  birth_date date,
  gender text check (gender in ('male', 'female')),
  phone text,
  mobile text,
  email text,
  governorate_id uuid,
  community_id uuid,
  address_text text,
  marital_status text,
  application_status text not null default 'draft'
    check (application_status in ('draft', 'submitted', 'under_review', 'accepted', 'rejected', 'waitlist', 'closed')),
  eligibility_status text not null default 'pending'
    check (eligibility_status in ('pending', 'eligible', 'ineligible', 'needs_review')),
  submitted_at timestamptz,
  reviewed_at timestamptz,
  reviewed_by uuid,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_nosok_applications_no on nosok.applications(application_no);
create unique index if not exists idx_nosok_applications_tracking_token on nosok.applications(tracking_token);
create index if not exists idx_nosok_applications_nid on nosok.applications(national_id);
create index if not exists idx_nosok_applications_status on nosok.applications(application_status);

create table if not exists nosok.application_companions (
  id uuid primary key default gen_random_uuid(),
  application_id uuid not null references nosok.applications(id) on delete cascade,
  full_name text not null,
  national_id text,
  relation_type text,
  birth_date date,
  phone text,
  notes text,
  created_at timestamptz not null default now()
);

create table if not exists nosok.application_documents (
  id uuid primary key default gen_random_uuid(),
  application_id uuid not null references nosok.applications(id) on delete cascade,
  document_type text not null,
  file_url text,
  review_status text not null default 'pending'
    check (review_status in ('pending', 'approved', 'rejected')),
  review_notes text,
  uploaded_at timestamptz not null default now(),
  reviewed_at timestamptz
);

create table if not exists nosok.application_payments (
  id uuid primary key default gen_random_uuid(),
  application_id uuid not null references nosok.applications(id) on delete cascade,
  payment_type text not null,
  amount numeric(12,2) not null default 0,
  currency_code text not null default 'ILS',
  payment_reference text,
  paid_at timestamptz,
  payment_status text not null default 'pending'
    check (payment_status in ('pending', 'paid', 'failed', 'refunded', 'cancelled')),
  notes text,
  created_at timestamptz not null default now()
);

create table if not exists nosok.application_reviews (
  id uuid primary key default gen_random_uuid(),
  application_id uuid not null references nosok.applications(id) on delete cascade,
  reviewer_user_id uuid,
  review_action text not null
    check (review_action in ('submit', 'approve', 'reject', 'return_for_edit', 'mark_needs_review')),
  review_reason text,
  created_at timestamptz not null default now()
);

create table if not exists nosok.draw_batches (
  id uuid primary key default gen_random_uuid(),
  season_id uuid not null references nosok.seasons(id) on delete cascade,
  batch_code text not null unique,
  title_ar text not null,
  status text not null default 'draft'
    check (status in ('draft', 'prepared', 'executed', 'published', 'cancelled')),
  notes text,
  executed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists nosok.draw_results (
  id uuid primary key default gen_random_uuid(),
  batch_id uuid not null references nosok.draw_batches(id) on delete cascade,
  application_id uuid not null references nosok.applications(id) on delete cascade,
  result_status text not null
    check (result_status in ('accepted', 'waitlist', 'rejected')),
  result_rank integer,
  notes text,
  created_at timestamptz not null default now(),
  unique (batch_id, application_id)
);

create table if not exists nosok.complaints (
  id uuid primary key default gen_random_uuid(),
  complaint_no text not null unique,
  related_application_id uuid references nosok.applications(id) on delete set null,
  related_company_id uuid references nosok.qualified_companies(id) on delete set null,
  category text not null,
  subject text not null,
  description text not null,
  complainant_name text not null,
  phone text,
  email text,
  governorate_id uuid,
  status text not null default 'submitted'
    check (status in ('submitted', 'under_review', 'in_progress', 'resolved', 'closed', 'rejected')),
  priority text not null default 'normal'
    check (priority in ('low', 'normal', 'high', 'urgent')),
  assigned_to uuid,
  submitted_at timestamptz not null default now(),
  closed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_nosok_complaints_no on nosok.complaints(complaint_no);
create index if not exists idx_nosok_complaints_status on nosok.complaints(status);

create table if not exists nosok.complaint_actions (
  id uuid primary key default gen_random_uuid(),
  complaint_id uuid not null references nosok.complaints(id) on delete cascade,
  action_type text not null,
  action_notes text,
  acted_by uuid,
  created_at timestamptz not null default now()
);

create table if not exists nosok.system_announcements (
  id uuid primary key default gen_random_uuid(),
  slug text unique,
  title_ar text not null,
  title_en text,
  body_ar text not null,
  body_en text,
  season_id uuid references nosok.seasons(id) on delete set null,
  is_published boolean not null default false,
  publish_at timestamptz,
  unpublish_at timestamptz,
  display_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid,
  updated_by uuid
);

create table if not exists nosok.faq_items (
  id uuid primary key default gen_random_uuid(),
  category text,
  question_ar text not null,
  question_en text,
  answer_ar text not null,
  answer_en text,
  display_order integer not null default 0,
  is_published boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists nosok.static_content_blocks (
  id uuid primary key default gen_random_uuid(),
  block_key text not null unique,
  title_ar text not null,
  title_en text,
  body_ar text not null,
  body_en text,
  display_order integer not null default 0,
  is_published boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- =========================================================
-- updated_at trigger
-- =========================================================
create or replace function nosok.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists trg_nosok_seasons_updated_at on nosok.seasons;
create trigger trg_nosok_seasons_updated_at
before update on nosok.seasons
for each row execute function nosok.set_updated_at();

drop trigger if exists trg_nosok_service_programs_updated_at on nosok.service_programs;
create trigger trg_nosok_service_programs_updated_at
before update on nosok.service_programs
for each row execute function nosok.set_updated_at();

drop trigger if exists trg_nosok_qualified_companies_updated_at on nosok.qualified_companies;
create trigger trg_nosok_qualified_companies_updated_at
before update on nosok.qualified_companies
for each row execute function nosok.set_updated_at();

drop trigger if exists trg_nosok_company_season_qualifications_updated_at on nosok.company_season_qualifications;
create trigger trg_nosok_company_season_qualifications_updated_at
before update on nosok.company_season_qualifications
for each row execute function nosok.set_updated_at();

drop trigger if exists trg_nosok_applications_updated_at on nosok.applications;
create trigger trg_nosok_applications_updated_at
before update on nosok.applications
for each row execute function nosok.set_updated_at();

drop trigger if exists trg_nosok_draw_batches_updated_at on nosok.draw_batches;
create trigger trg_nosok_draw_batches_updated_at
before update on nosok.draw_batches
for each row execute function nosok.set_updated_at();

drop trigger if exists trg_nosok_complaints_updated_at on nosok.complaints;
create trigger trg_nosok_complaints_updated_at
before update on nosok.complaints
for each row execute function nosok.set_updated_at();

drop trigger if exists trg_nosok_system_announcements_updated_at on nosok.system_announcements;
create trigger trg_nosok_system_announcements_updated_at
before update on nosok.system_announcements
for each row execute function nosok.set_updated_at();

drop trigger if exists trg_nosok_faq_items_updated_at on nosok.faq_items;
create trigger trg_nosok_faq_items_updated_at
before update on nosok.faq_items
for each row execute function nosok.set_updated_at();

drop trigger if exists trg_nosok_static_content_blocks_updated_at on nosok.static_content_blocks;
create trigger trg_nosok_static_content_blocks_updated_at
before update on nosok.static_content_blocks
for each row execute function nosok.set_updated_at();

-- =========================================================
-- Views for public reading baseline
-- =========================================================
create or replace view nosok.v_public_seasons as
select
  id,
  season_code,
  title_ar,
  title_en,
  service_type,
  hijri_year,
  gregorian_year,
  registration_start_at,
  registration_end_at,
  status,
  notes
from nosok.seasons
where is_publicly_visible = true
  and status in ('open', 'closed');

create or replace view nosok.v_public_companies as
select
  q.id,
  q.company_name_ar,
  q.company_name_en,
  q.license_no,
  q.phone,
  q.mobile,
  q.email,
  q.address_text,
  q.governorate_id,
  q.status,
  q.notes
from nosok.qualified_companies q
where q.is_publicly_visible = true
  and q.status = 'qualified';

-- =========================================================
-- RLS baseline
-- ملاحظة:
-- السياسات النهائية يجب ربطها بوظائف RBAC الفعلية في المنصة.
-- تمكين RLS الآن لعدم ترك الجداول بلا حماية.
-- =========================================================
alter table nosok.seasons enable row level security;
alter table nosok.service_programs enable row level security;
alter table nosok.qualified_companies enable row level security;
alter table nosok.company_season_qualifications enable row level security;
alter table nosok.applications enable row level security;
alter table nosok.application_companions enable row level security;
alter table nosok.application_documents enable row level security;
alter table nosok.application_payments enable row level security;
alter table nosok.application_reviews enable row level security;
alter table nosok.draw_batches enable row level security;
alter table nosok.draw_results enable row level security;
alter table nosok.complaints enable row level security;
alter table nosok.complaint_actions enable row level security;
alter table nosok.system_announcements enable row level security;
alter table nosok.faq_items enable row level security;
alter table nosok.static_content_blocks enable row level security;

-- قراءة عامة للمواد المنشورة فقط
drop policy if exists nosok_public_read_seasons on nosok.seasons;
create policy nosok_public_read_seasons on nosok.seasons
for select
using (is_publicly_visible = true and status in ('open', 'closed'));

drop policy if exists nosok_public_read_companies on nosok.qualified_companies;
create policy nosok_public_read_companies on nosok.qualified_companies
for select
using (is_publicly_visible = true and status = 'qualified');

drop policy if exists nosok_public_read_announcements on nosok.system_announcements;
create policy nosok_public_read_announcements on nosok.system_announcements
for select
using (is_published = true);

drop policy if exists nosok_public_read_faq on nosok.faq_items;
create policy nosok_public_read_faq on nosok.faq_items
for select
using (is_published = true);

drop policy if exists nosok_public_read_static_blocks on nosok.static_content_blocks;
create policy nosok_public_read_static_blocks on nosok.static_content_blocks
for select
using (is_published = true);

-- TODO:
-- أضف هنا سياسات الإدارة النهائية عبر دوال المنصة مثل:
-- public.has_platform_permission('nosok.manageSeasons')
-- أو wrapper سيادي مع admin_users حسب العقد الحاكم.

commit;


-- =========================================================
-- v07 extension: seasonal qualifications visibility + documents/payments enrichment
-- =========================================================
alter table nosok.company_season_qualifications
  add column if not exists is_publicly_visible boolean not null default false,
  add column if not exists approved_at timestamptz,
  add column if not exists approved_by uuid;

alter table nosok.application_documents
  add column if not exists document_title text,
  add column if not exists original_file_name text,
  add column if not exists storage_bucket text,
  add column if not exists storage_path text,
  add column if not exists mime_type text,
  add column if not exists file_size_bytes bigint,
  add column if not exists uploaded_by uuid,
  add column if not exists notes text;

alter table nosok.application_payments
  add column if not exists payment_method text,
  add column if not exists provider_name text,
  add column if not exists external_transaction_id text,
  add column if not exists receipt_url text,
  add column if not exists verified_at timestamptz,
  add column if not exists verified_by uuid;

create index if not exists idx_nosok_company_qualifications_company on nosok.company_season_qualifications(company_id);
create index if not exists idx_nosok_company_qualifications_season on nosok.company_season_qualifications(season_id);
create index if not exists idx_nosok_company_qualifications_visible on nosok.company_season_qualifications(is_publicly_visible);
create index if not exists idx_nosok_application_documents_application on nosok.application_documents(application_id);
create index if not exists idx_nosok_application_payments_application on nosok.application_payments(application_id);


-- =========================================================
-- v08 final alignment for direct full-schema use
-- =========================================================

alter table if exists nosok.application_payments
  add column if not exists verification_status text not null default 'pending',
  add column if not exists verification_notes text,
  add column if not exists receipt_storage_bucket text,
  add column if not exists receipt_storage_path text,
  add column if not exists receipt_original_file_name text,
  add column if not exists receipt_mime_type text,
  add column if not exists receipt_file_size_bytes bigint;

alter table if exists nosok.application_payments
  drop constraint if exists application_payments_verification_status_check;
alter table if exists nosok.application_payments
  add constraint application_payments_verification_status_check
  check (verification_status in ('pending','under_review','verified','rejected','needs_receipt'));

alter table if exists nosok.application_reviews
  drop constraint if exists application_reviews_review_action_check;
alter table if exists nosok.application_reviews
  add constraint application_reviews_review_action_check
  check (review_action in (
    'submit',
    'approve',
    'reject',
    'return_for_edit',
    'mark_needs_review',
    'status_update',
    'verify_payment',
    'reject_payment',
    'approve_document',
    'reject_document'
  ));

create index if not exists idx_nosok_application_payments_verification_status on nosok.application_payments(verification_status);
create index if not exists idx_nosok_application_reviews_application on nosok.application_reviews(application_id);
