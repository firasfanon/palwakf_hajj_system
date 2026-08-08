-- Nosok v35 — Public Wrapper/RPC Rollback Draft
-- STATUS: DRAFT_NOT_RUN
-- Do not run unless a rollback decision is explicitly issued.

DO $$
BEGIN
  RAISE EXCEPTION 'NOSOK_V35_ROLLBACK_DRAFT_NOT_RUN: rollback requires explicit operator decision.';
END $$;

BEGIN;
DROP FUNCTION IF EXISTS public.rpc_nosok_application_submit_v1(text, text, uuid, uuid, uuid, jsonb);
DROP FUNCTION IF EXISTS public.rpc_nosok_application_track_v1(text);
DROP FUNCTION IF EXISTS public.rpc_nosok_requirements_public_list_v1(text);
DROP FUNCTION IF EXISTS public.rpc_nosok_campaigns_public_list_v1();
DROP VIEW IF EXISTS public.v_nosok_requirements_public_v1;
DROP VIEW IF EXISTS public.v_nosok_campaigns_public_v1;
COMMIT;
