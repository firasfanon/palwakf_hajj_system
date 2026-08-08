import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/nosok_v38h_supabase_binding_contract.dart';

final nosokV38HSupabaseBindingContractProvider =
    Provider<NosokV38HSupabaseBindingContract>((ref) {
  return const NosokV38HSupabaseBindingContract(
    version: 'v38H',
    executionStatus: 'contract-discovered / no-sql-apply / no-runtime-binding',
    platformClientFindings: [
      NosokV38HPlatformClientFinding(
        key: 'platform_supabase_initialization',
        sourceFile: 'PalWakf lib/main.dart',
        findingAr:
            'المنصة تهيئ Supabase مركزيًا عبر Supabase.initialize باستخدام AppConstants.baseUrl وAppConstants.apiKey بعد تحميل .env.',
        nosokDecisionAr:
            'نسك لا ينشئ Supabase.initialize مستقلًا. عند الاستضافة داخل PalWakf يستخدم العميل المركزي فقط.',
        status: 'discovered',
      ),
      NosokV38HPlatformClientFinding(
        key: 'platform_env_contract',
        sourceFile: 'PalWakf lib/core/constants/app_constants.dart',
        findingAr:
            'مفاتيح SUPABASE_URL وSUPABASE_ANON_KEY تقرأ من AppConstants ولا توجد fallbacks hardcoded.',
        nosokDecisionAr:
            'لا تُخزن أي مفاتيح داخل نسك. كل الإعدادات تأتي من بيئة PalWakf عند الانضمام.',
        status: 'discovered',
      ),
      NosokV38HPlatformClientFinding(
        key: 'platform_supabase_service',
        sourceFile: 'PalWakf lib/data/services/supabase_service.dart',
        findingAr:
            'المنصة تملك SupabaseService singleton يوفر client وfrom وrpc وauth/storage helpers.',
        nosokDecisionAr:
            'Repository الحقيقي لنسك يجب أن يحصل على SupabaseService أو SupabaseClient من Provider المنصة، لا من عميل مستقل.',
        status: 'adapter-required',
      ),
      NosokV38HPlatformClientFinding(
        key: 'platform_supabase_provider',
        sourceFile:
            'PalWakf lib/presentation/providers/supabase_providers.dart',
        findingAr:
            'supabaseServiceProvider هو مصدر حقن SupabaseService عبر Riverpod داخل PalWakf.',
        nosokDecisionAr:
            'بعد الاستضافة يتم override/توصيل nosokRepositoryProvider ليستخدم supabaseServiceProvider من المنصة.',
        status: 'provider-aware',
      ),
      NosokV38HPlatformClientFinding(
        key: 'platform_access_context',
        sourceFile:
            'PalWakf lib/core/access/access_repository.dart + access_provider.dart',
        findingAr:
            'AccessRepository يقرأ admin_users وsystem/user roles والpermissions من المنصة ويكشف AccessProfile.',
        nosokDecisionAr:
            'RPCs الإدارية في نسك يجب أن تعتمد auth.uid() وAccessProfile/RBAC المنصة؛ الواجهة ليست طبقة الأمن.',
        status: 'security-source-discovered',
      ),
    ],
    repositoryAdapterRules: [
      NosokV38HRepositoryAdapterRule(
        key: 'single_client_source',
        titleAr: 'عميل Supabase واحد من PalWakf',
        ruleAr:
            'يحظر إنشاء Supabase.initialize أو SupabaseClient مستقل داخل نسك بعد الانضمام.',
        implementationAr:
            'NosokSupabaseRepository يستقبل العميل/الخدمة من Provider المنصة، ومع عدم التهيئة يبقى InMemory/Preview.',
      ),
      NosokV38HRepositoryAdapterRule(
        key: 'rpc_first',
        titleAr: 'RPC أولًا لا جداول مباشرة',
        ruleAr:
            'واجهات نسك العامة والإدارية تستدعي public RPC wrappers بدل القراءة المباشرة من nosok schema.',
        implementationAr:
            'أي fallback مباشر إلى schema nosok يبقى محظورًا في production ويستخدم فقط كأداة developer sandbox إن صُرح بذلك.',
      ),
      NosokV38HRepositoryAdapterRule(
        key: 'auth_context_not_payload',
        titleAr: 'السياق من الجلسة لا من payload',
        ruleAr:
            'لا يرسل الموظف أو الشركة نطاقه يدويًا كقيمة موثوقة؛ النطاق يحسب من auth.uid وRBAC والمنصة.',
        implementationAr:
            'RPCs الإدارية تستخدم auth.uid() ثم admin_users/platform roles/core.org_units لاستخراج allowed scope.',
      ),
      NosokV38HRepositoryAdapterRule(
        key: 'public_privacy_boundary',
        titleAr: 'حد الخصوصية العامة',
        ruleAr:
            'القراءة العامة لا تكشف بيانات أشخاص أو قوائم متقدمين، وتعيد فقط payload آمن للتتبع/النتيجة.',
        implementationAr:
            'public RPCs تعيد رقم مرجعي/حالة عامة/نتيجة صاحب الطلب فقط أو محتوى published-only.',
      ),
      NosokV38HRepositoryAdapterRule(
        key: 'storage_deferred',
        titleAr: 'Storage مؤجل بعقد منفصل',
        ruleAr:
            'مرفقات نسك لا تستخدم bucket عشوائي؛ تحتاج bucket policy مرتبطة بالطلب والمستخدم والنطاق.',
        implementationAr:
            'يضاف لاحقًا storage bucket مثل nosok-documents مع signed upload/download وRLS/RPC gateway.',
      ),
    ],
    rpcContracts: [
      NosokV38HRpcContract(
        rpcName: 'public.rpc_nosok_homepage_sections_public_v1',
        surface: 'public',
        purposeAr:
            'إرجاع أقسام الصفحة الرئيسية المنشورة فقط حسب الموسم والوحدة إن وجدت.',
        securityAr: 'published-only ولا يعيد draft/internal/admin notes.',
        statusAr: 'draft contract',
      ),
      NosokV38HRpcContract(
        rpcName: 'public.rpc_nosok_public_application_submit_v1',
        surface: 'public',
        purposeAr:
            'استقبال طلب المواطن وفق سياسة التسجيل القانونية ونافذة الموسم.',
        securityAr:
            'يتحقق من التكرار والسياسة ونطاق العنوان ولا يثق ببيانات الواجهة وحدها.',
        statusAr: 'draft contract',
      ),
      NosokV38HRpcContract(
        rpcName: 'public.rpc_nosok_public_application_track_v1',
        surface: 'public',
        purposeAr:
            'تتبع طلب باستخدام رقم مرجعي/رمز آمن دون كشف بيانات الآخرين.',
        securityAr: 'public-safe payload فقط، ولا يرد بقوائم أو بيانات حساسة.',
        statusAr: 'draft contract',
      ),
      NosokV38HRpcContract(
        rpcName: 'public.rpc_nosok_public_lottery_result_get_v1',
        surface: 'public',
        purposeAr:
            'إرجاع نتيجة صاحب الطلب أو قائمة انتظاره حسب السياسة المنشورة.',
        securityAr: 'لا يعرض أسماء متقدمين آخرين ولا full draw pool.',
        statusAr: 'draft contract',
      ),
      NosokV38HRpcContract(
        rpcName: 'public.rpc_nosok_public_objection_submit_v1',
        surface: 'public',
        purposeAr: 'تقديم اعتراض ضمن نافذة قانونية مع رقم متابعة.',
        securityAr: 'يتحقق من النافذة والطلب ولا يسمح بتعديل pool مجمد.',
        statusAr: 'draft contract',
      ),
      NosokV38HRpcContract(
        rpcName: 'public.rpc_nosok_admin_applications_queue_v1',
        surface: 'admin',
        purposeAr: 'طابور طلبات الموظف حسب unit/LGU/company scope.',
        securityAr:
            'RBAC + auth.uid + allowed_unit_ids/allowed_lgu_ids داخل RPC.',
        statusAr: 'draft contract',
      ),
      NosokV38HRpcContract(
        rpcName: 'public.rpc_nosok_admin_homepage_sections_upsert_v1',
        surface: 'admin',
        purposeAr: 'إدارة أقسام الصفحة الرئيسية بنشر/إخفاء/ترتيب وسجل تدقيق.',
        securityAr:
            'manageNosokHomepageSections + audit event + no public draft exposure.',
        statusAr: 'draft contract',
      ),
      NosokV38HRpcContract(
        rpcName: 'public.rpc_nosok_admin_dynamic_page_publish_v1',
        surface: 'admin',
        purposeAr: 'نشر صفحة عامة ديناميكية من قالب آمن بعد التدقيق.',
        securityAr:
            'permission key + slug collision checks + template whitelist + audit.',
        statusAr: 'draft contract',
      ),
      NosokV38HRpcContract(
        rpcName: 'public.rpc_nosok_admin_legal_lottery_simulate_v1',
        surface: 'admin',
        purposeAr:
            'محاكاة خوارزمية الحج القانونية لأغراض المراجعة دون اعتماد نتائج.',
        securityAr: 'read/simulation only ولا يكتب نتائج قرعة إنتاجية.',
        statusAr: 'draft contract',
      ),
      NosokV38HRpcContract(
        rpcName: 'public.rpc_nosok_admin_lottery_draw_execute_v1',
        surface: 'admin',
        purposeAr:
            'تنفيذ القرعة القانونية بعد إغلاق التسجيل وتجميد pool وتثبيت السياسة.',
        securityAr:
            'executeNosokLotteryDraw + immutable audit + single draw run guard.',
        statusAr: 'draft contract / not executable now',
      ),
    ],
    shapeDiscoveryChecks: [
      NosokV38HShapeDiscoveryCheck(
        checkKey: 'supabase_client_contract',
        targetObject: 'PalWakf SupabaseService / supabaseServiceProvider',
        expectedPurposeAr: 'تحديد طريقة حقن العميل في repositories.',
        decisionAr:
            'استخدم Provider المنصة بعد الانضمام، ولا تنشئ client مستقل.',
      ),
      NosokV38HShapeDiscoveryCheck(
        checkKey: 'admin_users_shape',
        targetObject: 'public.admin_users',
        expectedPurposeAr:
            'تأكيد أعمدة id/email/role/is_active/is_superuser/unit_id/governorate.',
        decisionAr:
            'تستخدم كهوية موظفين، مع عدم إنشاء جدول مستخدمين مستقل في نسك.',
      ),
      NosokV38HShapeDiscoveryCheck(
        checkKey: 'platform_rbac_shape',
        targetObject:
            'platform.system_user_roles + platform.system_user_permissions',
        expectedPurposeAr:
            'تأكيد أسماء الأعمدة والقيم قبل ربط system_key=nosok.',
        decisionAr:
            'أي seed لصلاحيات نسك ينتظر platform track ولا ينفذ في standalone.',
      ),
      NosokV38HShapeDiscoveryCheck(
        checkKey: 'org_units_shape',
        targetObject: 'core.org_units / public.org_units / unit profile RPCs',
        expectedPurposeAr: 'تأكيد slug/unit id/hierarchy للمديريات والوحدات.',
        decisionAr: 'unit scope في نسك يبنى فوق هذا المصدر لا فوق إدخال حر.',
      ),
      NosokV38HShapeDiscoveryCheck(
        checkKey: 'lgu_governorates_shape',
        targetObject: 'GIS LGU/Governorate objects',
        expectedPurposeAr:
            'تحديد مصدر LGU والمحافظات الفعلي وربطه بلقطات الموسم.',
        decisionAr: 'لا FK أو mapping نهائي قبل discovery داخل PalWakf DB.',
      ),
      NosokV38HShapeDiscoveryCheck(
        checkKey: 'storage_policy_shape',
        targetObject: 'Supabase storage buckets/policies',
        expectedPurposeAr: 'تحديد bucket الوثائق وسياسة الرفع والتنزيل.',
        decisionAr:
            'document upload remains contract until storage bucket is approved.',
      ),
    ],
    noApplyGates: [
      'لا SQL apply في v38H؛ هذه دفعة اكتشاف عقد اتصال وتجهيز adapter فقط.',
      'لا تستخدم service_role أو مفاتيح حساسة داخل الكود أو الوثائق.',
      'لا اتصال Supabase مستقل داخل نسك standalone؛ الربط الحقيقي ينتظر استضافة PalWakf.',
      'لا قراءة مباشرة من core/gis/waqf؛ القراءة تتم عبر RPC wrappers أو snapshots مصرح بها.',
      'لا تعديل على waqf_assets أو schema waqf أو awqaf_system.',
    ],
    runtimeBindingSequence: [
      '1. تستضيف PalWakf feature nosok_system داخل الريبو الحقيقي بعد انتهاء pre-join.',
      '2. يمرر ProviderScope في PalWakf SupabaseService/AccessProfile الحقيقي إلى نسك.',
      '3. تنشأ schema nosok والجداول/RLS/RPC في Supabase عبر platform track بعد shape discovery.',
      '4. يتحول NosokRepository من preview/in-memory إلى RPC-first Supabase repository.',
      '5. تجرى UAT للأدوار والوحدات والشركات والجمهور قبل أي اعتماد إنتاجي.',
    ],
  );
});
