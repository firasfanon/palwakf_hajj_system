# UAT_MATRIX_NOSOK_V24_2

| المحور | الحالة | الدليل |
|---|---|---|
| flutter clean | passed | user local log |
| flutter pub get | passed | user local log |
| dart format . | passed | user local log |
| flutter analyze | passed | No issues found |
| flutter run -d chrome | passed | Debug service listening / Dart VM Service available |
| Public pages opened | reported passed | user statement: كل الصفحات تعمل |
| Internal pages opened | reported passed | user statement: كل الصفحات تعمل |
| Role UAT | pending | needs role screenshots/logs |
| Responsive UAT | pending | needs desktop/tablet/mobile evidence |
| Supabase SQL UAT | pending | needs SQL result output |
| Full PalWakf Merge | pending | needs full repo apply evidence |
| Production Gate | not approved | blocked pending above |

## المسارات المطلوب توثيقها لاحقًا

### Public
- `/services/nosok`
- `/services/nosok/apply`
- `/services/nosok/track`
- `/services/nosok/requirements`
- `/services/nosok/faq`

### Internal
- `/admin/systems/nosok`
- `/admin/systems/nosok/requests`
- `/admin/systems/nosok/review`
- `/admin/systems/nosok/campaigns`
- `/admin/systems/nosok/groups`
- `/admin/systems/nosok/documents`
- `/admin/systems/nosok/messages`
- `/admin/systems/nosok/reports`
- `/admin/systems/nosok/settings`
