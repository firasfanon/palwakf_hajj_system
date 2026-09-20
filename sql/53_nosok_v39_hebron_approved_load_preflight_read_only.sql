-- NOSOK v39 — Hebron APPROVED-only load preflight
-- READ ONLY. No DDL/DML/GRANT.
-- Reviewed authority dataset contains 12 APPROVED rows.

with approved(unit_id,lgu_id) as (
  values
  ('04f19f65-5e0c-47df-b897-9dd88152ea6c'::uuid,'8a7b2bcd-3fd3-4ec4-aee6-bf0ecb83bf4c'::uuid),
  ('04f19f65-5e0c-47df-b897-9dd88152ea6c'::uuid,'76936253-7d3b-4e17-acb6-f1a74ceb87c5'::uuid),
  ('8e0238db-2e20-49d4-8cf2-db7c376d512b'::uuid,'f295f8a9-34ba-494e-b653-8c0521f68549'::uuid),
  ('7e391f77-ded8-4ea8-b0eb-d518507ff194'::uuid,'f4daa9a4-4b8f-4166-8f17-a2018985752d'::uuid),
  ('7270d37a-6eca-4fd4-8abe-0164022f9a80'::uuid,'bd13d5bf-b3fe-49ea-ba4e-483d7ab98e32'::uuid),
  ('7270d37a-6eca-4fd4-8abe-0164022f9a80'::uuid,'c8801611-6b8c-487e-a084-c8efdc87ad88'::uuid),
  ('04f19f65-5e0c-47df-b897-9dd88152ea6c'::uuid,'4d207532-6317-457d-aafb-8ca884ac70ed'::uuid),
  ('04f19f65-5e0c-47df-b897-9dd88152ea6c'::uuid,'3ee44241-6ec0-4679-bb87-5cd62f99742d'::uuid),
  ('7270d37a-6eca-4fd4-8abe-0164022f9a80'::uuid,'9866c853-55b8-432b-8763-9d0b3a4d8550'::uuid),
  ('7270d37a-6eca-4fd4-8abe-0164022f9a80'::uuid,'1220a8e5-be94-4122-870a-d037fae7bfc1'::uuid),
  ('7270d37a-6eca-4fd4-8abe-0164022f9a80'::uuid,'b8bc08d2-244d-4182-b2be-ae58c415fb5a'::uuid),
  ('7270d37a-6eca-4fd4-8abe-0164022f9a80'::uuid,'106fe2e0-58b4-4fbe-9009-4a1fb3465bfb'::uuid)
)
select
 count(*)::int as rows,
 count(*) filter(where u.id is not null and u.is_active and u.unit_type::text='directorate')::int as valid_units,
 count(*) filter(where l.id is not null and l.is_active and l.governorate_no=2)::int as valid_lgus,
 count(*) filter(where u.governorate_id=g.id)::int as same_governorate,
 count(*) filter(where p.id is not null)::int as preexisting_policy_rows
from approved a
left join core.org_units u on u.id=a.unit_id
left join core.core_lgus l on l.id=a.lgu_id
left join core.core_governorates g on g.governorate_no=l.governorate_no
left join nosok.administrative_unit_lgu_scope_policy p
 on p.unit_id=a.unit_id and p.lgu_id=a.lgu_id;

-- Expected:
-- rows=12
-- valid_units=12
-- valid_lgus=12
-- same_governorate=12
-- preexisting_policy_rows=0
