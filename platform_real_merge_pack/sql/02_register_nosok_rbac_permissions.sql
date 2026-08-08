-- Register Nosok permission keys inside platform-wide RBAC catalog.
-- Adapt table/column names if the target catalog differs.
insert into platform.permission_catalog (permission_key, title_ar, system_key, is_active) values
('manageNosok','إدارة نسك','nosok',true),
('viewNosokDashboard','عرض لوحة نسك','nosok',true),
('manageNosokApplications','إدارة طلبات نسك','nosok',true),
('reviewNosokApplications','مراجعة طلبات نسك','nosok',true),
('manageNosokApplicationLifecycle','إدارة دورة حياة الطلب','nosok',true),
('verifyNosokPayments','التحقق من دفعات نسك','nosok',true),
('executeNosokBillingBridge','تنفيذ جسر الدفع لنسك','nosok',true),
('manageNosokFollowupInbox','إدارة صندوق متابعة المواطن','nosok',true),
('closeNosokProductionUat','إغلاق UAT الإنتاجي لنسك','nosok',true),
('manageNosokPlatformIntegrationReadiness','إدارة جاهزية دمج نسك','nosok',true),
('manageNosokRealPlatformMerge','إدارة الدمج الفعلي لنسك','nosok',true),
('manageNosokRbacProviderOverride','إدارة ربط RBAC لنسك','nosok',true),
('intakeNosokSqlUatResults','استيعاب نتائج SQL UAT لنسك','nosok',true),
('intakeNosokBrowserRoleEvidence','استيعاب أدلة المتصفح والأدوار لنسك','nosok',true),
('decideNosokProductionGate','تسجيل قرار بوابة إنتاج نسك','nosok',true),
('viewNosokRemainingWork','عرض المتبقي قبل اعتماد نسك','nosok',true)
on conflict (permission_key) do update set title_ar=excluded.title_ar, system_key=excluded.system_key, is_active=excluded.is_active;
