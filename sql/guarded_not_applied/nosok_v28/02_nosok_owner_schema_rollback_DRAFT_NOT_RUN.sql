-- Nosok v28 — Rollback Draft
-- STATUS: DRAFT_NOT_RUN / GUARDED_NOT_APPLIED
-- Default guard intentionally aborts before any rollback DDL.

DO $$
BEGIN
  RAISE EXCEPTION 'DRAFT_NOT_RUN: rollback script is not authorized. Use only after a documented staging apply attempt and owner approval.';
END $$;

-- DRAFT ONLY BELOW THIS LINE.
BEGIN;
DROP TABLE IF EXISTS nosok.audit_events;
DROP TABLE IF EXISTS nosok.workflow_events;
DROP TABLE IF EXISTS nosok.lgu_quotas;
DROP TABLE IF EXISTS nosok.quota_rules;
DROP TABLE IF EXISTS nosok.eligibility_rules;
DROP TABLE IF EXISTS nosok.application_documents;
DROP TABLE IF EXISTS nosok.applications;
DROP TABLE IF EXISTS nosok.campaigns;
DROP SCHEMA IF EXISTS nosok;
ROLLBACK;
