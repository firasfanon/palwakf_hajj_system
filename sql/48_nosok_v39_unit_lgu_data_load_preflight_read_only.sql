-- NOSOK v39 — Unit→LGU DATA LOAD preflight
-- READ ONLY. This file never loads authority data.
-- PASS requires an externally reviewed dataset with zero unresolved rows.

select
  to_regclass('nosok.administrative_unit_lgu_scope_policy') as policy_table,
  to_regprocedure('public.rpc_nosok_unit_lgu_scope_resolve_v1(uuid,uuid)') as resolver_rpc,
  count(*)::int as existing_policy_rows
from nosok.administrative_unit_lgu_scope_policy
GROUP BY 1,2;

with dir_counts as (
  select governorate_id, count(*)::int as dir_count
  from core.org_units
  where unit_type::text='directorate' and is_active=true
  group by governorate_id
), lgus as (
  select l.id, g.id as governorate_id
  from core.core_lgus l
  join core.core_governorates g on g.governorate_no=l.governorate_no
  where coalesce(l.is_active,true)
    and l.governorate_no between 1 and 11
)
select
  count(*)::int as candidate_rows,
  count(*) filter(where d.dir_count=1)::int as deterministic_candidate_rows,
  count(*) filter(where coalesce(d.dir_count,0)<>1)::int as unresolved_rows,
  case
    when count(*) filter(where coalesce(d.dir_count,0)<>1)=0
      then 'AUTHORITY_DATASET_REVIEW_MAY_PROCEED'
    else 'FAIL_CLOSED_CURRENT_AWQAF_ROSTER_REQUIRED'
  end as preflight_decision
from lgus l
left join dir_counts d on d.governorate_id=l.governorate_id;

-- Expected current result before an authoritative roster is supplied:
-- candidate_rows=722
-- deterministic_candidate_rows=569
-- unresolved_rows=153
-- preflight_decision=FAIL_CLOSED_CURRENT_AWQAF_ROSTER_REQUIRED

-- DATA LOAD MUST NOT be authorized from this file alone.
-- Required external evidence:
-- 1) current Ministry of Awqaf jurisdiction roster/export;
-- 2) exact reconciliation to core.core_lgus.id;
-- 3) source version/date and reviewer/approver;
-- 4) zero unresolved/ambiguous rows;
-- 5) separately authorized controlled insert.
