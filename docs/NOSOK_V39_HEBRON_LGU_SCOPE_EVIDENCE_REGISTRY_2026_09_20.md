# Nosok v39 — Hebron LGU Scope Evidence Registry

Date: 2026-09-20

## Matrix

Machine-readable matrix:

`evidence/NOSOK_V39_HEBRON_LGU_SCOPE_EVIDENCE_MATRIX_2026_09_20.csv`

Columns:

```text
lgu_id
lgus_no
lgu_code
lgu_name_ar
city_status
candidate_directorate
evidence_source
evidence_type
confidence
authority_verified
decision
```

## Decision semantics

- `AUTHORITY_VERIFIED`: direct institutional/operational evidence ties the current LGU itself to the directorate identity.
- `SUPPORTING_EVIDENCE_ONLY`: evidence supports a candidate but does not establish a complete formal jurisdiction assignment.
- `UNRESOLVED_FAIL_CLOSED`: no sufficiently specific evidence; no policy row may be loaded.
- `EXCLUDED_NON_CURRENT_CITY_STATUS`: Core marks the geography as removed/displaced; it is not eligible for current operational authorization.
- `STATUS_REVIEW_REQUIRED`: Core current-status metadata is incomplete and must be reconciled before policy assignment.

## Source registry

### SRC_NH_HALHUL_2018

Authority line: North Hebron / Halhul.

Evidence:
- Halhul Municipality mosque inventory states its source is “Directorate of Awqaf North Hebron”.
- Halhul Municipality also records current institutional participation by Awqaf North Hebron in Halhul.

URLs:
- https://halhul-city.ps/site/2018/09/16/%D9%85%D8%B3%D8%A7%D8%AC%D8%AF-%D9%85%D8%AF%D9%8A%D9%86%D8%A9-%D8%AD%D9%84%D8%AD%D9%88%D9%84/
- https://halhul-city.ps/site/2024/02/22/%D8%A8%D9%84%D8%AF%D9%8A%D8%A9-%D8%AD%D9%84%D8%AD%D9%88%D9%84-%D8%AA%D8%B9%D9%82%D8%AF-%D8%A7%D8%AC%D8%AA%D9%85%D8%A7%D8%B9%D8%A7-%D9%84%D8%A8%D8%AD%D8%AB-%D9%88%D8%AF%D8%B1%D8%A7%D8%B3%D9%87-%D8%B7/

Classification: `HIGH / AUTHORITY_VERIFIED` for Halhul only.
### SRC_YATTA_PLAN_2023_2026

Authority line: Yatta.

Evidence:
Yatta Municipality development plan states that the Directorate of Awqaf Yatta supervises the city's mosques, religious activities, cemeteries, waqf lands, Quran center, and Hajj-related affairs.

URL:
- https://yatta-munc.org/Images/UploadWebFiles/%D8%AA%D8%B4%D8%AE%D9%8A%D8%B5-%D8%A7%D9%84%D9%85%D8%AC%D8%A7%D9%84%D8%A7%D8%AA-%D8%A7%D9%84%D8%AA%D9%86%D9%85%D9%88%D9%8A%D8%A9-2023-%D8%A8%D8%B9%D8%AF-%D8%A7%D9%84%D8%AA%D8%B9%D8%AF%D9%8A%D9%84.pdf

Classification: `HIGH / AUTHORITY_VERIFIED` for Yatta city.
“Masafir Yatta” remains supporting-only until a direct jurisdiction source is captured.

### SRC_SH_DURA_HQ_2019

Authority line: South Hebron / Dura.

Evidence:
- Ministry-reported agreement established the South Hebron Awqaf Directorate headquarters in Dura.
- Dura Municipality records official correspondence from “Directorate of Awqaf South Hebron in Dura”.

URLs:
- https://palsawa.com/post/187951/
- https://duracity.ps/web/index.php?Itemid=802&catid=93&id=360%3A171-2020&option=com_content&view=article

Classification: `HIGH / AUTHORITY_VERIFIED` for Dura.
### SRC_SH_DHAHIRIYA_2025_2026

Authority line candidate: South Hebron / al-Dhahiriya.

Evidence:
A current Ministry-affiliated Islamic College in al-Dhahiriya records direct cooperation with the Director General of South Hebron Awqaf. Additional operational evidence reports South Hebron Awqaf cemetery activity in al-Dhahiriya.

URL:
- https://dcsis.edu.ps/

Classification: `HIGH / SUPPORTING_EVIDENCE_ONLY`.
The evidence shows active institutional reach but is not a formal jurisdiction roster.

### SRC_NH_SERVICE_COUNCIL_2010 / SRC_NH_WATER_COUNCIL_2018

Candidate line: North Hebron.

Evidence:
Halhul Municipality records North Hebron joint-service groupings containing a set of local authorities, including Halhul, Beit Ummar, Surif, Sa'ir, ash-Shuyukh, Bani Na'im, Kharas, Nuba, Beit Ula and others.

URLs:
- https://halhul-city.ps/site/2010/01/11/%D9%85%D8%AC%D9%84%D8%B3-%D8%A7%D9%84%D8%AE%D8%AF%D9%85%D8%A7%D8%AA-%D8%A7%D9%84%D9%85%D8%B4%D8%AA%D8%B1%D9%83-%D9%8A%D8%B2%D8%A7%D9%88%D9%84-%D9%85%D9%87%D8%A7%D9%85%D9%87-%D9%85%D9%86-%D9%85%D9%82/
- https://halhul-city.ps/site/2018/10/02/%D9%88%D8%B2%D9%8A%D8%B1-%D8%A7%D9%84%D8%AD%D9%83%D9%85-%D8%A7%D9%84%D9%85%D8%AD%D9%84%D9%8A-%D9%8A%D8%B5%D8%AF%D8%B1-%D9%82%D8%B1%D8%A7%D8%B1%D8%A7-%D8%A8%D8%A5%D9%86%D8%B4%D8%A7%D8%A1-%D9%85%D8%AC/

Classification: `MEDIUM/LOW SUPPORTING_EVIDENCE_ONLY`.
These are regional service-administration sources, not Awqaf jurisdiction instruments.
### SRC_SH_LOCAL_COUNCILS_EVENT_2017

Candidate line: South Hebron.

Evidence:
A South Hebron Awqaf director participated institutionally with councils/localities including Abu al-Asja, Rabud and Karza.

URL:
- https://www.maannews.net/news/902579.html

Classification: `MEDIUM / SUPPORTING_EVIDENCE_ONLY`.
Presence/activity is not equivalent to formal jurisdiction.

### SRC_CORE_HEBRON_PROFILE

Candidate line: Hebron.

Evidence:
Canonical `core.org_units` and `core.org_unit_profiles` identify the Hebron Awqaf Directorate and location label Hebron.

Classification: `HIGH / SUPPORTING_EVIDENCE_ONLY`.
Identity/location alone is not sufficient to infer the directorate's entire LGU jurisdiction.

## Current gate

```text
TOTAL_MATRIX_ROWS=153
CURRENT_OPERATIONAL_ROWS=132
AUTHORITY_VERIFIED_ROWS=3
SUPPORTING_ONLY_ROWS=20
UNRESOLVED_CURRENT_ROWS=109
EXCLUDED_NON_CURRENT_ROWS=20
STATUS_REVIEW_REQUIRED_ROWS=1
POLICY_LOAD_READY=NO
```

## Targeted Evidence Expansion — Batch 01 (2026-09-20)

This batch supersedes the earlier 3-row verified count.

### SRC_NH_KHARAS_2025_GOV_REPORT

LGU: خاراس → North Hebron.

Evidence: the Palestinian Government Communication Center weekly report, published by WAFA, states under the Ministry of Awqaf section that in North Hebron the directorate organized an iftar for Qur'an-course students in Kharas.

URL: https://wafa.ps/Pages/Details/117999

Classification: `HIGH / AUTHORITY_VERIFIED`.

### SRC_NH_BEIT_ULA_2025_AYYAM

LGU: بيت أولا → North Hebron.

Evidence: Al-Ayyam reported in November 2025 that the North Hebron Awqaf Directorate honored Qur'an students in al-Jab'a and Beit Ula, with the Awqaf director and department heads present.

URL: https://www.al-ayyam.ps/public/pdfs/2025/11/03/all/all.pdf

Classification: `HIGH / AUTHORITY_VERIFIED`.

### SRC_NH_BEIT_UMMAR_2023_DIRECTORATE_ACTION

LGU: بيت أمر → North Hebron.

Evidence: a 2023 report records North Hebron Awqaf Directorate action concerning the khatib/imam of Beit Ummar Grand Mosque, directly tying the town's mosque administration to the directorate.

URL: https://shahed.cc/archives/63739

Classification: `HIGH / AUTHORITY_VERIFIED` for current operational scope, with source-quality note: secondary local media reporting direct directorate action.

### SRC_SH_DHAHIRIYA_2025_DIRECTORATE_POST

LGU: الظاهرية → South Hebron.

Evidence: a 2025 post from the South Hebron Awqaf Directorate, mirrored by FindGlocal, records the directorate's manager honoring volunteers for cleaning six cemeteries in al-Dhahiriya.

URL: https://www.findglocal.com/IL/Hebron/619365621570283/%D9%85%D8%AF%D9%8A%D8%B1%D9%8A%D8%A9-%D8%A7%D9%88%D9%82%D8%A7%D9%81-%D8%AC%D9%86%D9%88%D8%A8-%D8%A7%D9%84%D8%AE%D9%84%D9%8A%D9%84

Classification: `HIGH / AUTHORITY_VERIFIED` for current operational scope, with source-quality note: mirror of directorate-originated content rather than the ministry domain itself.

### SRC_HEBRON_TARQUMIYA_2015_MOSQUE_OPENING

LGU: ترقوميا → Hebron candidate.

Evidence: a 2015 report states that the Hebron Awqaf Directorate opened Khalid ibn al-Walid Mosque in Tarqumiya.

URL: https://www.maannews.net/news/774318.html

Classification: `MEDIUM / SUPPORTING_EVIDENCE_ONLY`.
Reason: direct but historical; it is not sufficient by itself to prove the current 2026 jurisdiction after later organizational changes.

## Batch-01 gate

```text
TOTAL_MATRIX_ROWS=153
CURRENT_OPERATIONAL_ROWS=132
AUTHORITY_VERIFIED_ROWS=7
SUPPORTING_EVIDENCE_ONLY_ROWS=16
UNRESOLVED_FAIL_CLOSED_ROWS=109
EXCLUDED_NON_CURRENT_ROWS=20
STATUS_REVIEW_REQUIRED_ROWS=1
POLICY_LOAD_READY=NO
```

No policy row may be inserted solely from the supporting-only set.

### SRC_SH_PREACHER_SCHEDULE_2025_08_01

Evidence: public Dura City Telegram post dated 2025-08-01 explicitly labels an image as “Friday preachers schedule for mosques affiliated with the South Hebron / Dura Awqaf Directorate”.

URL: https://t.me/DuraCity/28370

Locally downloaded evidence SHA256 during review:
`79B4CC5F9B569C66F78361818F5A8A72880863FAFCEEF1F26172E422360BCE24`

Classification: `HIGH SOURCE / NO ROW PROMOTION YET`.
Reason: the image itself could not be read with sufficient certainty in the available toolchain, and no Arabic OCR was installed. No LGU was inferred from neighboring channel posts or from geographic proximity.
