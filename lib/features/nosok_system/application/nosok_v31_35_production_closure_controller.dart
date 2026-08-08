import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/nosok_v31_35_production_closure_contract.dart';

final nosokV31ToV35ProductionClosureContractProvider =
    Provider<NosokV31ToV35ProductionClosureContract>((ref) {
  return const NosokV31ToV35ProductionClosureContract(
    version: 'v31-v35-consolidated-palwakf-merge-to-production-candidate-pack',
    status:
        'single-large-batch-applied / palwakf-merge-pack-prepared / schema-rpc-rls-draft-finalized / backend-binding-candidate-ready / uat-matrix-ready / production-candidate-not-approved',
    productionDecision:
        'production-not-approved / production-candidate-deferred-until-real-palwakf-merge-and-supabase-apply-evidence',
    databaseDecision:
        'nosok schema creation prepared as sandbox draft only; no production SQL apply and no DML inside this package',
    mergeExecution: [
      NosokV31MergeExecutionItem(
        key: 'feature_folder_application',
        surfaceAr: 'تطبيق مجلد نسك داخل PalWakf',
        palwakfTarget: 'PalWakf/lib/features/nosok_system',
        applicationMode:
            'copy/merge guarded by analyzer and route registration review',
        status: 'application-pack-ready-not-externally-applied',
      ),
      NosokV31MergeExecutionItem(
        key: 'routing_application',
        surfaceAr: 'تسجيل public/admin routes داخل GoRouter المنصة',
        palwakfTarget: 'PalWakf/lib/app/routing/route_groups',
        applicationMode:
            'NosokRoutes.publicRoutes + NosokRoutes.adminRoutes with fail-closed admin guard',
        status: 'route-contract-ready',
      ),
      NosokV31MergeExecutionItem(
        key: 'dynamic_registry_entry',
        surfaceAr: 'إدخال نسك في Dynamic System Registry',
        palwakfTarget: 'platform.system_registry + platform.system_sections',
        applicationMode:
            'system_key=nosok, route_base=/admin/systems/nosok, public_route_base=/services/nosok',
        status: 'registry-seed-draft-ready',
      ),
      NosokV31MergeExecutionItem(
        key: 'access_profile_override',
        surfaceAr: 'إغلاق AccessProfile Override',
        palwakfTarget: 'PalWakf core/access providers',
        applicationMode:
            'replace preview access provider with platform AccessProfile/RBAC projection',
        status: 'binding-candidate-ready-pending-palwakf-repo',
      ),
      NosokV31MergeExecutionItem(
        key: 'platform_shell_alignment',
        surfaceAr: 'ربط السايدبار والداشبورد وHealth/Error Boundary',
        palwakfTarget: 'Platform Sidebar/Dashboard/Health Center/Maintenance',
        applicationMode:
            'registry-driven visibility and route guard; no standalone visual shell ownership',
        status: 'contract-ready',
      ),
    ],
    schemaCreation: [
      NosokV32SchemaCreationItem(
        objectName: 'nosok.seasons',
        objectType: 'table',
        purposeAr: 'مواسم الحج والعمرة ونوافذ التسجيل والقرعة والاعتراض.',
        rlsPolicyAr:
            'admin read/write by nosok role; public reads only published service windows through RPC.',
        creationMode: 'sandbox DDL draft after PalWakf merge',
        status: 'draft-finalized-not-applied',
      ),
      NosokV32SchemaCreationItem(
        objectName: 'nosok.applications / applicants / companions',
        objectType: 'tables',
        purposeAr:
            'طلبات المواطنين ومقدم الطلب والمرافقين وعدد الأشخاص المحتسب في الحصة.',
        rlsPolicyAr:
            'citizen reads own application only through public RPC; staff scoped by AccessProfile.',
        creationMode: 'sandbox DDL draft after schema shell approval',
        status: 'draft-finalized-not-applied',
      ),
      NosokV32SchemaCreationItem(
        objectName: 'nosok.documents / messages / reviews',
        objectType: 'tables',
        purposeAr:
            'المرفقات والمراسلات والمراجعات التشغيلية دون كشف ملاحظات الموظف للجمهور.',
        rlsPolicyAr:
            'storage paths and document rows scoped by owner/application/staff role.',
        creationMode: 'sandbox DDL draft with storage policy review',
        status: 'draft-finalized-not-applied',
      ),
      NosokV32SchemaCreationItem(
        objectName: 'nosok.companies / campaigns / groups',
        objectType: 'tables',
        purposeAr:
            'الشركات المؤهلة والحملات والمجموعات وربط الفائزين بعد القرعة.',
        rlsPolicyAr:
            'company portal sees own company scope only; staff scopes by role/unit.',
        creationMode: 'sandbox DDL draft pending company policy',
        status: 'draft-finalized-not-applied',
      ),
      NosokV32SchemaCreationItem(
        objectName: 'nosok.lottery_policies / lgu_quota_snapshots',
        objectType: 'tables',
        purposeAr:
            'سياسة الموسم، عدد السكان، معامل الحصة، وحصة كل LGU حسب البطاقة الشخصية.',
        rlsPolicyAr:
            'read-only for staff except authorized policy managers; public sees safe summary only.',
        creationMode: 'sandbox DDL draft pending ministry quota policy',
        status: 'draft-finalized-not-applied',
      ),
      NosokV32SchemaCreationItem(
        objectName: 'nosok.lottery_draw_runs / lottery_draw_results',
        objectType: 'tables',
        purposeAr:
            'تشغيل القرعة، النتائج، قائمة الانتظار، وعدد الأشخاص ضمن السعة لا عدد الطلبات فقط.',
        rlsPolicyAr:
            'immutable result after publish except committee/audit override; public result RPC is own-result only.',
        creationMode: 'sandbox DDL draft with audit hash fields',
        status: 'draft-finalized-not-applied',
      ),
      NosokV32SchemaCreationItem(
        objectName:
            'nosok.lottery_committee_decisions / objections / audit_events',
        objectType: 'tables',
        purposeAr:
            'قرارات لجنة الحج عند نقص الحصة والاعتراضات وسجل التدقيق غير القابل للإخفاء.',
        rlsPolicyAr:
            'committee/admin scoped writes; citizen submits/reads own objection through RPC only.',
        creationMode: 'sandbox DDL draft with audit-only wrappers',
        status: 'draft-finalized-not-applied',
      ),
    ],
    backendBinding: [
      NosokV33BackendBindingItem(
        repositorySurface: 'NosokPublicRepository',
        rpcContract:
            'public.rpc_nosok_public_service_home_v1 / rpc_nosok_application_submit_v1',
        publicSafetyAr:
            'لا يعرض إلا بيانات الخدمات العامة وحفظ طلب المواطن عبر payload آمن.',
        bindingMode: 'candidate adapter after RPC deployment',
        status: 'candidate-ready-not-enabled',
      ),
      NosokV33BackendBindingItem(
        repositorySurface: 'NosokTrackingRepository',
        rpcContract: 'public.rpc_nosok_track_application_v1',
        publicSafetyAr:
            'يتحقق من رقم الطلب + الهوية/رمز آمن ولا يعرض بيانات طلبات أخرى.',
        bindingMode: 'candidate adapter after tracking privacy UAT',
        status: 'candidate-ready-not-enabled',
      ),
      NosokV33BackendBindingItem(
        repositorySurface: 'NosokLotteryRepository',
        rpcContract:
            'public.rpc_nosok_lottery_result_get_v1 / rpc_nosok_waiting_list_status_get_v1',
        publicSafetyAr:
            'المواطن يرى نتيجته وتجمعه وحالته فقط؛ لا يرى seed أو بيانات الآخرين.',
        bindingMode: 'candidate adapter after lottery schema apply',
        status: 'candidate-ready-not-enabled',
      ),
      NosokV33BackendBindingItem(
        repositorySurface: 'NosokInternalRepository',
        rpcContract:
            'nosok.rpc_admin_requests_snapshot_v1 / nosok.rpc_lottery_admin_snapshot_v1',
        publicSafetyAr:
            'admin-only via AccessProfile; no direct table read from UI.',
        bindingMode: 'candidate adapter inside PalWakf only',
        status: 'candidate-ready-not-enabled',
      ),
      NosokV33BackendBindingItem(
        repositorySurface: 'NosokCommitteeRepository',
        rpcContract: 'nosok.rpc_lottery_committee_decision_record_v1',
        publicSafetyAr:
            'كل قرار لجنة يحتاج reason + actor + evidence + audit event.',
        bindingMode: 'candidate adapter after committee role approval',
        status: 'candidate-ready-not-enabled',
      ),
    ],
    uatClosure: [
      NosokV34UatClosureItem(
        actorAr: 'زائر',
        routesAr:
            '/services/nosok, /services/nosok/hajj, /services/nosok/requirements',
        requiredEvidenceAr:
            'لا تظهر أدوات الموظف، CTA واضح، RTL، لا overflow على mobile.',
        responsiveScope: 'desktop/tablet/mobile',
        status: 'uat-required-inside-palwakf',
      ),
      NosokV34UatClosureItem(
        actorAr: 'مواطن',
        routesAr:
            '/services/nosok/apply, /track, /lottery-results, /waiting-list, /objections',
        requiredEvidenceAr:
            'الطلب/المتابعة/النتيجة/الاعتراض ضمن بياناته فقط، ورسائل الخطأ آمنة.',
        responsiveScope: 'wizard/cards/timeline on mobile',
        status: 'uat-required-after-backend-binding',
      ),
      NosokV34UatClosureItem(
        actorAr: 'شركة/شريك',
        routesAr:
            '/services/nosok/company-login, /admin/systems/nosok/companies بعد التصريح',
        requiredEvidenceAr:
            'Workspace الشريك لا يتحول إلى admin كامل ولا يرى إلا نطاق الشركة.',
        responsiveScope: 'partner cards + lists',
        status: 'uat-required-after-company-role-binding',
      ),
      NosokV34UatClosureItem(
        actorAr: 'موظف نسك',
        routesAr:
            '/admin/systems/nosok/requests, /review, /documents, /messages',
        requiredEvidenceAr:
            'يعمل ضمن نطاقه، لا يرى إعدادات عليا، ولا يتم تجاوز route guards.',
        responsiveScope: 'table-to-cards on small screens',
        status: 'uat-required-inside-palwakf',
      ),
      NosokV34UatClosureItem(
        actorAr: 'لجنة الحج/مدير النظام/Superuser',
        routesAr: '/admin/systems/nosok/lottery/*, /v31-v35-production-closure',
        requiredEvidenceAr:
            'القرعة لا تنفذ دون policy/snapshot/audit، وقرار اللجنة مطلوب عند نقص الحصة.',
        responsiveScope:
            'desktop primary; tablet review; mobile read-only safe',
        status: 'governance-uat-required',
      ),
      NosokV34UatClosureItem(
        actorAr: 'مستخدم مقيد',
        routesAr: '/admin/systems/nosok/*',
        requiredEvidenceAr:
            'forbidden أو read-only حسب العقد، مع عدم ظهور سايدبار غير مصرح.',
        responsiveScope: 'all sizes',
        status: 'role-negative-uat-required',
      ),
    ],
    productionCandidate: [
      NosokV35ProductionCandidateItem(
        gateAr: 'Analyzer / Chrome',
        requiredClosureAr:
            'dart format + flutter analyze + flutter run داخل PalWakf بعد الدمج.',
        decisionAr:
            'لا يفتح production candidate دون clean analyzer وChrome startup.',
        status: 'pending-local-palwakf-retest',
      ),
      NosokV35ProductionCandidateItem(
        gateAr: 'Schema/RPC/RLS',
        requiredClosureAr:
            'تطبيق sandbox SQL وread-only UAT ثم مراجعة RLS/RPC.',
        decisionAr: 'لا يتم backend binding الحقيقي دون evidence.',
        status: 'pending-post-merge-sandbox',
      ),
      NosokV35ProductionCandidateItem(
        gateAr: 'Role/Responsive/Browser UAT',
        requiredClosureAr: 'أدلة لكل دور وحجم شاشة ومراجعة console.',
        decisionAr: 'أي overflow أو route leak يمنع candidate.',
        status: 'pending-evidence',
      ),
      NosokV35ProductionCandidateItem(
        gateAr: 'Lottery governance',
        requiredClosureAr:
            'policy snapshot + LGU quota + committee decision + immutable audit evidence.',
        decisionAr: 'القرعة لا تصبح تشغيلية دون موافقة حوكمة.',
        status: 'pending-ministry-policy',
      ),
      NosokV35ProductionCandidateItem(
        gateAr: 'Final decision',
        requiredClosureAr:
            'كل البوابات السابقة + عدم تعديل waqf_assets + لا raw backend errors.',
        decisionAr:
            'production-candidate فقط، وليس production-ready، حتى pilot approval.',
        status: 'candidate-deferred',
      ),
    ],
    stageGates: [
      NosokV31ToV35StageGate(
        stage: 'v31',
        titleAr: 'PalWakf Merge Execution',
        deliverableAr: 'حزمة دمج كاملة ومسارات/Registry/RBAC candidate.',
        decisionAr:
            'جاهزة للتطبيق داخل ريبو PalWakf؛ التطبيق الخارجي يحتاج الريبو الكامل.',
        status: 'pack-applied-in-baseline',
      ),
      NosokV31ToV35StageGate(
        stage: 'v32',
        titleAr: 'Nosok Schema/RPC/RLS Creation',
        deliverableAr: 'DDL/RPC/RLS draft نهائي آمن، لا SQL production apply.',
        decisionAr: 'schema creation prepared; التنفيذ بعد الدمج وsandbox فقط.',
        status: 'draft-finalized-not-applied',
      ),
      NosokV31ToV35StageGate(
        stage: 'v33',
        titleAr: 'Backend Runtime Binding',
        deliverableAr: 'Repository binding candidate وخريطة RPCs.',
        decisionAr: 'binding candidate جاهز لكنه disabled حتى وجود schema/RPC.',
        status: 'candidate-ready-disabled',
      ),
      NosokV31ToV35StageGate(
        stage: 'v34',
        titleAr: 'Full Browser/Role/Responsive UAT',
        deliverableAr: 'مصفوفة UAT كاملة للأدوار والمسارات والأحجام.',
        decisionAr: 'UAT closure ينتظر التنفيذ داخل PalWakf.',
        status: 'uat-pack-ready-pending-evidence',
      ),
      NosokV31ToV35StageGate(
        stage: 'v35',
        titleAr: 'Production Candidate Closure',
        deliverableAr: 'صفحة قرار candidate وقائمة بوابات نهائية.',
        decisionAr: 'production-candidate مؤجل؛ production-not-approved.',
        status: 'candidate-deferred',
      ),
    ],
    acceptanceChecklist: [
      'نسك لا يستخدم legacy.dart في الملفات الجديدة.',
      'الواجهات العامة لا تعرض أدوات الموظفين.',
      'الواجهات الداخلية محمية بـ AccessProfile/Route Guard.',
      'SQL/RPC/RLS مهيأة كـ Draft/Sandbox فقط قبل إنشاء schema.',
      'Repository binding الحقيقي disabled حتى نجاح SQL/RPC evidence.',
      'قرعة LGU capacity-aware موثقة مع قرار لجنة عند نقص الحصة.',
      'Browser/Role/Responsive UAT مطلوب داخل PalWakf بعد الدمج.',
      'لا توجد موافقة إنتاج ولا تعديل على waqf_assets.',
    ],
    blockers: [
      'لم يتم توفير ريبو PalWakf الكامل داخل هذه البيئة، لذلك لا يمكن إثبات الدمج الفعلي خارجيًا.',
      'لم يتم إنشاء nosok schema في Supabase عمدًا قبل الدمج الرسمي.',
      'لا توجد نتيجة SQL sandbox apply ولا readiness RPC لأنها مؤجلة إلى ما بعد الدمج.',
      'Backend binding الحقيقي مؤجل حتى وجود schema/RPC/RLS.',
      'Production candidate مؤجل حتى أدلة v34 داخل PalWakf.',
      'Production-ready غير معتمد في هذه الحزمة.',
    ],
  );
});
