# PALWAKF PLATFORM COMPREHENSIVE GUIDE — Nosok Appendix v27C

## Lottery Governance Rule

نظام نسك يعتمد في قرعة الحج على نموذج حصة جغرافية محكومة:

```text
Identity-card address → LGU → seasonal quota snapshot → capacity-aware draw → waiting list per LGU → committee decision for unfilled quota
```

## Sovereign Boundaries

- نسك نظام شبه مستقل تحت PalWakf.
- لا يملك نسك Design System مستقل؛ يلتزم PWF-SIS.
- لا يجوز نقل حصة بين تجمعات تلقائيًا.
- لا يجوز تنفيذ قرعة إنتاجية دون Audit/RBAC/SQL/RPC/UAT.
- لا تعديل على `waqf_assets` أو schema `waqf` أو `awqaf_system`.

## Committee Decision Gate

أي عجز في استكمال حصة LGU بعد البحث عن طلب مؤهل داخل نفس LGU يتحول إلى قرار لجنة الحج، مع سبب وأثر تدقيقي، وليس إلى ترحيل آلي.
