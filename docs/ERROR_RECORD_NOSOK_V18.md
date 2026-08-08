# ERROR RECORD — Nosok v18

## Status
No runtime/analyzer log was provided for v18 in this conversation turn.

## Preventive decisions
- Follow-up actions are bound to `tracking_token` and status gates; they do not expose national ID, phone, email, or documents publicly.
- Application transitions are routed through a state-machine RPC and audit table instead of ad-hoc status updates.
- Notification dispatch is queued and bridged; no provider secrets or SMS/email engine is embedded in Nosok.

## Expected local checks
```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

## SQL check
```sql
select * from public.rpc_nosok_v18_runtime_contract_uat_v1();
```
