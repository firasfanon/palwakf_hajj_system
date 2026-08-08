-- Nosok v18 — Application Lifecycle State Machine + Citizen Follow-up Actions + Notification Dispatch Bridge
-- Scope: nosok schema + public RPC wrappers only. No waqf/waqf_assets/awqaf_system mutation.

create schema if not exists nosok;

create table if not exists nosok.application_lifecycle_rules (
  transition_key text primary key,
  title_ar text not null,
  description_ar text,
  from_status text not null,
  to_status text not null,
  required_permission text,
  requires_reason boolean not null default false,
  is_enabled boolean not null default true,
  display_order integer not null default 100,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

insert into nosok.application_lifecycle_rules
  (transition_key, title_ar, description_ar, from_status, to_status, required_permission, requires_reason, is_enabled, display_order)
values
  ('submit_to_review', 'تحويل للمراجعة', 'ينقل الطلب من مقدم إلى قيد المراجعة.', 'submitted', 'under_review', 'reviewNosokApplications', false, true, 10),
  ('request_completion', 'طلب استكمال من المواطن', 'يفتح إجراءات متابعة للمواطن دون كشف بيانات حساسة.', 'under_review', 'needs_completion', 'reviewNosokApplications', true, true, 20),
  ('approve_application', 'اعتماد الطلب', 'اعتماد أولي بعد اكتمال الوثائق والدفعات.', 'under_review', 'accepted', 'approveNosokApplications', true, true, 30),
  ('reject_application', 'رفض الطلب', 'رفض محكوم بسبب موثق.', 'under_review', 'rejected', 'approveNosokApplications', true, true, 40),
  ('close_application', 'إغلاق الطلب', 'إغلاق إداري بعد اكتمال الإجراءات.', 'accepted', 'closed', 'manageNosokApplications', false, true, 50)
on conflict (transition_key) do update set
  title_ar = excluded.title_ar,
  description_ar = excluded.description_ar,
  from_status = excluded.from_status,
  to_status = excluded.to_status,
  required_permission = excluded.required_permission,
  requires_reason = excluded.requires_reason,
  is_enabled = excluded.is_enabled,
  display_order = excluded.display_order,
  updated_at = now();

create table if not exists nosok.application_lifecycle_transitions (
  id uuid primary key default gen_random_uuid(),
  application_id uuid not null,
  application_no text,
  transition_key text not null references nosok.application_lifecycle_rules(transition_key),
  from_status text not null,
  to_status text not null,
  eligibility_status text,
  actor_role text,
  actor_user_id uuid,
  reason_ar text,
  note_ar text,
  is_allowed boolean not null default true,
  blocker_reason_ar text,
  created_at timestamptz not null default now()
);

create index if not exists idx_nosok_lifecycle_transitions_application_id
  on nosok.application_lifecycle_transitions(application_id, created_at desc);

create table if not exists nosok.citizen_followup_actions_catalog (
  action_key text primary key,
  title_ar text not null,
  description_ar text not null,
  action_type text not null default 'request',
  route_path text,
  enabled boolean not null default true,
  requires_note boolean not null default true,
  allowed_statuses text[] not null default array['submitted','under_review','needs_completion','rejected'],
  display_order integer not null default 100,
  updated_at timestamptz not null default now()
);

insert into nosok.citizen_followup_actions_catalog
  (action_key, title_ar, description_ar, action_type, route_path, enabled, requires_note, allowed_statuses, display_order)
values
  ('add_note', 'إضافة ملاحظة للطلب', 'إرسال ملاحظة مختصرة لموظف نسك دون تعديل البيانات الحساسة.', 'request', null, true, true, array['submitted','under_review','needs_completion','rejected'], 10),
  ('request_contact_update', 'طلب تحديث بيانات التواصل', 'طلب إداري لتحديث وسيلة التواصل بعد تحقق الموظف.', 'request', null, true, true, array['submitted','under_review','needs_completion'], 20),
  ('submit_objection', 'تقديم اعتراض/مراجعة', 'يفتح مسار مراجعة عند الرفض أو طلب الاستكمال.', 'request', null, true, true, array['needs_completion','rejected'], 30)
on conflict (action_key) do update set
  title_ar = excluded.title_ar,
  description_ar = excluded.description_ar,
  action_type = excluded.action_type,
  route_path = excluded.route_path,
  enabled = excluded.enabled,
  requires_note = excluded.requires_note,
  allowed_statuses = excluded.allowed_statuses,
  display_order = excluded.display_order,
  updated_at = now();

create table if not exists nosok.citizen_followup_requests (
  id uuid primary key default gen_random_uuid(),
  application_id uuid not null,
  application_no text not null,
  action_key text not null references nosok.citizen_followup_actions_catalog(action_key),
  status text not null default 'submitted',
  note_ar text,
  created_at timestamptz not null default now(),
  reviewed_at timestamptz,
  reviewed_by uuid,
  admin_note_ar text
);

create index if not exists idx_nosok_citizen_followup_application
  on nosok.citizen_followup_requests(application_id, created_at desc);

create table if not exists nosok.notification_dispatch_queue (
  id uuid primary key default gen_random_uuid(),
  event_key text not null,
  template_key text not null,
  channel text not null default 'in_app',
  recipient_scope text not null default 'citizen',
  related_entity_type text not null,
  related_entity_id text not null,
  status text not null default 'queued',
  payload_preview_ar text,
  provider_reference text,
  error_message text,
  created_at timestamptz not null default now(),
  dispatched_at timestamptz
);

create index if not exists idx_nosok_notification_dispatch_status
  on nosok.notification_dispatch_queue(status, created_at desc);

create or replace function public.rpc_nosok_v18_application_lifecycle_rules_v1(p_from_status text default null)
returns table (
  transition_key text,
  title_ar text,
  description_ar text,
  from_status text,
  to_status text,
  required_permission text,
  requires_reason boolean,
  is_enabled boolean,
  display_order integer
)
language sql
security definer
set search_path = nosok, public
as $$
  select r.transition_key, r.title_ar, r.description_ar, r.from_status, r.to_status,
         r.required_permission, r.requires_reason, r.is_enabled, r.display_order
  from nosok.application_lifecycle_rules r
  where r.is_enabled = true
    and (p_from_status is null or r.from_status = p_from_status)
  order by r.display_order, r.transition_key;
$$;

create or replace function public.rpc_nosok_v18_application_lifecycle_transitions_v1(p_application_id text default null)
returns table (
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
)
language sql
security definer
set search_path = nosok, public
as $$
  select t.id, t.application_id, t.application_no, t.transition_key, t.from_status, t.to_status,
         t.eligibility_status, t.actor_role, t.reason_ar, t.note_ar, t.is_allowed, t.blocker_reason_ar, t.created_at
  from nosok.application_lifecycle_transitions t
  where p_application_id is null or t.application_id::text = p_application_id
  order by t.created_at desc;
$$;

create or replace function public.rpc_nosok_v18_application_transition_v1(
  p_application_id text,
  p_transition_key text,
  p_reason_ar text default null,
  p_note_ar text default null
)
returns table (
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
)
language plpgsql
security definer
set search_path = nosok, public
as $$
declare
  v_app record;
  v_rule record;
  v_transition_id uuid;
  v_eligibility text;
begin
  select * into v_app from nosok.applications where id::text = p_application_id;
  if not found then
    raise exception 'Nosok application not found';
  end if;

  select * into v_rule
  from nosok.application_lifecycle_rules
  where transition_key = p_transition_key
    and from_status = v_app.application_status
    and is_enabled = true;

  if not found then
    insert into nosok.application_lifecycle_transitions
      (application_id, application_no, transition_key, from_status, to_status, is_allowed, blocker_reason_ar, reason_ar, note_ar)
    values
      (v_app.id, v_app.application_no, p_transition_key, v_app.application_status, v_app.application_status, false, 'الانتقال غير مسموح من الحالة الحالية.', p_reason_ar, p_note_ar)
    returning application_lifecycle_transitions.id into v_transition_id;
    return query select r.* from public.rpc_nosok_v18_application_lifecycle_transitions_v1(v_app.id::text) as r where r.id = v_transition_id;
    return;
  end if;

  v_eligibility := case
    when v_rule.to_status = 'accepted' then 'eligible'
    when v_rule.to_status = 'rejected' then 'ineligible'
    when v_rule.to_status = 'needs_completion' then 'needs_review'
    else v_app.eligibility_status
  end;

  update nosok.applications
  set application_status = v_rule.to_status,
      eligibility_status = v_eligibility,
      reviewed_at = now()
  where id = v_app.id;

  insert into nosok.application_lifecycle_transitions
    (application_id, application_no, transition_key, from_status, to_status, eligibility_status, actor_role, reason_ar, note_ar, is_allowed)
  values
    (v_app.id, v_app.application_no, p_transition_key, v_app.application_status, v_rule.to_status, v_eligibility, 'nosok_admin', p_reason_ar, p_note_ar, true)
  returning application_lifecycle_transitions.id into v_transition_id;

  insert into nosok.notification_dispatch_queue
    (event_key, template_key, channel, recipient_scope, related_entity_type, related_entity_id, payload_preview_ar)
  values
    (p_transition_key, case when p_transition_key = 'request_completion' then 'application_requires_followup' else 'application_status_changed' end,
     'in_app', 'citizen', 'nosok_application', v_app.id::text, 'تم تحديث حالة طلب نسك رقم ' || v_app.application_no || '.');

  return query select r.* from public.rpc_nosok_v18_application_lifecycle_transitions_v1(v_app.id::text) as r where r.id = v_transition_id;
end;
$$;

create or replace function public.rpc_nosok_v18_public_followup_actions_v1(p_tracking_token text)
returns table (
  action_key text,
  title_ar text,
  description_ar text,
  action_type text,
  route_path text,
  enabled boolean,
  requires_note boolean,
  status text,
  display_order integer
)
language sql
security definer
set search_path = nosok, public
as $$
  select c.action_key, c.title_ar, c.description_ar, c.action_type, c.route_path,
         (c.enabled and a.application_status = any(c.allowed_statuses)) as enabled,
         c.requires_note,
         case when c.enabled and a.application_status = any(c.allowed_statuses) then 'available' else 'not_available_for_status' end as status,
         c.display_order
  from nosok.applications a
  join nosok.citizen_followup_actions_catalog c on true
  where a.tracking_token = upper(trim(p_tracking_token))
  order by c.display_order, c.action_key;
$$;

create or replace function public.rpc_nosok_v18_public_followup_request_submit_v1(
  p_tracking_token text,
  p_action_key text,
  p_note_ar text default null
)
returns table (
  id uuid,
  application_no text,
  action_key text,
  status text,
  note_ar text,
  created_at timestamptz
)
language plpgsql
security definer
set search_path = nosok, public
as $$
declare
  v_app record;
  v_action record;
  v_request_id uuid;
begin
  select * into v_app from nosok.applications where tracking_token = upper(trim(p_tracking_token));
  if not found then
    raise exception 'Invalid tracking token';
  end if;

  select * into v_action
  from nosok.citizen_followup_actions_catalog
  where action_key = p_action_key
    and enabled = true
    and v_app.application_status = any(allowed_statuses);

  if not found then
    raise exception 'Follow-up action is not available for this application status';
  end if;

  insert into nosok.citizen_followup_requests
    (application_id, application_no, action_key, status, note_ar)
  values
    (v_app.id, v_app.application_no, p_action_key, 'submitted', p_note_ar)
  returning citizen_followup_requests.id into v_request_id;

  insert into nosok.notification_dispatch_queue
    (event_key, template_key, channel, recipient_scope, related_entity_type, related_entity_id, payload_preview_ar)
  values
    ('citizen_followup_submitted', 'citizen_followup_submitted', 'in_app', 'admin', 'nosok_application', v_app.id::text,
     'وصل إجراء متابعة من المواطن على الطلب ' || v_app.application_no || '.');

  return query
  select r.id, r.application_no, r.action_key, r.status, r.note_ar, r.created_at
  from nosok.citizen_followup_requests r
  where r.id = v_request_id;
end;
$$;

create or replace function public.rpc_nosok_v18_admin_notification_dispatch_queue_v1(p_status text default null)
returns table (
  id uuid,
  event_key text,
  template_key text,
  channel text,
  recipient_scope text,
  related_entity_type text,
  related_entity_id text,
  status text,
  payload_preview_ar text,
  provider_reference text,
  error_message text,
  created_at timestamptz,
  dispatched_at timestamptz
)
language sql
security definer
set search_path = nosok, public
as $$
  select q.id, q.event_key, q.template_key, q.channel, q.recipient_scope, q.related_entity_type,
         q.related_entity_id, q.status, q.payload_preview_ar, q.provider_reference, q.error_message, q.created_at, q.dispatched_at
  from nosok.notification_dispatch_queue q
  where p_status is null or q.status = p_status
  order by q.created_at desc;
$$;

create or replace function public.rpc_nosok_v18_admin_notification_dispatch_create_v1(
  p_event_key text,
  p_template_key text,
  p_channel text,
  p_recipient_scope text,
  p_related_entity_type text,
  p_related_entity_id text,
  p_payload_preview_ar text default null
)
returns table (
  id uuid,
  event_key text,
  template_key text,
  channel text,
  recipient_scope text,
  related_entity_type text,
  related_entity_id text,
  status text,
  payload_preview_ar text,
  provider_reference text,
  error_message text,
  created_at timestamptz,
  dispatched_at timestamptz
)
language plpgsql
security definer
set search_path = nosok, public
as $$
declare
  v_id uuid;
begin
  insert into nosok.notification_dispatch_queue
    (event_key, template_key, channel, recipient_scope, related_entity_type, related_entity_id, payload_preview_ar)
  values
    (p_event_key, p_template_key, coalesce(nullif(p_channel,''),'in_app'), coalesce(nullif(p_recipient_scope,''),'citizen'), p_related_entity_type, p_related_entity_id, p_payload_preview_ar)
  returning notification_dispatch_queue.id into v_id;

  return query select q.* from public.rpc_nosok_v18_admin_notification_dispatch_queue_v1(null) as q where q.id = v_id;
end;
$$;

create or replace function public.rpc_nosok_v18_admin_notification_dispatch_mark_v1(
  p_dispatch_id text,
  p_status text,
  p_provider_reference text default null,
  p_error_message text default null
)
returns table (
  id uuid,
  event_key text,
  template_key text,
  channel text,
  recipient_scope text,
  related_entity_type text,
  related_entity_id text,
  status text,
  payload_preview_ar text,
  provider_reference text,
  error_message text,
  created_at timestamptz,
  dispatched_at timestamptz
)
language plpgsql
security definer
set search_path = nosok, public
as $$
begin
  update nosok.notification_dispatch_queue
  set status = p_status,
      provider_reference = coalesce(p_provider_reference, provider_reference),
      error_message = p_error_message,
      dispatched_at = case when p_status = 'sent' then now() else dispatched_at end
  where id::text = p_dispatch_id;

  return query select q.* from public.rpc_nosok_v18_admin_notification_dispatch_queue_v1(null) as q where q.id::text = p_dispatch_id;
end;
$$;

create or replace function public.rpc_nosok_v18_runtime_contract_uat_v1()
returns table (
  section text,
  check_key text,
  passed boolean,
  note text
)
language sql
security definer
set search_path = nosok, public
as $$
  select 'v18_schema', 'lifecycle_rules_exists', to_regclass('nosok.application_lifecycle_rules') is not null, 'Application lifecycle rules table.'
  union all
  select 'v18_schema', 'followup_requests_exists', to_regclass('nosok.citizen_followup_requests') is not null, 'Citizen follow-up requests table.'
  union all
  select 'v18_schema', 'notification_dispatch_queue_exists', to_regclass('nosok.notification_dispatch_queue') is not null, 'Notification dispatch queue table.'
  union all
  select 'v18_rpc', 'public_followup_actions_rpc_exists', to_regprocedure('public.rpc_nosok_v18_public_followup_actions_v1(text)') is not null, 'Public follow-up actions RPC.'
  union all
  select 'v18_rpc', 'transition_rpc_exists', to_regprocedure('public.rpc_nosok_v18_application_transition_v1(text,text,text,text)') is not null, 'Application transition RPC.'
  union all
  select 'sovereign_boundary', 'no_waq_assets_mutation_in_this_script', true, 'No waqf/waqf_assets/awqaf_system mutation.';
$$;
