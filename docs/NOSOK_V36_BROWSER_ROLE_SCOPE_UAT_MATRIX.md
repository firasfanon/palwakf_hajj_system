# Nosok v36 — Browser/Role/Scope UAT Matrix

| case | actor | route/surface | required evidence |
|---|---|---|---|
| public_campaigns_list | anonymous | `/services/nosok` | Network RPC 200/empty-safe + Console clean |
| public_requirements_list | anonymous | `/services/nosok/requirements` | Published-only requirements + no direct table payload |
| public_application_submit | anonymous/public applicant | `/services/nosok/apply` | Safe tracking or safe rejection + no raw backend error |
| public_application_track | anonymous/public applicant | `/services/nosok/track` | No PII/no documents/no audit payload |
| authenticated_no_nosok_role | authenticated without role | `/admin/systems/nosok` | Arabic forbidden/hidden route |
| wrong_unit_scope | unit user wrong scope | admin unit surfaces | scope denied |

الإنتاج محجوب حتى إغلاق هذه الحالات بدليل متصفح وشبكة وconsole.
