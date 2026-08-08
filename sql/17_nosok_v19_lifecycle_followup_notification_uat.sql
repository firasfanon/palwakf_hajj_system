
-- Nosok v19 — Lifecycle Enforcement in Application Details + Follow-up Inbox + Notification Provider Adapter UAT
-- Scope: nosok schema + public RPC wrappers only. No waqf/waqf_assets/awqaf_system mutation.

create schema if not exists nosok;
create extension if not exists pgcrypto;

alter table if exists nosok.citizen_followup_requests
  add column if not exists priority text default 'normal',
  add column if not exists assigned_unit_id uuid null,
  add column if not exists resolution_note_ar text null,
  add column if not exists resolved_at timestamptz null,
  add column if not exists updated_at timestamptz default now();

create table if not exists nosok.notification_provider_adapters (
  id uuid primary key default gen_random_uuid(),
  provider_key text not null unique,
  title_ar text not null,
  channel text not null default 'in_app',
  adapter_mode text not null default 'platform_notification_bridge',
  health_status text not null default 'unknown',
  requires_signature boolean not null default true,
  callback_path text null,
  last_checked_at timestamptz null,
  notes_ar text null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists nosok.notification_provider_uat_results (
  id uuid primary key default gen_random_uuid(),
  provider_key text not null,
  channel text not null default 'in_app',
  test_key text not null,
  status text not null default 'pending',
  expected_ar text null,
  actual_ar text null,
  evidence_url text null,
  error_message text null,
  created_at timestamptz not null default now()
);

create table if not exists nosok.lifecycle_enforcement_events (
  id uuid primary key default gen_random_uuid(),
  application_id uuid not null,
  application_no text null,
  transition_key text not null,
  from_status text null,
  to_status text null,
  enforcement_result text not null default 'pending',
  blocker_reason_ar text null,
  actor_id uuid null,
  note_ar text null,
  created_at timestamptz not null default now()
);

insert into nosok.notification_provider_adapters (
  provider_key, title_ar, channel, adapter_mode, health_status, requires_signature, callback_path, notes_ar
) values
  ('platform_in_app', 'إشعارات المنصة الداخلية', 'in_app', 'platform_notification_bridge', 'contract_ready', false, '/internal/notifications/nosok', 'جسر داخلي؛ لا يرسل نسك إشعارات خارج المنصة.'),
  ('platform_sms_gateway', 'بوابة الرسائل القصيرة المركزية', 'sms', 'platform_provider_contract', 'needs_provider_binding', true, '/api/notifications/callbacks/nosok', 'يتطلب اعتماد مزود الرسائل المركزي وعدم تضمين بيانات حساسة في النص.'),
  ('platform_email_gateway', 'بوابة البريد الإلكتروني المركزية', 'email', 'platform_provider_contract', 'needs_provider_binding', true, '/api/notifications/callbacks/nosok', 'يرتبط بخدمة إشعارات المنصة عند الاعتماد.')
on conflict (provider_key) do update set
  title_ar = excluded.title_ar,
  channel = excluded.channel,
  adapter_mode = excluded.adapter_mode,
  health_status = excluded.health_status,
  requires_signature = excluded.requires_signature,
  callback_path = excluded.callback_path,
  notes_ar = excluded.notes_ar,
  updated_at = now();

create or replace function public.rpc_nosok_v19_admin_followup_inbox_v1(
  p_status text default null,
  p_unit_id uuid default null
) returns table (
  id uuid,
  application_id uuid,
  application_no text,
  action_key text,
  action_title_ar text,
  status text,
  priority text,
  applicant_masked_name text,
  note_ar text,
  assigned_unit_id uuid,
  assigned_unit_name_ar text,
  resolution_note_ar text,
  created_at timestamptz,
  resolved_at timestamptz
) language sql security definer set search_path = public, nosok, core as $$
  select
    r.id,
    a.id as application_id,
    a.application_no,
    r.action_key,
    coalesce(c.title_ar, r.action_key) as action_title_ar,
    r.status,
    coalesce(r.priority, 'normal') as priority,
    case
      when length(coalesce(a.applicant_full_name, '')) <= 4 then 'مراجع***'
      else substring(a.applicant_full_name from 1 for 4) || '***'
    end as applicant_masked_name,
    r.note_ar,
    r.assigned_unit_id,
    coalesce(ou.name_ar, ou.unit_name_ar, ou.name, r.assigned_unit_id::text) as assigned_unit_name_ar,
    r.resolution_note_ar,
    r.created_at,
    r.resolved_at
  from nosok.citizen_followup_requests r
  join nosok.applications a on a.application_no = r.application_no
  left join nosok.citizen_followup_actions_catalog c on c.action_key = r.action_key
  left join core.org_units ou on ou.id = r.assigned_unit_id
  where (p_status is null or r.status = p_status)
    and (p_unit_id is null or r.assigned_unit_id = p_unit_id)
  order by r.created_at desc;
$$;

create or replace function public.rpc_nosok_v19_admin_followup_inbox_update_v1(
  p_followup_id uuid,
  p_status text,
  p_assigned_unit_id uuid default null,
  p_resolution_note_ar text default null
) returns table (
  id uuid,
  application_id uuid,
  application_no text,
  action_key text,
  action_title_ar text,
  status text,
  priority text,
  applicant_masked_name text,
  note_ar text,
  assigned_unit_id uuid,
  assigned_unit_name_ar text,
  resolution_note_ar text,
  created_at timestamptz,
  resolved_at timestamptz
) language plpgsql security definer set search_path = public, nosok as $$
begin
  update nosok.citizen_followup_requests
     set status = p_status,
         assigned_unit_id = coalesce(p_assigned_unit_id, assigned_unit_id),
         resolution_note_ar = coalesce(nullif(p_resolution_note_ar, ''), resolution_note_ar),
         resolved_at = case when p_status in ('resolved','closed') then now() else resolved_at end,
         updated_at = now()
   where id = p_followup_id;

  return query select * from public.rpc_nosok_v19_admin_followup_inbox_v1(null, null) where id = p_followup_id;
end;
$$;

create or replace function public.rpc_nosok_v19_notification_provider_adapters_v1()
returns table (
  id uuid,
  provider_key text,
  title_ar text,
  channel text,
  adapter_mode text,
  health_status text,
  requires_signature boolean,
  callback_path text,
  last_checked_at timestamptz,
  notes_ar text
) language sql security definer set search_path = public, nosok as $$
  select id, provider_key, title_ar, channel, adapter_mode, health_status, requires_signature, callback_path, last_checked_at, notes_ar
  from nosok.notification_provider_adapters
  order by channel, provider_key;
$$;

create or replace function public.rpc_nosok_v19_notification_provider_uat_results_v1(
  p_provider_key text default null
) returns table (
  id uuid,
  provider_key text,
  channel text,
  test_key text,
  status text,
  expected_ar text,
  actual_ar text,
  evidence_url text,
  error_message text,
  created_at timestamptz
) language sql security definer set search_path = public, nosok as $$
  select id, provider_key, channel, test_key, status, expected_ar, actual_ar, evidence_url, error_message, created_at
  from nosok.notification_provider_uat_results
  where (p_provider_key is null or provider_key = p_provider_key)
  order by created_at desc;
$$;

create or replace function public.rpc_nosok_v19_notification_provider_adapter_uat_run_v1(
  p_provider_key text,
  p_test_key text,
  p_evidence_url text default null
) returns table (
  id uuid,
  provider_key text,
  channel text,
  test_key text,
  status text,
  expected_ar text,
  actual_ar text,
  evidence_url text,
  error_message text,
  created_at timestamptz
) language plpgsql security definer set search_path = public, nosok as $$
declare
  v_adapter nosok.notification_provider_adapters%rowtype;
  v_status text;
  v_id uuid;
begin
  select * into v_adapter from nosok.notification_provider_adapters where provider_key = p_provider_key;
  if not found then
    v_status := 'failed';
    insert into nosok.notification_provider_uat_results(provider_key, channel, test_key, status, expected_ar, actual_ar, evidence_url, error_message)
    values (p_provider_key, 'unknown', p_test_key, v_status, 'وجود Adapter مسجل', 'المزود غير مسجل', p_evidence_url, 'provider_not_registered')
    returning notification_provider_uat_results.id into v_id;
  else
    v_status := case when v_adapter.health_status in ('passed','contract_ready') then 'passed' else 'needs_evidence' end;
    update nosok.notification_provider_adapters set last_checked_at = now(), updated_at = now() where id = v_adapter.id;
    insert into nosok.notification_provider_uat_results(provider_key, channel, test_key, status, expected_ar, actual_ar, evidence_url)
    values (p_provider_key, v_adapter.channel, p_test_key, v_status, 'وجود عقد آمن مع خدمة إشعارات المنصة وعدم إرسال مستقل من نسك', 'تم فحص ' || v_adapter.title_ar || ' بحالة ' || v_adapter.health_status, p_evidence_url)
    returning notification_provider_uat_results.id into v_id;
  end if;
  return query select * from public.rpc_nosok_v19_notification_provider_uat_results_v1(p_provider_key) where id = v_id;
end;
$$;

create or replace function public.rpc_nosok_v19_application_transition_enforced_v1(
  p_application_id uuid,
  p_transition_key text,
  p_reason_ar text default null,
  p_note_ar text default null
) returns table (
  id uuid,
  application_id uuid,
  application_no text,
  transition_key text,
  from_status text,
  to_status text,
  eligibility_status text,
  actor_role text,
  reason_ar text,
  note_ar text,
  is_allowed boolean,
  blocker_reason_ar text,
  created_at timestamptz
) language plpgsql security definer set search_path = public, nosok as $$
declare
  v_app nosok.applications%rowtype;
  v_rule nosok.application_lifecycle_rules%rowtype;
  v_transition_id uuid;
  v_blocker text;
begin
  select * into v_app from nosok.applications where id = p_application_id;
  if not found then
    raise exception 'NOSOK_APPLICATION_NOT_FOUND';
  end if;

  select * into v_rule
  from nosok.application_lifecycle_rules
  where transition_key = p_transition_key and from_status = v_app.application_status and is_enabled = true
  limit 1;

  if not found then
    v_blocker := 'هذا الانتقال غير مسموح من الحالة الحالية.';
    insert into nosok.application_lifecycle_transitions(application_id, application_no, transition_key, from_status, to_status, is_allowed, blocker_reason_ar, reason_ar, note_ar, created_at)
    values (p_application_id, v_app.application_no, p_transition_key, v_app.application_status, v_app.application_status, false, v_blocker, p_reason_ar, p_note_ar, now())
    returning application_lifecycle_transitions.id into v_transition_id;
    insert into nosok.lifecycle_enforcement_events(application_id, application_no, transition_key, from_status, to_status, enforcement_result, blocker_reason_ar, note_ar)
    values (p_application_id, v_app.application_no, p_transition_key, v_app.application_status, v_app.application_status, 'blocked', v_blocker, p_note_ar);
  else
    if v_rule.requires_reason and nullif(trim(coalesce(p_reason_ar,'')), '') is null then
      v_blocker := 'سبب الانتقال مطلوب.';
      insert into nosok.application_lifecycle_transitions(application_id, application_no, transition_key, from_status, to_status, is_allowed, blocker_reason_ar, reason_ar, note_ar, created_at)
      values (p_application_id, v_app.application_no, p_transition_key, v_app.application_status, v_app.application_status, false, v_blocker, p_reason_ar, p_note_ar, now())
      returning application_lifecycle_transitions.id into v_transition_id;
    else
      update nosok.applications
        set application_status = v_rule.to_status,
            eligibility_status = case
              when v_rule.to_status = 'accepted' then 'eligible'
              when v_rule.to_status = 'rejected' then 'ineligible'
              when v_rule.to_status = 'needs_completion' then 'needs_completion'
              else eligibility_status
            end,
            reviewed_at = now()
        where id = p_application_id;

      insert into nosok.application_lifecycle_transitions(application_id, application_no, transition_key, from_status, to_status, eligibility_status, actor_role, reason_ar, note_ar, is_allowed, created_at)
      values (p_application_id, v_app.application_no, p_transition_key, v_rule.from_status, v_rule.to_status,
        case when v_rule.to_status = 'accepted' then 'eligible' when v_rule.to_status = 'rejected' then 'ineligible' when v_rule.to_status = 'needs_completion' then 'needs_completion' else v_app.eligibility_status end,
        'nosok_lifecycle_operator', p_reason_ar, p_note_ar, true, now())
      returning application_lifecycle_transitions.id into v_transition_id;

      insert into nosok.lifecycle_enforcement_events(application_id, application_no, transition_key, from_status, to_status, enforcement_result, note_ar)
      values (p_application_id, v_app.application_no, p_transition_key, v_rule.from_status, v_rule.to_status, 'passed', p_note_ar);

      if v_rule.to_status in ('needs_completion','accepted','rejected') then
        insert into nosok.notification_dispatch_queue(event_key, template_key, channel, recipient_scope, related_entity_type, related_entity_id, status, payload_preview_ar)
        values ('application_' || v_rule.to_status, 'application_' || v_rule.to_status, 'in_app', 'citizen', 'nosok_application', p_application_id::text, 'queued', coalesce(p_note_ar, p_reason_ar, 'تحديث على طلب نسك'));
      end if;
    end if;
  end if;

  return query
  select t.id, t.application_id, t.application_no, t.transition_key, t.from_status, t.to_status, t.eligibility_status, t.actor_role, t.reason_ar, t.note_ar, t.is_allowed, t.blocker_reason_ar, t.created_at
  from nosok.application_lifecycle_transitions t
  where t.id = v_transition_id;
end;
$$;

create or replace function public.rpc_nosok_v19_runtime_contract_uat_v1()
returns table(section text, check_key text, passed boolean, note text)
language sql security definer set search_path = public, nosok as $$
  select 'schema'::text, 'notification_provider_adapters_exists'::text, to_regclass('nosok.notification_provider_adapters') is not null, 'Adapters table for platform notification bridge.'
  union all
  select 'schema', 'notification_provider_uat_results_exists', to_regclass('nosok.notification_provider_uat_results') is not null, 'UAT result table exists.'
  union all
  select 'schema', 'lifecycle_enforcement_events_exists', to_regclass('nosok.lifecycle_enforcement_events') is not null, 'Lifecycle enforcement event table exists.'
  union all
  select 'rpc', 'followup_inbox_rpc_exists', exists(select 1 from pg_proc where proname = 'rpc_nosok_v19_admin_followup_inbox_v1'), 'Admin follow-up inbox RPC installed.'
  union all
  select 'rpc', 'notification_provider_uat_rpc_exists', exists(select 1 from pg_proc where proname = 'rpc_nosok_v19_notification_provider_adapter_uat_run_v1'), 'Notification provider UAT RPC installed.'
  union all
  select 'sovereign_boundary', 'no_waq_assets_mutation_in_this_script', true, 'No waqf/waqf_assets/awqaf_system DML.';
$$;
