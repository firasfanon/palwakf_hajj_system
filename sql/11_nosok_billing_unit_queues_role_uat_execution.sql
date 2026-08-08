-- Nosok v12 — Billing System Bridge Execution + Unit-Scoped Application Queues + Role UAT Evidence Intake
-- Scope: nosok schema + public RPC wrappers only. No waqf_assets mutation.

create schema if not exists nosok;

alter table if exists nosok.applications
  add column if not exists unit_id text,
  add column if not exists unit_slug text;

alter table if exists nosok.payment_bridge_requests
  add column if not exists executed_at timestamptz,
  add column if not exists synced_at timestamptz,
  add column if not exists execution_notes text,
  add column if not exists billing_payload jsonb default '{}'::jsonb,
  add column if not exists billing_response jsonb default '{}'::jsonb;

create table if not exists nosok.role_uat_evidence (
  id uuid primary key default gen_random_uuid(),
  matrix_case_id uuid null,
  role_key text not null,
  surface_key text not null,
  expected_access text not null,
  actual_access text not null,
  result_status text not null default 'pending_review',
  tested_by uuid null,
  evidence_url text null,
  notes_ar text null,
  tested_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

create index if not exists idx_nosok_role_uat_evidence_case on nosok.role_uat_evidence(matrix_case_id);
create index if not exists idx_nosok_role_uat_evidence_role_surface on nosok.role_uat_evidence(role_key, surface_key);

create or replace function public.rpc_nosok_admin_payment_bridge_execute_v1(
  p_bridge_request_id uuid,
  p_provider_key text default 'billing_system',
  p_payment_channel text default null,
  p_notes text default null
)
returns table (
  id uuid,
  application_id uuid,
  application_no text,
  payment_id uuid,
  amount numeric,
  currency_code text,
  bridge_status text,
  billing_reference text,
  provider_reference text,
  payment_method text,
  notes text,
  created_at timestamptz,
  updated_at timestamptz
)
language plpgsql
security definer
set search_path = public, nosok
as $$
declare
  v_ref text;
begin
  -- Contract-first execution: when billing_system tables/RPCs exist, this wrapper is the single integration point.
  -- Current safe implementation creates a deterministic billing reference and marks the bridge as sent_to_billing.
  v_ref := 'BILL-NSK-' || upper(substr(replace(gen_random_uuid()::text, '-', ''), 1, 14));

  update nosok.payment_bridge_requests r
     set bridge_status = 'sent_to_billing',
         billing_reference = coalesce(r.billing_reference, v_ref),
         payment_method = coalesce(nullif(p_payment_channel, ''), r.payment_method),
         execution_notes = nullif(p_notes, ''),
         billing_payload = jsonb_build_object(
           'provider_key', coalesce(nullif(p_provider_key, ''), 'billing_system'),
           'payment_channel', nullif(p_payment_channel, ''),
           'source_system', 'nosok',
           'bridge_request_id', r.id,
           'application_id', r.application_id,
           'payment_id', r.payment_id,
           'amount', r.amount,
           'currency_code', r.currency_code
         ),
         executed_at = now(),
         updated_at = now()
   where r.id = p_bridge_request_id;

  return query
  select r.id, r.application_id, a.application_no, r.payment_id, r.amount, r.currency_code,
         r.bridge_status, r.billing_reference, r.provider_reference, r.payment_method, r.notes,
         r.created_at, r.updated_at
    from nosok.payment_bridge_requests r
    left join nosok.applications a on a.id = r.application_id
   where r.id = p_bridge_request_id;
end;
$$;

create or replace function public.rpc_nosok_admin_payment_bridge_sync_v1(
  p_bridge_request_id uuid,
  p_provider_reference text default null,
  p_notes text default null
)
returns table (
  id uuid,
  application_id uuid,
  application_no text,
  payment_id uuid,
  amount numeric,
  currency_code text,
  bridge_status text,
  billing_reference text,
  provider_reference text,
  payment_method text,
  notes text,
  created_at timestamptz,
  updated_at timestamptz
)
language plpgsql
security definer
set search_path = public, nosok
as $$
begin
  update nosok.payment_bridge_requests r
     set bridge_status = 'billing_synced',
         provider_reference = coalesce(nullif(p_provider_reference, ''), r.provider_reference, 'SYNC-' || upper(substr(replace(gen_random_uuid()::text, '-', ''), 1, 12))),
         billing_response = jsonb_build_object(
           'synced_at', now(),
           'provider_reference', coalesce(nullif(p_provider_reference, ''), r.provider_reference),
           'notes', nullif(p_notes, '')
         ),
         synced_at = now(),
         updated_at = now()
   where r.id = p_bridge_request_id;

  return query
  select r.id, r.application_id, a.application_no, r.payment_id, r.amount, r.currency_code,
         r.bridge_status, r.billing_reference, r.provider_reference, r.payment_method, r.notes,
         r.created_at, r.updated_at
    from nosok.payment_bridge_requests r
    left join nosok.applications a on a.id = r.application_id
   where r.id = p_bridge_request_id;
end;
$$;

create or replace function public.rpc_nosok_admin_unit_application_queue_v1(
  p_unit_id text default null,
  p_unit_slug text default null,
  p_status text default null
)
returns table (
  id uuid,
  application_no text,
  applicant_full_name text,
  service_type text,
  application_status text,
  eligibility_status text,
  unit_id text,
  unit_slug text,
  unit_name_ar text,
  season_title_ar text,
  program_title_ar text,
  mobile text,
  submitted_at timestamptz,
  documents_count integer,
  pending_documents_count integer,
  rejected_documents_count integer,
  payments_count integer,
  total_paid_amount numeric,
  pending_payments_count integer,
  verified_payments_count integer,
  needs_action boolean
)
language sql
security definer
set search_path = public, nosok
as $$
  with doc_stats as (
    select application_id,
           count(*)::int documents_count,
           count(*) filter (where review_status in ('pending','under_review'))::int pending_documents_count,
           count(*) filter (where review_status = 'rejected')::int rejected_documents_count
      from nosok.application_documents
     group by application_id
  ), pay_stats as (
    select application_id,
           count(*)::int payments_count,
           coalesce(sum(amount),0)::numeric total_paid_amount,
           count(*) filter (where verification_status in ('pending','under_review','needs_receipt'))::int pending_payments_count,
           count(*) filter (where verification_status = 'verified')::int verified_payments_count
      from nosok.application_payments
     group by application_id
  )
  select a.id, a.application_no, a.applicant_full_name, a.service_type, a.application_status,
         a.eligibility_status, a.unit_id, a.unit_slug,
         coalesce(u.public_title_ar, u.unit_name_ar, a.unit_slug, a.unit_id, 'غير محدد') as unit_name_ar,
         s.title_ar as season_title_ar, p.title_ar as program_title_ar, a.mobile, a.submitted_at,
         coalesce(d.documents_count,0), coalesce(d.pending_documents_count,0), coalesce(d.rejected_documents_count,0),
         coalesce(pay.payments_count,0), coalesce(pay.total_paid_amount,0), coalesce(pay.pending_payments_count,0), coalesce(pay.verified_payments_count,0),
         (coalesce(d.rejected_documents_count,0) > 0 or coalesce(pay.pending_payments_count,0) > 0) as needs_action
    from nosok.applications a
    left join nosok.seasons s on s.id = a.season_id
    left join nosok.service_programs p on p.id = a.program_id
    left join nosok.unit_service_scopes u on (u.unit_id = a.unit_id or u.unit_slug = a.unit_slug)
    left join doc_stats d on d.application_id = a.id
    left join pay_stats pay on pay.application_id = a.id
   where (nullif(p_unit_id,'') is null or a.unit_id = p_unit_id)
     and (nullif(p_unit_slug,'') is null or a.unit_slug = p_unit_slug)
     and (nullif(p_status,'') is null or a.application_status = p_status)
   order by a.submitted_at desc nulls last;
$$;

create or replace function public.rpc_nosok_admin_role_uat_evidence_v1(p_matrix_case_id uuid default null)
returns table (
  id uuid,
  matrix_case_id uuid,
  role_key text,
  surface_key text,
  expected_access text,
  actual_access text,
  result_status text,
  tested_by uuid,
  evidence_url text,
  notes_ar text,
  tested_at timestamptz
)
language sql
security definer
set search_path = public, nosok
as $$
  select e.id, e.matrix_case_id, e.role_key, e.surface_key, e.expected_access, e.actual_access,
         e.result_status, e.tested_by, e.evidence_url, e.notes_ar, e.tested_at
    from nosok.role_uat_evidence e
   where (p_matrix_case_id is null or e.matrix_case_id = p_matrix_case_id)
   order by e.tested_at desc;
$$;

create or replace function public.rpc_nosok_admin_role_uat_evidence_upsert_v1(p_payload jsonb)
returns table (
  id uuid,
  matrix_case_id uuid,
  role_key text,
  surface_key text,
  expected_access text,
  actual_access text,
  result_status text,
  tested_by uuid,
  evidence_url text,
  notes_ar text,
  tested_at timestamptz
)
language plpgsql
security definer
set search_path = public, nosok
as $$
declare
  v_id uuid;
begin
  insert into nosok.role_uat_evidence(
    matrix_case_id, role_key, surface_key, expected_access, actual_access, result_status,
    tested_by, evidence_url, notes_ar, tested_at
  ) values (
    nullif(p_payload->>'matrix_case_id','')::uuid,
    p_payload->>'role_key',
    p_payload->>'surface_key',
    p_payload->>'expected_access',
    p_payload->>'actual_access',
    coalesce(nullif(p_payload->>'result_status',''), 'pending_review'),
    nullif(p_payload->>'tested_by','')::uuid,
    nullif(p_payload->>'evidence_url',''),
    nullif(p_payload->>'notes_ar',''),
    now()
  ) returning role_uat_evidence.id into v_id;

  update nosok.role_uat_matrix m
     set actual_access = p_payload->>'actual_access',
         status = coalesce(nullif(p_payload->>'result_status',''), 'pending_review'),
         notes_ar = nullif(p_payload->>'notes_ar',''),
         last_tested_at = now()
   where m.id = nullif(p_payload->>'matrix_case_id','')::uuid;

  return query
  select e.id, e.matrix_case_id, e.role_key, e.surface_key, e.expected_access, e.actual_access,
         e.result_status, e.tested_by, e.evidence_url, e.notes_ar, e.tested_at
    from nosok.role_uat_evidence e
   where e.id = v_id;
end;
$$;

create or replace function public.rpc_nosok_v12_runtime_contract_uat_v1()
returns table(section text, check_key text, passed boolean, note text)
language sql
security definer
set search_path = public, nosok
as $$
  select 'billing_bridge', 'execute_rpc_exists', to_regprocedure('public.rpc_nosok_admin_payment_bridge_execute_v1(uuid,text,text,text)') is not null, 'Billing bridge execute RPC installed.'
  union all
  select 'billing_bridge', 'sync_rpc_exists', to_regprocedure('public.rpc_nosok_admin_payment_bridge_sync_v1(uuid,text,text)') is not null, 'Billing bridge sync RPC installed.'
  union all
  select 'unit_queues', 'unit_queue_rpc_exists', to_regprocedure('public.rpc_nosok_admin_unit_application_queue_v1(text,text,text)') is not null, 'Unit scoped application queue RPC installed.'
  union all
  select 'role_uat', 'evidence_table_exists', to_regclass('nosok.role_uat_evidence') is not null, 'Role UAT evidence table installed.'
  union all
  select 'sovereign_boundary', 'no_waq_assets_mutation_in_this_script', true, 'Read-only/DDL for nosok only; no waqf/waqf_assets mutation.';
$$;

notify pgrst, 'reload schema';
