# Baseline Changelog — Nosok v39 Tawaf Public Reality Gap Adapter

Date: 2026-09-16

Decision:

`TAWAF_PUBLIC_REALITY_GAP_ADAPTER_AND_EVIDENCE_MATRIX_PREPARED_PRODUCTION_NOT_APPROVED_NO_EXTERNAL_INTEGRATION`

## Scope

This batch converts the public operational gaps observed from the Tawaf/Nosok official public site into a governed Nosok v39 runtime/evidence contract. It does **not** integrate with the official site, civil registry, SMS/OTP providers, banks/eSadad, company portal, Captcha, or official lottery result feeds.

## Public reference observations

- `https://nosok.pal-wakf.ps/pilgrimage.php` exposes public Hajj 1448H/2027 registration rules and flow: first-time Hajj restriction, age over 16, duplicate application prohibition, 1000 JOD payment, maximum two companions, address from civil registry, mahram/spouse address rule, identity type selection, OTP/mobile code, Jerusalem ID attachment, payment code, bank/eSadad payment, and SMS acceptance after payment.
- `https://nosok.pal-wakf.ps/check_register.php` exposes a public registration check surface by national ID / registration number.
- `https://nosok.pal-wakf.ps/company.php` exposes a public qualified-company directory with names, phones, and governorate/address values.
- `https://nosok.pal-wakf.ps/company/` exposes a company login surface with username, password, and Captcha.

## Added runtime contract files

- `lib/features/nosok_system/domain/models/nosok_v39_tawaf_reality_gap_contract.dart`
- `lib/features/nosok_system/application/nosok_v39_tawaf_reality_gap_controller.dart`
- `lib/features/nosok_system/presentation/pages/admin/nosok_admin_v39_tawaf_reality_gap_page.dart`

## Updated route/navigation files

- `lib/features/nosok_system/system_routes.dart`
- `lib/features/nosok_system/presentation/routes/nosok_routes.dart`
- `lib/features/nosok_system/system_navigation.dart`

New governed admin route:

`/admin/systems/nosok/v39-tawaf-reality-gap`

Required permission:

`NosokPermissionKeys.redecideNosokProductionGate`

## Evidence matrix domains

- Civil Registry / address authority
- Identity type and Jerusalem ID attachment
- OTP/SMS verification and delivery receipts
- Bank/eSadad payment reconciliation and idempotency
- Mahram/companions backend constraint enforcement
- Duplicate request prevention
- Qualified company directory import/versioning
- Company portal authentication and Captcha/session controls
- Official lottery result feed or audited lottery execution

## Production re-decision

Production remains **not approved**.

Reasons:

- v39 is an evidence/adapter contract only.
- No authority/provider integrations were executed.
- No Browser/Network evidence has been supplied from a local Flutter environment.
- No civil registry, OTP, payment, company-auth, Captcha, or official lottery evidence exists yet.

## Preserved boundaries

- No scraping.
- No Captcha bypass.
- No private citizen data extraction.
- No third-party credential/session use.
- No DDL/DML/GRANT/REVOKE.
- No `service_role`.
- No `platformHosted` switch.
- No direct citizen Flutter read from `nosok.*`.
- No public base table creation.
- No mutation on `waqf_assets`, `waqf`, or `awqaf_system`.
