create or replace function public.rpc_nosok_admin_dashboard_summary_v1()
returns table (
  active_seasons_count integer,
  active_programs_count integer,
  published_companies_count integer,
  open_complaints_count integer,
  pending_applications_count integer
)
language sql
security definer
set search_path = public, nosok
as $$
  select
    (select count(*)::int from nosok.seasons where status = 'open') as active_seasons_count,
    (select count(*)::int from nosok.service_programs where status = 'active') as active_programs_count,
    (select count(*)::int from nosok.qualified_companies where is_publicly_visible = true) as published_companies_count,
    (select count(*)::int from nosok.complaints where status in ('submitted', 'under_review', 'in_progress')) as open_complaints_count,
    (select count(*)::int from nosok.applications where application_status in ('submitted', 'under_review')) as pending_applications_count
$$;

create or replace function public.rpc_nosok_admin_season_upsert_v1(
  p_id uuid default null,
  p_season_code text default null,
  p_title_ar text default null,
  p_title_en text default null,
  p_service_type text default 'hajj',
  p_hijri_year integer default null,
  p_gregorian_year integer default null,
  p_registration_start_at timestamptz default null,
  p_registration_end_at timestamptz default null,
  p_status text default 'draft',
  p_notes text default null,
  p_is_publicly_visible boolean default false
)
returns table (
  id uuid,
  season_code text,
  title_ar text,
  title_en text,
  service_type text,
  hijri_year integer,
  gregorian_year integer,
  registration_start_at timestamptz,
  registration_end_at timestamptz,
  status text,
  notes text,
  is_publicly_visible boolean
)
language plpgsql
security definer
set search_path = public, nosok
as $$
declare
  v_row nosok.seasons%rowtype;
begin
  if p_id is null then
    insert into nosok.seasons (
      season_code,
      title_ar,
      title_en,
      service_type,
      hijri_year,
      gregorian_year,
      registration_start_at,
      registration_end_at,
      status,
      notes,
      is_publicly_visible
    )
    values (
      p_season_code,
      p_title_ar,
      p_title_en,
      p_service_type,
      p_hijri_year,
      p_gregorian_year,
      p_registration_start_at,
      p_registration_end_at,
      p_status,
      p_notes,
      p_is_publicly_visible
    )
    returning * into v_row;
  else
    update nosok.seasons
    set
      season_code = coalesce(p_season_code, season_code),
      title_ar = coalesce(p_title_ar, title_ar),
      title_en = p_title_en,
      service_type = coalesce(p_service_type, service_type),
      hijri_year = p_hijri_year,
      gregorian_year = p_gregorian_year,
      registration_start_at = p_registration_start_at,
      registration_end_at = p_registration_end_at,
      status = coalesce(p_status, status),
      notes = p_notes,
      is_publicly_visible = coalesce(p_is_publicly_visible, is_publicly_visible),
      updated_at = now()
    where id = p_id
    returning * into v_row;
  end if;

  return query
  select
    v_row.id,
    v_row.season_code,
    v_row.title_ar,
    v_row.title_en,
    v_row.service_type,
    v_row.hijri_year,
    v_row.gregorian_year,
    v_row.registration_start_at,
    v_row.registration_end_at,
    v_row.status,
    v_row.notes,
    v_row.is_publicly_visible;
end;
$$;

create or replace function public.rpc_nosok_admin_season_delete_v1(p_id uuid)
returns boolean
language plpgsql
security definer
set search_path = public, nosok
as $$
begin
  delete from nosok.seasons where id = p_id;
  return true;
end;
$$;

create or replace function public.rpc_nosok_admin_program_upsert_v1(
  p_id uuid default null,
  p_season_id uuid default null,
  p_code text default null,
  p_title_ar text default null,
  p_title_en text default null,
  p_service_type text default 'hajj',
  p_description text default null,
  p_registration_start_at timestamptz default null,
  p_registration_end_at timestamptz default null,
  p_max_companions integer default 0,
  p_notes text default null,
  p_status text default 'draft',
  p_is_publicly_visible boolean default false
)
returns table (
  id uuid,
  season_id uuid,
  code text,
  title_ar text,
  title_en text,
  service_type text,
  description text,
  registration_start_at timestamptz,
  registration_end_at timestamptz,
  max_companions integer,
  notes text,
  status text,
  is_publicly_visible boolean
)
language plpgsql
security definer
set search_path = public, nosok
as $$
declare
  v_row nosok.service_programs%rowtype;
begin
  if p_id is null then
    insert into nosok.service_programs (
      season_id,
      code,
      title_ar,
      title_en,
      service_type,
      description,
      registration_start_at,
      registration_end_at,
      max_companions,
      notes,
      status,
      is_publicly_visible
    )
    values (
      p_season_id,
      p_code,
      p_title_ar,
      p_title_en,
      p_service_type,
      p_description,
      p_registration_start_at,
      p_registration_end_at,
      coalesce(p_max_companions, 0),
      p_notes,
      p_status,
      p_is_publicly_visible
    )
    returning * into v_row;
  else
    update nosok.service_programs
    set
      season_id = coalesce(p_season_id, season_id),
      code = coalesce(p_code, code),
      title_ar = coalesce(p_title_ar, title_ar),
      title_en = p_title_en,
      service_type = coalesce(p_service_type, service_type),
      description = p_description,
      registration_start_at = p_registration_start_at,
      registration_end_at = p_registration_end_at,
      max_companions = coalesce(p_max_companions, max_companions),
      notes = p_notes,
      status = coalesce(p_status, status),
      is_publicly_visible = coalesce(p_is_publicly_visible, is_publicly_visible),
      updated_at = now()
    where id = p_id
    returning * into v_row;
  end if;

  return query
  select
    v_row.id,
    v_row.season_id,
    v_row.code,
    v_row.title_ar,
    v_row.title_en,
    v_row.service_type,
    v_row.description,
    v_row.registration_start_at,
    v_row.registration_end_at,
    v_row.max_companions,
    v_row.notes,
    v_row.status,
    v_row.is_publicly_visible;
end;
$$;

create or replace function public.rpc_nosok_admin_program_delete_v1(p_id uuid)
returns boolean
language plpgsql
security definer
set search_path = public, nosok
as $$
begin
  delete from nosok.service_programs where id = p_id;
  return true;
end;
$$;

create or replace function public.rpc_nosok_admin_company_upsert_v1(
  p_id uuid default null,
  p_company_name_ar text default null,
  p_company_name_en text default null,
  p_license_no text default null,
  p_phone text default null,
  p_mobile text default null,
  p_email text default null,
  p_address_text text default null,
  p_governorate_id uuid default null,
  p_unit_id uuid default null,
  p_status text default 'draft',
  p_is_publicly_visible boolean default false,
  p_notes text default null
)
returns table (
  id uuid,
  company_name_ar text,
  company_name_en text,
  license_no text,
  phone text,
  mobile text,
  email text,
  address_text text,
  governorate_id uuid,
  unit_id uuid,
  status text,
  is_publicly_visible boolean,
  notes text
)
language plpgsql
security definer
set search_path = public, nosok
as $$
declare
  v_row nosok.qualified_companies%rowtype;
begin
  if p_id is null then
    insert into nosok.qualified_companies (
      company_name_ar,
      company_name_en,
      license_no,
      phone,
      mobile,
      email,
      address_text,
      governorate_id,
      unit_id,
      status,
      is_publicly_visible,
      notes
    )
    values (
      p_company_name_ar,
      p_company_name_en,
      p_license_no,
      p_phone,
      p_mobile,
      p_email,
      p_address_text,
      p_governorate_id,
      p_unit_id,
      p_status,
      p_is_publicly_visible,
      p_notes
    )
    returning * into v_row;
  else
    update nosok.qualified_companies
    set
      company_name_ar = coalesce(p_company_name_ar, company_name_ar),
      company_name_en = p_company_name_en,
      license_no = p_license_no,
      phone = p_phone,
      mobile = p_mobile,
      email = p_email,
      address_text = p_address_text,
      governorate_id = p_governorate_id,
      unit_id = p_unit_id,
      status = coalesce(p_status, status),
      is_publicly_visible = coalesce(p_is_publicly_visible, is_publicly_visible),
      notes = p_notes,
      updated_at = now()
    where id = p_id
    returning * into v_row;
  end if;

  return query
  select
    v_row.id,
    v_row.company_name_ar,
    v_row.company_name_en,
    v_row.license_no,
    v_row.phone,
    v_row.mobile,
    v_row.email,
    v_row.address_text,
    v_row.governorate_id,
    v_row.unit_id,
    v_row.status,
    v_row.is_publicly_visible,
    v_row.notes;
end;
$$;

create or replace function public.rpc_nosok_admin_company_delete_v1(p_id uuid)
returns boolean
language plpgsql
security definer
set search_path = public, nosok
as $$
begin
  delete from nosok.qualified_companies where id = p_id;
  return true;
end;
$$;


-- =========================================================
-- v07 admin additions
-- =========================================================

create or replace function public.rpc_nosok_admin_company_qualifications_list_v1(
  p_company_id uuid default null,
  p_season_id uuid default null
)
returns table (
  id uuid,
  company_id uuid,
  season_id uuid,
  season_title_ar text,
  qualification_status text,
  is_publicly_visible boolean,
  qualification_notes text,
  starts_at timestamptz,
  ends_at timestamptz
)
language sql
security definer
set search_path = public, nosok
as $$
  select
    q.id,
    q.company_id,
    q.season_id,
    s.title_ar as season_title_ar,
    q.qualification_status,
    q.is_publicly_visible,
    q.qualification_notes,
    q.starts_at,
    q.ends_at
  from nosok.company_season_qualifications q
  join nosok.seasons s on s.id = q.season_id
  where (p_company_id is null or q.company_id = p_company_id)
    and (p_season_id is null or q.season_id = p_season_id)
  order by s.gregorian_year desc nulls last, s.title_ar asc
$$;

create or replace function public.rpc_nosok_admin_company_qualification_upsert_v1(
  p_id uuid default null,
  p_company_id uuid default null,
  p_season_id uuid default null,
  p_qualification_status text default 'draft',
  p_is_publicly_visible boolean default false,
  p_qualification_notes text default null,
  p_starts_at timestamptz default null,
  p_ends_at timestamptz default null
)
returns table (
  id uuid,
  company_id uuid,
  season_id uuid,
  season_title_ar text,
  qualification_status text,
  is_publicly_visible boolean,
  qualification_notes text,
  starts_at timestamptz,
  ends_at timestamptz
)
language plpgsql
security definer
set search_path = public, nosok
as $$
declare
  v_row nosok.company_season_qualifications%rowtype;
  v_season_title text;
begin
  if p_id is null then
    insert into nosok.company_season_qualifications (
      company_id,
      season_id,
      qualification_status,
      is_publicly_visible,
      qualification_notes,
      starts_at,
      ends_at
    )
    values (
      p_company_id,
      p_season_id,
      p_qualification_status,
      coalesce(p_is_publicly_visible, false),
      p_qualification_notes,
      p_starts_at,
      p_ends_at
    )
    returning * into v_row;
  else
    update nosok.company_season_qualifications
    set
      company_id = coalesce(p_company_id, company_id),
      season_id = coalesce(p_season_id, season_id),
      qualification_status = coalesce(p_qualification_status, qualification_status),
      is_publicly_visible = coalesce(p_is_publicly_visible, is_publicly_visible),
      qualification_notes = p_qualification_notes,
      starts_at = p_starts_at,
      ends_at = p_ends_at,
      updated_at = now()
    where id = p_id
    returning * into v_row;
  end if;

  select title_ar into v_season_title from nosok.seasons where id = v_row.season_id;

  return query
  select
    v_row.id,
    v_row.company_id,
    v_row.season_id,
    v_season_title,
    v_row.qualification_status,
    v_row.is_publicly_visible,
    v_row.qualification_notes,
    v_row.starts_at,
    v_row.ends_at;
end;
$$;

create or replace function public.rpc_nosok_admin_company_qualification_delete_v1(p_id uuid)
returns boolean
language plpgsql
security definer
set search_path = public, nosok
as $$
begin
  delete from nosok.company_season_qualifications where id = p_id;
  return true;
end;
$$;

create or replace function public.rpc_nosok_admin_application_documents_list_v1(
  p_application_id uuid
)
returns table (
  id uuid,
  application_id uuid,
  document_type text,
  document_title text,
  original_file_name text,
  file_url text,
  storage_bucket text,
  storage_path text,
  mime_type text,
  file_size_bytes bigint,
  review_status text,
  review_notes text,
  notes text,
  uploaded_at timestamptz,
  reviewed_at timestamptz
)
language sql
security definer
set search_path = public, nosok
as $$
  select
    d.id,
    d.application_id,
    d.document_type,
    d.document_title,
    d.original_file_name,
    d.file_url,
    d.storage_bucket,
    d.storage_path,
    d.mime_type,
    d.file_size_bytes,
    d.review_status,
    d.review_notes,
    d.notes,
    d.uploaded_at,
    d.reviewed_at
  from nosok.application_documents d
  where d.application_id = p_application_id
  order by d.uploaded_at desc
$$;

create or replace function public.rpc_nosok_admin_application_document_upsert_v1(
  p_id uuid default null,
  p_application_id uuid default null,
  p_document_type text default null,
  p_document_title text default null,
  p_original_file_name text default null,
  p_file_url text default null,
  p_storage_bucket text default null,
  p_storage_path text default null,
  p_mime_type text default null,
  p_file_size_bytes bigint default null,
  p_review_status text default 'pending',
  p_review_notes text default null,
  p_notes text default null
)
returns table (
  id uuid,
  application_id uuid,
  document_type text,
  document_title text,
  original_file_name text,
  file_url text,
  storage_bucket text,
  storage_path text,
  mime_type text,
  file_size_bytes bigint,
  review_status text,
  review_notes text,
  notes text,
  uploaded_at timestamptz,
  reviewed_at timestamptz
)
language plpgsql
security definer
set search_path = public, nosok
as $$
declare
  v_row nosok.application_documents%rowtype;
begin
  if p_id is null then
    insert into nosok.application_documents (
      application_id,
      document_type,
      document_title,
      original_file_name,
      file_url,
      storage_bucket,
      storage_path,
      mime_type,
      file_size_bytes,
      review_status,
      review_notes,
      notes
    ) values (
      p_application_id,
      p_document_type,
      p_document_title,
      p_original_file_name,
      p_file_url,
      p_storage_bucket,
      p_storage_path,
      p_mime_type,
      p_file_size_bytes,
      coalesce(p_review_status, 'pending'),
      p_review_notes,
      p_notes
    ) returning * into v_row;
  else
    update nosok.application_documents
    set
      application_id = coalesce(p_application_id, application_id),
      document_type = coalesce(p_document_type, document_type),
      document_title = p_document_title,
      original_file_name = p_original_file_name,
      file_url = p_file_url,
      storage_bucket = p_storage_bucket,
      storage_path = p_storage_path,
      mime_type = p_mime_type,
      file_size_bytes = p_file_size_bytes,
      review_status = coalesce(p_review_status, review_status),
      review_notes = p_review_notes,
      notes = p_notes,
      reviewed_at = case when p_review_status in ('approved','rejected') then now() else reviewed_at end
    where id = p_id
    returning * into v_row;
  end if;

  return query
  select
    v_row.id,
    v_row.application_id,
    v_row.document_type,
    v_row.document_title,
    v_row.original_file_name,
    v_row.file_url,
    v_row.storage_bucket,
    v_row.storage_path,
    v_row.mime_type,
    v_row.file_size_bytes,
    v_row.review_status,
    v_row.review_notes,
    v_row.notes,
    v_row.uploaded_at,
    v_row.reviewed_at;
end;
$$;

create or replace function public.rpc_nosok_admin_application_document_delete_v1(p_id uuid)
returns boolean
language plpgsql
security definer
set search_path = public, nosok
as $$
begin
  delete from nosok.application_documents where id = p_id;
  return true;
end;
$$;

create or replace function public.rpc_nosok_admin_application_payments_list_v1(
  p_application_id uuid
)
returns table (
  id uuid,
  application_id uuid,
  payment_type text,
  amount numeric,
  currency_code text,
  payment_reference text,
  payment_method text,
  provider_name text,
  external_transaction_id text,
  receipt_url text,
  paid_at timestamptz,
  payment_status text,
  notes text
)
language sql
security definer
set search_path = public, nosok
as $$
  select
    p.id,
    p.application_id,
    p.payment_type,
    p.amount,
    p.currency_code,
    p.payment_reference,
    p.payment_method,
    p.provider_name,
    p.external_transaction_id,
    p.receipt_url,
    p.paid_at,
    p.payment_status,
    p.notes
  from nosok.application_payments p
  where p.application_id = p_application_id
  order by coalesce(p.paid_at, p.created_at) desc
$$;

create or replace function public.rpc_nosok_admin_application_payment_upsert_v1(
  p_id uuid default null,
  p_application_id uuid default null,
  p_payment_type text default null,
  p_amount numeric default 0,
  p_currency_code text default 'ILS',
  p_payment_reference text default null,
  p_payment_method text default null,
  p_provider_name text default null,
  p_external_transaction_id text default null,
  p_receipt_url text default null,
  p_paid_at timestamptz default null,
  p_payment_status text default 'pending',
  p_notes text default null
)
returns table (
  id uuid,
  application_id uuid,
  payment_type text,
  amount numeric,
  currency_code text,
  payment_reference text,
  payment_method text,
  provider_name text,
  external_transaction_id text,
  receipt_url text,
  paid_at timestamptz,
  payment_status text,
  notes text
)
language plpgsql
security definer
set search_path = public, nosok
as $$
declare
  v_row nosok.application_payments%rowtype;
begin
  if p_id is null then
    insert into nosok.application_payments (
      application_id,
      payment_type,
      amount,
      currency_code,
      payment_reference,
      payment_method,
      provider_name,
      external_transaction_id,
      receipt_url,
      paid_at,
      payment_status,
      notes
    ) values (
      p_application_id,
      p_payment_type,
      coalesce(p_amount, 0),
      coalesce(p_currency_code, 'ILS'),
      p_payment_reference,
      p_payment_method,
      p_provider_name,
      p_external_transaction_id,
      p_receipt_url,
      p_paid_at,
      coalesce(p_payment_status, 'pending'),
      p_notes
    ) returning * into v_row;
  else
    update nosok.application_payments
    set
      application_id = coalesce(p_application_id, application_id),
      payment_type = coalesce(p_payment_type, payment_type),
      amount = coalesce(p_amount, amount),
      currency_code = coalesce(p_currency_code, currency_code),
      payment_reference = p_payment_reference,
      payment_method = p_payment_method,
      provider_name = p_provider_name,
      external_transaction_id = p_external_transaction_id,
      receipt_url = p_receipt_url,
      paid_at = p_paid_at,
      payment_status = coalesce(p_payment_status, payment_status),
      notes = p_notes,
      verified_at = case when p_payment_status = 'paid' then now() else verified_at end
    where id = p_id
    returning * into v_row;
  end if;

  return query
  select
    v_row.id,
    v_row.application_id,
    v_row.payment_type,
    v_row.amount,
    v_row.currency_code,
    v_row.payment_reference,
    v_row.payment_method,
    v_row.provider_name,
    v_row.external_transaction_id,
    v_row.receipt_url,
    v_row.paid_at,
    v_row.payment_status,
    v_row.notes;
end;
$$;

create or replace function public.rpc_nosok_admin_application_payment_delete_v1(p_id uuid)
returns boolean
language plpgsql
security definer
set search_path = public, nosok
as $$
begin
  delete from nosok.application_payments where id = p_id;
  return true;
end;
$$;


-- =========================================================
-- v08 admin operations
-- =========================================================

create or replace function public.rpc_nosok_admin_applications_list_v1(
  p_query text default null
)
returns table (
  id uuid,
  season_id uuid,
  program_id uuid,
  application_no text,
  tracking_token text,
  tracking_token_issued_at timestamptz,
  service_type text,
  applicant_full_name text,
  national_id text,
  application_status text,
  eligibility_status text,
  phone text,
  mobile text,
  email text,
  submitted_at timestamptz,
  reviewed_at timestamptz,
  season_title_ar text,
  program_title_ar text,
  documents_count integer,
  payments_count integer,
  total_paid_amount numeric,
  last_payment_status text
)
language sql
security definer
set search_path = public, nosok
as $$
  select
    a.id,
    a.season_id,
    a.program_id,
    a.application_no,
    a.tracking_token,
    a.tracking_token_issued_at,
    a.service_type,
    a.applicant_full_name,
    a.national_id,
    a.application_status,
    a.eligibility_status,
    a.phone,
    a.mobile,
    a.email,
    a.submitted_at,
    a.reviewed_at,
    s.title_ar as season_title_ar,
    p.title_ar as program_title_ar,
    coalesce(d.documents_count, 0)::int as documents_count,
    coalesce(pay.payments_count, 0)::int as payments_count,
    coalesce(pay.total_paid_amount, 0) as total_paid_amount,
    pay.last_payment_status
  from nosok.applications a
  left join nosok.seasons s on s.id = a.season_id
  left join nosok.service_programs p on p.id = a.program_id
  left join (
    select application_id, count(*) as documents_count
    from nosok.application_documents
    group by application_id
  ) d on d.application_id = a.id
  left join (
    select
      application_id,
      count(*) as payments_count,
      sum(amount) filter (where payment_status in ('paid','pending')) as total_paid_amount,
      (array_agg(payment_status order by coalesce(paid_at, created_at) desc))[1] as last_payment_status
    from nosok.application_payments
    group by application_id
  ) pay on pay.application_id = a.id
  where (
    p_query is null
    or a.application_no ilike '%' || p_query || '%'
    or a.tracking_token ilike '%' || p_query || '%'
    or a.applicant_full_name ilike '%' || p_query || '%'
    or a.national_id ilike '%' || p_query || '%'
  )
  order by a.submitted_at desc nulls last, a.created_at desc
$$;

create or replace function public.rpc_nosok_admin_application_detail_v1(
  p_application_id uuid
)
returns table (
  id uuid,
  season_id uuid,
  program_id uuid,
  application_no text,
  tracking_token text,
  tracking_token_issued_at timestamptz,
  service_type text,
  applicant_full_name text,
  national_id text,
  application_status text,
  eligibility_status text,
  phone text,
  mobile text,
  email text,
  submitted_at timestamptz,
  reviewed_at timestamptz,
  season_title_ar text,
  program_title_ar text,
  documents_count integer,
  payments_count integer,
  total_paid_amount numeric,
  last_payment_status text
)
language sql
security definer
set search_path = public, nosok
as $$
  select * from public.rpc_nosok_admin_applications_list_v1(null)
  where id = p_application_id
$$;

create or replace function public.rpc_nosok_admin_application_companions_list_v1(
  p_application_id uuid
)
returns table (
  id uuid,
  application_id uuid,
  full_name text,
  national_id text,
  relation_type text,
  birth_date date,
  phone text,
  notes text
)
language sql
security definer
set search_path = public, nosok
as $$
  select
    c.id,
    c.application_id,
    c.full_name,
    c.national_id,
    c.relation_type,
    c.birth_date,
    c.phone,
    c.notes
  from nosok.application_companions c
  where c.application_id = p_application_id
  order by c.created_at asc
$$;

create or replace function public.rpc_nosok_admin_application_reviews_list_v1(
  p_application_id uuid
)
returns table (
  id uuid,
  application_id uuid,
  reviewer_user_id uuid,
  review_action text,
  review_reason text,
  created_at timestamptz
)
language sql
security definer
set search_path = public, nosok
as $$
  select
    r.id,
    r.application_id,
    r.reviewer_user_id,
    r.review_action,
    r.review_reason,
    r.created_at
  from nosok.application_reviews r
  where r.application_id = p_application_id
  order by r.created_at desc
$$;

create or replace function public.rpc_nosok_admin_application_update_status_v1(
  p_application_id uuid,
  p_application_status text,
  p_eligibility_status text default null,
  p_review_reason text default null
)
returns table (
  id uuid,
  season_id uuid,
  program_id uuid,
  application_no text,
  tracking_token text,
  tracking_token_issued_at timestamptz,
  service_type text,
  applicant_full_name text,
  national_id text,
  application_status text,
  eligibility_status text,
  phone text,
  mobile text,
  email text,
  submitted_at timestamptz,
  reviewed_at timestamptz,
  season_title_ar text,
  program_title_ar text,
  documents_count integer,
  payments_count integer,
  total_paid_amount numeric,
  last_payment_status text
)
language plpgsql
security definer
set search_path = public, nosok
as $$
declare
  v_row nosok.applications%rowtype;
begin
  update nosok.applications
  set
    application_status = coalesce(p_application_status, application_status),
    eligibility_status = coalesce(p_eligibility_status, eligibility_status),
    reviewed_at = now()
  where id = p_application_id
  returning * into v_row;

  insert into nosok.application_reviews (
    application_id,
    review_action,
    review_reason
  ) values (
    p_application_id,
    'status_update',
    p_review_reason
  );

  return query
  select * from public.rpc_nosok_admin_application_detail_v1(v_row.id);
end;
$$;

drop function if exists public.rpc_nosok_admin_application_payments_list_v1(uuid);
create or replace function public.rpc_nosok_admin_application_payments_list_v1(
  p_application_id uuid
)
returns table (
  id uuid,
  application_id uuid,
  payment_type text,
  amount numeric,
  currency_code text,
  payment_reference text,
  payment_method text,
  provider_name text,
  external_transaction_id text,
  receipt_url text,
  receipt_storage_bucket text,
  receipt_storage_path text,
  receipt_original_file_name text,
  receipt_mime_type text,
  receipt_file_size_bytes bigint,
  paid_at timestamptz,
  payment_status text,
  verification_status text,
  verification_notes text,
  verified_at timestamptz,
  notes text
)
language sql
security definer
set search_path = public, nosok
as $$
  select
    p.id,
    p.application_id,
    p.payment_type,
    p.amount,
    p.currency_code,
    p.payment_reference,
    p.payment_method,
    p.provider_name,
    p.external_transaction_id,
    p.receipt_url,
    p.receipt_storage_bucket,
    p.receipt_storage_path,
    p.receipt_original_file_name,
    p.receipt_mime_type,
    p.receipt_file_size_bytes,
    p.paid_at,
    p.payment_status,
    p.verification_status,
    p.verification_notes,
    p.verified_at,
    p.notes
  from nosok.application_payments p
  where p.application_id = p_application_id
  order by coalesce(p.paid_at, p.created_at) desc
$$;

drop function if exists public.rpc_nosok_admin_application_payment_upsert_v1(uuid,uuid,text,numeric,text,text,text,text,text,text,timestamptz,text,text);
create or replace function public.rpc_nosok_admin_application_payment_upsert_v1(
  p_id uuid default null,
  p_application_id uuid default null,
  p_payment_type text default null,
  p_amount numeric default 0,
  p_currency_code text default 'ILS',
  p_payment_reference text default null,
  p_payment_method text default null,
  p_provider_name text default null,
  p_external_transaction_id text default null,
  p_receipt_url text default null,
  p_receipt_storage_bucket text default null,
  p_receipt_storage_path text default null,
  p_receipt_original_file_name text default null,
  p_receipt_mime_type text default null,
  p_receipt_file_size_bytes bigint default null,
  p_paid_at timestamptz default null,
  p_payment_status text default 'pending',
  p_verification_status text default 'pending',
  p_verification_notes text default null,
  p_notes text default null
)
returns table (
  id uuid,
  application_id uuid,
  payment_type text,
  amount numeric,
  currency_code text,
  payment_reference text,
  payment_method text,
  provider_name text,
  external_transaction_id text,
  receipt_url text,
  receipt_storage_bucket text,
  receipt_storage_path text,
  receipt_original_file_name text,
  receipt_mime_type text,
  receipt_file_size_bytes bigint,
  paid_at timestamptz,
  payment_status text,
  verification_status text,
  verification_notes text,
  verified_at timestamptz,
  notes text
)
language plpgsql
security definer
set search_path = public, nosok
as $$
declare
  v_row nosok.application_payments%rowtype;
begin
  if p_id is null then
    insert into nosok.application_payments (
      application_id,
      payment_type,
      amount,
      currency_code,
      payment_reference,
      payment_method,
      provider_name,
      external_transaction_id,
      receipt_url,
      receipt_storage_bucket,
      receipt_storage_path,
      receipt_original_file_name,
      receipt_mime_type,
      receipt_file_size_bytes,
      paid_at,
      payment_status,
      verification_status,
      verification_notes,
      notes
    ) values (
      p_application_id,
      p_payment_type,
      coalesce(p_amount, 0),
      coalesce(p_currency_code, 'ILS'),
      p_payment_reference,
      p_payment_method,
      p_provider_name,
      p_external_transaction_id,
      p_receipt_url,
      p_receipt_storage_bucket,
      p_receipt_storage_path,
      p_receipt_original_file_name,
      p_receipt_mime_type,
      p_receipt_file_size_bytes,
      p_paid_at,
      coalesce(p_payment_status, 'pending'),
      coalesce(p_verification_status, 'pending'),
      p_verification_notes,
      p_notes
    ) returning * into v_row;
  else
    update nosok.application_payments
    set
      application_id = coalesce(p_application_id, application_id),
      payment_type = coalesce(p_payment_type, payment_type),
      amount = coalesce(p_amount, amount),
      currency_code = coalesce(p_currency_code, currency_code),
      payment_reference = p_payment_reference,
      payment_method = p_payment_method,
      provider_name = p_provider_name,
      external_transaction_id = p_external_transaction_id,
      receipt_url = p_receipt_url,
      receipt_storage_bucket = p_receipt_storage_bucket,
      receipt_storage_path = p_receipt_storage_path,
      receipt_original_file_name = p_receipt_original_file_name,
      receipt_mime_type = p_receipt_mime_type,
      receipt_file_size_bytes = p_receipt_file_size_bytes,
      paid_at = p_paid_at,
      payment_status = coalesce(p_payment_status, payment_status),
      verification_status = coalesce(p_verification_status, verification_status),
      verification_notes = p_verification_notes,
      verified_at = case when coalesce(p_verification_status, verification_status) = 'verified' then now() else verified_at end,
      notes = p_notes
    where id = p_id
    returning * into v_row;
  end if;

  return query
  select
    v_row.id,
    v_row.application_id,
    v_row.payment_type,
    v_row.amount,
    v_row.currency_code,
    v_row.payment_reference,
    v_row.payment_method,
    v_row.provider_name,
    v_row.external_transaction_id,
    v_row.receipt_url,
    v_row.receipt_storage_bucket,
    v_row.receipt_storage_path,
    v_row.receipt_original_file_name,
    v_row.receipt_mime_type,
    v_row.receipt_file_size_bytes,
    v_row.paid_at,
    v_row.payment_status,
    v_row.verification_status,
    v_row.verification_notes,
    v_row.verified_at,
    v_row.notes;
end;
$$;

create or replace function public.rpc_nosok_admin_application_payment_verify_v1(
  p_payment_id uuid,
  p_application_id uuid,
  p_verification_status text,
  p_verification_notes text default null,
  p_payment_status text default null
)
returns table (
  id uuid,
  application_id uuid,
  payment_type text,
  amount numeric,
  currency_code text,
  payment_reference text,
  payment_method text,
  provider_name text,
  external_transaction_id text,
  receipt_url text,
  receipt_storage_bucket text,
  receipt_storage_path text,
  receipt_original_file_name text,
  receipt_mime_type text,
  receipt_file_size_bytes bigint,
  paid_at timestamptz,
  payment_status text,
  verification_status text,
  verification_notes text,
  verified_at timestamptz,
  notes text
)
language plpgsql
security definer
set search_path = public, nosok
as $$
declare
  v_row nosok.application_payments%rowtype;
  v_action text;
begin
  update nosok.application_payments
  set
    verification_status = coalesce(p_verification_status, verification_status),
    verification_notes = p_verification_notes,
    verified_at = now(),
    payment_status = coalesce(p_payment_status, payment_status),
    paid_at = case when coalesce(p_payment_status, payment_status) = 'paid' and paid_at is null then now() else paid_at end
  where id = p_payment_id
  returning * into v_row;

  v_action := case when p_verification_status = 'verified' then 'verify_payment' when p_verification_status = 'rejected' then 'reject_payment' else 'mark_needs_review' end;

  insert into nosok.application_reviews (
    application_id,
    review_action,
    review_reason
  ) values (
    p_application_id,
    v_action,
    p_verification_notes
  );

  return query
  select
    v_row.id,
    v_row.application_id,
    v_row.payment_type,
    v_row.amount,
    v_row.currency_code,
    v_row.payment_reference,
    v_row.payment_method,
    v_row.provider_name,
    v_row.external_transaction_id,
    v_row.receipt_url,
    v_row.receipt_storage_bucket,
    v_row.receipt_storage_path,
    v_row.receipt_original_file_name,
    v_row.receipt_mime_type,
    v_row.receipt_file_size_bytes,
    v_row.paid_at,
    v_row.payment_status,
    v_row.verification_status,
    v_row.verification_notes,
    v_row.verified_at,
    v_row.notes;
end;
$$;
