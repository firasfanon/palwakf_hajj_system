import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/nosok_v38g_platform_schema_binding_contract.dart';

final nosokV38GPlatformSchemaBindingContractProvider =
    Provider<NosokV38GPlatformSchemaBindingContract>((ref) {
  return const NosokV38GPlatformSchemaBindingContract(
    version: 'v38G',
    platformSources: [
      NosokV38GPlatformSource(
        key: 'platform_identity',
        sourceName: 'public.admin_users + auth.users',
        platformContract:
            'من ملفات PalWakf: admin_users هو مصدر هوية الإدارة، و admin_users.id يطابق auth.users.id، مع is_active/is_superuser/role/unit_id/governorate.',
        nosokUsage:
            'ربط موظفي نسك وممثلي الشركات والمشرفين بالحساب الحقيقي، ولا يُستخدم جدول مستخدمين مستقل داخل نسك إلا كامتداد نطاق.',
        bindingStatus: 'platform-derived / apply later',
      ),
      NosokV38GPlatformSource(
        key: 'platform_dynamic_rbac',
        sourceName:
            'platform.system_user_roles + platform.system_user_permissions',
        platformContract:
            'AccessRepository في المنصة يقرأ الأدوار والصلاحيات الديناميكية من schema platform عند توفرها.',
        nosokUsage:
            'تثبيت system_key=nosok، وربط صلاحيات مثل manageNosokHomepageSections وmanageNosokDynamicPages وexecuteNosokLotteryDraw.',
        bindingStatus: 'contract-ready / no DML now',
      ),
      NosokV38GPlatformSource(
        key: 'org_units',
        sourceName: 'core.org_units + public.org_units compatibility view',
        platformContract:
            'OrgUnitsRepository يوضح أن المصدر السيادي للوحدات هو core.org_units، والقراءة العامة/التوافقية تتم عبر public.org_units أو RPC wrappers.',
        nosokUsage:
            'ربط unitSlug والمديريات ونطاق الموظفين، مثال موظف بيت لحم يرى فقط LGUs التابعة لنطاقه.',
        bindingStatus: 'platform-derived / required for join',
      ),
      NosokV38GPlatformSource(
        key: 'org_unit_rpcs',
        sourceName:
            'pwf_resolve_unit_id / pwf_list_units_with_profiles / pwf_get_unit_with_profile_by_slug',
        platformContract:
            'المنصة تفضل القراءة عبر RPC wrappers بدل القراءة المباشرة من core schema.',
        nosokUsage:
            'تستخدم لاحقًا في ربط slugs ونطاقات المديريات داخل نسك دون وصول مباشر غير مصرح إلى core.',
        bindingStatus: 'rpc-aware / no runtime call in standalone',
      ),
      NosokV38GPlatformSource(
        key: 'gis_lgu_governorates',
        sourceName: 'GIS LGU/Governorate authority',
        platformContract:
            'المنصة تعتمد GIS/PostGIS للمحافظات والهيئات المحلية؛ أسماء الجداول النهائية تُحسم عبر shape discovery داخل PalWakf قبل apply.',
        nosokUsage:
            'إنشاء snapshots موسمية لحصص التجمعات وربط العنوان في الهوية بـ LGU والمحافظة.',
        bindingStatus: 'shape-discovery-required',
      ),
    ],
    nosokSchemaObjects: [
      NosokV38GSchemaObject(
        objectName: 'nosok.seasons',
        objectType: 'table',
        purposeAr: 'تعريف موسم الحج/العمرة ونوافذ التسجيل والنشر.',
        platformDependency: 'system_key=nosok + platform audit/user context',
        statusAr: 'draft not applied',
      ),
      NosokV38GSchemaObject(
        objectName: 'nosok.applications',
        objectType: 'table',
        purposeAr:
            'طلبات المواطنين مع ربط season_id وunit/lgu/governorate snapshots.',
        platformDependency: 'public-safe RPC + identity/address verification',
        statusAr: 'draft not applied',
      ),
      NosokV38GSchemaObject(
        objectName: 'nosok.user_unit_scope_assignments',
        objectType: 'table',
        purposeAr:
            'امتداد نسك لنطاق الموظف حسب unitSlug/LGU عند الحاجة، فوق AccessProfile لا بدلًا منه.',
        platformDependency: 'public.admin_users + core.org_units',
        statusAr: 'draft not applied',
      ),
      NosokV38GSchemaObject(
        objectName: 'nosok.lgu_reference_snapshots',
        objectType: 'table',
        purposeAr: 'snapshot موسمي للهيئات المحلية والتجمعات والحصص والسكان.',
        platformDependency: 'GIS LGU authority + core/org unit mapping',
        statusAr: 'draft not applied',
      ),
      NosokV38GSchemaObject(
        objectName: 'nosok.governorate_reference_snapshots',
        objectType: 'table',
        purposeAr:
            'snapshot موسمي للمحافظات المستخدمة في نطاق التسجيل والقرعة.',
        platformDependency:
            'GIS/governorate authority + public compatibility where available',
        statusAr: 'draft not applied',
      ),
      NosokV38GSchemaObject(
        objectName: 'nosok.lottery_algorithm_rules',
        objectType: 'table',
        purposeAr:
            'قواعد خوارزمية القرعة وفق نظام تنظيم شؤون الحج رقم 15/2025.',
        platformDependency: 'legal compliance + immutable audit',
        statusAr: 'draft not applied',
      ),
    ],
    homepageContentObjects: [
      NosokV38GSchemaObject(
        objectName: 'nosok.homepage_sections',
        objectType: 'table',
        purposeAr:
            'التحكم بأقسام الصفحة الرئيسية: Hero، الخدمات، الموسم، الشركات، الشفافية، الدعم.',
        platformDependency: 'admin RPC + published-only public RPC/view',
        statusAr: 'draft not applied',
      ),
      NosokV38GSchemaObject(
        objectName: 'nosok.page_registry',
        objectType: 'table',
        purposeAr:
            'إضافة صفحات عامة جديدة من لوحة الإدارة بقوالب آمنة دون رجوع للمطور.',
        platformDependency: 'slug uniqueness + publish workflow + audit',
        statusAr: 'draft not applied',
      ),
      NosokV38GSchemaObject(
        objectName: 'nosok.page_sections',
        objectType: 'table',
        purposeAr:
            'أقسام الصفحات الديناميكية: بطاقة، نص، FAQ، CTA، جدول منشور، حالة موسم.',
        platformDependency: 'template whitelist + no HTML/script free content',
        statusAr: 'draft not applied',
      ),
      NosokV38GSchemaObject(
        objectName: 'public.rpc_nosok_homepage_sections_public_v1',
        objectType: 'rpc',
        purposeAr:
            'قراءة عامة published-only للصفحة الرئيسية دون كشف إعدادات الإدارة.',
        platformDependency:
            'public wrapper only; source table remains nosok schema',
        statusAr: 'draft not deployed',
      ),
    ],
    bindingRules: [
      NosokV38GBindingRule(
        key: 'no_duplicate_identity',
        titleAr: 'لا جدول هوية مستقل داخل نسك',
        ruleAr:
            'المستخدم الإداري يأتي من public.admin_users/auth.users، ونسك يحتفظ فقط بامتدادات النطاق عند الحاجة.',
        enforcementAr:
            'RLS/RPC يتحقق من auth.uid() ثم public.admin_users ثم platform roles/permissions.',
      ),
      NosokV38GBindingRule(
        key: 'unit_scope_from_platform',
        titleAr: 'نطاق الموظف من المنصة',
        ruleAr:
            'unitSlug والمديرية تُحل عبر core.org_units/public.org_units/RPC wrappers، لا من إدخال حر في نسك.',
        enforcementAr:
            'RPC الإداري يفلتر الطلبات حسب allowed_unit_ids/allowed_lgu_ids المحسوبة للمستخدم.',
      ),
      NosokV38GBindingRule(
        key: 'seasonal_reference_snapshot',
        titleAr: 'Snapshot موسمي للمحافظات والهيئات',
        ruleAr:
            'لا تعتمد القرعة على live GIS مباشرة أثناء الموسم؛ تثبت نسخة مرجعية للسكان والحصص.',
        enforcementAr:
            'الطلبات ترتبط بـ season_id + lgu_snapshot_id + governorate_snapshot_id.',
      ),
      NosokV38GBindingRule(
        key: 'homepage_public_safe',
        titleAr: 'أقسام الصفحة الرئيسية published-only',
        ruleAr:
            'لوحة الإدارة تعدّل nosok.homepage_sections، والجمهور يقرأ RPC/View منشور فقط.',
        enforcementAr:
            'لا direct public table exposure؛ لا عرض draft أو archived أو role-restricted sections.',
      ),
    ],
    securityGates: [
      'تنفيذ schema يتم داخل PalWakf/Supabase بعد اعتماد الاستضافة، وليس داخل standalone نسك.',
      'قبل SQL apply يجب تشغيل shape discovery للتأكد من core.org_units/public.org_units/admin_users/platform RBAC/GIS tables.',
      'أي ربط LGU أو محافظة يجب أن يعتمد snapshot موسمي ثابت، لا قراءة حية قابلة للتغير أثناء القرعة.',
      'أدوات homepage/dynamic pages تحتاج RPC/RLS/audit قبل تمكينها كأدوات تشغيل فعلية.',
      'لا مساس بـ waqf_assets أو schema waqf أو awqaf_system؛ نسك يستخدم مصادر منصة عامة أو core/GIS عبر عقود مصرح بها فقط.',
    ],
  );
});
