begin;

-- =========================================================
-- Nosok RLS Template
-- هذا الملف Template أولي ويحتاج مواءمة بسيطة مع أسماء
-- جداول/وظائف RBAC النهائية في المنصة عند الدمج.
-- =========================================================

-- جداول نسك العامة
alter table if exists nosok.seasons enable row level security;
alter table if exists nosok.service_programs enable row level security;
alter table if exists nosok.qualified_companies enable row level security;
alter table if exists nosok.company_season_qualifications enable row level security;
alter table if exists nosok.applications enable row level security;
alter table if exists nosok.application_companions enable row level security;
alter table if exists nosok.application_documents enable row level security;
alter table if exists nosok.application_payments enable row level security;
alter table if exists nosok.application_reviews enable row level security;
alter table if exists nosok.draw_batches enable row level security;
alter table if exists nosok.draw_results enable row level security;
alter table if exists nosok.complaints enable row level security;
alter table if exists nosok.complaint_actions enable row level security;
alter table if exists nosok.system_announcements enable row level security;
alter table if exists nosok.faq_items enable row level security;
alter table if exists nosok.static_content_blocks enable row level security;

-- =========================================================
-- Public read policies
-- =========================================================

drop policy if exists "nosok_public_read_seasons" on nosok.seasons;
create policy "nosok_public_read_seasons"
on nosok.seasons
for select
to anon, authenticated
using (is_publicly_visible = true);

drop policy if exists "nosok_public_read_programs" on nosok.service_programs;
create policy "nosok_public_read_programs"
on nosok.service_programs
for select
to anon, authenticated
using (is_publicly_visible = true);

drop policy if exists "nosok_public_read_companies" on nosok.qualified_companies;
create policy "nosok_public_read_companies"
on nosok.qualified_companies
for select
to anon, authenticated
using (is_publicly_visible = true and status = 'qualified');

drop policy if exists "nosok_public_read_announcements" on nosok.system_announcements;
create policy "nosok_public_read_announcements"
on nosok.system_announcements
for select
to anon, authenticated
using (is_published = true);

drop policy if exists "nosok_public_read_faq" on nosok.faq_items;
create policy "nosok_public_read_faq"
on nosok.faq_items
for select
to anon, authenticated
using (is_published = true);

drop policy if exists "nosok_public_read_blocks" on nosok.static_content_blocks;
create policy "nosok_public_read_blocks"
on nosok.static_content_blocks
for select
to anon, authenticated
using (is_published = true);

-- =========================================================
-- Authenticated insert for public complaints/applications
-- يترك intentionally narrow ويمكن استبداله بـ RPC عند الإطلاق.
-- =========================================================

drop policy if exists "nosok_authenticated_submit_complaints" on nosok.complaints;
create policy "nosok_authenticated_submit_complaints"
on nosok.complaints
for insert
to authenticated
with check (true);

drop policy if exists "nosok_authenticated_submit_applications" on nosok.applications;
create policy "nosok_authenticated_submit_applications"
on nosok.applications
for insert
to authenticated
with check (true);

-- =========================================================
-- Admin full access template
-- يفترض وجود public.admin_users وربط هوية المنصة عليه.
-- =========================================================

drop policy if exists "nosok_admin_full_access_seasons" on nosok.seasons;
create policy "nosok_admin_full_access_seasons"
on nosok.seasons
for all
to authenticated
using (
  exists (
    select 1
    from public.admin_users au
    where au.auth_user_id = auth.uid()
      and coalesce(au.is_active, true) = true
  )
)
with check (
  exists (
    select 1
    from public.admin_users au
    where au.auth_user_id = auth.uid()
      and coalesce(au.is_active, true) = true
  )
);

-- كرر نفس السياسة لبقية الجداول عند الدمج الفعلي أو استخدم RPCs حاكمة.
-- تم الإبقاء على الملف Template لتفادي افتراضات خاطئة حول جداول RBAC النهائية.

commit;
