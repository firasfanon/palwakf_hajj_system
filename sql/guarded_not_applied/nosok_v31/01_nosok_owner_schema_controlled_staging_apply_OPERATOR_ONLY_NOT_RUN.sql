-- Nosok v31 — Controlled Staging DDL Apply
-- STATUS: OPERATOR_ONLY_NOT_RUN / FAIL-CLOSED BY DEFAULT
-- This script is a guarded template. It must not be executed as-is.

-- REQUIRED VALUES TO BE SET BY DBA/OPERATOR BEFORE REMOVING THE FAIL-CLOSED GUARD:
-- owner_authorization_id: CHAT_AUTHORIZATION_NOSOK_V31_2026_06_04_PENDING_OPERATOR_BINDING
-- staging_target: explicit non-production database identifier
-- backup_reference: external backup/snapshot/restore point reference
-- operator_identity: DBA/operator account executing the script

DO $$
BEGIN
  RAISE EXCEPTION 'NOSOK_V31_OPERATOR_ONLY_NOT_RUN: bind owner_authorization_id, staging target, backup_reference, and remove this guard only in an approved staging session.';
END $$;

-- CONTROLLED DDL BODY BELOW. DO NOT RUN UNTIL THE GUARD ABOVE IS REMOVED BY AN AUTHORIZED DBA/OPERATOR.
-- The DDL remains restricted to nosok.* owner schema only.

BEGIN;

CREATE SCHEMA IF NOT EXISTS nosok;

CREATE TABLE IF NOT EXISTS nosok.campaigns (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  campaign_code text NOT NULL UNIQUE,
  title_ar text NOT NULL,
  service_type text NOT NULL CHECK (service_type IN ('hajj','umrah','mixed')),
  season_year integer NOT NULL,
  status text NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','published','closed','archived')),
  unit_id uuid NULL,
  application_open_at timestamptz NULL,
  application_close_at timestamptz NULL,
  metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS nosok.applications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  campaign_id uuid NOT NULL REFERENCES nosok.campaigns(id),
  tracking_code text NOT NULL UNIQUE,
  applicant_user_id uuid NULL,
  applicant_national_id_hash text NULL,
  applicant_display_name text NULL,
  lgu_id uuid NULL,
  governorate_id uuid NULL,
  unit_id uuid NULL,
  status text NOT NULL DEFAULT 'draft',
  eligibility_status text NOT NULL DEFAULT 'pending',
  submitted_at timestamptz NULL,
  metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS nosok.application_documents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  application_id uuid NOT NULL REFERENCES nosok.applications(id) ON DELETE CASCADE,
  document_type text NOT NULL,
  storage_bucket text NOT NULL,
  storage_path text NOT NULL,
  status text NOT NULL DEFAULT 'uploaded',
  reviewer_note text NULL,
  metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS nosok.eligibility_rules (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  campaign_id uuid REFERENCES nosok.campaigns(id),
  rule_key text NOT NULL,
  title_ar text NOT NULL,
  rule_body jsonb NOT NULL DEFAULT '{}'::jsonb,
  is_published boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (campaign_id, rule_key)
);

CREATE TABLE IF NOT EXISTS nosok.quota_rules (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  campaign_id uuid NOT NULL REFERENCES nosok.campaigns(id),
  rule_key text NOT NULL,
  rule_body jsonb NOT NULL DEFAULT '{}'::jsonb,
  approval_status text NOT NULL DEFAULT 'draft',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (campaign_id, rule_key)
);

CREATE TABLE IF NOT EXISTS nosok.lgu_quotas (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  campaign_id uuid NOT NULL REFERENCES nosok.campaigns(id),
  lgu_id uuid NOT NULL,
  quota_count integer NOT NULL CHECK (quota_count >= 0),
  calculation_basis jsonb NOT NULL DEFAULT '{}'::jsonb,
  approval_status text NOT NULL DEFAULT 'draft',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (campaign_id, lgu_id)
);

CREATE TABLE IF NOT EXISTS nosok.workflow_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  application_id uuid REFERENCES nosok.applications(id) ON DELETE CASCADE,
  event_key text NOT NULL,
  from_status text NULL,
  to_status text NULL,
  actor_user_id uuid NULL,
  actor_unit_id uuid NULL,
  reason text NULL,
  metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS nosok.audit_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  event_key text NOT NULL,
  actor_user_id uuid NULL,
  actor_unit_id uuid NULL,
  target_table text NULL,
  target_id uuid NULL,
  reason text NULL,
  metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
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

-- Baseline restrictive policies. Full role-specific policies/RPCs require separate post-apply review.
CREATE POLICY nosok_campaigns_no_anonymous_write_v31 ON nosok.campaigns FOR ALL TO anon USING (false) WITH CHECK (false);
CREATE POLICY nosok_applications_no_anonymous_direct_access_v31 ON nosok.applications FOR ALL TO anon USING (false) WITH CHECK (false);
CREATE POLICY nosok_documents_no_anonymous_direct_access_v31 ON nosok.application_documents FOR ALL TO anon USING (false) WITH CHECK (false);
CREATE POLICY nosok_eligibility_rules_no_anonymous_write_v31 ON nosok.eligibility_rules FOR ALL TO anon USING (false) WITH CHECK (false);
CREATE POLICY nosok_quota_rules_no_anonymous_write_v31 ON nosok.quota_rules FOR ALL TO anon USING (false) WITH CHECK (false);
CREATE POLICY nosok_lgu_quotas_no_anonymous_write_v31 ON nosok.lgu_quotas FOR ALL TO anon USING (false) WITH CHECK (false);
CREATE POLICY nosok_workflow_events_no_anonymous_access_v31 ON nosok.workflow_events FOR ALL TO anon USING (false) WITH CHECK (false);
CREATE POLICY nosok_audit_events_no_anonymous_access_v31 ON nosok.audit_events FOR ALL TO anon USING (false) WITH CHECK (false);

-- Lottery tables intentionally deferred until legal/algorithm/audit approval.
-- Public wrappers intentionally not created in this staging DDL pack.

COMMIT;
