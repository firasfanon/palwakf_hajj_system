# SESSION HANDOFF — Nosok v27C Lottery Governance

## نقطة البداية التالية

ابدأ من baseline:

```text
nosok_v27c_lottery_governance_lgu_quota_2026_05_19.zip
```

## الحكم

```text
staging-stable /
nosok-v27c-lottery-governance-applied /
lgu-quota-policy-configurable /
capacity-aware-draw-engine-contract-applied /
committee-decision-required-for-unfilled-quota /
production-not-approved /
local-flutter-retest-required /
no-waqf-assets-mutation
```

## ما تم

تم إدخال طبقة قرعة حج حاكمة داخل نسك تعتمد:

1. التسجيل مفتوح لكل من تنطبق عليه الشروط.
2. دخول القرعة مشروط بالأهلية واكتمال الطلب.
3. العنوان المعتمد في البطاقة الشخصية هو مصدر LGU.
4. لكل LGU حصة موسمية قابلة للتعديل.
5. القرعة capacity-aware: مجموع الأشخاص لا يتجاوز حصة التجمع.
6. عند نقص الحصة، يبحث النظام داخل نفس LGU عن طلب يلائم السعة.
7. إن تعذر ذلك، يلزم قرار لجنة الحج ولا يتم نقل تلقائي.
8. كل ذلك staging/contract فقط، دون تشغيل إنتاجي.

## المطلوب محليًا

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

ثم SQL read-only:

```sql
\i sql/25_nosok_v27c_lottery_governance_read_only_uat.sql
```

## بوابات الإنتاج المفتوحة

- ربط backend فعلي لسياسة الموسم.
- RLS/RPC للقرعة.
- Audit immutable.
- Role UAT.
- Browser UAT.
- Responsive UAT.
- لجنة الحج workflow فعلي.
