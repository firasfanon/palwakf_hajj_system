-- NOSOK v39 — Hebron multi-directorate scope census
-- READ ONLY. No policy inference.

select
  u.id as unit_id,
  u.slug,
  u.name_ar,
  u.is_active,
  p.location_label
from core.org_units u
left join core.org_unit_profiles p on p.unit_id=u.id
where u.governorate_id=(
  select id from core.core_governorates where governorate_no=2
)
and u.unit_type::text='directorate'
order by u.slug;

select
  l.id as lgu_id,
  l.lgus_no,
  l.code,
  l.name_ar,
  gb.lgusn as gis_name,
  gb.governorate
from core.core_lgus l
join gis.lgus_boundary gb on gb.lgusb_no=l.lgus_no
where l.governorate_no=2
  and l.is_active=true
order by l.lgus_no;

-- Expected current gate:
-- 153 LGUs
-- 4 active directorates
-- 0 canonical Unit→LGU rows available before Nosok policy load.
