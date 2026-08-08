# Nosok v29 guarded SQL pack

These scripts are prepared for staging review only.

Required before running any DDL file:

1. Explicit owner authorization ID for creating `nosok.*` only.
2. DBA/operator confirmation that a backup/snapshot exists.
3. Acceptance of `NOSOK_V29_STAGING_APPLY_GATE.md`.
4. No `public.*` base table creation.
5. No writes to `core`, `platform_access`, `billing_system`, `waqf`, or `awqaf_system`.
6. RLS/RPC/negative UAT preflight plan accepted.

Default status: `GUARDED_NOT_APPLIED`.
