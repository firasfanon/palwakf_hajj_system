# Nosok v38B — Evidence Center Hardening

## الهدف

تحويل كل صفحات الأدلة والجاهزية التاريخية إلى مركز واحد يمنع ازدحام لوحة الموظف.

## المسار المعتمد

```text
/admin/systems/nosok/evidence-center
/admin/systems/nosok/v38b-prejoin-closure
```

## المحتويات المتوقعة

- Public Runtime UAT evidence.
- Role/Responsive matrix.
- Schema/RPC/RLS design review.
- PalWakf join package checklist.
- Error Record.
- Production blockers.
- Handoffs and changelogs.

## قاعدة العرض

- الموظف التشغيلي يرى الطلبات والمراجعة والقرعة والحملات والتقارير.
- superuser/readiness/admin فقط يرى مركز الأدلة.
- صفحات v24–v38 تبقى routable للتدقيق، لا كأدوات تشغيل يومي.
