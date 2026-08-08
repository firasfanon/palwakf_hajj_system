-- Nosok v38C — Admin Tools Pre-Join Scope Contract
-- Purpose: DRAFT ONLY for future nosok schema after PalWakf hosting.
-- Safe default: transaction rolls back. Do not remove ROLLBACK unless explicitly approved in a PalWakf SQL sandbox migration session.
-- No waqf_assets, waqf, or awqaf_system mutation.

BEGIN;

-- =============================================================
-- Draft table: nosok.homepage_sections
-- Controls public homepage sections from Nosok admin dashboard.
-- Public RPC must expose published-only, non-sensitive payloads.
-- =============================================================
CREATE SCHEMA IF NOT EXISTS nosok;

CREATE TABLE IF NOT EXISTS nosok.homepage_sections (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  section_key text NOT NULL,
  title_ar text NOT NULL,
  body_ar text,
  cta_label_ar text,
  route_path text,
  icon_key text,
  display_order integer NOT NULL DEFAULT 100,
  visibility_scope text NOT NULL DEFAULT 'public', -- public, unit, season, company
  unit_slug text,
  season_key text,
  is_published boolean NOT NULL DEFAULT false,
  published_from timestamptz,
  published_to timestamptz,
  metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT homepage_sections_key_scope_unique UNIQUE (section_key, COALESCE(unit_slug, ''), COALESCE(season_key, ''))
);

CREATE TABLE IF NOT EXISTS nosok.public_content_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  content_key text NOT NULL,
  title_ar text NOT NULL,
  body_ar text NOT NULL,
  category_key text NOT NULL DEFAULT 'general',
  route_path text,
  is_published boolean NOT NULL DEFAULT false,
  published_from timestamptz,
  published_to timestamptz,
  metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT public_content_key_unique UNIQUE (content_key)
);

CREATE TABLE IF NOT EXISTS nosok.unit_scope_policies (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  unit_slug text NOT NULL,
  org_unit_id uuid,
  governorate_code text,
  allowed_lgu_codes text[] NOT NULL DEFAULT ARRAY[]::text[],
  role_key text NOT NULL DEFAULT 'nosokUnitOfficer',
  can_view boolean NOT NULL DEFAULT true,
  can_edit_before_close boolean NOT NULL DEFAULT false,
  can_review boolean NOT NULL DEFAULT true,
  can_override boolean NOT NULL DEFAULT false,
  policy_snapshot jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT unit_scope_policy_unique UNIQUE (unit_slug, role_key)
);

CREATE TABLE IF NOT EXISTS nosok.registration_governance_windows (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  season_key text NOT NULL,
  window_key text NOT NULL, -- registration_open, registration_closed, completion_window, lottery_pool_frozen
  starts_at timestamptz,
  ends_at timestamptz,
  citizen_can_create boolean NOT NULL DEFAULT false,
  citizen_can_edit_core_data boolean NOT NULL DEFAULT false,
  citizen_can_upload_missing_documents boolean NOT NULL DEFAULT false,
  employee_can_edit_core_data boolean NOT NULL DEFAULT false,
  employee_can_review boolean NOT NULL DEFAULT true,
  committee_override_required boolean NOT NULL DEFAULT false,
  policy_reason_ar text,
  metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT registration_window_unique UNIQUE (season_key, window_key)
);

CREATE TABLE IF NOT EXISTS nosok.admin_override_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  season_key text NOT NULL,
  application_id uuid,
  override_key text NOT NULL,
  reason_ar text NOT NULL,
  committee_decision_id uuid,
  requested_by uuid,
  approved_by uuid,
  evidence jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);

-- Draft public-safe view/RPC surfaces. These are markers only in this package.
-- Future RPCs:
--   nosok.rpc_public_homepage_surface_v1(unit_slug text, season_key text)
--   nosok.rpc_admin_homepage_sections_v1(filters jsonb)
--   nosok.rpc_admin_unit_scope_preview_v1(user_id uuid, unit_slug text)
--   nosok.rpc_registration_governance_state_v1(season_key text, application_id uuid)

ROLLBACK;
