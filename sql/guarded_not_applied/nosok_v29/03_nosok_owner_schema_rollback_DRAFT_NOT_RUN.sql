-- Nosok v29 — Rollback Draft (DRAFT NOT RUN)
-- Use only in staging and only after explicit rollback authorization.

DO $$
BEGIN
  RAISE EXCEPTION 'NOSOK_V29_ROLLBACK_DRAFT_NOT_RUN: rollback requires explicit operator authorization.';
END $$;

-- DRAFT BODY BELOW — NOT FOR PRODUCTION.
-- drop table if exists nosok.audit_events cascade;
-- drop table if exists nosok.workflow_events cascade;
-- drop table if exists nosok.lgu_quotas cascade;
-- drop table if exists nosok.quota_rules cascade;
-- drop table if exists nosok.eligibility_rules cascade;
-- drop table if exists nosok.application_documents cascade;
-- drop table if exists nosok.applications cascade;
-- drop table if exists nosok.campaigns cascade;
-- drop schema if exists nosok cascade;
