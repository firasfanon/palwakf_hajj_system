# Nosok v36 — Repository Binding Controlled Adapter Pack

## القرار

```text
V36_REPOSITORY_BINDING_CONTROLLED_ADAPTER_PREPARED_GLOBAL_SWITCH_BLOCKED
```

تم تجهيز adapter جديد للـ public wrapper/RPC surfaces:

```text
lib/features/nosok_system/data/repositories/nosok_public_wrapper_rpc_adapter.dart
```

## الأسطح المدعومة

- `public.rpc_nosok_campaigns_public_list_v1`
- `public.rpc_nosok_requirements_public_list_v1`
- `public.rpc_nosok_application_submit_v1`
- `public.rpc_nosok_application_track_v1`

## قواعد الربط

1. لا direct access إلى `nosok.*` من Flutter public pages.
2. لا `service_role` داخل Flutter.
3. لا raw backend errors للمواطن.
4. `standaloneSupabaseDevelopment` مرشح بعد Browser/Network evidence.
5. `platformHosted` محجوب حتى Role/Scope UAT وقرار إنتاج مستقل.
