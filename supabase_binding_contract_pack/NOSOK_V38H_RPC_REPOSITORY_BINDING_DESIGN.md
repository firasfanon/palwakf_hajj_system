# Nosok v38H — RPC / Repository Binding Design

## قاعدة Repository

`NosokRepository` يبقى الواجهة التطبيقية. عند standalone يستخدم preview/in-memory. عند الاستضافة في PalWakf يربط بـ `NosokSupabaseRepository` عبر SupabaseService/Client من المنصة.

## RPC-first contracts

### Public RPCs

- `public.rpc_nosok_homepage_sections_public_v1`
- `public.rpc_nosok_public_application_submit_v1`
- `public.rpc_nosok_public_application_track_v1`
- `public.rpc_nosok_public_lottery_result_get_v1`
- `public.rpc_nosok_public_objection_submit_v1`

### Admin RPCs

- `public.rpc_nosok_admin_applications_queue_v1`
- `public.rpc_nosok_admin_homepage_sections_upsert_v1`
- `public.rpc_nosok_admin_dynamic_page_publish_v1`
- `public.rpc_nosok_admin_legal_lottery_simulate_v1`
- `public.rpc_nosok_admin_lottery_draw_execute_v1`

## ضوابط الأمن

1. كل admin RPC يعتمد `auth.uid()` ويحل صلاحياته من PalWakf.
2. لا يرسل الموظف `unit_id` أو `lgu_id` كقيمة موثوقة.
3. public RPCs تعرض payload آمن فقط.
4. قرعة الحج لا تنفذ من Flutter؛ Flutter يطلب RPC قانوني مؤمّن.
5. كل publish/update/delete يحتاج audit event.
