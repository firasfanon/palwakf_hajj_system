import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/nosok_merge_readiness_contract.dart';

final nosokV29MergeReadinessContractProvider =
    Provider<NosokV29MergeReadinessContract>((ref) {
  return const NosokV29MergeReadinessContract(
    version: 'v29-palwakf-merge-readiness-pre-database-pack',
    status:
        'pre-platform-merge-ready / database-schema-not-created-by-design / sql-apply-not-required / frontend-runtime-contract-complete / production-not-approved',
    databaseState: 'not-created-by-design-until-palwakf-merge',
    productionDecision: 'production-not-approved',
    registryBindings: [
      NosokRegistryBindingContract(
        key: 'platform_system_registry',
        titleAr: 'تسجيل النظام في platform.system_registry',
        platformSurface: 'Dynamic System Registry',
        expectedBinding:
            'system_key=nosok, route_base=/admin/systems/nosok, public_route=/services/nosok, system_type=semi_independent_service_system, owner_schema=nosok بعد الدمج.',
        status: 'merge-pack-ready-not-applied',
      ),
      NosokRegistryBindingContract(
        key: 'platform_system_sections',
        titleAr: 'أقسام نسك داخل system sections',
        platformSurface: 'Sidebar/Dashboard Registry',
        expectedBinding:
            'requests/review/lottery/companies/campaigns/documents/messages/reports/settings مع display_order وصلاحيات كل قسم.',
        status: 'contract-ready-not-applied',
      ),
      NosokRegistryBindingContract(
        key: 'platform_public_routes',
        titleAr: 'المسارات العامة تحت مركز الخدمات',
        platformSurface: 'Public Service Center',
        expectedBinding:
            '/services/nosok + hajj/umrah/apply/track/requirements/faq/companies/contact/lottery-results/waiting-list/objections.',
        status: 'routes-ready',
      ),
      NosokRegistryBindingContract(
        key: 'platform_access_profile_override',
        titleAr: 'ربط AccessProfile الحقيقي',
        platformSurface: 'PalWakf RBAC',
        expectedBinding:
            'استبدال preview access profile بـ provider override من المنصة دون RBAC مستقل داخل نسك.',
        status: 'binding-plan-ready-deferred-until-merge',
      ),
      NosokRegistryBindingContract(
        key: 'platform_health_maintenance',
        titleAr: 'Health/Maintenance/Error Boundary',
        platformSurface: 'System-of-Systems Operations',
        expectedBinding:
            'health check وmaintenance mode وerror boundary خاص بنسك حتى لا يعطل المنصة كاملة.',
        status: 'contract-ready',
      ),
    ],
    schemaTables: [
      NosokSchemaTableDesign(
        name: 'nosok.seasons',
        purposeAr:
            'تعريف مواسم الحج والعمرة ونوافذ التسجيل والدفع والقرعة والاعتراضات.',
        ownerScope: 'nosok schema بعد الدمج',
        primaryRelations: [
          'core.org_units اختياريًا',
          'nosok.lottery_policies',
          'nosok.applications'
        ],
        privacyPolicyAr: 'قراءة إدارية؛ ملخص منشور فقط للجمهور عبر RPC آمن.',
        status: 'design-finalized-not-created',
      ),
      NosokSchemaTableDesign(
        name: 'nosok.applications',
        purposeAr:
            'الطلب السيادي للخدمة: نوع الخدمة، الموسم، مقدم الطلب، حالة lifecycle، tracking token.',
        ownerScope: 'nosok operational data',
        primaryRelations: [
          'nosok.applicants',
          'nosok.companions',
          'nosok.documents',
          'nosok.lottery_eligibility_snapshots'
        ],
        privacyPolicyAr:
            'الجمهور يرى طلبه فقط؛ الموظف حسب الدور والنطاق؛ لا public table direct access.',
        status: 'design-finalized-not-created',
      ),
      NosokSchemaTableDesign(
        name: 'nosok.applicants',
        purposeAr:
            'بيانات مقدم الطلب والتحقق من الهوية والعنوان المعتمد في البطاقة وLGU المستنتج.',
        ownerScope: 'nosok PII guarded data',
        primaryRelations: [
          'nosok.applications',
          'platform/core identity later',
          'gis/core LGU registry later'
        ],
        privacyPolicyAr:
            'بيانات حساسة؛ لا تعرض إلا بالحد الأدنى عبر RPCs محكومة.',
        status: 'design-finalized-not-created',
      ),
      NosokSchemaTableDesign(
        name: 'nosok.companions',
        purposeAr:
            'المرافقون/المحرم وعدد الأشخاص الفعلي الذي يحسب ضمن حصة LGU في القرعة.',
        ownerScope: 'nosok application details',
        primaryRelations: ['nosok.applications', 'nosok.applicants'],
        privacyPolicyAr: 'لا تظهر في public إلا للطلب نفسه وبعد التحقق.',
        status: 'design-finalized-not-created',
      ),
      NosokSchemaTableDesign(
        name: 'nosok.documents',
        purposeAr:
            'المرفقات وحالات التحقق ومرجع التخزين وجودة الملف وربط document_intelligence لاحقًا.',
        ownerScope: 'nosok documents + storage contracts',
        primaryRelations: [
          'nosok.applications',
          'storage buckets',
          'document_intelligence optional'
        ],
        privacyPolicyAr:
            'لا URL عام دائم؛ الوصول عبر signed/controlled surfaces فقط.',
        status: 'design-finalized-not-created',
      ),
      NosokSchemaTableDesign(
        name: 'nosok.companies',
        purposeAr:
            'الشركات المؤهلة ومعلومات التواصل والنطاق الجغرافي والحالة الموسمية.',
        ownerScope: 'nosok partner workspace',
        primaryRelations: ['nosok.campaigns', 'nosok.company_users later'],
        privacyPolicyAr: 'دليل عام للشركات المؤهلة فقط؛ تفاصيل الشراكة داخلية.',
        status: 'design-finalized-not-created',
      ),
      NosokSchemaTableDesign(
        name: 'nosok.campaigns',
        purposeAr:
            'حملات الحج والعمرة والسعة والمشرفين والربط بالشركات والمجموعات.',
        ownerScope: 'nosok operations',
        primaryRelations: [
          'nosok.companies',
          'nosok.groups',
          'nosok.applications'
        ],
        privacyPolicyAr:
            'إداري/شركة حسب الصلاحية؛ لا كشف قوائم المستفيدين للجمهور.',
        status: 'design-finalized-not-created',
      ),
      NosokSchemaTableDesign(
        name: 'nosok.lottery_policies',
        purposeAr:
            'سياسة القرعة الموسمية القابلة للتعديل من الوزارة: السكان، الحصة، الشروط، الاستثناءات، والمحرم/المرافقين.',
        ownerScope: 'nosok lottery governance',
        primaryRelations: ['nosok.seasons', 'nosok.lgu_quota_snapshots'],
        privacyPolicyAr: 'ملخص منشور فقط؛ التفاصيل الحاكمة داخلية ومدققة.',
        status: 'design-finalized-not-created',
      ),
      NosokSchemaTableDesign(
        name: 'nosok.lgu_quota_snapshots',
        purposeAr:
            'Snapshot حصة كل تجمع/LGU حسب العنوان المعتمد في البطاقة وعدد السكان أو الحصة اليدوية.',
        ownerScope: 'nosok LGU quota governance',
        primaryRelations: [
          'nosok.lottery_policies',
          'gis/core LGU registry later'
        ],
        privacyPolicyAr:
            'يعرض للمواطن تجمعه وحصته فقط؛ لا بيانات طلبات الآخرين.',
        status: 'design-finalized-not-created',
      ),
      NosokSchemaTableDesign(
        name:
            'nosok.lottery_draw_runs/results/committee_decisions/objections/audit_events',
        purposeAr:
            'تشغيل القرعة، النتائج، لجنة الحج، الاعتراضات، والتدقيق append-only.',
        ownerScope: 'nosok lottery runtime + audit',
        primaryRelations: [
          'nosok.applications',
          'nosok.lgu_quota_snapshots',
          'nosok.audit_events'
        ],
        privacyPolicyAr:
            'public result wrapper لطلب واحد فقط؛ audit داخلي فقط؛ لا تعديل صامت للنتائج.',
        status: 'design-finalized-not-created',
      ),
    ],
    rbacBindings: [
      NosokRbacBindingContract(
        roleKey: 'visitor',
        roleAr: 'زائر',
        allowedSurfacesAr:
            'الصفحة العامة، المتطلبات، FAQ، الشركات المؤهلة، التواصل.',
        deniedSurfacesAr:
            'لوحة الموظفين، الطلبات، نتائج الآخرين، أدوات القرعة.',
        platformPermissionContract: 'public routes only; no admin permission.',
      ),
      NosokRbacBindingContract(
        roleKey: 'citizen',
        roleAr: 'مواطن/مستخدم عام',
        allowedSurfacesAr:
            'تقديم طلب، متابعة طلبه، رفع نواقصه، رؤية نتيجة قرعته واعتراضه فقط.',
        deniedSurfacesAr:
            'audit الداخلي، قائمة الطلبات، قرارات اللجنة العامة، بيانات الآخرين.',
        platformPermissionContract:
            'secure public wrappers; future authenticated citizen context.',
      ),
      NosokRbacBindingContract(
        roleKey: 'nosok_employee',
        roleAr: 'موظف نسك',
        allowedSurfacesAr:
            'الطلبات المسندة، مراجعة أولية، مراسلات، وثائق ضمن نطاقه.',
        deniedSurfacesAr:
            'تشغيل القرعة، إعدادات السياسة، override الحصص، بوابة الإنتاج.',
        platformPermissionContract:
            'viewNosokRequests/reviewNosokRequestsQueue scoped by assignment/unit.',
      ),
      NosokRbacBindingContract(
        roleKey: 'nosok_supervisor',
        roleAr: 'مشرف نسك',
        allowedSurfacesAr:
            'طلبات نطاقه، مراجعة الأهلية، إدارة waiting list ضمن النطاق.',
        deniedSurfacesAr:
            'تشغيل قرعة نهائية دون صلاحية draw، تعديل audit، إنتاج.',
        platformPermissionContract:
            'manageNosokLotteryEligibility/manageNosokLotteryWaitingList scoped by org unit.',
      ),
      NosokRbacBindingContract(
        roleKey: 'hajj_committee',
        roleAr: 'لجنة الحج',
        allowedSurfacesAr:
            'قرارات نقص الحصة، الاستثناءات، الاعتراضات الحاكمة، reason/evidence required.',
        deniedSurfacesAr: 'تغيير نتائج بلا قرار مدقق أو خارج السياسة.',
        platformPermissionContract:
            'manageNosokLotteryCommittee + audit context.',
      ),
      NosokRbacBindingContract(
        roleKey: 'system_admin_superuser',
        roleAr: 'مدير نظام / Superuser',
        allowedSurfacesAr:
            'إعدادات النظام، registry، readiness، audit، production gate بعد UAT.',
        deniedSurfacesAr: 'لا bypass للإنتاج دون أدلة UAT موثقة.',
        platformPermissionContract:
            'manageNosokPlatformIntegrationReadiness/decideNosokProductionGate/superuser.',
      ),
    ],
    frontendSurfaces: [
      NosokFrontendRuntimeSurface(
          route: '/services/nosok',
          surfaceAr: 'Public Citizen Portal',
          runtimeState: 'service-journey-ready',
          bindingMode: 'preview repository until merge',
          status: 'ready-for-click-through-uat'),
      NosokFrontendRuntimeSurface(
          route: '/services/nosok/apply',
          surfaceAr: 'Application Wizard',
          runtimeState: 'wizard-contract-ready',
          bindingMode: 'frontend contract only',
          status: 'ready-before-db'),
      NosokFrontendRuntimeSurface(
          route: '/services/nosok/track',
          surfaceAr: 'Public Tracking',
          runtimeState: 'privacy-gated',
          bindingMode: 'secure lookup contract',
          status: 'ready-before-db'),
      NosokFrontendRuntimeSurface(
          route: '/services/nosok/lottery-results',
          surfaceAr: 'Public Lottery Result',
          runtimeState: 'citizen-result-only',
          bindingMode: 'RPC contract pending schema',
          status: 'ready-before-db'),
      NosokFrontendRuntimeSurface(
          route: '/admin/systems/nosok',
          surfaceAr: 'Internal Operations Console',
          runtimeState: 'admin-entry-visible-rbac-guarded',
          bindingMode: 'platform access override pending merge',
          status: 'ready-for-merge-uat'),
      NosokFrontendRuntimeSurface(
          route: '/admin/systems/nosok/lottery',
          surfaceAr: 'Lottery Console',
          runtimeState: 'governance-sensitive',
          bindingMode: 'contract/readiness only before DB',
          status: 'ready-before-db'),
      NosokFrontendRuntimeSurface(
          route: '/admin/systems/nosok/v29-merge-readiness',
          surfaceAr: 'v29 Merge Readiness',
          runtimeState: 'pre-database-pack',
          bindingMode: 'merge plan and schema contract',
          status: 'new-in-v29'),
    ],
    integrationSteps: [
      NosokMergeIntegrationStep(
        key: 'merge_feature_folder',
        titleAr: 'دمج feature folder داخل PalWakf',
        descriptionAr:
            'نقل lib/features/nosok_system كما هو إلى ريبو PalWakf مع عدم استخدام legacy.dart في الملفات الجديدة.',
        owner: 'platform developer + nosok developer',
        status: 'ready-to-apply-after-review',
      ),
      NosokMergeIntegrationStep(
        key: 'register_system',
        titleAr: 'تسجيل النظام ديناميكيًا',
        descriptionAr:
            'إضافة nosok إلى سجل الأنظمة والأقسام مع health/maintenance/error boundary.',
        owner: 'PalWakf platform admin',
        status: 'plan-ready-not-applied',
      ),
      NosokMergeIntegrationStep(
        key: 'rbac_override',
        titleAr: 'ربط RBAC الحقيقي',
        descriptionAr:
            'استبدال preview access profile بـ AccessProfile provider من المنصة، ثم اختبار visitor/citizen/employee/supervisor/committee/admin/superuser/restricted.',
        owner: 'platform access team',
        status: 'deferred-until-merge',
      ),
      NosokMergeIntegrationStep(
        key: 'create_nosok_schema_after_merge',
        titleAr: 'إنشاء schema نسك بعد الدمج فقط',
        descriptionAr:
            'لا توجد جداول الآن عمدًا. بعد الدمج يتم إنشاء nosok schema من العقود النهائية في sandbox أولًا.',
        owner: 'database/platform team',
        status: 'not-created-by-design',
      ),
      NosokMergeIntegrationStep(
        key: 'bind_repositories',
        titleAr: 'ربط Repository الحقيقي',
        descriptionAr:
            'بعد إنشاء schema وRPCs وتشغيل UAT، يتم تحويل بعض أسطح preview إلى Supabase repository تدريجيًا.',
        owner: 'nosok developer',
        status: 'deferred-after-schema',
      ),
      NosokMergeIntegrationStep(
        key: 'production_gate',
        titleAr: 'بوابة الإنتاج',
        descriptionAr:
            'لا إنتاج قبل SQL UAT وRole UAT وResponsive UAT وBrowser console review وPrivacy check.',
        owner: 'governance + QA',
        status: 'blocked-by-design',
      ),
    ],
    preDatabasePack: [
      'مخطط schema نهائي كتصميم لا كجداول منفذة.',
      'خطة platform registry وsystem sections وsidebar/dashboard binding.',
      'خريطة RBAC للأدوار العامة والموظفين ولجنة الحج والإدارة.',
      'عقود RPC public/admin دون تنفيذ فعلي قبل إنشاء schema.',
      'أسطح frontend جاهزة للعمل بالـ preview repository حتى الدمج.',
      'تعليمات عدم طلب SQL apply قبل دمج PalWakf وإنشاء schema نسك.',
    ],
    productionBlockers: [
      'لم يتم دمج نسك داخل ريبو PalWakf الكامل بعد.',
      'لم يتم إنشاء schema nosok في Supabase عمدًا حتى ما بعد الدمج.',
      'لم يتم ربط AccessProfile الحقيقي من المنصة.',
      'لم يتم تشغيل SQL/RPC/RLS UAT لأن قاعدة البيانات غير منشأة بعد.',
      'لم يتم إرفاق Role/Responsive/Browser console evidence داخل PalWakf بعد الدمج.',
      'لا توجد موافقة إنتاج.',
    ],
  );
});
