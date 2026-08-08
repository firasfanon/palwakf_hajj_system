# Baseline Changelog — Nosok v37

## Decision

```text
V37_PUBLIC_REPOSITORY_BINDING_RUNTIME_SWITCH_CANDIDATE_PREPARED_PRODUCTION_DEFERRED
```

## Summary

- Added controlled runtime switch candidate pages.
- Added browser evidence result intake based on user screenshots.
- Added Flutter provider for public repository binding candidate.
- Added signature-aware SQL wrapper census to avoid false-negative function checks.
- Production remains deferred.

## Boundaries

- No DDL/DML.
- No `public.*` base tables.
- No direct `nosok.*` Flutter access.
- No `service_role` in Flutter.
- No waqf/awqaf_system mutation.
