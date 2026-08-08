class NosokV36EvidenceItem {
  const NosokV36EvidenceItem({
    required this.key,
    required this.titleAr,
    required this.status,
    required this.evidenceAr,
    required this.decisionAr,
  });

  final String key;
  final String titleAr;
  final String status;
  final String evidenceAr;
  final String decisionAr;

  bool get accepted => status == 'accepted';
  bool get pending => status == 'pending';
  bool get blocked => status == 'blocked';
  bool get candidate => status == 'candidate';
}

class NosokV36WrapperRuntimeCase {
  const NosokV36WrapperRuntimeCase({
    required this.caseKey,
    required this.actorAr,
    required this.routeOrSurface,
    required this.rpcSurface,
    required this.expectedAr,
    required this.requiredEvidenceAr,
    required this.status,
  });

  final String caseKey;
  final String actorAr;
  final String routeOrSurface;
  final String rpcSurface;
  final String expectedAr;
  final String requiredEvidenceAr;
  final String status;

  bool get accepted => status == 'accepted';
  bool get pending => status == 'pending';
  bool get blocked => status == 'blocked';
}

class NosokV36RepositoryBindingRule {
  const NosokV36RepositoryBindingRule({
    required this.area,
    required this.currentSource,
    required this.controlledTarget,
    required this.allowedNow,
    required this.requiredGateAr,
  });

  final String area;
  final String currentSource;
  final String controlledTarget;
  final bool allowedNow;
  final String requiredGateAr;
}

class NosokV36AdapterMethodContract {
  const NosokV36AdapterMethodContract({
    required this.methodName,
    required this.wrapperSurface,
    required this.dataDirection,
    required this.privacyBoundaryAr,
    required this.bindingDecisionAr,
  });

  final String methodName;
  final String wrapperSurface;
  final String dataDirection;
  final String privacyBoundaryAr;
  final String bindingDecisionAr;
}

class NosokV36ProductionGateDecision {
  const NosokV36ProductionGateDecision({
    required this.decision,
    required this.summaryAr,
    required this.acceptedAr,
    required this.blockedAr,
    required this.nextStepAr,
  });

  final String decision;
  final String summaryAr;
  final String acceptedAr;
  final String blockedAr;
  final String nextStepAr;
}

class NosokV36BindingPack {
  const NosokV36BindingPack({
    required this.evidenceItems,
    required this.runtimeCases,
    required this.repositoryBindingRules,
    required this.adapterMethods,
    required this.productionGateDecision,
  });

  final List<NosokV36EvidenceItem> evidenceItems;
  final List<NosokV36WrapperRuntimeCase> runtimeCases;
  final List<NosokV36RepositoryBindingRule> repositoryBindingRules;
  final List<NosokV36AdapterMethodContract> adapterMethods;
  final NosokV36ProductionGateDecision productionGateDecision;

  int get acceptedEvidenceCount =>
      evidenceItems.where((item) => item.accepted).length;
  int get pendingRuntimeCaseCount =>
      runtimeCases.where((item) => item.pending).length;
  int get adapterMethodCount => adapterMethods.length;
  int get bindingCandidateCount =>
      repositoryBindingRules.where((item) => item.allowedNow).length;

  static NosokV36BindingPack baseline() {
    return const NosokV36BindingPack(
      evidenceItems: [
        NosokV36EvidenceItem(
          key: 'v35_1_sql_gate',
          titleAr: 'نتيجة v35.1 read-only',
          status: 'accepted',
          evidenceAr:
              'أكدت أن repository binding لا يعتمد قبل Browser/Role/Scope UAT.',
          decisionAr: 'يُقبل كمدخل لدفعة v36 ولا يمنح production approval.',
        ),
        NosokV36EvidenceItem(
          key: 'v35_wrapper_apply',
          titleAr: 'تطبيق public wrapper/RPC على staging',
          status: 'accepted',
          evidenceAr:
              'تم إثبات وجود أربع RPCs وواجهتي view داخل public دون إنشاء public base tables.',
          decisionAr:
              'يسمح بتجهيز adapter controlled للقراءة/الإرسال عبر wrappers فقط.',
        ),
        NosokV36EvidenceItem(
          key: 'function_security',
          titleAr: 'Security definer + search_path',
          status: 'accepted',
          evidenceAr:
              'الدوال الأربع security_definer وبـ search_path=public, nosok, pg_temp.',
          decisionAr:
              'مقبول لمرحلة staging مع بقاء فحص privacy وnetwork evidence مطلوبًا.',
        ),
        NosokV36EvidenceItem(
          key: 'browser_role_scope',
          titleAr: 'Browser/Role/Scope evidence',
          status: 'pending',
          evidenceAr:
              'لم تُغلق بعد لقطات المتصفح، Network RPC 200، وسيناريوهات anonymous/authenticated/no-role.',
          decisionAr: 'لا إنتاج ولا platformHosted binding قبل الإغلاق.',
        ),
      ],
      runtimeCases: [
        NosokV36WrapperRuntimeCase(
          caseKey: 'public_campaigns_list',
          actorAr: 'anonymous',
          routeOrSurface: '/services/nosok',
          rpcSurface: 'public.rpc_nosok_campaigns_public_list_v1',
          expectedAr: '200 أو empty-safe دون كشف جداول nosok.* مباشرة.',
          requiredEvidenceAr: 'Network tab + screenshot + console clean.',
          status: 'pending',
        ),
        NosokV36WrapperRuntimeCase(
          caseKey: 'public_requirements_list',
          actorAr: 'anonymous',
          routeOrSurface: '/services/nosok/requirements',
          rpcSurface: 'public.rpc_nosok_requirements_public_list_v1',
          expectedAr: 'عرض شروط منشورة فقط، دون شروط draft أو payload داخلي.',
          requiredEvidenceAr: 'Network 200/empty-safe + privacy screenshot.',
          status: 'pending',
        ),
        NosokV36WrapperRuntimeCase(
          caseKey: 'public_application_submit',
          actorAr: 'anonymous/public applicant',
          routeOrSurface: '/services/nosok/apply',
          rpcSurface: 'public.rpc_nosok_application_submit_v1',
          expectedAr:
              'staging submit محكوم؛ إما tracking_code آمن أو رفض آمن عند غياب campaign مفتوح.',
          requiredEvidenceAr:
              'Network payload redaction + response screenshot.',
          status: 'pending',
        ),
        NosokV36WrapperRuntimeCase(
          caseKey: 'public_application_track',
          actorAr: 'anonymous/public applicant',
          routeOrSurface: '/services/nosok/track',
          rpcSurface: 'public.rpc_nosok_application_track_v1',
          expectedAr: 'يعرض status عام فقط دون هوية/مرفقات/audit events.',
          requiredEvidenceAr: 'Network response + privacy evidence.',
          status: 'pending',
        ),
        NosokV36WrapperRuntimeCase(
          caseKey: 'authenticated_no_nosok_role',
          actorAr: 'authenticated بلا دور نسك',
          routeOrSurface: '/admin/systems/nosok',
          rpcSurface: 'Platform Access Gateway + NosokAccessGate',
          expectedAr:
              'Forbidden عربي أو إخفاء إداري، دون تسريب بيانات أو direct table access.',
          requiredEvidenceAr:
              'Screenshot actor strip + forbidden/hidden route evidence.',
          status: 'pending',
        ),
        NosokV36WrapperRuntimeCase(
          caseKey: 'unit_scope_negative',
          actorAr: 'موظف وحدة يحاول وحدة أخرى',
          routeOrSurface: 'admin/unit scoped surfaces',
          rpcSurface: 'platform_access + controlled repository scope',
          expectedAr: 'scope denied آمن حتى لو RPCs العامة موجودة.',
          requiredEvidenceAr: 'role/unit matrix + screenshot.',
          status: 'pending',
        ),
      ],
      repositoryBindingRules: [
        NosokV36RepositoryBindingRule(
          area: 'Public campaigns',
          currentSource: 'preview/in-memory fallback',
          controlledTarget: 'rpc_nosok_campaigns_public_list_v1',
          allowedNow: true,
          requiredGateAr:
              'يمكن ربط standaloneSupabaseDevelopment بعد Network evidence؛ platformHosted يبقى محجوبًا.',
        ),
        NosokV36RepositoryBindingRule(
          area: 'Public requirements',
          currentSource: 'preview/static requirements',
          controlledTarget: 'rpc_nosok_requirements_public_list_v1',
          allowedNow: true,
          requiredGateAr:
              'يربط فقط للشروط المنشورة، مع fallback آمن عند empty/error.',
        ),
        NosokV36RepositoryBindingRule(
          area: 'Public submit',
          currentSource: 'preview/staging gated submit',
          controlledTarget: 'rpc_nosok_application_submit_v1',
          allowedNow: false,
          requiredGateAr:
              'يتطلب privacy review وstaging-only banner وrate-limit/server-side controls قبل الربط الكامل.',
        ),
        NosokV36RepositoryBindingRule(
          area: 'Public track',
          currentSource: 'preview/tracking mock',
          controlledTarget: 'rpc_nosok_application_track_v1',
          allowedNow: false,
          requiredGateAr:
              'يتطلب tracking privacy evidence لعدم كشف بيانات شخصية.',
        ),
        NosokV36RepositoryBindingRule(
          area: 'Admin queues/review',
          currentSource: 'preview/admin repository',
          controlledTarget: 'future authenticated admin RPCs',
          allowedNow: false,
          requiredGateAr:
              'ليس ضمن public wrapper v35؛ يحتاج دفعة Admin RPC/RLS مستقلة.',
        ),
      ],
      adapterMethods: [
        NosokV36AdapterMethodContract(
          methodName: 'listPublicCampaigns',
          wrapperSurface: 'rpc_nosok_campaigns_public_list_v1',
          dataDirection: 'read-only',
          privacyBoundaryAr: 'لا يعرض إلا الحقول العامة للمواسم المنشورة.',
          bindingDecisionAr: 'candidate في standaloneSupabaseDevelopment.',
        ),
        NosokV36AdapterMethodContract(
          methodName: 'listPublicRequirements',
          wrapperSurface: 'rpc_nosok_requirements_public_list_v1',
          dataDirection: 'read-only',
          privacyBoundaryAr:
              'يعرض شروطًا عامة فقط ولا يقرأ eligibility_rules مباشرة من Flutter.',
          bindingDecisionAr: 'candidate بعد browser evidence.',
        ),
        NosokV36AdapterMethodContract(
          methodName: 'submitPublicApplication',
          wrapperSurface: 'rpc_nosok_application_submit_v1',
          dataDirection: 'write via RPC only',
          privacyBoundaryAr:
              'لا direct insert إلى nosok.applications، ولا service_role، ولا raw backend errors.',
          bindingDecisionAr: 'blocked حتى privacy/rate-limit/staging evidence.',
        ),
        NosokV36AdapterMethodContract(
          methodName: 'trackPublicApplication',
          wrapperSurface: 'rpc_nosok_application_track_v1',
          dataDirection: 'read via RPC only',
          privacyBoundaryAr: 'يرجع status عامًا فقط وفق عقد التتبع.',
          bindingDecisionAr: 'blocked حتى tracking privacy evidence.',
        ),
      ],
      productionGateDecision: NosokV36ProductionGateDecision(
        decision:
            'V36_REPOSITORY_BINDING_CONTROLLED_ADAPTER_PREPARED_PRODUCTION_DEFERRED',
        summaryAr:
            'تم تجهيز adapter controlled وربط قرار الواجهات العامة نظريًا، لكن لم يتم اعتماد production ولا platformHosted binding.',
        acceptedAr:
            'تم قبول وجود wrappers/RPCs وSecurity Definer وgrants وعدم إنشاء public base tables.',
        blockedAr:
            'Browser/Role/Scope/Network evidence غير مغلق؛ Admin RPCs غير موجودة؛ production غير معتمد.',
        nextStepAr:
            'تشغيل SQL 35 read-only ثم تنفيذ Browser/Role/Scope evidence؛ بعدها v37 لربط public repository فعليًا أو لإغلاق production gate.',
      ),
    );
  }
}
