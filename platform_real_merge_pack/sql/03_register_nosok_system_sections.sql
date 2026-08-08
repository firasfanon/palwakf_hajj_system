-- Register high-level Nosok sections inside platform.system_sections.
insert into platform.system_sections (system_key, section_key, title_ar, route_path, required_permission_key, display_order, is_enabled) values
('nosok','dashboard','لوحة النظام','/admin/systems/nosok','viewNosokDashboard',10,true),
('nosok','applications','الطلبات','/admin/systems/nosok/applications','manageNosokApplications',20,true),
('nosok','application_operations','عمليات الطلبات','/admin/systems/nosok/application-operations','viewNosokApplicationOperations',30,true),
('nosok','real_platform_merge','الدمج الفعلي','/admin/systems/nosok/real-platform-merge','manageNosokRealPlatformMerge',90,true),
('nosok','rbac_provider_override','ربط RBAC','/admin/systems/nosok/rbac-provider-override','manageNosokRbacProviderOverride',100,true),
('nosok','sql_uat_intake','استيعاب SQL UAT','/admin/systems/nosok/sql-uat-intake','intakeNosokSqlUatResults',110,true)
on conflict (system_key, section_key) do update set
  title_ar=excluded.title_ar, route_path=excluded.route_path, required_permission_key=excluded.required_permission_key, display_order=excluded.display_order, is_enabled=excluded.is_enabled;
