# ERROR RECORD — NOSOK V19

## Context
المستخدم طلب دفعة تطوير كبيرة جدًا وليس باتشات صغيرة، بناءً على v18.

## Previous blocker context
- v15: compile blocker في `Expanded(child: visual)` بسبب `const` مع متغير محلي.
- v15.1: compile blocker في sidebar بسبب تعريفات مفقودة.
- v15.2: runtime Material blocker في الصفحة العامة بسبب `Chip` خارج Material ancestor.

## V19 risk areas
1. **Lifecycle enforcement:** قد يفشل RPC v19 إذا كانت بنية `application_lifecycle_rules` مختلفة في قاعدة الإنتاج.
   - الحل: repository يستخدم fallback إلى RPC v18 عند فشل v19.
2. **Follow-up inbox:** يعتمد على وجود `nosok.citizen_followup_requests` من v18.
   - الحل: SQL v19 يضيف الأعمدة الناقصة فقط عبر `add column if not exists`.
3. **Notification provider UAT:** لا يرسل إشعارات فعلية.
   - السبب: الإرسال الحقيقي يجب أن يكون عبر خدمة إشعارات PalWakf لا داخل نسك.

## Required local retest
```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

## Required SQL UAT
```sql
select * from public.rpc_nosok_v19_runtime_contract_uat_v1();
select * from public.rpc_nosok_v19_admin_followup_inbox_v1();
select * from public.rpc_nosok_v19_notification_provider_adapters_v1();
```
