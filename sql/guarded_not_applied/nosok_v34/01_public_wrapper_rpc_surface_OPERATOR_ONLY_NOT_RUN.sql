-- Nosok v34 — Public Wrapper/RPC Surface Apply
-- STATUS: OPERATOR_ONLY_NOT_RUN / FAIL-CLOSED BY DEFAULT
-- This script creates public views/functions only. It never creates public base tables.

-- REQUIRED VALUES TO BE SET BY DBA/OPERATOR BEFORE REMOVING THE FAIL-CLOSED GUARD:
-- owner_authorization_id: CHAT_AUTHORIZATION_NOSOK_V34_PENDING_OPERATOR_BINDING
-- staging_target: explicit non-production database identifier
-- backup_reference: external backup/snapshot/restore point reference
-- operator_identity: DBA/operator account executing the script
-- production_approved: false

DO $$
BEGIN
  RAISE EXCEPTION 'NOSOK_V34_OPERATOR_ONLY_NOT_RUN: bind owner_authorization_id, staging target, backup_reference, and remove this guard only in an approved staging session.';
END $$;

BEGIN;

-- Public campaign read surface. public remains a view/RPC surface, not owner schema.
CREATE OR REPLACE VIEW public.v_nosok_campaigns_public_v1 AS
SELECT
  c.id,
  c.campaign_code,
  c.title_ar,
  c.service_type,
  c.season_year,
  c.status,
  c.application_open_at,
  c.application_close_at,
  c.updated_at
FROM nosok.campaigns c
WHERE c.status IN ('published', 'closed');

CREATE OR REPLACE FUNCTION public.rpc_nosok_campaigns_public_list_v1()
RETURNS TABLE (
  id uuid,
  campaign_code text,
  title_ar text,
  service_type text,
  season_year integer,
  status text,
  application_open_at timestamptz,
  application_close_at timestamptz
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public, nosok, pg_temp
AS $$
  SELECT c.id, c.campaign_code, c.title_ar, c.service_type, c.season_year, c.status, c.application_open_at, c.application_close_at
  FROM public.v_nosok_campaigns_public_v1 c
  ORDER BY c.season_year DESC, c.application_open_at DESC NULLS LAST, c.title_ar;
$$;

CREATE OR REPLACE VIEW public.v_nosok_requirements_public_v1 AS
SELECT
  er.id,
  c.campaign_code,
  er.rule_key,
  er.title_ar,
  er.rule_body,
  er.updated_at
FROM nosok.eligibility_rules er
JOIN nosok.campaigns c ON c.id = er.campaign_id
WHERE er.is_published = true
  AND c.status IN ('published', 'closed');

CREATE OR REPLACE FUNCTION public.rpc_nosok_requirements_public_list_v1(p_campaign_code text DEFAULT NULL)
RETURNS TABLE (
  id uuid,
  campaign_code text,
  rule_key text,
  title_ar text,
  rule_body jsonb,
  updated_at timestamptz
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public, nosok, pg_temp
AS $$
  SELECT r.id, r.campaign_code, r.rule_key, r.title_ar, r.rule_body, r.updated_at
  FROM public.v_nosok_requirements_public_v1 r
  WHERE p_campaign_code IS NULL OR r.campaign_code = p_campaign_code
  ORDER BY r.campaign_code, r.rule_key;
$$;

CREATE OR REPLACE FUNCTION public.rpc_nosok_application_track_v1(p_tracking_code text)
RETURNS TABLE (
  tracking_code text,
  campaign_code text,
  service_type text,
  status text,
  eligibility_status text,
  submitted_at timestamptz,
  last_event_at timestamptz
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public, nosok, pg_temp
AS $$
BEGIN
  IF p_tracking_code IS NULL OR length(trim(p_tracking_code)) < 8 THEN
    RAISE EXCEPTION 'NOSOK_TRACKING_CODE_REQUIRED';
  END IF;

  RETURN QUERY
  SELECT
    a.tracking_code,
    c.campaign_code,
    c.service_type,
    a.status,
    a.eligibility_status,
    a.submitted_at,
    (SELECT max(e.created_at) FROM nosok.workflow_events e WHERE e.application_id = a.id) AS last_event_at
  FROM nosok.applications a
  JOIN nosok.campaigns c ON c.id = a.campaign_id
  WHERE a.tracking_code = trim(p_tracking_code)
  LIMIT 1;
END;
$$;

CREATE OR REPLACE FUNCTION public.rpc_nosok_application_submit_v1(
  p_campaign_code text,
  p_applicant_display_name text DEFAULT NULL,
  p_lgu_id uuid DEFAULT NULL,
  p_governorate_id uuid DEFAULT NULL,
  p_unit_id uuid DEFAULT NULL,
  p_metadata jsonb DEFAULT '{}'::jsonb
)
RETURNS TABLE (
  application_id uuid,
  tracking_code text,
  status text,
  eligibility_status text
)
LANGUAGE plpgsql
VOLATILE
SECURITY DEFINER
SET search_path = public, nosok, pg_temp
AS $$
DECLARE
  v_campaign_id uuid;
  v_tracking_code text;
  v_application_id uuid;
BEGIN
  IF p_campaign_code IS NULL OR trim(p_campaign_code) = '' THEN
    RAISE EXCEPTION 'NOSOK_CAMPAIGN_CODE_REQUIRED';
  END IF;

  SELECT c.id INTO v_campaign_id
  FROM nosok.campaigns c
  WHERE c.campaign_code = trim(p_campaign_code)
    AND c.status = 'published'
    AND (c.application_open_at IS NULL OR c.application_open_at <= now())
    AND (c.application_close_at IS NULL OR c.application_close_at >= now())
  LIMIT 1;

  IF v_campaign_id IS NULL THEN
    RAISE EXCEPTION 'NOSOK_CAMPAIGN_NOT_OPEN';
  END IF;

  v_tracking_code := 'NSK-' || to_char(now(), 'YYYYMMDD') || '-' || upper(substr(replace(gen_random_uuid()::text, '-', ''), 1, 8));

  INSERT INTO nosok.applications (
    campaign_id,
    tracking_code,
    applicant_display_name,
    lgu_id,
    governorate_id,
    unit_id,
    status,
    eligibility_status,
    submitted_at,
    metadata
  ) VALUES (
    v_campaign_id,
    v_tracking_code,
    nullif(trim(coalesce(p_applicant_display_name, '')), ''),
    p_lgu_id,
    p_governorate_id,
    p_unit_id,
    'submitted',
    'pending',
    now(),
    coalesce(p_metadata, '{}'::jsonb)
  )
  RETURNING id INTO v_application_id;

  INSERT INTO nosok.workflow_events(application_id, event_key, from_status, to_status, reason, metadata)
  VALUES (v_application_id, 'public_submit', NULL, 'submitted', 'public RPC submit', jsonb_build_object('source', 'rpc_nosok_application_submit_v1'));

  INSERT INTO nosok.audit_events(event_key, target_table, target_id, reason, metadata)
  VALUES ('public_submit', 'nosok.applications', v_application_id, 'public RPC submit', jsonb_build_object('tracking_code', v_tracking_code));

  RETURN QUERY SELECT v_application_id, v_tracking_code, 'submitted'::text, 'pending'::text;
END;
$$;

REVOKE ALL ON public.v_nosok_campaigns_public_v1 FROM PUBLIC;
REVOKE ALL ON public.v_nosok_requirements_public_v1 FROM PUBLIC;
GRANT SELECT ON public.v_nosok_campaigns_public_v1 TO anon, authenticated;
GRANT SELECT ON public.v_nosok_requirements_public_v1 TO anon, authenticated;

REVOKE ALL ON FUNCTION public.rpc_nosok_campaigns_public_list_v1() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.rpc_nosok_requirements_public_list_v1(text) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.rpc_nosok_application_track_v1(text) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.rpc_nosok_application_submit_v1(text, text, uuid, uuid, uuid, jsonb) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.rpc_nosok_campaigns_public_list_v1() TO anon, authenticated;
GRANT EXECUTE ON FUNCTION public.rpc_nosok_requirements_public_list_v1(text) TO anon, authenticated;
GRANT EXECUTE ON FUNCTION public.rpc_nosok_application_track_v1(text) TO anon, authenticated;
GRANT EXECUTE ON FUNCTION public.rpc_nosok_application_submit_v1(text, text, uuid, uuid, uuid, jsonb) TO anon, authenticated;

COMMIT;
