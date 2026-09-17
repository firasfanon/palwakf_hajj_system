-- NOSOK v39 — POST-APPLY UNIT→LGU SCOPE CENSUS
-- READ ONLY. Run only after migration 45 is separately authorized/applied.

select
  to_regclass('nosok.administrative_unit_lgu_scope_policy') as policy_table,
  to_regprocedure('public.rpc_nosok_unit_lgu_scope_resolve_v1(uuid,uuid)') as resolver_rpc;

select
  count(*) as total_rows,
  count(*) filter (where status='approved' and is_active) as active_approved_rows,
  count(*) filter (where campaign_id is null and status='approved' and is_active) as default_rows,
  count(*) filter (where campaign_id is not null and status='approved' and is_active) as campaign_rows
from nosok.administrative_unit_lgu_scope_policy;

select
  p.unit_id,
  u.slug as canonical_slug,
  u.name_ar as unit_name_ar,
  u.governorate_id,
  count(*) filter (where p.status='approved' and p.is_active) as approved_lgu_count
from nosok.administrative_unit_lgu_scope_policy p
join core.org_units u on u.id=p.unit_id
group by p.unit_id,u.slug,u.name_ar,u.governorate_id
order by u.name_ar;
select
  count(*) as cross_governorate_mismatches
from nosok.administrative_unit_lgu_scope_policy p
join core.org_units u on u.id=p.unit_id
join core.core_lgus l on l.id=p.lgu_id
join core.core_governorates g on g.governorate_no=l.governorate_no
where u.governorate_id is distinct from g.id;

select grantee, privilege_type
from information_schema.role_table_grants
where table_schema='nosok'
  and table_name='administrative_unit_lgu_scope_policy'
  and grantee in ('anon','authenticated')
order by grantee, privilege_type;

select grantee, privilege_type
from information_schema.routine_privileges
where specific_schema='public'
  and routine_name='rpc_nosok_unit_lgu_scope_resolve_v1'
  and grantee in ('anon','authenticated')
order by grantee, privilege_type;
