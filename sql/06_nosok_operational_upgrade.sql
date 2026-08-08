begin;

alter table if exists nosok.company_season_qualifications
  add column if not exists is_publicly_visible boolean not null default false,
  add column if not exists approved_at timestamptz,
  add column if not exists approved_by uuid;

alter table if exists nosok.application_documents
  add column if not exists document_title text,
  add column if not exists original_file_name text,
  add column if not exists storage_bucket text,
  add column if not exists storage_path text,
  add column if not exists mime_type text,
  add column if not exists file_size_bytes bigint,
  add column if not exists uploaded_by uuid,
  add column if not exists notes text;

alter table if exists nosok.application_payments
  add column if not exists payment_method text,
  add column if not exists provider_name text,
  add column if not exists external_transaction_id text,
  add column if not exists receipt_url text,
  add column if not exists verified_at timestamptz,
  add column if not exists verified_by uuid;

create index if not exists idx_nosok_company_qualifications_company on nosok.company_season_qualifications(company_id);
create index if not exists idx_nosok_company_qualifications_season on nosok.company_season_qualifications(season_id);
create index if not exists idx_nosok_company_qualifications_visible on nosok.company_season_qualifications(is_publicly_visible);
create index if not exists idx_nosok_application_documents_application on nosok.application_documents(application_id);
create index if not exists idx_nosok_application_payments_application on nosok.application_payments(application_id);

commit;


-- =========================================================
-- v08 final alignment for direct full-schema use
-- =========================================================

alter table if exists nosok.application_payments
  add column if not exists verification_status text not null default 'pending',
  add column if not exists verification_notes text,
  add column if not exists receipt_storage_bucket text,
  add column if not exists receipt_storage_path text,
  add column if not exists receipt_original_file_name text,
  add column if not exists receipt_mime_type text,
  add column if not exists receipt_file_size_bytes bigint;

alter table if exists nosok.application_payments
  drop constraint if exists application_payments_verification_status_check;
alter table if exists nosok.application_payments
  add constraint application_payments_verification_status_check
  check (verification_status in ('pending','under_review','verified','rejected','needs_receipt'));

alter table if exists nosok.application_reviews
  drop constraint if exists application_reviews_review_action_check;
alter table if exists nosok.application_reviews
  add constraint application_reviews_review_action_check
  check (review_action in (
    'submit',
    'approve',
    'reject',
    'return_for_edit',
    'mark_needs_review',
    'status_update',
    'verify_payment',
    'reject_payment',
    'approve_document',
    'reject_document'
  ));

create index if not exists idx_nosok_application_payments_verification_status on nosok.application_payments(verification_status);
create index if not exists idx_nosok_application_reviews_application on nosok.application_reviews(application_id);
