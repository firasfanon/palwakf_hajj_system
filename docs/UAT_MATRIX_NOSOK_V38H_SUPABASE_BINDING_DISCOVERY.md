# UAT MATRIX — Nosok v38H

| check | expected | status |
|---|---|---|
| dart format | لا تغييرات أو تنسيق ناجح | pending local |
| flutter analyze | No issues found | pending local |
| chrome startup | يعمل بدون compile blocker | pending local |
| /admin/systems/nosok/supabase-binding-discovery | الصفحة تفتح وتعرض عقد الربط | pending browser |
| /admin/systems/nosok/v38h-supabase-binding | الصفحة تفتح وتعرض أدلة v38H | pending browser |
| no independent Supabase client | لا يوجد Supabase.initialize داخل nosok feature | static contract |
| no SQL apply | SQL file read-only discovery | passed static |
| no waqf_assets mutation | لا DML ولا waqf/waqf_assets | passed static |
