# UAT MATRIX — Nosok v38I-1

| المسار | المطلوب | القرار المتوقع |
|---|---|---|
| `/admin/systems/nosok/supabase-connection-diagnostics` | يفتح صفحة التشخيص | visible |
| env mode | يعرض `standaloneSupabaseDevelopment` عند ضبط `.env` | passed إذا صحيح |
| Supabase URL | يعرض masked URL | لا يكشف أسرار |
| Anon key | يعرض masked key فقط | لا service_role |
| Supabase client | يظهر initialized عند توفر URL/key | passed |
| nosok schema probe | warning إذا لم تُطبّق schema بعد | expected |
| homepage RPC probe | warning إذا لم تُطبّق RPC بعد | expected |
| core readiness RPC | pending حتى shape discovery | expected |
