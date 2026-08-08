# UAT_MATRIX — Nosok v24

## Browser UAT
| المسار | النوع | الحالة |
|---|---|---|
| /services/nosok | Public | passed حسب v23.2 |
| /services/nosok/apply | Public | passed / يحتاج UAT مع Supabase للرفع |
| /services/nosok/track | Public | passed / privacy review مستمر |
| /services/nosok/requirements | Public | passed بعد hotfix |
| /admin/systems/nosok | Internal | passed |
| /admin/systems/nosok/requests | Internal | passed |
| /admin/systems/nosok/review | Internal | passed |
| /admin/systems/nosok/campaigns | Internal | passed |
| /admin/systems/nosok/documents | Internal | passed |
| /admin/systems/nosok/messages | Internal | passed |

## Role UAT
| الدور | الحالة | ملاحظة |
|---|---|---|
| زائر | passed مبدئيًا | يرى public portal |
| مواطن | pending | يحتاج Supabase tracking token runtime |
| موظف نسك | pending | يحتاج AccessProfile override |
| مشرف نسك | pending | يحتاج نطاق وحدة/حملة |
| مدير النظام | pending | يحتاج RBAC داخل PalWakf |
| Superuser | pending | يحتاج override حقيقي |
| Restricted | pending | يجب إثبات forbidden/read-only |

## Responsive UAT
| الحجم | الحالة |
|---|---|
| Desktop | passed مبدئيًا |
| Laptop | pending screenshot |
| Tablet | pending screenshot |
| Mobile | pending screenshot |

## Supabase UAT
تنفيذ `sql/22_nosok_v24_read_only_uat_pack.sql` مطلوب داخل Supabase.
