# UAT Matrix — Nosok v38I-2

| المسار | الفحص | القرار المتوقع |
|---|---|---|
| `/admin/systems/nosok/supabase-connection-diagnostics` | mode | `standaloneSupabaseDevelopment` إذا كانت URL/anon موجودة |
| الصفحة نفسها | client | READY إذا التهيئة نجحت |
| الصفحة نفسها | nosok schema | warning/pending حتى تطبيق schema |
| الصفحة نفسها | RPCs | warning/pending حتى تطبيق RPCs |
| عام | production | غير معتمد |
