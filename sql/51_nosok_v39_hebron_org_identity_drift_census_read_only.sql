-- NOSOK v39 — Hebron Awqaf org identity drift census
-- READ ONLY.

select
  u.id,
  u.slug,
  u.code,
  u.name_ar,
  u.name_en,
  u.unit_type::text as unit_type,
  u.is_active,
  u.governorate_id,
  p.location_label,
  p.site_title
from core.org_units u
left join core.org_unit_profiles p on p.unit_id=u.id
where u.governorate_id=(
  select id
  from core.core_governorates
  where governorate_no=2
)
and u.unit_type::text='directorate'
order by u.slug;

-- Review note:
-- UUIDs are canonical.
-- Public/current labels must not be used as authorization keys.
-- No UPDATE/rename is performed by this census.
