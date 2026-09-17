# UAT Matrix — Nosok v39 Tawaf Public Reality Gap Adapter

Date: 2026-09-16

Decision: `TAWAF_PUBLIC_REALITY_GAP_ADAPTER_AND_EVIDENCE_MATRIX_PREPARED_PRODUCTION_NOT_APPROVED_NO_EXTERNAL_INTEGRATION`

## Purpose

Define the minimum evidence needed before Nosok can claim operational parity with the public Tawaf/Nosok Hajj registration reality. This matrix is binding for future implementation but is not itself an integration proof.

| Case | Domain | Surface | Positive evidence required | Negative evidence required | Status |
|---|---|---|---|---|---|
| V39_CIV_001 | Civil Registry | `/services/nosok/apply` | address/governorate/town validated by governed authority source | invalid town / mismatched governorate rejected safely | PENDING_AUTHORITY |
| V39_ID_001 | Identity Documents | `/services/nosok/apply` | Jerusalem ID attachment required and safely stored | missing/invalid file rejected; no public document URL leakage | PENDING_STORAGE_POLICY |
| V39_OTP_001 | OTP/SMS | `/services/nosok/apply` | OTP request/verify provider receipt and expiry evidence | wrong/expired/reused OTP rejected; no OTP in logs/client payload | PENDING_PROVIDER |
| V39_PAY_001 | Payment | apply + payment bridge | payment code generation, bank/eSadad reconciliation, SMS acceptance after payment | duplicate callback, unknown code, underpayment, accept-without-payment rejected | PENDING_PROVIDER |
| V39_COMP_001 | Company Directory | `/services/nosok/companies` | directory source snapshot with checksum, import manifest, diff report | duplicate company/placeholder phone/unknown governorate flagged | PENDING_IMPORT_VERSIONING |
| V39_AUTH_001 | Company Portal/Captcha | company login/admin companies | username/password/Captcha/session cycle documented | wrong password, missing/expired Captcha, wrong company scope denied | PENDING_AUTH_SECURITY |
| V39_LOT_001 | Lottery | `/services/nosok/lottery-results` or `/services/nosok/track` | official result feed or audited algorithm/seed custody | enumeration, pre-publication result, invalid ID/registration denied | PENDING_AUTHORITY |
| V39_PROD_001 | Production Gate | `/admin/systems/nosok/v39-tawaf-reality-gap` | route renders under authorized admin profile | anonymous/no-role/wrong-scope denied | BROWSER_EVIDENCE_REQUIRED |

## Local retest commands

```bash
dart format lib/features/nosok_system/domain/models/nosok_v39_tawaf_reality_gap_contract.dart lib/features/nosok_system/application/nosok_v39_tawaf_reality_gap_controller.dart lib/features/nosok_system/presentation/pages/admin/nosok_admin_v39_tawaf_reality_gap_page.dart lib/features/nosok_system/system_routes.dart lib/features/nosok_system/presentation/routes/nosok_routes.dart lib/features/nosok_system/system_navigation.dart
flutter analyze
flutter run -d chrome
```

## Browser evidence to capture

1. Authorized admin opens `/admin/systems/nosok/v39-tawaf-reality-gap` and sees v39 decision + matrix.
2. Anonymous/no-session attempt is denied or redirected safely.
3. Authenticated profile without `redecideNosokProductionGate` is denied.
4. DevTools Network confirms this page does not call Tawaf/Nosok official site, civil registry, OTP provider, payment provider, or company portal.

## Production gate

`PRODUCTION_APPROVAL = NO`

## Local compile-repair evidence — 2026-09-17

| Gate | Result | Evidence |
|---|---|---|
| Required v38 public-runtime dependency files present | PASS | contract + controller + admin evidence page restored from v39 artifact |
| Nosok-scoped analyzer | PASS | `flutter analyze --no-pub lib/features/nosok_system` → `No issues found` |
| Web dependency-graph build | PASS | `flutter build web --debug --no-pub` → `Built build/web`, exit 0 |
| Whole-repository analyzer | FAIL_OUT_OF_SCOPE_DRIFT | 564 pre-existing issues concentrated in `awqaf_system` / `waqf_assets`; not attributed to Nosok v39 |
| Chrome debug runtime | PENDING_RUNTIME_EVIDENCE | first retry no longer produced the missing v38-page compile error, but debug-service connection did not complete during the observed run |

Current production decision remains unchanged: `PRODUCTION_APPROVAL = NO`.
