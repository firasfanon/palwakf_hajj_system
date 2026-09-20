-- NOSOK v39 — Current LGU scope candidates
-- READ ONLY. No DDL/DML/GRANT.
-- Uses current core.core_lgus + gis.lgus_boundary only.
-- core.core_communities is intentionally excluded from authorization logic.

with active_directorates as (
  select
    u.id as unit_id,
    u.slug as unit_slug,
    u.name_ar as unit_name_ar,
    u.governorate_id,
    count(*) over (partition by u.governorate_id) as active_directorate_count
  from core.org_units u
  where u.unit_type::text='directorate'
    and u.is_active=true
),
unique_directorate as (
  select * from active_directorates
  where active_directorate_count=1
),
current_lgus as (
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
    on g.governorate_no=l.governorate_no
  join gis.lgus_boundary gb
    on gb.lgusb_no=l.lgus_no
  where l.is_active=true
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
    when u.unit_id is not null then 'CURRENT_LGU_SINGLE_DIRECTORATE_CANDIDATE'
    else 'CURRENT_LGU_MULTI_DIRECTORATE_FAIL_CLOSED'
  end as resolution_status,
  false as authority_verified,
  false as load_ready
from current_lgus l
left join unique_directorate u
  on u.governorate_id=l.governorate_id
order by l.governorate_no,l.lgus_no;
