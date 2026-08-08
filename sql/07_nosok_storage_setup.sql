begin;

insert into storage.buckets (id, name, public, file_size_limit)
values ('nosok-public', 'nosok-public', true, 10485760)
on conflict (id) do nothing;

do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'storage' and tablename = 'objects' and policyname = 'Public can view nosok storage'
  ) then
    create policy "Public can view nosok storage"
    on storage.objects for select
    to public
    using (bucket_id = 'nosok-public');
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'storage' and tablename = 'objects' and policyname = 'Public can upload nosok storage'
  ) then
    create policy "Public can upload nosok storage"
    on storage.objects for insert
    to public
    with check (
      bucket_id = 'nosok-public'
      and ((storage.foldername(name))[1] = 'applications')
    );
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'storage' and tablename = 'objects' and policyname = 'Authenticated can update nosok storage'
  ) then
    create policy "Authenticated can update nosok storage"
    on storage.objects for update
    to authenticated
    using (bucket_id = 'nosok-public')
    with check (bucket_id = 'nosok-public');
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'storage' and tablename = 'objects' and policyname = 'Authenticated can delete nosok storage'
  ) then
    create policy "Authenticated can delete nosok storage"
    on storage.objects for delete
    to authenticated
    using (bucket_id = 'nosok-public');
  end if;
end $$;

commit;
