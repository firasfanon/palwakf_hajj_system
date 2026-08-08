
-- Nosok v33 — Public Wrapper Surface Draft
-- DO NOT RUN unless v34 explicitly authorizes wrapper/RPC staging apply.

DO $$
BEGIN
  RAISE EXCEPTION 'NOSOK_V33_PUBLIC_WRAPPER_DRAFT_NOT_RUN: wrapper/RPC apply requires separate v34 authorization, approved hash, staging target, and rollback plan.';
END $$;

-- Draft begins below. Keep public as compatibility/RPC surface only. No public base tables.
-- BEGIN;
-- CREATE OR REPLACE VIEW public.v_nosok_campaigns_public_v1 AS
--   SELECT id, title_ar, title_en, campaign_type, status, starts_at, ends_at, created_at
--   FROM nosok.campaigns
--   WHERE status IN ('published','open');
--
-- CREATE OR REPLACE FUNCTION public.rpc_nosok_campaigns_public_list_v1()
-- RETURNS SETOF public.v_nosok_campaigns_public_v1
-- LANGUAGE sql
-- STABLE
-- SECURITY DEFINER
-- SET search_path = public, nosok
-- AS $$ SELECT * FROM public.v_nosok_campaigns_public_v1; $$;
-- COMMIT;
