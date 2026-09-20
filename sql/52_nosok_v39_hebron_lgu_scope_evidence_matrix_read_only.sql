-- NOSOK v39 — Hebron LGU scope evidence matrix
-- READ ONLY. No DDL/DML/GRANT.
-- Current authorization candidates use core.core_lgus only.

with base as (
  select
    l.id as lgu_id,
    l.lgus_no,
    l.code as lgu_code,
    l.name_ar as lgu_name_ar,
    coalesce(l.city_status,'<NULL>') as city_status
  from core.core_lgus l
  where l.governorate_no=2
    and l.is_active=true
), classified as (
  select b.*,
    case
      when b.city_status in ('مزاله','مهجره') then null
      when b.city_status='<NULL>' then null
      when b.lgu_name_ar='حلحول' then 'North Hebron'
      when b.lgu_name_ar in (
        'بيت امر','صوريف','نوبا','بيت اولا','سعير','بني نعيم',
        'خاراس','الشيوخ', E'\tشيوخ العروب','حتا','ترقوميا',
        'اذنا','بيت كاحل','تفوح'
      ) then 'North Hebron'
      when b.lgu_name_ar='يطا' then 'Yatta'
      when b.lgu_name_ar in ('مسافر يطا','خله الضبع-مسافر يطا') then 'Yatta'
      when b.lgu_name_ar='دورا' then 'South Hebron'
      when b.lgu_name_ar='الظاهريه' then 'South Hebron'
      when b.lgu_name_ar in ('ابو العسجا','رابود','كرزه') then 'South Hebron'
      when b.lgu_name_ar='الخليل' then 'Hebron'
      else null
    end as candidate_directorate,
    case
      when b.city_status in ('مزاله','مهجره') then null
      when b.city_status='<NULL>' then null
      when b.lgu_name_ar='حلحول' then 'SRC_NH_HALHUL_2018'
      when b.lgu_name_ar='يطا' then 'SRC_YATTA_PLAN_2023_2026'
      when b.lgu_name_ar='دورا' then 'SRC_SH_DURA_HQ_2019'
      when b.lgu_name_ar='الخليل' then 'SRC_CORE_HEBRON_PROFILE'
      when b.lgu_name_ar='الظاهريه' then 'SRC_SH_DHAHIRIYA_2025_2026'
      when b.lgu_name_ar in (
        'بيت امر','صوريف','نوبا','بيت اولا','سعير','بني نعيم',
        'خاراس','الشيوخ', E'\tشيوخ العروب','ترقوميا',
        'اذنا','بيت كاحل','تفوح'
      ) then 'SRC_NH_SERVICE_COUNCIL_2010'
      when b.lgu_name_ar='حتا' then 'SRC_NH_WATER_COUNCIL_2018'
      when b.lgu_name_ar in ('ابو العسجا','رابود','كرزه')
        then 'SRC_SH_LOCAL_COUNCILS_EVENT_2017'
      when b.lgu_name_ar in ('مسافر يطا','خله الضبع-مسافر يطا')
        then 'SRC_YATTA_PLAN_2023_2026'
      else null
    end as evidence_source
  from base b
)
select
  c.*,
  case
    when c.city_status in ('مزاله','مهجره') then 'NONE'
    when c.city_status='<NULL>' then 'NONE'
    when c.lgu_name_ar in ('حلحول','يطا','دورا')
      then 'HIGH'
    when c.lgu_name_ar in ('الخليل','الظاهريه')
      then 'HIGH'
    when c.candidate_directorate is not null then 'MEDIUM'
    else 'NONE'
  end as confidence,
  (c.lgu_name_ar in ('حلحول','يطا','دورا')
   and c.city_status='موجوده') as authority_verified,
  case
    when c.city_status in ('مزاله','مهجره')
      then 'EXCLUDED_NON_CURRENT_CITY_STATUS'
    when c.city_status='<NULL>'
      then 'STATUS_REVIEW_REQUIRED'
    when c.lgu_name_ar in ('حلحول','يطا','دورا')
      then 'AUTHORITY_VERIFIED'
    when c.candidate_directorate is not null
      then 'SUPPORTING_EVIDENCE_ONLY'
    else 'UNRESOLVED_FAIL_CLOSED'
  end as decision
from classified c
order by c.lgus_no,c.lgu_name_ar;
-- Summary gate.
with matrix as (
  select
    coalesce(city_status,'<NULL>') as city_status,
    name_ar
  from core.core_lgus
  where governorate_no=2 and is_active=true
)
select
  count(*)::int as total_rows,
  count(*) filter(where city_status='موجوده')::int as current_operational_rows,
  count(*) filter(where city_status in ('مزاله','مهجره'))::int as excluded_non_current_rows,
  count(*) filter(where city_status='<NULL>')::int as status_review_required_rows
from matrix;
