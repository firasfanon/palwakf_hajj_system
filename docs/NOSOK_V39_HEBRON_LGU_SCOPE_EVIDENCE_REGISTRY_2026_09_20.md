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

## Targeted Evidence Expansion — Batch 02 (2026-09-20)

### SRC_SH_AS_SAMU_2024_MUNICIPAL_TAJWEED

LGU: السموع → South Hebron.

Evidence: Samu Municipality documented on 21/11/2024 that five students from the town placed among the top ten in the 2024 Tajweed examination at the level of the South Hebron Awqaf Directorate.

URL: https://samou.ps/content/news/223.html

Classification: `HIGH / AUTHORITY_VERIFIED`.
Reason: current municipal evidence directly ties residents of the LGU to an operational examination administered at South Hebron Awqaf directorate level.

### SRC_SH_ENNAB_AL_SAGHIRA_2025_DIRECTORATE_VISIT

LGU: مزرعه عناب الصغيره → South Hebron candidate.

Evidence: a 2025 South Hebron Awqaf Directorate-originated post records the directorate receiving students from Ennab al-Saghira School. Core and GIS contain exactly one current Hebron LGU named `مزرعه عناب الصغيره` (lgus_no=680).

URL: https://www.findglocal.com/IL/Hebron/619365621570283/%D9%85%D8%AF%D9%8A%D8%B1%D9%8A%D8%A9-%D8%A7%D9%88%D9%82%D8%A7%D9%81-%D8%AC%D9%86%D9%88%D8%A8-%D8%A7%D9%84%D8%AE%D9%84%D9%8A%D9%84

Classification: `HIGH / SUPPORTING_EVIDENCE_ONLY`.
Reason: direct institutional contact is current and the locality identity is unambiguous, but a school visit alone does not establish formal jurisdiction.

## Batch-02 gate

```text
TOTAL_MATRIX_ROWS=153
CURRENT_OPERATIONAL_ROWS=132
AUTHORITY_VERIFIED_ROWS=8
SUPPORTING_EVIDENCE_ONLY_ROWS=17
UNRESOLVED_FAIL_CLOSED_ROWS=107
EXCLUDED_NON_CURRENT_ROWS=20
STATUS_REVIEW_REQUIRED_ROWS=1
POLICY_LOAD_READY=NO
```

## Targeted Evidence Expansion — Batch 03 (2026-09-20)

### SRC_SH_HAJJ_WINNERS_2026

LGUs promoted:
- خرسا → South Hebron.
- دير رازح → South Hebron.
- فقيقيس → South Hebron.

Evidence: a current Hajj-winners post explicitly labels the listed places as “المناطق التابعة لمديرية اوقاف جنوب الخليل” and then enumerates, among others, دير رازح، فقيقيس، خرسا. This is directly relevant to Nosok because it is an Awqaf operational jurisdiction statement in the Hajj-registration context itself.

Public mirror:
- https://t.me/s/DuraCity?before=33550

Classification for the three exact-name matches: `HIGH / AUTHORITY_VERIFIED`.
Reason: exact current Core LGU names are present in a current Hajj jurisdiction list tied explicitly to South Hebron Awqaf.

### SRC_SH_HAJJ_WINNERS_2026_KHIRBET_SALAMA_ALIAS_PENDING

Candidate LGU: سلامه → South Hebron.

Evidence source uses the label `خربة سلامة`, while current Core LGU row is named `سلامه` and does not expose an authoritative alias field proving exact identity.

Classification: `MEDIUM / SUPPORTING_EVIDENCE_ONLY`.
Reason: probable match is insufficient for authorization; alias reconciliation is required before promotion.

## Batch-03 gate

```text
TOTAL_MATRIX_ROWS=153
CURRENT_OPERATIONAL_ROWS=132
AUTHORITY_VERIFIED_ROWS=11
SUPPORTING_EVIDENCE_ONLY_ROWS=18
UNRESOLVED_FAIL_CLOSED_ROWS=103
EXCLUDED_NON_CURRENT_ROWS=20
STATUS_REVIEW_REQUIRED_ROWS=1
POLICY_LOAD_READY=NO
```

## Targeted Evidence Expansion — Batch 04 (2026-09-20)

Batch 04 tightened evidence quality without inflating the authority-verified count.

### SRC_NH_NUBA_GOVERNMENT_AWQAF_REPORT_2025

LGU: نوبا → North Hebron candidate.

Evidence: the Palestinian Government Communication Center weekly report, under the Ministry of Awqaf section, places the Nuba Quran-house activity in the same North Hebron Awqaf intervention paragraph that directly identifies the directorate's activity in Kharas.

Source: WAFA / Government Communication Center, 29-03-2025.

Classification: `HIGH / SUPPORTING_EVIDENCE_ONLY`.
Reason: this is current government evidence in an Awqaf context, but it does not explicitly state that Nuba is administratively assigned to the directorate.

### SRC_NH_SURIF_MUNICIPAL_DIRECT_RELATION_2018

LGU: صوريف → North Hebron candidate.

Evidence: Surif Municipality records an official municipal visit to the Director of North Hebron Awqaf to discuss matters of public interest.

Classification: `MEDIUM / SUPPORTING_EVIDENCE_ONLY`.
Reason: direct institutional relation is established, but territorial jurisdiction is not explicitly stated.

### Batch-04 no-promotion rule

Current South Hebron search also found multiple current service/health/regional references for Deir Samet, Beit Awwa, ar-Rihiya and other Dura-area localities. These were not used to authorize Awqaf scope because another ministry's regional boundary is not proof of Awqaf jurisdiction.

```text
TOTAL_MATRIX_ROWS=153
CURRENT_OPERATIONAL_ROWS=132
AUTHORITY_VERIFIED_ROWS=11
SUPPORTING_EVIDENCE_ONLY_ROWS=18
UNRESOLVED_FAIL_CLOSED_ROWS=103
EXCLUDED_NON_CURRENT_ROWS=20
STATUS_REVIEW_REQUIRED_ROWS=1
POLICY_LOAD_READY=NO
```

## Targeted Evidence Expansion — Batch 05 (2026-09-20)

Batch 05 focused on direct Hajj/Awqaf jurisdiction evidence for the remaining current LGUs. No new row met the AUTHORITY_VERIFIED threshold.

### Hajj operational-region identity confirmation

Current Hajj operating material lists Halhul, Yatta, Dura, and Hebron separately among pilgrim travel regions. Current Hajj registration instructions also require winning pilgrims to report to Awqaf directorates, each in their own region.

Sources:
- Dura City / Ministry Hajj travel notice: https://t.me/s/DuraCity/25794
- Dura City / 1447H-2026 registration notice: https://t.me/s/DuraCity/33612

Classification: `HIGH / ORGANIZATIONAL_IDENTITY_SUPPORT`.
This strengthens the four-region operating model but does not allocate an unresolved LGU by itself.

### South Hebron direct-source search

Current sources were reviewed for Beit Awwa, Deir Samet, ar-Rihiya, al-Majd, Imreish, as-Surra, Beit ar-Rush, Karma, Deir al-Asal and related Dura-area LGUs.

The strongest new results were:
- current Friday-preacher schedules explicitly labelled as mosques affiliated with South Hebron / Dura Awqaf, but the individual mosque/locality rows remain image-only in the available source;
- current Hajj notices and South Hebron pilgrim guidance based in Dura;
- non-Awqaf health/agriculture/service-region lists containing several of these localities.

No LGU was promoted from those sources because image text was not reliably extractable and another ministry's regional boundary is not Awqaf jurisdiction evidence.

### Yatta direct-source search

Yatta Municipality's development plan states that the Directorate of Awqaf Yatta manages mosque, religious, cemetery, waqf-land, Quran-center and Hajj affairs in the city and its environs, with approximately 212 mosques/prayer places in the city and environs.

Source:
- https://yatta-munc.org/Images/UploadWebFiles/%D8%AA%D8%B4%D8%AE%D9%8A%D8%B5-%D8%A7%D9%84%D9%85%D8%AC%D8%A7%D9%84%D8%A7%D8%AA-%D8%A7%D9%84%D8%AA%D9%86%D9%85%D9%88%D9%8A%D8%A9-2023-%D8%A8%D8%B9%D8%AF-%D8%A7%D9%84%D8%AA%D8%B9%D8%AF%D9%8A%D9%84.pdf

This supports the Yatta organizational scope concept but does not name enough individual LGUs to authorize Karmil, at-Tuwani, Umm al-Khair, Susiya or other unresolved rows.

### Batch-05 gate

```text
TOTAL_MATRIX_ROWS=153
CURRENT_OPERATIONAL_ROWS=132
AUTHORITY_VERIFIED_ROWS=11
SUPPORTING_EVIDENCE_ONLY_ROWS=18
UNRESOLVED_FAIL_CLOSED_ROWS=103
EXCLUDED_NON_CURRENT_ROWS=20
STATUS_REVIEW_REQUIRED_ROWS=1
FALSE_PROMOTIONS=0
POLICY_LOAD_READY=NO
```
