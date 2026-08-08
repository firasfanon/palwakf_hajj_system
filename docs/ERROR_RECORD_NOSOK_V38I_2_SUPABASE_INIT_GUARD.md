# Error Record — Nosok v38I-2

## الخطأ

صفحة التشخيص أظهرت أن `SUPABASE_URL` و`SUPABASE_ANON_KEY` موجودان، لكن `Data mode` بقي `preview`، وبالتالي لم تتم تهيئة `Supabase.instance.client` وبقيت Repository على `NosokInMemoryRepository`.

## السبب

ملف `.env` placeholder كان يحتوي قيمة `NOSOK_DATA_MODE=preview` أو لم يتم ضبط الوضع صراحة عند نسخ بيانات الاتصال.

## الحل

- عند وجود URL/anon key يتم اختيار `standaloneSupabaseDevelopment` تلقائيًا.
- تقوية التشخيص لشرح سبب عدم التهيئة بدل إظهار failure عام.

## آخر baseline مستقر

`nosok_v38i2_supabase_initialization_guard_2026_05_21.zip`
