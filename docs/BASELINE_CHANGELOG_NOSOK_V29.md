# Baseline Changelog — Nosok v29

## Title

Nosok v29 — Owner Schema DDL Authorization Intake + Staging Apply Gate + RLS/RPC/Negative UAT Preflight

## Changes

- Added v29 authorization intake model/controller.
- Added admin pages for DDL authorization, staging apply gate, and RLS/RPC negative UAT preflight.
- Added read-only SQL preflight.
- Added guarded-not-applied SQL staging apply draft.
- Added rollback draft and after-apply read-only preflight.
- Added governance docs and updated routes/navigation/permissions.

## Non-changes

- No SQL executed by assistant.
- No production approval.
- No public base table creation.
- No mutation in `waqf`, `waqf_assets`, or `awqaf_system`.
