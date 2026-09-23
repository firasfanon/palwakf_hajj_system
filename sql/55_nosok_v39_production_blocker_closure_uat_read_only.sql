-- NOSOK v39 — Production Blocker Closure Mega Batch UAT (READ ONLY)
-- Intended for post-apply verification; it performs no DDL or DML.

with expected_objects(object_kind, object_name, signature) as (
  values
  ('table','application_private_payloads',null),
  ('table','production_integration_readiness',null),
  ('function','rpc_nosok_admin_campaigns_list_v1','public.rpc_nosok_admin_campaigns_list_v1()'),
  ('function','rpc_nosok_admin_campaign_upsert_v1','public.rpc_nosok_admin_campaign_upsert_v1(text,text,text,integer,text,uuid,timestamptz,timestamptz,jsonb)'),
  ('function','rpc_nosok_admin_campaign_delete_v1','public.rpc_nosok_admin_campaign_delete_v1(uuid)'),
  ('function','rpc_nosok_campaign_lgus_public_list_v1','public.rpc_nosok_campaign_lgus_public_list_v1(text)'),
  ('function','rpc_nosok_application_submit_v2','public.rpc_nosok_application_submit_v2(text,text,uuid,uuid,jsonb,jsonb)'),
  ('function','rpc_nosok_admin_application_private_v1','public.rpc_nosok_admin_application_private_v1(uuid)'),
  ('function','rpc_nosok_admin_unit_application_queue_v1','public.rpc_nosok_admin_unit_application_queue_v1(uuid,text,text)'),
  ('function','rpc_nosok_admin_integration_readiness_v1','public.rpc_nosok_admin_integration_readiness_v1()'),
  ('function','rpc_nosok_admin_integration_readiness_update_v1','public.rpc_nosok_admin_integration_readiness_update_v1(text,text,text,text)'),
  ('function','rpc_nosok_production_gate_readiness_v1','public.rpc_nosok_production_gate_readiness_v1()')
),
object_status as (
  select object_kind,object_name,signature,
    case when object_kind='table'
      then to_regclass('nosok.'||object_name) is not null
      else to_regprocedure(signature) is not null
    end as present
  from expected_objects
),
policy_state as (
  select count(*)::int as policy_rows,
    count(*) filter(where status='approved' and is_active)::int as approved_active_rows,
    count(*) filter(where approved_by is null or approved_at is null)::int as missing_approval_metadata
  from nosok.administrative_unit_lgu_scope_policy
),
campaign_state as (
  select count(*)::int as campaigns,
    count(*) filter(where status='published'
      and (application_open_at is null or application_open_at<=now())
      and (application_close_at is null or application_close_at>=now()))::int as open_campaigns
  from nosok.campaigns
),
pii_key_state as (
  select exists(
    select 1 from vault.decrypted_secrets
    where name='NOSOK_PII_ENCRYPTION_KEY_V1'
      and length(decrypted_secret)>=32
  ) as pii_key_provisioned
),
storage_state as (
  select jsonb_build_object(
    'private_bucket_exists',exists(select 1 from storage.buckets where id='nosok-private'),
    'private_bucket_is_private',exists(select 1 from storage.buckets where id='nosok-private' and public=false),
    'legacy_public_bucket_still_public',exists(select 1 from storage.buckets where id='nosok-public' and public=true)
  ) as payload
),
storage_policies as (
  select coalesce(jsonb_agg(jsonb_build_object(
    'policyname',policyname,'roles',roles,'cmd',cmd
  ) order by policyname),'[]'::jsonb) as payload
  from pg_policies
  where schemaname='storage' and tablename='objects'
    and policyname in (
      'Public can view nosok storage',
      'Public can upload nosok storage',
      'Authenticated can update nosok storage',
      'Authenticated can delete nosok storage',
      'Nosok citizen private draft upload',
      'Nosok document officers private read',
      'Nosok document officers private delete'
    )
),
direct_grants as (
  select coalesce(jsonb_agg(jsonb_build_object(
    'schema',table_schema,'table',table_name,'grantee',grantee,'privilege',privilege_type
  ) order by table_schema,table_name,grantee,privilege_type),'[]'::jsonb) as payload
  from information_schema.role_table_grants
  where table_schema='nosok'
    and table_name in (
      'administrative_unit_lgu_scope_policy',
      'application_private_payloads',
      'production_integration_readiness'
    )
    and grantee in ('anon','authenticated')
)
select '01_expected_objects' as section,
       coalesce(jsonb_agg(to_jsonb(object_status)),'[]'::jsonb) as payload
from object_status
union all
select '02_policy_state',to_jsonb(policy_state) from policy_state
union all
select '03_campaign_state',to_jsonb(campaign_state) from campaign_state
union all
select '04_pii_key_state',to_jsonb(pii_key_state) from pii_key_state
union all
select '05_storage_state',payload from storage_state
union all
select '06_storage_policies',payload from storage_policies
union all
select '07_direct_anon_authenticated_table_grants',payload from direct_grants;
