# Nosok v37 — Browser Evidence Result Intake

## الأدلة المقبولة

- `/services/nosok` ظهر بنجاح.
- `/admin/systems/nosok` ظهر بنجاح.
- `/admin/systems/nosok/users-roles` ظهر بنجاح.
- Console لا يعرض أخطاء runtime حمراء جوهرية.
- Supabase init completed.

## حدود الدليل

لقطة Network الحالية لا تثبت runtime RPC switch؛ ظهرت طلبات favicon/startup فقط. لذلك لا يتم اعتماد repository binding بعد.

## المطلوب قبل الاعتماد

- ظهور `rpc_nosok_campaigns_public_list_v1` في Network أو adapter diagnostic.
- ظهور `rpc_nosok_requirements_public_list_v1` في Network أو adapter diagnostic.
- negative actor: authenticated without Nosok role.
- wrong-unit scope denial.
- privacy evidence لتتبع الطلب قبل submit/track switch.
