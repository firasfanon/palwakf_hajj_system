import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/nosok_prejoin_admin_tools_contract.dart';

final nosokPrejoinAdminToolsContractProvider =
    Provider<NosokPrejoinAdminToolsContract>((ref) {
  return const NosokPrejoinAdminToolsContract(
    version: 'v38D-dynamic-pages-sections-builder-prejoin-scope',
    scopeDecision:
        'development/preparation-only: admin tools are designed and surfaced inside Nosok preview, but real persistence/RBAC binding waits for PalWakf hosting.',
    databaseDecision:
        'nosok schema is not created by design. homepage/admin tables are draft contracts only until PalWakf hosts Nosok and Supabase sandbox approves creation.',
    homepageSections: [
      NosokHomepageSectionContract(
        key: 'hero',
        titleAr: 'القسم الترحيبي الرئيسي',
        surface: 'public_homepage',
        visibilityScope: 'public / unit optional / season-aware',
        defaultState: 'published-visible',
        adminControl:
            'title, subtitle, badges, CTA, display order, publish window',
        notesAr:
            'لا تعرض أي حوكمة تقنية للمواطن، وتلتزم بالهوية السيادية الأزرق/الذهبي فقط.',
      ),
      NosokHomepageSectionContract(
        key: 'season_status',
        titleAr: 'حالة الموسم',
        surface: 'public_homepage',
        visibilityScope: 'public / season-policy snapshot',
        defaultState: 'published-visible',
        adminControl: 'registration status, deadline, result status, notices',
        notesAr:
            'تعرض لغة مواطن: التسجيل مفتوح/مغلق، النتائج متاحة/غير متاحة، لا backend terms.',
      ),
      NosokHomepageSectionContract(
        key: 'primary_services',
        titleAr: 'الخدمات الرئيسية',
        surface: 'public_homepage',
        visibilityScope: 'public / role-neutral',
        defaultState: 'published-visible',
        adminControl: 'cards, routes, display order, publish/unpublish',
        notesAr: 'تقديم طلب، متابعة طلب، نتائج القرعة تظهر كإجراءات رئيسية.',
      ),
      NosokHomepageSectionContract(
        key: 'companies',
        titleAr: 'الشركات المؤهلة',
        surface: 'public_homepage + companies page',
        visibilityScope: 'public',
        defaultState: 'published-visible',
        adminControl: 'section visibility, intro text, route binding',
        notesAr: 'لا تعرض تقييمات داخلية للشركات للعامة قبل سياسة نشر واضحة.',
      ),
      NosokHomepageSectionContract(
        key: 'trust_transparency',
        titleAr: 'الشفافية والعدالة',
        surface: 'public_homepage',
        visibilityScope: 'public',
        defaultState: 'published-visible',
        adminControl:
            'policy wording, LGU quota explanation, publication window',
        notesAr:
            'تشرح أن التسجيل حسب العنوان في البطاقة الشخصية وأن القرعة حسب حصة التجمع.',
      ),
      NosokHomepageSectionContract(
        key: 'help_support',
        titleAr: 'المساعدة والدعم',
        surface: 'public_homepage + help pages',
        visibilityScope: 'public',
        defaultState: 'published-visible',
        adminControl:
            'FAQ links, contact channels, complaint links, assistant availability',
        notesAr:
            'كل تكامل غير جاهز يظهر كإرشاد/غير متاح ولا يدعي التشغيل الحقيقي.',
      ),
    ],
    dynamicPages: [
      NosokDynamicPageContract(
        key: 'public_dynamic_page',
        titleAr: 'صفحة عامة ديناميكية',
        routePattern: '/services/nosok/pages/:slug',
        surface: 'public_dynamic_content',
        allowedAudience: 'public / citizen-safe only',
        adminControl:
            'title, slug, intro, page template, sections, publish window, display order, SEO hints',
        status: 'draft registry / not applied',
      ),
      NosokDynamicPageContract(
        key: 'season_landing_page',
        titleAr: 'صفحة موسم أو تعليمات موسمية',
        routePattern: '/services/nosok/seasons/:seasonSlug',
        surface: 'public_season_content',
        allowedAudience: 'public with season policy snapshot',
        adminControl:
            'registration notice, deadlines, requirements, result-publication notice, citizen actions',
        status: 'draft registry / not applied',
      ),
      NosokDynamicPageContract(
        key: 'company_public_page',
        titleAr: 'صفحة شركات/حملات عامة',
        routePattern: '/services/nosok/companies/:companySlug',
        surface: 'public_company_content',
        allowedAudience: 'public-safe company directory content',
        adminControl:
            'company intro, contacts, qualification season, allowed public fields, publish/unpublish',
        status: 'draft registry / not applied',
      ),
      NosokDynamicPageContract(
        key: 'admin_operational_page',
        titleAr: 'صفحة إدارية تشغيلية مستقبلية',
        routePattern: '/admin/systems/nosok/dynamic/:slug',
        surface: 'admin_dynamic_workspace',
        allowedAudience:
            'RBAC protected / role scoped / unit scoped when needed',
        adminControl:
            'page capability, required permission key, unit scope, table/RPC contract, evidence-only flag',
        status: 'draft registry / not applied',
      ),
    ],
    dynamicPageSections: [
      NosokDynamicPageSectionContract(
        key: 'rich_text_policy_block',
        titleAr: 'كتلة نص سياسة أو تعليمات',
        componentType: 'rich_text_block',
        reusableOn: 'public pages / season pages / help pages',
        contentFields:
            'title_ar, body_ar, icon_key, notice_tone, display_order',
        governanceNoteAr:
            'لا تعرض لغة تقنية ولا بيانات شخصية، وتخضع لنافذة نشر وتدقيق محتوى.',
      ),
      NosokDynamicPageSectionContract(
        key: 'service_action_cards',
        titleAr: 'بطاقات إجراءات الخدمة',
        componentType: 'service_cards_grid',
        reusableOn: 'homepage / dynamic public pages / company pages',
        contentFields:
            'card_title_ar, card_body_ar, route_path, badge_ar, icon_key, priority',
        governanceNoteAr:
            'كل route يجب أن يكون ضمن قائمة مسارات نسك العامة المصرحة، ولا يربط بمسار إداري.',
      ),
      NosokDynamicPageSectionContract(
        key: 'season_status_banner',
        titleAr: 'شريط حالة الموسم',
        componentType: 'season_status_banner',
        reusableOn: 'homepage / season landing pages / apply page intro',
        contentFields:
            'season_key, status_label_ar, deadline_ar, notice_ar, tone',
        governanceNoteAr:
            'المصدر النهائي يجب أن يكون snapshot سياسة الموسم، لا نصًا منفصلًا غير متزامن.',
      ),
      NosokDynamicPageSectionContract(
        key: 'faq_accordion',
        titleAr: 'أسئلة شائعة قابلة للتوسيع',
        componentType: 'faq_accordion',
        reusableOn: 'help / hajj / umrah / dynamic pages',
        contentFields:
            'question_ar, answer_ar, category_key, display_order, is_published',
        governanceNoteAr:
            'يجب ألا تحتوي الإجابات على وعود تشغيلية غير مدعومة أو روابط خارجية غير معتمدة.',
      ),
      NosokDynamicPageSectionContract(
        key: 'admin_table_workspace',
        titleAr: 'مساحة جدول/قائمة إدارية',
        componentType: 'admin_table_workspace',
        reusableOn: 'admin dynamic pages only',
        contentFields:
            'required_permission_key, rpc_contract, visible_columns, allowed_actions, unit_scope_mode',
        governanceNoteAr:
            'لا يكفي إخفاؤها من الواجهة؛ يجب أن يحكمها RBAC/RLS/RPC عند الإنشاء الحقيقي.',
      ),
    ],
    dynamicPageGovernanceRules: [
      NosokDynamicPageGovernanceRuleContract(
        key: 'no_developer_for_content_pages',
        titleAr: 'إضافة صفحات محتوى دون مطور',
        ruleAr:
            'مدير المحتوى يستطيع إضافة صفحة عامة جديدة من قالب معتمد وربط أقسامها وترتيبها ونشرها ضمن مسارات آمنة.',
        securityLayer: 'admin RPC + publish workflow + audit events',
        status: 'contract-ready / schema pending',
      ),
      NosokDynamicPageGovernanceRuleContract(
        key: 'admin_pages_need_platform_contract',
        titleAr: 'الصفحات الإدارية الجديدة ليست محتوى فقط',
        ruleAr:
            'أي صفحة إدارية جديدة تحتاج permission key وroute contract وRPC contract وscope policy قبل الظهور لأي مستخدم.',
        securityLayer: 'PalWakf RBAC + Nosok permission catalog + RLS/RPC',
        status: 'pre-join rule / enforced after hosting',
      ),
      NosokDynamicPageGovernanceRuleContract(
        key: 'route_slug_safety',
        titleAr: 'سلامة slug والمسارات',
        ruleAr:
            'لا يسمح بإنشاء slug يطابق مسارًا ثابتًا أو إداريًا، ولا يسمح بالروابط الخارجية إلا بقائمة بيضاء.',
        securityLayer: 'slug validator + reserved routes table + admin audit',
        status: 'contract-ready / schema pending',
      ),
      NosokDynamicPageGovernanceRuleContract(
        key: 'publish_workflow_required',
        titleAr: 'النشر يحتاج Workflow',
        ruleAr:
            'المسودات لا تظهر للعامة. النشر/الإخفاء/الأرشفة يحتاج حالة واضحة وسببًا وسجل تدقيق.',
        securityLayer: 'content workflow + audit events',
        status: 'contract-ready / schema pending',
      ),
    ],
    unitScopeRules: [
      NosokUnitScopeRuleContract(
        key: 'employee_slug_entry',
        titleAr: 'دخول الموظف بنطاق وحدة/مديرية',
        sourceOfTruth:
            'PalWakf AccessProfile + core.org_units + unitSlug mapping',
        filterContract:
            'unitSlug -> allowed governorates/LGUs -> application rows visible to employee',
        roleImpact:
            'موظف مديرية بيت لحم يرى سجلات تجمعات بيت لحم فقط عند التسجيل/التعديل/المراجعة.',
        status: 'contract-ready / real binding deferred',
      ),
      NosokUnitScopeRuleContract(
        key: 'citizen_address_lgu',
        titleAr: 'ربط المواطن بعنوان البطاقة الشخصية',
        sourceOfTruth: 'official ID address + LGU dictionary snapshot',
        filterContract:
            'identity address -> normalized LGU -> lottery quota + unit queue',
        roleImpact: 'لا يسمح للمواطن باختيار تجمع مختلف لتغيير حصة القرعة.',
        status: 'contract-ready / requires schema and official data source',
      ),
      NosokUnitScopeRuleContract(
        key: 'supervisor_scope',
        titleAr: 'نطاق المشرف',
        sourceOfTruth: 'AccessProfile roles + org unit hierarchy',
        filterContract:
            'supervisor unit scope can include multiple LGUs/directorates by policy',
        roleImpact: 'المشرف يرى نطاقه فقط، والسوبر يوزر يرى الكل مع audit.',
        status: 'contract-ready / real RBAC pending PalWakf',
      ),
      NosokUnitScopeRuleContract(
        key: 'company_scope',
        titleAr: 'نطاق الشركة',
        sourceOfTruth: 'company representative identity + company assignment',
        filterContract:
            'company user -> company_id -> campaigns/applicants/documents linked to company',
        roleImpact: 'الشركة ترى نطاقها فقط ولا ترى شركات أو طلبات أخرى.',
        status: 'contract-ready / company portal binding deferred',
      ),
    ],
    registrationGovernanceRules: [
      NosokRegistrationGovernanceRuleContract(
        key: 'registration_open',
        titleAr: 'فترة التسجيل مفتوحة',
        publicEffect:
            'المواطن يستطيع تقديم طلب وتعديله قبل الإرسال وفق سياسة الموسم.',
        adminEffect: 'الموظف يستطيع الفرز والمراجعة ضمن نطاقه فقط.',
        exceptionPath: 'لا حاجة لاستثناء إلا إذا نصت سياسة الموسم.',
        auditRequirement: 'تسجيل submit/update/attachment events.',
      ),
      NosokRegistrationGovernanceRuleContract(
        key: 'registration_closed',
        titleAr: 'انتهاء الفترة القانونية للتسجيل',
        publicEffect:
            'منع إنشاء طلب جديد ومنع تعديل المواطن إلا ضمن مسار استكمال نواقص مصرح.',
        adminEffect:
            'تجميد تعديلات الموظف على بيانات الطلب الأساسية؛ السماح بالمراجعة/التصنيف فقط.',
        exceptionPath: 'قرار لجنة الحج أو صلاحية superuser مع سبب واضح.',
        auditRequirement:
            'أي override يحتاج reason, operator, timestamp, evidence.',
      ),
      NosokRegistrationGovernanceRuleContract(
        key: 'completion_window',
        titleAr: 'نافذة استكمال النواقص',
        publicEffect:
            'السماح برفع مرفق ناقص أو تصحيح محدود فقط للطلب المعاد للاستكمال.',
        adminEffect:
            'الموظف يستطيع طلب استكمال أو قبول الوثائق ضمن نطاقه ولا يغير الحصة أو LGU.',
        exceptionPath: 'تمديد نافذة الاستكمال بسياسة موسم أو لجنة الحج.',
        auditRequirement: 'تسجيل الطلب/الرفع/القبول/الرفض لكل مرفق.',
      ),
      NosokRegistrationGovernanceRuleContract(
        key: 'lottery_pool_frozen',
        titleAr: 'تجميد Pool القرعة',
        publicEffect: 'لا تعديل يؤثر على الأهلية أو عدد الأشخاص بعد التجميد.',
        adminEffect:
            'لا تغيير على الأشخاص/المرافقين/العنوان/LGU إلا بقرار لجنة موثق.',
        exceptionPath:
            'committee decision required, no automatic cross-LGU movement.',
        auditRequirement: 'policy snapshot + quota snapshot + freeze hash.',
      ),
    ],
    requiredTables: [
      NosokSchemaObjectContract(
        name: 'nosok.homepage_sections',
        owner: 'nosok',
        purposeAr:
            'إدارة أقسام الصفحة الرئيسية العامة: ترتيب، نشر، إخفاء، نطاق وحدة/موسم، نصوص وCTA.',
        status: 'draft table / not applied',
      ),
      NosokSchemaObjectContract(
        name: 'nosok.page_registry',
        owner: 'nosok',
        purposeAr:
            'سجل الصفحات الديناميكية العامة والإدارية: slug، route، template، audience، publish status، permission key.',
        status: 'draft table / not applied',
      ),
      NosokSchemaObjectContract(
        name: 'nosok.page_sections',
        owner: 'nosok',
        purposeAr:
            'أقسام قابلة لإعادة الاستخدام داخل الصفحات الديناميكية مع ترتيب ونطاق نشر ومحتوى آمن.',
        status: 'draft table / not applied',
      ),
      NosokSchemaObjectContract(
        name: 'nosok.page_actions',
        owner: 'nosok',
        purposeAr:
            'أزرار وروابط الصفحات الديناميكية مع تحقق من المسارات وقائمة بيضاء للروابط.',
        status: 'draft table / not applied',
      ),
      NosokSchemaObjectContract(
        name: 'nosok.public_content_items',
        owner: 'nosok',
        purposeAr:
            'محتوى عام موجه للمواطن مثل التعليمات، نصوص الثقة، أسئلة مختارة، والتنبيهات الموسمية.',
        status: 'draft table / not applied',
      ),
      NosokSchemaObjectContract(
        name: 'nosok.unit_scope_policies',
        owner: 'nosok',
        purposeAr:
            'قواعد ربط unitSlug بالمديريات والتجمعات وسلوك الموظفين حسب نطاقهم.',
        status: 'draft table / not applied',
      ),
      NosokSchemaObjectContract(
        name: 'nosok.registration_governance_windows',
        owner: 'nosok',
        purposeAr:
            'فترات التسجيل والاستكمال والتجميد والقيود القانونية على المواطن والموظف.',
        status: 'draft table / not applied',
      ),
      NosokSchemaObjectContract(
        name: 'nosok.admin_override_events',
        owner: 'nosok',
        purposeAr: 'سجل قرارات الاستثناء بعد الإغلاق القانوني أو تجميد القرعة.',
        status: 'draft table / not applied',
      ),
    ],
    requiredRpcs: [
      NosokSchemaObjectContract(
        name: 'nosok.rpc_admin_homepage_sections_v1',
        owner: 'nosok',
        purposeAr: 'قراءة/إدارة أقسام الصفحة الرئيسية للمديرين حسب الصلاحية.',
        status: 'draft RPC / not deployed',
      ),
      NosokSchemaObjectContract(
        name: 'nosok.rpc_public_homepage_surface_v1',
        owner: 'nosok',
        purposeAr: 'عرض عام آمن لأقسام الصفحة الرئيسية المنشورة فقط.',
        status: 'draft RPC / not deployed',
      ),
      NosokSchemaObjectContract(
        name: 'nosok.rpc_public_dynamic_page_get_v1',
        owner: 'nosok',
        purposeAr:
            'إرجاع صفحة عامة منشورة حسب slug مع أقسامها فقط دون بيانات حساسة.',
        status: 'draft RPC / not deployed',
      ),
      NosokSchemaObjectContract(
        name: 'nosok.rpc_admin_dynamic_pages_manage_v1',
        owner: 'nosok',
        purposeAr:
            'إدارة الصفحات والأقسام والقوالب من لوحة الإدارة وفق RBAC وتدقيق كامل.',
        status: 'draft RPC / not deployed',
      ),
      NosokSchemaObjectContract(
        name: 'nosok.rpc_admin_unit_scope_preview_v1',
        owner: 'nosok',
        purposeAr:
            'معاينة السجلات التي يحق لموظف الوحدة رؤيتها حسب unitSlug/LGU.',
        status: 'draft RPC / not deployed',
      ),
      NosokSchemaObjectContract(
        name: 'nosok.rpc_registration_governance_state_v1',
        owner: 'nosok',
        purposeAr:
            'إرجاع حالة التسجيل/الاستكمال/التجميد وما يسمح به للمواطن والموظف.',
        status: 'draft RPC / not deployed',
      ),
    ],
    joinReadinessGates: [
      'PalWakf must provide real AccessProfile with unitSlug/org_units/LGU mapping before employee-scoped editing is enabled.',
      'Homepage sections table is draft only; public homepage continues to use safe static/fallback content until nosok schema exists.',
      'Dynamic pages/page sections must be created through approved templates and reserved-route validation, not through arbitrary code injection.',
      'Admin dynamic pages require permission keys, route contracts, unit-scope mode, and RPC/RLS enforcement before appearing to non-superuser roles.',
      'Registration close/freeze rules must be enforced in backend RPCs before any production registration window.',
      'Committee overrides require audit evidence and cannot be implemented as UI-only action.',
      'No cross-LGU quota transfer without committee decision and documented policy.',
    ],
  );
});
