# Nosok v38I — Standalone Real Supabase Development Binding

## القرار الحاكم

يسمح لنسك بالعمل مؤقتًا كبيئة تطوير مستقلة متصلة بقاعدة Supabase حقيقية، بشرط أن تبقى بيانات نسك داخل schema خاصة به باسم `nosok`، وأن تُقرأ البيانات السيادية المرجعية من `core` عبر wrappers آمنة فقط.

```text
nosok-standalone-real-db-development-approved /
core-is-sovereign-source-for-lgu-governorates /
public-is-wrapper-surface-only /
no-cross-schema-mutation /
schema-shape-discovery-required /
production-not-approved /
no-waqf-assets-mutation
```

## قواعد الربط

- `nosok` يملك جداول نسك التشغيلية فقط.
- `core` هو المصدر السيادي للمحافظات و LGUs و org_units و unit profiles.
- `public` يستخدم فقط كطبقة RPC/views آمنة، وليس source of truth.
- لا يكتب نسك في `core` أو `platform` أو `gis` أو `public.admin_users`.
- لا service role داخل Flutter.
- كل عمليات الواجهة تمر عبر `NosokRepository` ثم RPC wrappers.

## أوضاع التشغيل

1. `preview`: بيانات تجريبية فقط.
2. `standaloneSupabaseDevelopment`: اتصال Supabase حقيقي لغرض التطوير قبل الانضمام.
3. `platformHosted`: لاحقًا داخل PalWakf باستخدام Supabase client وAccessProfile الحقيقيين.

## ملفات SQL

- `sql/38_nosok_v38i_core_reference_shape_discovery_read_only.sql`
- `sql/39_nosok_v38i_standalone_development_schema_creation_pack.sql`
- `sql/40_nosok_v38i_standalone_development_uat_read_only.sql`

## تسلسل العمل المقترح

1. تشغيل SQL 38 لاكتشاف شكل `core`.
2. مراجعة أسماء جداول وأعمدة المحافظات و LGUs و org_units.
3. تعديل wrappers الخاصة بـ core إذا لزم.
4. تشغيل SQL 39 في قاعدة تطوير فقط.
5. تشغيل SQL 40 للتحقق.
6. تشغيل Flutter مع:

```bash
flutter run -d chrome --dart-define=NOSOK_DATA_MODE=standaloneSupabaseDevelopment
```

## الموانع

لا إنتاج، لا انضمام فعلي للمنصة، لا تعديل waqf_assets، لا SQL production، ولا cross-schema mutation.
