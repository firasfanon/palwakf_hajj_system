# BASELINE CHANGELOG — Nosok v27D Lottery Operational Hardening

**التاريخ:** 2026-05-19  
**المصدر:** `nosok_v27c1_lottery_compile_fix_2026_05_19.zip`  
**نوع الدفعة:** تطوير كبير واحد فوق v27C-1، دون SQL إنتاجي ودون DML.

## الحكم

```text
staging-stable /
nosok-v27d-lottery-operational-hardening-applied /
seasonal-policy-configurable /
lgu-capacity-aware-selection-expanded /
committee-decision-workflow-deepened /
public-result-objection-ux-expanded /
local-flutter-retest-required /
production-not-approved /
no-waqf-assets-mutation
```

## التغييرات

1. توسيع `NosokLotteryPolicy` ليحمل:
   - نسخة السياسة.
   - مصدر السكان.
   - مصدر الحصة.
   - مصدر العنوان/LGU.
   - حصة الحج الوطنية.
   - سياسة الحصة غير المستكملة.
2. إضافة نماذج تشغيلية للقرعة:
   - `NosokUnderfilledQuotaPolicy`
   - `NosokLotteryCandidateDecision`
   - `NosokLotterySelectionResult`
   - `NosokCommitteeDecisionType`
   - `NosokLotteryCommitteeDecisionDraft`
   - `NosokLotteryCitizenResult`
   - `NosokLotteryObjectionReason`
3. توسيع `nosokLotteryDashboardProvider` ببيانات staging أعمق:
   - نتائج اختيار capacity-aware.
   - ملفات لجنة الحج.
   - نتائج مواطن عامة آمنة.
   - أسباب اعتراضات محكومة.
   - evidence snapshot v27D.
4. تعميق صفحات الإدارة:
   - لوحة القرعة.
   - فحص الأهلية.
   - تنفيذ القرعة.
   - قوائم الانتظار.
   - لجنة الحج.
   - تدقيق القرعة.
5. تعميق صفحات الجمهور:
   - نتائج القرعة.
   - الاعتراضات.
6. إنشاء SQL read-only UAT جديد لـ v27D.

## ما لم يتم

- لم يتم تشغيل SQL إنتاجي.
- لم يتم تنفيذ DML.
- لم يتم اعتماد الإنتاج.
- لم يتم لمس `waqf_assets` أو `waqf` أو `awqaf_system`.
