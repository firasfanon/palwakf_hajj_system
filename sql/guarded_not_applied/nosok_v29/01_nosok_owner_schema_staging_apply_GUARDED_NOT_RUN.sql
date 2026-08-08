-- Nosok v29 — Owner Schema Staging Apply (GUARDED NOT RUN)
-- This file is intentionally blocked by default.
-- Replace the placeholders only in a controlled staging session after explicit owner authorization.

-- REQUIRED OPERATOR STEPS BEFORE RUNNING:
-- 1) Confirm backup/snapshot.
-- 2) Record owner_authorization_id.
-- 3) Confirm this is STAGING only.
-- 4) Confirm no CREATE TABLE public.* and no writes to core/platform_access/billing_system/waqf/awqaf_system.

DO $$
BEGIN
  RAISE EXCEPTION 'NOSOK_V29_GUARDED_NOT_RUN: replace this blocker only after explicit owner_authorization_id and staging backup confirmation.';
END $$;

-- DRAFT BODY BELOW — DO NOT RUN UNTIL THE BLOCKER ABOVE IS REMOVED BY AUTHORIZED DBA/OPERATOR.

-- create schema if not exists nosok;

-- create table if not exists nosok.campaigns (
--   id uuid primary key default gen_random_uuid(),
--   campaign_code text not null unique,
--   title_ar text not null,
--   service_type text not null check (service_type in ('hajj','umrah','mixed')),
--   season_year int not null,
--   status text not null default 'draft' check (status in ('draft','published','closed','archived')),
--   unit_id uuid null,
--   application_open_at timestamptz null,
--   application_close_at timestamptz null,
--   metadata jsonb not null default '{}'::jsonb,
--   created_at timestamptz not null default now(),
--   updated_at timestamptz not null default now()
-- );
-- alter table nosok.campaigns enable row level security;

-- create table if not exists nosok.applications (
--   id uuid primary key default gen_random_uuid(),
--   campaign_id uuid not null references nosok.campaigns(id),
--   tracking_code text not null unique,
--   applicant_user_id uuid null,
--   applicant_national_id_hash text null,
--   applicant_display_name text null,
--   lgu_id uuid null,
--   governorate_id uuid null,
--   unit_id uuid null,
--   status text not null default 'draft',
--   eligibility_status text not null default 'pending',
--   submitted_at timestamptz null,
--   metadata jsonb not null default '{}'::jsonb,
--   created_at timestamptz not null default now(),
--   updated_at timestamptz not null default now()
-- );
-- alter table nosok.applications enable row level security;

-- create table if not exists nosok.application_documents (
--   id uuid primary key default gen_random_uuid(),
--   application_id uuid not null references nosok.applications(id) on delete cascade,
--   document_type text not null,
--   storage_bucket text not null,
--   storage_path text not null,
--   status text not null default 'uploaded',
--   reviewer_note text null,
--   metadata jsonb not null default '{}'::jsonb,
--   created_at timestamptz not null default now(),
--   updated_at timestamptz not null default now()
-- );
-- alter table nosok.application_documents enable row level security;

-- create table if not exists nosok.eligibility_rules (
--   id uuid primary key default gen_random_uuid(),
--   campaign_id uuid references nosok.campaigns(id),
--   rule_key text not null,
--   title_ar text not null,
--   rule_body jsonb not null default '{}'::jsonb,
--   is_published boolean not null default false,
--   created_at timestamptz not null default now(),
--   updated_at timestamptz not null default now(),
--   unique (campaign_id, rule_key)
-- );
-- alter table nosok.eligibility_rules enable row level security;

-- create table if not exists nosok.quota_rules (
--   id uuid primary key default gen_random_uuid(),
--   campaign_id uuid not null references nosok.campaigns(id),
--   rule_key text not null,
--   rule_body jsonb not null default '{}'::jsonb,
--   approval_status text not null default 'draft',
--   created_at timestamptz not null default now(),
--   updated_at timestamptz not null default now(),
--   unique (campaign_id, rule_key)
-- );
-- alter table nosok.quota_rules enable row level security;

-- create table if not exists nosok.lgu_quotas (
--   id uuid primary key default gen_random_uuid(),
--   campaign_id uuid not null references nosok.campaigns(id),
--   lgu_id uuid not null,
--   quota_count int not null check (quota_count >= 0),
--   calculation_basis jsonb not null default '{}'::jsonb,
--   approval_status text not null default 'draft',
--   created_at timestamptz not null default now(),
--   updated_at timestamptz not null default now(),
--   unique (campaign_id, lgu_id)
-- );
-- alter table nosok.lgu_quotas enable row level security;

-- create table if not exists nosok.workflow_events (
--   id uuid primary key default gen_random_uuid(),
--   application_id uuid references nosok.applications(id) on delete cascade,
--   event_key text not null,
--   from_status text null,
--   to_status text null,
--   actor_user_id uuid null,
--   actor_unit_id uuid null,
--   reason text null,
--   metadata jsonb not null default '{}'::jsonb,
--   created_at timestamptz not null default now()
-- );
-- alter table nosok.workflow_events enable row level security;

-- create table if not exists nosok.audit_events (
--   id uuid primary key default gen_random_uuid(),
--   event_key text not null,
--   actor_user_id uuid null,
--   actor_unit_id uuid null,
--   target_table text null,
--   target_id uuid null,
--   reason text null,
--   metadata jsonb not null default '{}'::jsonb,
--   created_at timestamptz not null default now()
-- );
-- alter table nosok.audit_events enable row level security;

-- NOTE: lottery_runs and lottery_entries are intentionally deferred until legal/algorithm approval.
