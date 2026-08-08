# NEXT SESSION PROMPT — Nosok v38I

نقطة البداية: Nosok v38I — Standalone Real Supabase Development Binding.

المطلوب التالي:

1. تشغيل SQL 38 shape discovery read-only على قاعدة Supabase التطويرية.
2. إرسال نتائج discovery الخاصة بـ:
   - core governorates
   - core LGUs
   - core org_units
   - core unit profiles
3. بعد اعتماد shape، تعديل core wrappers إن لزم.
4. تشغيل SQL 39 على قاعدة تطوير فقط.
5. تشغيل SQL 40 UAT read-only.
6. تشغيل Flutter مع `NOSOK_DATA_MODE=standaloneSupabaseDevelopment`.

الموانع: لا production، لا waqf_assets mutation، لا كتابة في core/platform/gis.
