-- Mega Batch Nosok v24 — read-only Supabase Runtime UAT Pack
-- Scope: read-only contract checks only. No DDL, no DML, no waqf/waqf_assets mutation.
-- Run in Supabase SQL Editor after applying authorized Nosok schema/RPC batches.

with expected_relations(source_schema, object_name, object_type, required_level, notes_ar) as (
  values
    ('nosok','seasons','table','P0','جدول المواسم مطلوب للتشغيل الموسمي'),
    ('nosok','service_programs','table','P0','برامج الحج/العمرة مطلوبة'),
    ('nosok','applications','table','P0','طلبات المواطنين مطلوبة'),
    ('nosok','application_documents','table','P0','مرفقات الطلب مطلوبة'),
    ('nosok','application_payments','table','P1','دفعات الطلب/الجسر المالي'),
    ('nosok','qualified_companies','table','P1','الشركات المؤهلة'),
    ('nosok','citizen_followup_requests','table','P1','طلبات المتابعة العامة'),
    ('nosok','notification_dispatch_queue','table','P1','طابور إشعارات نسك'),
    ('nosok','production_readiness_evidence','table','P1','أدلة الجاهزية'),
    ('nosok','browser_role_evidence','table','P1','أدلة المتصفح والأدوار')
), relation_checks as (
  select
    'relation_presence'::text as section,
    e.source_schema,
    e.object_name,
    e.object_type,
    e.required_level,
    exists (
      select 1
      from information_schema.tables t
      where t.table_schema = e.source_schema
        and t.table_name = e.object_name
    ) as passed,
    e.notes_ar
  from expected_relations e
), expected_rpcs(function_schema, function_name, required_level, notes_ar) as (
  values
    ('public','rpc_nosok_public_application_status_by_token_v1','P0','تتبع عام آمن'),
    ('public','rpc_nosok_v18_public_followup_request_submit_v1','P1','إرسال متابعة المواطن'),
    ('public','rpc_nosok_v19_admin_followup_inbox_v1','P1','صندوق متابعة الموظف'),
    ('public','rpc_nosok_v20_platform_integration_readiness_v1','P1','جاهزية الدمج'),
    ('public','rpc_nosok_v21_rbac_override_contract_v1','P0','عقد RBAC provider override'),
    ('public','rpc_nosok_v22_browser_role_evidence_v1','P1','استيعاب أدلة المتصفح والأدوار')
), rpc_checks as (
  select
    'rpc_presence'::text as section,
    e.function_schema as source_schema,
    e.function_name as object_name,
    'function'::text as object_type,
    e.required_level,
    exists (
      select 1
      from information_schema.routines r
      where r.specific_schema = e.function_schema
        and r.routine_name = e.function_name
    ) as passed,
    e.notes_ar
  from expected_rpcs e
), storage_checks as (
  select
    'storage_presence'::text as section,
    'storage'::text as source_schema,
    'nosok-documents bucket/policies'::text as object_name,
    'storage_contract'::text as object_type,
    'P1'::text as required_level,
    exists (
      select 1
      from information_schema.tables t
      where t.table_schema = 'storage'
        and t.table_name in ('buckets','objects')
    ) as passed,
    'وجود storage schema شرط أولي؛ bucket/policies تتطلب مراجعة منفصلة قبل الإنتاج.'::text as notes_ar
), sovereign_boundary as (
  select
    'sovereign_boundary'::text as section,
    'waqf'::text as source_schema,
    'no_waqf_assets_mutation_in_this_script'::text as object_name,
    'read_only_guard'::text as object_type,
    'P0'::text as required_level,
    true as passed,
    'هذا الملف read-only ولا ينفذ أي DDL/DML ولا يلمس waqf أو waqf_assets أو awqaf_system.'::text as notes_ar
)
select * from relation_checks
union all
select * from rpc_checks
union all
select * from storage_checks
union all
select * from sovereign_boundary
order by section, required_level, object_name;
