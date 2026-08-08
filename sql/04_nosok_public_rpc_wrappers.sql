-- Public wrappers for Nosok under PalWakf
-- Keep Flutter/web reads on controlled wrappers when practical.

create or replace function public.rpc_nosok_public_announcements_list_v1()
returns table (
  id uuid,
  title_ar text,
  body_ar text,
  priority integer,
  is_published boolean
)
language sql
security definer
set search_path = public, nosok
as $$
  select
    a.id,
    a.title_ar,
    a.body_ar,
    a.display_order as priority,
    a.is_published
  from nosok.system_announcements a
  where a.is_published = true
  order by a.display_order asc, a.created_at desc
$$;

create or replace function public.rpc_nosok_public_faq_list_v1()
returns table (
  id uuid,
  question_ar text,
  answer_ar text,
  display_order integer,
  is_published boolean
)
language sql
security definer
set search_path = public, nosok
as $$
  select
    f.id,
    f.question_ar,
    f.answer_ar,
    f.display_order,
    f.is_published
  from nosok.faq_items f
  where f.is_published = true
  order by f.display_order asc, f.created_at desc
$$;

create or replace function public.rpc_nosok_public_seasons_list_v1()
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
language sql
security definer
set search_path = public, nosok
as $$
  select
    s.id,
    s.season_code,
    s.title_ar,
    s.title_en,
    s.service_type,
    s.hijri_year,
    s.gregorian_year,
    s.registration_start_at,
    s.registration_end_at,
    s.status,
    s.notes,
    s.is_publicly_visible
  from nosok.seasons s
  where s.is_publicly_visible = true
    and s.status = 'open'
  order by s.gregorian_year desc nulls last, s.registration_start_at desc nulls last
$$;

create or replace function public.rpc_nosok_public_programs_list_v1(
  p_season_id uuid default null,
  p_service_type text default null
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
language sql
security definer
set search_path = public, nosok
as $$
  select
    p.id,
    p.season_id,
    p.code,
    p.title_ar,
    p.title_en,
    p.service_type,
    p.description,
    p.registration_start_at,
    p.registration_end_at,
    p.max_companions,
    p.notes,
    p.status,
    p.is_publicly_visible
  from nosok.service_programs p
  join nosok.seasons s on s.id = p.season_id
  where p.is_publicly_visible = true
    and p.status = 'active'
    and s.status = 'open'
    and (p_season_id is null or p.season_id = p_season_id)
    and (p_service_type is null or p.service_type = p_service_type)
  order by p.title_ar asc
$$;

create or replace function public.rpc_nosok_public_companies_list_v1(
  p_query text default null
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
  status text,
  is_publicly_visible boolean,
  notes text
)
language sql
security definer
set search_path = public, nosok
as $$
  select
    c.id,
    c.company_name_ar,
    c.company_name_en,
    c.license_no,
    c.phone,
    c.mobile,
    c.email,
    c.address_text,
    c.status,
    c.is_publicly_visible,
    c.notes
  from nosok.qualified_companies c
  where c.is_publicly_visible = true
    and (
      p_query is null
      or c.company_name_ar ilike '%' || p_query || '%'
      or coalesce(c.license_no, '') ilike '%' || p_query || '%'
      or coalesce(c.address_text, '') ilike '%' || p_query || '%'
    )
  order by c.company_name_ar asc
$$;

create or replace function public.rpc_nosok_public_submit_application_v1(
  p_season_id uuid,
  p_program_id uuid,
  p_service_type text,
  p_applicant_full_name text,
  p_national_id text,
  p_birth_date date default null,
  p_gender text default null,
  p_phone text default null,
  p_mobile text default null,
  p_email text default null,
  p_governorate_id uuid default null,
  p_community_id uuid default null,
  p_address_text text default null,
  p_marital_status text default null,
  p_notes text default null,
  p_companions jsonb default '[]'::jsonb
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
  submitted_at timestamptz
)
language plpgsql
security definer
set search_path = public, nosok
as $$
declare
  v_application nosok.applications%rowtype;
begin
  insert into nosok.applications (
    season_id,
    program_id,
    service_type,
    applicant_full_name,
    national_id,
    birth_date,
    gender,
    phone,
    mobile,
    email,
    governorate_id,
    community_id,
    address_text,
    marital_status,
    application_status,
    eligibility_status,
    submitted_at,
    notes
  )
  values (
    p_season_id,
    p_program_id,
    p_service_type,
    p_applicant_full_name,
    p_national_id,
    p_birth_date,
    p_gender,
    p_phone,
    p_mobile,
    p_email,
    p_governorate_id,
    p_community_id,
    p_address_text,
    p_marital_status,
    'submitted',
    'pending',
    now(),
    p_notes
  )
  returning * into v_application;

  if coalesce(jsonb_array_length(p_companions), 0) > 0 then
    insert into nosok.application_companions (
      application_id,
      full_name,
      national_id,
      relation_type,
      birth_date,
      phone,
      notes
    )
    select
      v_application.id,
      x.full_name,
      x.national_id,
      x.relation_type,
      x.birth_date,
      x.phone,
      x.notes
    from jsonb_to_recordset(p_companions) as x(
      full_name text,
      national_id text,
      relation_type text,
      birth_date date,
      phone text,
      notes text
    );
  end if;

  insert into nosok.application_reviews (
    application_id,
    review_action,
    review_reason
  )
  values (
    v_application.id,
    'submit',
    'Public application submission'
  );

  return query
  select
    v_application.id,
    v_application.season_id,
    v_application.program_id,
    v_application.application_no,
    v_application.tracking_token,
    v_application.tracking_token_issued_at,
    v_application.service_type,
    v_application.applicant_full_name,
    v_application.national_id,
    v_application.application_status,
    v_application.eligibility_status,
    v_application.phone,
    v_application.mobile,
    v_application.email,
    v_application.submitted_at;
end;
$$;

create or replace function public.rpc_nosok_public_application_status_by_token_v1(
  p_tracking_token text
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
  season_title_ar text,
  program_title_ar text,
  submitted_at timestamptz,
  reviewed_at timestamptz
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
    s.title_ar as season_title_ar,
    p.title_ar as program_title_ar,
    a.submitted_at,
    a.reviewed_at
  from nosok.applications a
  left join nosok.seasons s on s.id = a.season_id
  left join nosok.service_programs p on p.id = a.program_id
  where a.tracking_token = upper(trim(p_tracking_token))
  limit 1
$$;


-- =========================================================
-- v07 overrides
-- =========================================================

drop function if exists public.rpc_nosok_public_companies_list_v1(text);
create or replace function public.rpc_nosok_public_companies_list_v1(
  p_query text default null,
  p_season_id uuid default null
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
  status text,
  is_publicly_visible boolean,
  notes text,
  current_season_qualification_status text
)
language sql
security definer
set search_path = public, nosok
as $$
  select
    c.id,
    c.company_name_ar,
    c.company_name_en,
    c.license_no,
    c.phone,
    c.mobile,
    c.email,
    c.address_text,
    c.status,
    c.is_publicly_visible,
    c.notes,
    q.qualification_status as current_season_qualification_status
  from nosok.qualified_companies c
  left join nosok.company_season_qualifications q
    on q.company_id = c.id
   and q.season_id = p_season_id
  where c.is_publicly_visible = true
    and (
      p_query is null
      or c.company_name_ar ilike '%' || p_query || '%'
      or coalesce(c.license_no, '') ilike '%' || p_query || '%'
      or coalesce(c.address_text, '') ilike '%' || p_query || '%'
    )
    and (
      p_season_id is null
      or (q.qualification_status = 'qualified' and q.is_publicly_visible = true)
    )
  order by c.company_name_ar asc
$$;

drop function if exists public.rpc_nosok_public_submit_application_v1(uuid,uuid,text,text,text,date,text,text,text,text,uuid,uuid,text,text,text,jsonb);
create or replace function public.rpc_nosok_public_submit_application_v1(
  p_season_id uuid,
  p_program_id uuid,
  p_service_type text,
  p_applicant_full_name text,
  p_national_id text,
  p_birth_date date default null,
  p_gender text default null,
  p_phone text default null,
  p_mobile text default null,
  p_email text default null,
  p_governorate_id uuid default null,
  p_community_id uuid default null,
  p_address_text text default null,
  p_marital_status text default null,
  p_notes text default null,
  p_companions jsonb default '[]'::jsonb,
  p_documents jsonb default '[]'::jsonb,
  p_payments jsonb default '[]'::jsonb
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
  submitted_at timestamptz
)
language plpgsql
security definer
set search_path = public, nosok
as $$
declare
  v_application nosok.applications%rowtype;
begin
  insert into nosok.applications (
    season_id,
    program_id,
    service_type,
    applicant_full_name,
    national_id,
    birth_date,
    gender,
    phone,
    mobile,
    email,
    governorate_id,
    community_id,
    address_text,
    marital_status,
    application_status,
    eligibility_status,
    submitted_at,
    notes
  )
  values (
    p_season_id,
    p_program_id,
    p_service_type,
    p_applicant_full_name,
    p_national_id,
    p_birth_date,
    p_gender,
    p_phone,
    p_mobile,
    p_email,
    p_governorate_id,
    p_community_id,
    p_address_text,
    p_marital_status,
    'submitted',
    'pending',
    now(),
    p_notes
  )
  returning * into v_application;

  if coalesce(jsonb_array_length(p_companions), 0) > 0 then
    insert into nosok.application_companions (
      application_id,
      full_name,
      national_id,
      relation_type,
      birth_date,
      phone,
      notes
    )
    select
      v_application.id,
      x.full_name,
      x.national_id,
      x.relation_type,
      x.birth_date,
      x.phone,
      x.notes
    from jsonb_to_recordset(p_companions) as x(
      full_name text,
      national_id text,
      relation_type text,
      birth_date date,
      phone text,
      notes text
    );
  end if;

  if coalesce(jsonb_array_length(p_documents), 0) > 0 then
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
      notes
    )
    select
      v_application.id,
      x.document_type,
      x.document_title,
      x.original_file_name,
      x.file_url,
      x.storage_bucket,
      x.storage_path,
      x.mime_type,
      x.file_size_bytes,
      coalesce(x.review_status, 'pending'),
      x.notes
    from jsonb_to_recordset(p_documents) as x(
      document_type text,
      document_title text,
      original_file_name text,
      file_url text,
      storage_bucket text,
      storage_path text,
      mime_type text,
      file_size_bytes bigint,
      review_status text,
      notes text
    );
  end if;

  if coalesce(jsonb_array_length(p_payments), 0) > 0 then
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
    )
    select
      v_application.id,
      x.payment_type,
      coalesce(x.amount, 0),
      coalesce(x.currency_code, 'ILS'),
      x.payment_reference,
      x.payment_method,
      x.provider_name,
      x.external_transaction_id,
      x.receipt_url,
      x.paid_at,
      coalesce(x.payment_status, 'pending'),
      x.notes
    from jsonb_to_recordset(p_payments) as x(
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
    );
  end if;

  insert into nosok.application_reviews (
    application_id,
    review_action,
    review_reason
  )
  values (
    v_application.id,
    'submit',
    'Public application submission'
  );

  return query
  select
    v_application.id,
    v_application.season_id,
    v_application.program_id,
    v_application.application_no,
    v_application.tracking_token,
    v_application.tracking_token_issued_at,
    v_application.service_type,
    v_application.applicant_full_name,
    v_application.national_id,
    v_application.application_status,
    v_application.eligibility_status,
    v_application.phone,
    v_application.mobile,
    v_application.email,
    v_application.submitted_at;
end;
$$;

drop function if exists public.rpc_nosok_public_application_status_by_token_v1(text);
create or replace function public.rpc_nosok_public_application_status_by_token_v1(
  p_tracking_token text
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
  season_title_ar text,
  program_title_ar text,
  submitted_at timestamptz,
  reviewed_at timestamptz,
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
    s.title_ar as season_title_ar,
    p.title_ar as program_title_ar,
    a.submitted_at,
    a.reviewed_at,
    coalesce((select count(*)::int from nosok.application_documents d where d.application_id = a.id), 0) as documents_count,
    coalesce((select count(*)::int from nosok.application_payments ap where ap.application_id = a.id), 0) as payments_count,
    coalesce((select sum(ap.amount) from nosok.application_payments ap where ap.application_id = a.id and ap.payment_status = 'paid'), 0) as total_paid_amount,
    (select ap.payment_status from nosok.application_payments ap where ap.application_id = a.id order by coalesce(ap.paid_at, ap.created_at) desc limit 1) as last_payment_status
  from nosok.applications a
  left join nosok.seasons s on s.id = a.season_id
  left join nosok.service_programs p on p.id = a.program_id
  where a.tracking_token = upper(trim(p_tracking_token))
  limit 1
$$;


-- =========================================================
-- v08 public submission refresh
-- =========================================================

drop function if exists public.rpc_nosok_public_submit_application_v1(uuid,uuid,text,text,text,date,text,text,text,text,uuid,uuid,text,text,text,jsonb,jsonb,jsonb);
create or replace function public.rpc_nosok_public_submit_application_v1(
  p_season_id uuid,
  p_program_id uuid,
  p_service_type text,
  p_applicant_full_name text,
  p_national_id text,
  p_birth_date date default null,
  p_gender text default null,
  p_phone text default null,
  p_mobile text default null,
  p_email text default null,
  p_governorate_id uuid default null,
  p_community_id uuid default null,
  p_address_text text default null,
  p_marital_status text default null,
  p_notes text default null,
  p_companions jsonb default '[]'::jsonb,
  p_documents jsonb default '[]'::jsonb,
  p_payments jsonb default '[]'::jsonb
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
  submitted_at timestamptz
)
language plpgsql
security definer
set search_path = public, nosok
as $$
declare
  v_application nosok.applications%rowtype;
begin
  insert into nosok.applications (
    season_id,
    program_id,
    service_type,
    applicant_full_name,
    national_id,
    birth_date,
    gender,
    phone,
    mobile,
    email,
    governorate_id,
    community_id,
    address_text,
    marital_status,
    application_status,
    eligibility_status,
    submitted_at,
    notes
  )
  values (
    p_season_id,
    p_program_id,
    p_service_type,
    p_applicant_full_name,
    p_national_id,
    p_birth_date,
    p_gender,
    p_phone,
    p_mobile,
    p_email,
    p_governorate_id,
    p_community_id,
    p_address_text,
    p_marital_status,
    'submitted',
    'pending',
    now(),
    p_notes
  )
  returning * into v_application;

  if coalesce(jsonb_array_length(p_companions), 0) > 0 then
    insert into nosok.application_companions (
      application_id,
      full_name,
      national_id,
      relation_type,
      birth_date,
      phone,
      notes
    )
    select
      v_application.id,
      x.full_name,
      x.national_id,
      x.relation_type,
      x.birth_date,
      x.phone,
      x.notes
    from jsonb_to_recordset(p_companions) as x(
      full_name text,
      national_id text,
      relation_type text,
      birth_date date,
      phone text,
      notes text
    );
  end if;

  if coalesce(jsonb_array_length(p_documents), 0) > 0 then
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
    )
    select
      v_application.id,
      x.document_type,
      x.document_title,
      x.original_file_name,
      x.file_url,
      x.storage_bucket,
      x.storage_path,
      x.mime_type,
      x.file_size_bytes,
      coalesce(x.review_status, 'pending'),
      x.review_notes,
      x.notes
    from jsonb_to_recordset(p_documents) as x(
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
      notes text
    );
  end if;

  if coalesce(jsonb_array_length(p_payments), 0) > 0 then
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
    )
    select
      v_application.id,
      x.payment_type,
      coalesce(x.amount, 0),
      coalesce(x.currency_code, 'ILS'),
      x.payment_reference,
      x.payment_method,
      x.provider_name,
      x.external_transaction_id,
      x.receipt_url,
      x.receipt_storage_bucket,
      x.receipt_storage_path,
      x.receipt_original_file_name,
      x.receipt_mime_type,
      x.receipt_file_size_bytes,
      x.paid_at,
      coalesce(x.payment_status, 'pending'),
      coalesce(x.verification_status, 'pending'),
      x.verification_notes,
      x.notes
    from jsonb_to_recordset(p_payments) as x(
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
      notes text
    );
  end if;

  insert into nosok.application_reviews (
    application_id,
    review_action,
    review_reason
  )
  values (
    v_application.id,
    'submit',
    'Public application submission'
  );

  return query
  select
    v_application.id,
    v_application.season_id,
    v_application.program_id,
    v_application.application_no,
    v_application.tracking_token,
    v_application.tracking_token_issued_at,
    v_application.service_type,
    v_application.applicant_full_name,
    v_application.national_id,
    v_application.application_status,
    v_application.eligibility_status,
    v_application.phone,
    v_application.mobile,
    v_application.email,
    v_application.submitted_at;
end;
$$;
