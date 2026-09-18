-- NOSOK v39 — Unit→LGU candidate dataset review
-- READ ONLY. No INSERT/UPDATE/DELETE/GRANT/DDL.
-- Purpose: emit one row per active LGU in West Bank governorates 1..11.
-- Multi-directorate governorates remain unresolved/fail-closed.

with active_directorates as (
  select
    u.id as unit_id,
    u.slug as unit_slug,
    u.name_ar as unit_name_ar,
    u.governorate_id,
    count(*) over (partition by u.governorate_id) as active_directorate_count
  from core.org_units u
  where u.unit_type::text = 'directorate'
    and u.is_active = true
), unique_directorate as (
  select *
  from active_directorates
  where active_directorate_count = 1
), scoped_lgus as (
  select
    l.id as lgu_id,
    l.lgus_no,
    l.code as lgu_code,
    l.name_ar as lgu_name_ar,
    l.governorate_no,
    g.id as governorate_id,
    g.name_ar as governorate_name_ar
  from core.core_lgus l
  join core.core_governorates g
    on g.governorate_no = l.governorate_no
  where coalesce(l.is_active, true) = true
    and l.governorate_no between 1 and 11
)
select
  l.governorate_no,
  l.governorate_name_ar,
  l.lgu_id,
  l.lgus_no,
  l.lgu_code,
  l.lgu_name_ar,
  u.unit_id as candidate_unit_id,
  u.unit_slug as candidate_unit_slug,
  u.unit_name_ar as candidate_unit_name_ar,
  case
    when u.unit_id is not null
      then 'DETERMINISTIC_SINGLE_DIRECTORATE_CANDIDATE'
    else 'NEEDS_CURRENT_AWQAF_JURISDICTION_ROSTER'
  end as resolution_status,
  case
    when u.unit_id is not null
      then 'PALWAKF_CORE_CANONICAL_GOVERNORATE_UNIQUENESS_V1'
    else 'MINISTRY_OF_AWQAF_CURRENT_JURISDICTION_ROSTER_REQUIRED'
  end as source_class,
  false as authority_verified,
  false as load_ready
from scoped_lgus l
left join unique_directorate u
  on u.governorate_id = l.governorate_id
order by l.governorate_no, l.lgus_no, l.lgu_name_ar;

-- Summary gate.
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
  count(*)::int as total_active_lgus,
  count(*) filter(where d.dir_count=1)::int as deterministic_candidates,
  count(*) filter(where coalesce(d.dir_count,0)<>1)::int as unresolved_rows,
  0::int as authority_verified_rows,
  case when count(*) filter(where coalesce(d.dir_count,0)<>1)=0
       then 'REVIEW_REQUIRED'
       else 'BLOCKED_CURRENT_AWQAF_ROSTER_REQUIRED' end as data_load_gate
from lgus l
left join dir_counts d on d.governorate_id=l.governorate_id;
