-- NOSOK v39 — Hebron LGU scope evidence matrix
-- READ ONLY. No DDL/DML/GRANT.
-- Current authorization candidates use core.core_lgus only.
-- Batch-01 targeted evidence expansion applied 2026-09-20.

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
), evidence as (
  select b.*,
    case
      when b.lgu_name_ar in ('حلحول','خاراس','بيت اولا','بيت امر') then 'North Hebron'
      when b.lgu_name_ar in ('صوريف','نوبا','سعير','بني نعيم','الشيوخ', E'\tشيوخ العروب','حتا','اذنا','بيت كاحل','تفوح') then 'North Hebron'
      when b.lgu_name_ar in ('دورا','الظاهريه','السموع','خرسا','دير رازح','فقيقيس','سلامه') then 'South Hebron'
      when b.lgu_name_ar in ('ابو العسجا','رابود','كرزه','مزرعه عناب الصغيره') then 'South Hebron'
      when b.lgu_name_ar in ('يطا','مسافر يطا','خله الضبع-مسافر يطا') then 'Yatta'
      when b.lgu_name_ar in ('الخليل','ترقوميا') then 'Hebron'
      else null
    end as candidate_directorate,
    case
      when b.lgu_name_ar='حلحول' then 'SRC_NH_HALHUL_2018'
      when b.lgu_name_ar='خاراس' then 'SRC_NH_KHARAS_2025_GOV_REPORT'
      when b.lgu_name_ar='بيت اولا' then 'SRC_NH_BEIT_ULA_2025_AYYAM'
      when b.lgu_name_ar='بيت امر' then 'SRC_NH_BEIT_UMMAR_2023_DIRECTORATE_ACTION'
      when b.lgu_name_ar='يطا' then 'SRC_YATTA_PLAN_2023_2026'
      when b.lgu_name_ar='دورا' then 'SRC_SH_DURA_HQ_2019'
      when b.lgu_name_ar='الظاهريه' then 'SRC_SH_DHAHIRIYA_2025_DIRECTORATE_POST'
      when b.lgu_name_ar='السموع' then 'SRC_SH_AS_SAMU_2024_MUNICIPAL_TAJWEED'
      when b.lgu_name_ar in ('خرسا','دير رازح','فقيقيس') then 'SRC_SH_HAJJ_WINNERS_2026'
      when b.lgu_name_ar='سلامه' then 'SRC_SH_HAJJ_WINNERS_2026_KHIRBET_SALAMA_ALIAS_PENDING'
      when b.lgu_name_ar='مزرعه عناب الصغيره' then 'SRC_SH_ENNAB_AL_SAGHIRA_2025_DIRECTORATE_VISIT'
      when b.lgu_name_ar='الخليل' then 'SRC_CORE_HEBRON_PROFILE'
      when b.lgu_name_ar='ترقوميا' then 'SRC_HEBRON_TARQUMIYA_2015_MOSQUE_OPENING'
      when b.lgu_name_ar='نوبا' then 'SRC_NH_KHARAS_NUBA_2025_GOV_REPORT'
      when b.lgu_name_ar in ('صوريف','سعير','بني نعيم','الشيوخ', E'\tشيوخ العروب','اذنا','بيت كاحل','تفوح') then 'SRC_NH_SERVICE_COUNCIL_OR_DIRECT_RELATION_SUPPORT'
      when b.lgu_name_ar='حتا' then 'SRC_NH_WATER_COUNCIL_2018'
      when b.lgu_name_ar in ('ابو العسجا','رابود','كرزه') then 'SRC_SH_LOCAL_COUNCILS_EVENT_2017'
      when b.lgu_name_ar in ('مسافر يطا','خله الضبع-مسافر يطا') then 'SRC_YATTA_PLAN_2023_2026'
      else null
    end as evidence_source
  from base b
), classified as (
  select e.*,
    case
      when e.city_status in ('مزاله','مهجره') then 'NONE'
      when e.city_status='<NULL>' then 'NONE'
      when e.lgu_name_ar in ('حلحول','خاراس','بيت اولا','بيت امر','يطا','دورا','الظاهريه','السموع','خرسا','دير رازح','فقيقيس','مزرعه عناب الصغيره') then 'HIGH'
      when e.lgu_name_ar='ترقوميا' then 'MEDIUM'
      when e.candidate_directorate is not null then 'MEDIUM'
      else 'NONE'
    end as confidence,
    case
      when e.lgu_name_ar in ('حلحول','خاراس','بيت اولا','بيت امر','يطا','دورا','الظاهريه','السموع','خرسا','دير رازح','فقيقيس')
        and e.city_status='موجوده' then true
      else false
    end as authority_verified
  from evidence e
)
select
  c.*,
  case
    when c.city_status in ('مزاله','مهجره') then 'EXCLUDED_NON_CURRENT_CITY_STATUS'
    when c.city_status='<NULL>' then 'STATUS_REVIEW_REQUIRED'
    when c.authority_verified then 'AUTHORITY_VERIFIED'
    when c.candidate_directorate is not null then 'SUPPORTING_EVIDENCE_ONLY'
    else 'UNRESOLVED_FAIL_CLOSED'
  end as decision
from classified c
order by c.lgus_no,c.lgu_name_ar;

-- Expected Batch-03 summary:
-- TOTAL_MATRIX_ROWS=153
-- CURRENT_OPERATIONAL_ROWS=132
-- AUTHORITY_VERIFIED_ROWS=11
-- SUPPORTING_EVIDENCE_ONLY_ROWS=18
-- UNRESOLVED_FAIL_CLOSED_ROWS=103
-- EXCLUDED_NON_CURRENT_ROWS=20
-- STATUS_REVIEW_REQUIRED_ROWS=1
