begin;

insert into nosok.static_content_blocks (block_key, title_ar, body_ar, display_order, is_published)
values
  (
    'nosok_origin',
    'نبذة عن نسك',
    'نظام نسك داخل منصة PalWakf مخصص لإدارة خدمات الحج والعمرة والمواسم والشركات المؤهلة والتعليمات العامة والشكاوى، مع ربط حوكمي وتقني موحد داخل المنصة.',
    1,
    true
  ),
  (
    'hajj_steps',
    'خطوات التسجيل',
    '1) مراجعة التعليمات والشروط. 2) تعبئة الطلب عبر النموذج متعدد الخطوات. 3) إضافة المرافقين عند الحاجة. 4) إرسال الطلب للمراجعة. 5) متابعة الإعلانات والتعليمات اللاحقة.',
    2,
    true
  ),
  (
    'hajj_conditions',
    'شروط أولية',
    'الشروط النهائية تخضع لاعتماد الموسم الحالي. تعرض هذه الصفحة الشروط والتعليمات المعتمدة وتحدّث موسميًا من لوحة تحكم نسك.',
    3,
    true
  )
on conflict (block_key) do update
set
  title_ar = excluded.title_ar,
  body_ar = excluded.body_ar,
  display_order = excluded.display_order,
  is_published = excluded.is_published;

insert into nosok.faq_items (category, question_ar, answer_ar, display_order, is_published)
values
  ('general', 'كيف أبدأ التسجيل؟', 'ابدأ من صفحة الحج أو العمرة، ثم اختر الموسم والبرنامج المناسب وأكمل الخطوات المطلوبة.', 1, true),
  ('general', 'هل تم تفعيل رمز المتابعة؟', 'نعم، تم تفعيل tracking token لمتابعة الطلبات من الواجهة العامة بطريقة آمنة.', 2, true),
  ('companies', 'أين أجد الشركات المؤهلة؟', 'يمكنك تصفح الشركات المؤهلة من صفحة الشركات مع الفلترة والبحث.', 3, true)
on conflict do nothing;

insert into nosok.system_announcements (
  slug,
  title_ar,
  body_ar,
  is_published,
  display_order
)
values
  (
    'season-preparation',
    'إعلان تمهيدي',
    'تم تجهيز الدفعة التشغيلية الأولى لنسك داخل PalWakf، وتشمل مواسم وبرامج وشركات ونموذج تقديم متعدد الخطوات.',
    true,
    1
  )
on conflict (slug) do update
set
  title_ar = excluded.title_ar,
  body_ar = excluded.body_ar,
  is_published = excluded.is_published,
  display_order = excluded.display_order;

insert into nosok.seasons (
  season_code,
  title_ar,
  service_type,
  hijri_year,
  gregorian_year,
  registration_start_at,
  registration_end_at,
  status,
  is_publicly_visible,
  notes
)
values (
  'HAJJ-1447',
  'موسم الحج 1447هـ / 2026م',
  'hajj',
  1447,
  2026,
  now(),
  now() + interval '30 days',
  'open',
  true,
  'سجل تأسيسي أولي لتجربة النظام.'
)
on conflict (season_code) do update
set
  title_ar = excluded.title_ar,
  service_type = excluded.service_type,
  hijri_year = excluded.hijri_year,
  gregorian_year = excluded.gregorian_year,
  registration_start_at = excluded.registration_start_at,
  registration_end_at = excluded.registration_end_at,
  status = excluded.status,
  is_publicly_visible = excluded.is_publicly_visible,
  notes = excluded.notes;

insert into nosok.service_programs (
  season_id,
  code,
  title_ar,
  service_type,
  description,
  registration_start_at,
  registration_end_at,
  max_companions,
  notes,
  status,
  is_publicly_visible
)
select
  s.id,
  'MAIN',
  'البرنامج الرئيسي',
  'hajj',
  'برنامج تأسيسي لتجربة النموذج متعدد الخطوات.',
  s.registration_start_at,
  s.registration_end_at,
  1,
  'يُستخدم كبرنامج افتراضي أولي.',
  'active',
  true
from nosok.seasons s
where s.season_code = 'HAJJ-1447'
on conflict (season_id, code) do update
set
  title_ar = excluded.title_ar,
  service_type = excluded.service_type,
  description = excluded.description,
  registration_start_at = excluded.registration_start_at,
  registration_end_at = excluded.registration_end_at,
  max_companions = excluded.max_companions,
  notes = excluded.notes,
  status = excluded.status,
  is_publicly_visible = excluded.is_publicly_visible;

insert into nosok.qualified_companies (
  company_name_ar,
  license_no,
  phone,
  mobile,
  address_text,
  status,
  is_publicly_visible,
  notes
)
values (
  'شركة نسك التجريبية',
  'NSK-DEMO-01',
  '022222222',
  '0599000000',
  'بيت لحم',
  'qualified',
  true,
  'سجل تأسيسي أولي للشركات المؤهلة.'
)
on conflict do nothing;

commit;
