# Nosok v38G — Platform Data Binding Findings

## الحكم

هذه الدفعة لا تنفذ انضمامًا ولا تنشئ schema. لكنها تستفيد من قراءة ملفات PalWakf في محاولة v39 الملغاة لمسار نسك، لتجهيز schema نسك وربطه بمصادر المنصة الصحيحة عند الاستضافة.

## مصادر PalWakf المثبتة من الملفات

1. `public.admin_users` هو مصدر هوية المستخدمين الإداريين. التعليق داخل `AccessRepository` يثبت أن `admin_users.id == auth.users.id`.
2. `platform.system_user_roles` و `platform.system_user_permissions` هما مصدر RBAC الديناميكي عند توفر Dynamic System Registry.
3. `core.org_units` و `core.org_unit_profiles` هما المصدر السيادي للوحدات، مع `public.org_units` كـ compatibility view.
4. المنصة تستخدم RPC wrappers مثل:
   - `pwf_resolve_unit_id`
   - `pwf_list_units_with_profiles`
   - `pwf_get_unit_with_profile_by_slug`
5. LGU/Governorates تحتاج shape discovery داخل بيئة PalWakf قبل apply، لأن أسماء GIS النهائية لا يجوز افتراضها عند إنشاء schema.

## أثر ذلك على نسك

- لا ينشئ نسك جدول هوية مستقل.
- يربط موظفي المديريات وممثلي الشركات عبر `public.admin_users` وRBAC المنصة.
- يستخدم `core.org_units`/RPC wrappers لحل `unitSlug` والمديريات.
- يستخدم snapshot موسمي للهيئات المحلية والمحافظات قبل القرعة، بدل قراءة live GIS مباشرة أثناء الموسم.
- ينشئ `nosok.homepage_sections` و`nosok.page_registry` لاحقًا للتحكم في الصفحة الرئيسية والصفحات العامة من لوحة الإدارة.

## قاعدة التنفيذ

كل ما سبق draft/contract فقط. التنفيذ الفعلي يكون بعد استضافة نسك داخل PalWakf واعتماد SQL/RPC/RLS.
