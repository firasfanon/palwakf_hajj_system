# SESSION HANDOFF — NOSOK v32

## Current state

`staging-stable / analyzer-clean / v31-read-only-apply-not-certified / controlled-apply-still-required / browser-runtime-cdn-blocker / production-not-approved / no-waqf-assets-mutation`

## Next action

Operator should read `00`, run `01` on staging only if backup and staging session are confirmed, then run `02` read-only after apply and send full SQL output.

## Do not run

`03 rollback` unless rollback is needed.
