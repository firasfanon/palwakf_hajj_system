
-- Nosok v38E — Hajj Regulation 15/2025 Legal Lottery Contract
-- Purpose: design-only draft for future nosok schema after PalWakf hosting.
-- This file MUST NOT be executed as production SQL in the standalone Nosok track.
-- It is intentionally wrapped in BEGIN/ROLLBACK.

BEGIN;

-- Future legal regulation version registry.
CREATE TABLE IF NOT EXISTS nosok.legal_regulation_versions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  regulation_key text NOT NULL UNIQUE,
  title_ar text NOT NULL,
  regulation_number text NOT NULL,
  regulation_year text NOT NULL,
  source_name_ar text NOT NULL,
  publication_reference_ar text NOT NULL,
  effective_scope_ar text NOT NULL,
  is_active boolean NOT NULL DEFAULT false,
  source_url text,
  notes_ar text,
  created_at timestamptz NOT NULL DEFAULT now()
);

-- Future registration policy version linked to the regulation and season.
CREATE TABLE IF NOT EXISTS nosok.registration_policy_versions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  season_key text NOT NULL,
  regulation_key text NOT NULL,
  min_age integer NOT NULL DEFAULT 16,
  max_companions integer NOT NULL DEFAULT 2,
  one_application_only boolean NOT NULL DEFAULT true,
  first_application_wins_on_duplicate boolean NOT NULL DEFAULT true,
  previous_hajj_exclusion boolean NOT NULL DEFAULT true,
  previous_hajj_exception_mahram boolean NOT NULL DEFAULT true,
  identity_address_lgu_required boolean NOT NULL DEFAULT true,
  residence_proof_allowed_when_address_differs boolean NOT NULL DEFAULT true,
  payment_required_before_acceptance boolean NOT NULL DEFAULT false,
  mutable_by_ministry_policy boolean NOT NULL DEFAULT true,
  status text NOT NULL DEFAULT 'draft',
  notes_ar text,
  created_at timestamptz NOT NULL DEFAULT now()
);

-- Future legal algorithm branches, ordered and auditable.
CREATE TABLE IF NOT EXISTS nosok.lottery_algorithm_rules (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  regulation_key text NOT NULL,
  season_key text NOT NULL,
  rule_key text NOT NULL,
  rule_order integer NOT NULL,
  title_ar text NOT NULL,
  rule_ar text NOT NULL,
  branch_condition text NOT NULL,
  runtime_guard text NOT NULL,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (season_key, rule_key)
);

-- Future simulation event log before live draw.
CREATE TABLE IF NOT EXISTS nosok.lottery_draw_simulation_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  simulation_run_id uuid NOT NULL,
  season_key text NOT NULL,
  lgu_key text,
  rule_key text NOT NULL,
  application_ref text,
  total_people_count integer,
  remaining_quota_before integer,
  remaining_quota_after integer,
  decision_key text NOT NULL,
  reason_ar text NOT NULL,
  payload jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS nosok.legal_compliance_audit_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  event_key text NOT NULL,
  actor_user_id uuid,
  season_key text,
  regulation_key text,
  affected_object text,
  decision_ar text NOT NULL,
  evidence_ref text,
  created_at timestamptz NOT NULL DEFAULT now()
);

-- Future RPC signatures only; implementation deferred.
-- nosok.rpc_legal_regulation_active_v1()
-- nosok.rpc_registration_policy_validate_v1(application_payload jsonb)
-- nosok.rpc_lottery_algorithm_simulate_v1(season_key text, lgu_key text)
-- nosok.rpc_lottery_draw_execute_v1(season_key text, lgu_key text, operator_reason text)

ROLLBACK;
