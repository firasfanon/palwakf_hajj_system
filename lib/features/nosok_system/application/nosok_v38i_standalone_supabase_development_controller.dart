import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/nosok_v38i_standalone_supabase_development_contract.dart';

final nosokV38IStandaloneSupabaseDevelopmentContractProvider =
    Provider<NosokV38IStandaloneSupabaseDevelopmentContract>((ref) {
  return const NosokV38IStandaloneSupabaseDevelopmentContract(
    version: 'v38I',
    executionStatus:
        'standalone-real-db-development-approved / core-reference-shape-discovery-required / schema-creation-pack-ready-not-applied / no-production-approval',
    runtimeModes: [
      NosokRuntimeModeContract(
        key: 'preview',
        titleAr: 'Preview / In-memory',
        descriptionAr:
            'وضع عرض آمن يستخدم بيانات تجريبية فقط عند عدم وجود اتصال Supabase أو عند تشغيل نسك كحزمة تصميم.',
        statusAr: 'available',
      ),
      NosokRuntimeModeContract(
        key: 'standaloneSupabaseDevelopment',
        titleAr: 'Standalone Real Supabase Development',
        descriptionAr:
            'وضع تطوير حقيقي يتصل بقاعدة Supabase التطويرية، يملك schema nosok ويقرأ مراجع core عبر wrappers آمنة.',
        statusAr: 'prepared',
      ),
      NosokRuntimeModeContract(
        key: 'platformHosted',
        titleAr: 'PalWakf Hosted لاحقًا',
        descriptionAr:
            'وضع الاستضافة المستقبلية داخل PalWakf حيث يستخدم نسك Supabase client وAccessProfile الحقيقيين للمنصة.',
        statusAr: 'deferred',
      ),
    ],
    coreReferenceObjects: [
      NosokCoreReferenceObjectContract(
        key: 'governorates',
        sourceSchema: 'core',
        expectedObjectFamily: 'governorates / governorate reference objects',
        nosokUsageAr:
            'اعتماد محافظة مقدم الطلب، فلترة سجلات المديريات، وحساب نطاق التقارير الموسمية.',
        accessRuleAr:
            'قراءة فقط عبر RPC/view آمنة؛ public ليس مصدرًا سياديًا للمحافظات.',
      ),
      NosokCoreReferenceObjectContract(
        key: 'lgus',
        sourceSchema: 'core',
        expectedObjectFamily:
            'LGU / local government units / تجمعات وهيئات محلية',
        nosokUsageAr:
            'ربط العنوان المعتمد في الهوية بالتجمع السكاني وحصة القرعة وقوائم انتظار كل تجمع.',
        accessRuleAr:
            'قراءة فقط من core بعد shape discovery؛ لا كتابة من nosok إلى core.',
      ),
      NosokCoreReferenceObjectContract(
        key: 'org_units',
        sourceSchema: 'core',
        expectedObjectFamily: 'org_units / directorates / unit profiles',
        nosokUsageAr:
            'تحديد نطاق موظف المديرية مثل بيت لحم أو الخليل وربطه بالـ LGUs المسموحة.',
        accessRuleAr:
            'قراءة/تحقق عبر RPC آمنة؛ النطاق لا يؤخذ من payload المستخدم.',
      ),
      NosokCoreReferenceObjectContract(
        key: 'unit_profiles',
        sourceSchema: 'core',
        expectedObjectFamily: 'org_unit_profiles / unit profile metadata',
        nosokUsageAr:
            'إظهار اسم الوحدة، slug، نوع الوحدة، وبيانات العرض داخل لوحة نسك.',
        accessRuleAr:
            'قراءة فقط، وأي توافق public يكون wrapper لا source of truth.',
      ),
    ],
    schemaObjects: [
      NosokSchemaObjectContract(
        objectName: 'nosok.homepage_sections',
        objectType: 'table',
        purposeAr:
            'إدارة أقسام الصفحة الرئيسية وترتيبها وحالة نشرها من لوحة نسك.',
        crossSchemaRuleAr:
            'لا FK مباشر إلى core قبل shape discovery؛ يستخدم unit_slug/lgu_code snapshot عند الحاجة.',
        statusAr: 'development apply ready',
      ),
      NosokSchemaObjectContract(
        objectName: 'nosok.page_registry / page_sections / page_actions',
        objectType: 'tables',
        purposeAr:
            'إضافة صفحات عامة وأقسام جديدة مستقبلًا دون الرجوع للمطور ضمن قوالب آمنة.',
        crossSchemaRuleAr:
            'public يعرض المنشور فقط، والإدارة عبر RPC مع audit.',
        statusAr: 'development apply ready',
      ),
      NosokSchemaObjectContract(
        objectName: 'nosok.applications / applicants / companions',
        objectType: 'tables',
        purposeAr:
            'تخزين طلبات الحج والعمرة ومقدمي الطلب والمرافقين ضمن schema نسك.',
        crossSchemaRuleAr:
            'تخزن مراجع core كـ snapshot/reference code حتى يتم اعتماد FK آمن لاحقًا.',
        statusAr: 'development apply ready',
      ),
      NosokSchemaObjectContract(
        objectName: 'nosok.registration_governance_windows',
        objectType: 'table',
        purposeAr: 'ضبط فتح/إغلاق التسجيل، نوافذ النواقص، وتجميد pool القرعة.',
        crossSchemaRuleAr: 'لا يغير core أو platform؛ يسجل قرارات نسك فقط.',
        statusAr: 'development apply ready',
      ),
      NosokSchemaObjectContract(
        objectName:
            'nosok.lottery_policies / lottery_algorithm_rules / lgu_quota_snapshots',
        objectType: 'tables',
        purposeAr:
            'حفظ سياسة القرعة القانونية وحصص التجمعات snapshots حسب الموسم.',
        crossSchemaRuleAr:
            'مصدر LGU من core، والحصة snapshot داخل nosok لضمان ثبات الموسم.',
        statusAr: 'development apply ready',
      ),
      NosokSchemaObjectContract(
        objectName: 'nosok.audit_events',
        objectType: 'table',
        purposeAr: 'تسجيل تغييرات الإدارة والنشر والقرعة والقرارات الحساسة.',
        crossSchemaRuleAr:
            'يربط لاحقًا بـ auth.uid/admin users دون كتابة في public.admin_users.',
        statusAr: 'development apply ready',
      ),
    ],
    rpcWrappers: [
      NosokRpcWrapperContract(
        rpcName: 'public.rpc_nosok_core_governorates_lookup_v1',
        surface: 'public wrapper',
        purposeAr: 'قراءة المحافظات من core عبر سطح آمن بعد shape discovery.',
        securityAr: 'read-only ولا يعتبر public مصدرًا سياديًا.',
        statusAr: 'shape-discovery dependent',
      ),
      NosokRpcWrapperContract(
        rpcName: 'public.rpc_nosok_core_lgus_lookup_v1',
        surface: 'public wrapper',
        purposeAr: 'قراءة LGUs/التجمعات من core لتسجيل العنوان والحصص.',
        securityAr: 'read-only، ولا كتابة إلى core أو gis.',
        statusAr: 'shape-discovery dependent',
      ),
      NosokRpcWrapperContract(
        rpcName: 'public.rpc_nosok_homepage_sections_public_v1',
        surface: 'public',
        purposeAr: 'عرض أقسام الصفحة الرئيسية المنشورة فقط حسب الموسم/الوحدة.',
        securityAr: 'published-only ولا يكشف draft أو admin notes.',
        statusAr: 'development apply ready',
      ),
      NosokRpcWrapperContract(
        rpcName: 'public.rpc_nosok_admin_homepage_sections_upsert_v1',
        surface: 'admin',
        purposeAr: 'إدارة أقسام الصفحة الرئيسية من لوحة الإدارة.',
        securityAr: 'auth.uid مطلوب + audit + لاحقًا RBAC كامل من PalWakf.',
        statusAr: 'development apply ready',
      ),
      NosokRpcWrapperContract(
        rpcName: 'public.rpc_nosok_public_application_submit_v1',
        surface: 'public',
        purposeAr: 'استقبال طلب تطويري حقيقي مع رقم تتبع وسياسات التسجيل.',
        securityAr: 'يتحقق من نافذة التسجيل ولا يعتمد على الواجهة وحدها.',
        statusAr: 'development apply ready',
      ),
      NosokRpcWrapperContract(
        rpcName: 'public.rpc_nosok_public_application_track_v1',
        surface: 'public',
        purposeAr: 'متابعة طلب برقم تتبع دون كشف بيانات الآخرين.',
        securityAr: 'public-safe payload فقط.',
        statusAr: 'development apply ready',
      ),
    ],
    repositoryAdapters: [
      NosokRepositoryAdapterContract(
        key: 'preview_repository',
        titleAr: 'Preview Repository',
        modeAr: 'preview',
        supabaseSourceAr: 'لا يستخدم Supabase.',
        decisionAr: 'يبقى متاحًا للعرض دون قاعدة بيانات.',
      ),
      NosokRepositoryAdapterContract(
        key: 'standalone_supabase_repository',
        titleAr: 'Standalone Supabase Development Repository',
        modeAr: 'standaloneSupabaseDevelopment',
        supabaseSourceAr:
            'Supabase.instance.client من إعدادات بيئة التطوير المحلية فقط.',
        decisionAr:
            'يستخدم RPC wrappers الخاصة بـ nosok ولا يتصل مباشرة بـ core/platform للكتابة.',
      ),
      NosokRepositoryAdapterContract(
        key: 'platform_hosted_repository',
        titleAr: 'PalWakf Hosted Repository',
        modeAr: 'platformHosted',
        supabaseSourceAr: 'SupabaseService/Provider الخاص بـ PalWakf لاحقًا.',
        decisionAr: 'يستبدل adapter فقط عند الانضمام، دون تغيير الواجهات.',
      ),
    ],
    homepageRuntimeAdminCapabilities: [
      NosokHomepageRuntimeAdminCapability(
        key: 'list_sections',
        titleAr: 'عرض الأقسام',
        workflowAr:
            'الإدارة تقرأ كل الأقسام draft/published/archived، والجمهور يرى published فقط.',
        guardAr: 'RPC إداري + audit لاحقًا.',
      ),
      NosokHomepageRuntimeAdminCapability(
        key: 'upsert_section',
        titleAr: 'إضافة/تعديل قسم',
        workflowAr: 'تعديل العنوان، الوصف، الترتيب، الحالة، والنطاق الموسمي.',
        guardAr:
            'manageNosokHomepageSections + no direct table access from UI.',
      ),
      NosokHomepageRuntimeAdminCapability(
        key: 'publish_archive',
        titleAr: 'نشر/أرشفة',
        workflowAr: 'الانتقال بين draft/published/archived مع سبب وتدقيق.',
        guardAr: 'audit event إلزامي قبل اعتماد production لاحقًا.',
      ),
    ],
    shapeDiscoveryGates: [
      'تشغيل SQL read-only لاكتشاف شكل core.governorates أو بدائله قبل أي FK.',
      'تشغيل SQL read-only لاكتشاف شكل core LGUs/هيئات محلية/تجمعات قبل ربط العنوان.',
      'تشغيل SQL read-only لاكتشاف core.org_units وunit profiles قبل نطاق الموظفين.',
      'عدم اعتبار public مصدرًا سياديًا لأي LGU/governorate؛ public wrappers فقط.',
      'منع cross-schema mutation: nosok لا يكتب في core/platform/gis/public.admin_users.',
    ],
    productionSafetyRules: [
      'هذه حزمة تطوير Standalone Real DB وليست اعتماد إنتاج.',
      'لا service_role داخل Flutter ولا مفاتيح اتصال داخل الكود.',
      'كل واجهة إنتاجية مستقبلية تمر عبر RPC/RLS لا جداول مباشرة.',
      'لا تعديل على waqf_assets أو waqf أو awqaf_system.',
      'أي ربط نهائي مع PalWakf يتم في مسار المنصة لاحقًا، لا داخل مسار نسك المستقل.',
    ],
    developmentApplySequence: [
      '1. تشغيل shape discovery read-only على core/platform/gis للتحقق من أسماء الجداول والأعمدة.',
      '2. مراجعة نتائج discovery وتعديل FK/view mapping عند الحاجة.',
      '3. تشغيل SQL development schema creation على قاعدة تطوير فقط.',
      '4. تشغيل SQL UAT readiness للتحقق من schema/RPC/RLS دون بيانات إنتاجية.',
      '5. تفعيل NOSOK_DATA_MODE=standaloneSupabaseDevelopment محليًا عند الحاجة.',
      '6. اختبار Homepage Sections runtime ثم submit/track runtime كحد أدنى.',
    ],
  );
});
