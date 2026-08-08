# PalWakf Guide Appendix — Nosok v29

Nosok v29 formalizes the staging DDL gate without executing SQL.

Contract rule:

```text
Nosok may only create operational owner tables inside nosok.* after explicit owner authorization.
Public remains views/RPC wrappers only.
Core remains sovereign reference.
Production remains blocked until UAT and independent approval.
```
