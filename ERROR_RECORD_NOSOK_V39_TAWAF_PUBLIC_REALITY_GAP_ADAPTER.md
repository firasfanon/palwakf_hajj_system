# Error / Risk Record — Nosok v39 Tawaf Public Reality Gap Adapter

Date: 2026-09-16

## Risk addressed

Prior Nosok staging versions could be misread as close to official Tawaf/Nosok operational parity because public surfaces existed for apply, track, requirements, companies, payment bridge, notifications, and lottery readiness. The public official site shows operational dependencies that are not closed in Nosok v38.

## Root cause

The product had internal/staging abstractions for many domains but lacked an explicit authority/provider evidence matrix separating:

- implemented UI/RPC hardening,
- planned authority integrations,
- provider integrations,
- browser/network evidence,
- and production approval.

## Lesson

A public-facing service that resembles an official government flow must expose a reality-gap adapter before claiming production readiness. UI parity is not operational parity.

## Preventive gate added

Nosok v39 adds a governed route and contract requiring explicit evidence for:

- Civil registry/address authority,
- Identity document storage and public masking,
- OTP/SMS provider receipts,
- Bank/eSadad payment reconciliation,
- Company directory source import/versioning,
- Company Captcha/session controls,
- Official lottery feed or audited lottery execution,
- Negative no-role/wrong-scope/browser evidence.

## Production implication

Production remains blocked until the above evidence is supplied and independently retested.

## Compile repair — 2026-09-17

Observed failure:

- `nosok_routes.dart` imported `nosok_admin_v38_public_runtime_evidence_page.dart`.
- The local project tree was missing that page and its v38 public-runtime contract/controller, although all three files existed in the canonical v39 ZIP artifact.

Root cause:

`ARTIFACT_TO_LOCAL_EXTRACTION_INCOMPLETE`: the local overlay did not materialize three v38 dependency files required by the v39 route graph.

Repair:

- restored the three files byte-for-byte from the v39 artifact before formatting;
- moved WIP off `main` to `task/NOSOK-V39-LOCAL-COMPILE-REPAIR-V1` at base `cb8c4f32111ca7759cd2af36c96dc9b90406568a`;
- `flutter analyze --no-pub lib/features/nosok_system` => `No issues found`;
- `flutter build web --debug --no-pub` => `WEB_BUILD_EXIT=0`, `Built build/web`.

Preventive gate:

Before future ZIP handoff/local overlay acceptance, verify every Dart import target exists, then run Nosok-scoped analyze and a Web build. A ZIP checksum alone does not prove extraction completeness.
