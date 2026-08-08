begin;

-- =========================================================
-- Platform registration template for Nosok
-- هذا الملف يعتمد على أسماء الجداول المذكورة في العقد:
-- platform_systems / platform_permissions / user_system_roles / user_system_permissions
-- عدّل أسماء الأعمدة فقط إذا كانت النسخة الحالية تختلف.
-- =========================================================

insert into public.platform_systems (
  system_key,
  name_ar,
  name_en,
  route,
  is_active
)
values (
  'nosok',
  'نسك',
  'Nosok',
  '/nosok',
  true
)
on conflict (system_key) do update
set
  name_ar = excluded.name_ar,
  name_en = excluded.name_en,
  route = excluded.route,
  is_active = excluded.is_active;

insert into public.platform_permissions (permission_key, system_key, name_ar)
values
  ('manageNosok', 'nosok', 'إدارة نسك'),
  ('manageNosokSeasons', 'nosok', 'إدارة مواسم نسك'),
  ('manageNosokPrograms', 'nosok', 'إدارة برامج نسك'),
  ('manageNosokCompanies', 'nosok', 'إدارة شركات نسك'),
  ('manageNosokApplications', 'nosok', 'إدارة طلبات نسك'),
  ('manageNosokComplaints', 'nosok', 'إدارة شكاوى نسك'),
  ('manageNosokContent', 'nosok', 'إدارة محتوى نسك'),
  ('publishNosokResults', 'nosok', 'نشر نتائج نسك'),
  ('viewNosokReports', 'nosok', 'عرض تقارير نسك')
on conflict (permission_key) do nothing;

commit;
