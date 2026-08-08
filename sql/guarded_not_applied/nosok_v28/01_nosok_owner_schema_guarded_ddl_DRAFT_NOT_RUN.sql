-- Nosok v28 — Guarded DDL Draft Pack
-- STATUS: DRAFT_NOT_RUN / GUARDED_NOT_APPLIED
-- This draft must NOT be executed until an explicit owner authorization is issued.
-- Default guard intentionally aborts before any DDL.

DO $$
BEGIN
  RAISE EXCEPTION 'DRAFT_NOT_RUN: Nosok v28 owner schema DDL requires explicit owner authorization and approved RLS/RPC/UAT/rollback matrices before execution.';
END $$;

-- DRAFT ONLY BELOW THIS LINE. Do not remove the guard without written authorization.

BEGIN;

CREATE SCHEMA IF NOT EXISTS nosok;

CREATE TABLE IF NOT EXISTS nosok.campaigns (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  campaign_code text NOT NULL UNIQUE,
  campaign_type text NOT NULL CHECK (campaign_type IN ('hajj', 'umrah')),
  title_ar text NOT NULL,
  status text NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'closed', 'archived')),
  unit_id uuid NULL,
  opens_at timestamptz NULL,
  closes_at timestamptz NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS nosok.applications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  campaign_id uuid NOT NULL REFERENCES nosok.campaigns(id),
  tracking_code text NOT NULL UNIQUE,
  applicant_user_id uuid NULL,
  lgu_id uuid NULL,
  governorate_id uuid NULL,
  applicant_name_snapshot text NULL,
  national_id_hash text NULL,
  status text NOT NULL DEFAULT 'draft',
  submitted_at timestamptz NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS nosok.application_documents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  application_id uuid NOT NULL REFERENCES nosok.applications(id) ON DELETE CASCADE,
  document_type text NOT NULL,
  storage_bucket text NOT NULL,
  storage_path text NOT NULL,
  file_name text NULL,
  mime_type text NULL,
  verification_status text NOT NULL DEFAULT 'pending',
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS nosok.eligibility_rules (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  rule_key text NOT NULL UNIQUE,
  title_ar text NOT NULL,
  rule_body jsonb NOT NULL DEFAULT '{}'::jsonb,
  is_published boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS nosok.quota_rules (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  campaign_id uuid NOT NULL REFERENCES nosok.campaigns(id) ON DELETE CASCADE,
  rule_key text NOT NULL,
  ratio_payload jsonb NOT NULL DEFAULT '{}'::jsonb,
  approval_status text NOT NULL DEFAULT 'draft',
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS nosok.lgu_quotas (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  campaign_id uuid NOT NULL REFERENCES nosok.campaigns(id) ON DELETE CASCADE,
  lgu_id uuid NOT NULL,
  seats integer NOT NULL CHECK (seats >= 0),
  approval_status text NOT NULL DEFAULT 'draft',
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (campaign_id, lgu_id)
);

CREATE TABLE IF NOT EXISTS nosok.workflow_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  application_id uuid NOT NULL REFERENCES nosok.applications(id) ON DELETE CASCADE,
  event_key text NOT NULL,
  from_status text NULL,
  to_status text NULL,
  actor_user_id uuid NULL,
  actor_unit_id uuid NULL,
  reason text NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS nosok.audit_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  event_key text NOT NULL,
  actor_user_id uuid NULL,
  actor_unit_id uuid NULL,
  target_table text NULL,
  target_id uuid NULL,
  payload jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE nosok.campaigns ENABLE ROW LEVEL SECURITY;
ALTER TABLE nosok.applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE nosok.application_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE nosok.eligibility_rules ENABLE ROW LEVEL SECURITY;
ALTER TABLE nosok.quota_rules ENABLE ROW LEVEL SECURITY;
ALTER TABLE nosok.lgu_quotas ENABLE ROW LEVEL SECURITY;
ALTER TABLE nosok.workflow_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE nosok.audit_events ENABLE ROW LEVEL SECURITY;

ROLLBACK;
