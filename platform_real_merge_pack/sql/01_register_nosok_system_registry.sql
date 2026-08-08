-- Register Nosok inside PalWakf Dynamic System Registry.
-- Adjust column names to the actual platform.system_registry contract if needed.
insert into platform.system_registry (system_key, title_ar, route_base, admin_route_base, system_type, sensitivity_level, is_enabled)
values ('nosok', 'نسك', '/systems/nosok', '/admin/systems/nosok', 'semi_independent_service_system', 'high', true)
on conflict (system_key) do update set
  title_ar = excluded.title_ar,
  route_base = excluded.route_base,
  admin_route_base = excluded.admin_route_base,
  system_type = excluded.system_type,
  sensitivity_level = excluded.sensitivity_level,
  is_enabled = excluded.is_enabled;
