-- Nosok v34 — Rollback draft for public wrappers/RPCs only
-- DO NOT RUN unless rollback is explicitly authorized.

DO $$
BEGIN
  RAISE EXCEPTION 'NOSOK_V34_ROLLBACK_DRAFT_NOT_RUN: remove this guard only after explicit rollback authorization.';
END $$;

BEGIN;
DROP FUNCTION IF EXISTS public.rpc_nosok_application_submit_v1(text, text, uuid, uuid, uuid, jsonb);
DROP FUNCTION IF EXISTS public.rpc_nosok_application_track_v1(text);
DROP FUNCTION IF EXISTS public.rpc_nosok_requirements_public_list_v1(text);
DROP FUNCTION IF EXISTS public.rpc_nosok_campaigns_public_list_v1();
DROP VIEW IF EXISTS public.v_nosok_requirements_public_v1;
DROP VIEW IF EXISTS public.v_nosok_campaigns_public_v1;
COMMIT;
