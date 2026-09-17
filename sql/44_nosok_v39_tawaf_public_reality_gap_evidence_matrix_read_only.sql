-- Nosok v39 Tawaf Public Reality Gap Evidence Matrix — READ ONLY
-- Date: 2026-09-16
-- Purpose: expose the v39 evidence matrix as immutable read-only literals for review.
-- This script performs no DDL, no DML, no GRANT/REVOKE, and no mutation.

with public_observations(source_key, public_url, observation) as (
  values
    ('TWF_SRC_001', 'https://nosok.pal-wakf.ps/pilgrimage.php', 'Hajj 1448H/2027 registration rules and flow: civil registry address, identity type, OTP, Jerusalem ID attachment, payment code/bank/eSadad, SMS acceptance.'),
    ('TWF_SRC_002', 'https://nosok.pal-wakf.ps/check_register.php', 'Public registration check by national ID / registration number.'),
    ('TWF_SRC_003', 'https://nosok.pal-wakf.ps/company.php', 'Public qualified company directory with company name, phone, and governorate/address.'),
    ('TWF_SRC_004', 'https://nosok.pal-wakf.ps/company/', 'Company login with username, password, and Captcha.')
), evidence_matrix(case_key, domain_key, status, required_evidence) as (
  values
    ('V39_CIV_001', 'civil_registry_address', 'PENDING_AUTHORITY', 'Authority source contract, safe rejection, and masked Network/RPC evidence.'),
    ('V39_ID_001', 'identity_documents', 'PENDING_STORAGE_POLICY', 'Jerusalem ID attachment policy and no public document URL leakage.'),
    ('V39_OTP_001', 'otp_sms', 'PENDING_PROVIDER', 'OTP provider receipts, expiry/retry limits, and negative OTP evidence.'),
    ('V39_PAY_001', 'payment_bank_esadad', 'PENDING_PROVIDER', 'Payment code, callback/idempotency, reconciliation report, and SMS acceptance evidence.'),
    ('V39_COMP_001', 'company_directory', 'PENDING_IMPORT_VERSIONING', 'Source snapshot, checksum, import manifest, and diff report.'),
    ('V39_AUTH_001', 'company_captcha_auth', 'PENDING_AUTH_SECURITY', 'Captcha/session threat model and wrong-company negative UAT.'),
    ('V39_LOT_001', 'lottery', 'PENDING_AUTHORITY', 'Official result feed or audited algorithm/seed custody plus anti-enumeration evidence.'),
    ('V39_PROD_001', 'production_gate', 'BROWSER_EVIDENCE_REQUIRED', 'Route renders for authorized admin and denies anonymous/no-role/wrong-scope.')
)
select 'public_observation' as record_type, source_key as key, public_url as scope, observation as detail
from public_observations
union all
select 'evidence_case' as record_type, case_key as key, domain_key as scope, status || ' :: ' || required_evidence as detail
from evidence_matrix
order by record_type, key;
