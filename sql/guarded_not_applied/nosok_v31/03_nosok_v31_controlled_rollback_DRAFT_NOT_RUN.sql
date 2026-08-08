-- Nosok v31 — Controlled Rollback Draft
-- STATUS: DRAFT_NOT_RUN / OPERATOR_ONLY
-- This rollback drops only nosok schema objects created by the controlled apply.
-- It is intentionally blocked by default.

DO $$
BEGIN
  RAISE EXCEPTION 'NOSOK_V31_ROLLBACK_DRAFT_NOT_RUN: operator rollback authorization and backup/restore decision required.';
END $$;

-- DRAFT BODY BELOW — DO NOT RUN UNTIL AUTHORIZED.
-- BEGIN;
-- DROP SCHEMA IF EXISTS nosok CASCADE;
-- COMMIT;
