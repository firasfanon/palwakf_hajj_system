class NosokV29AuthorizationItem {
  const NosokV29AuthorizationItem({
    required this.key,
    required this.labelAr,
    required this.status,
    required this.decision,
    required this.evidenceAr,
    this.blockerAr,
  });

  final String key;
  final String labelAr;
  final String status;
  final String decision;
  final String evidenceAr;
  final String? blockerAr;

  bool get accepted => status == 'accepted';
  bool get blocked => status == 'blocked';
  bool get pending => status == 'pending';
}

class NosokV29StagingApplyStep {
  const NosokV29StagingApplyStep({
    required this.order,
    required this.stepKey,
    required this.titleAr,
    required this.executionMode,
    required this.filePath,
    required this.allowed,
    required this.requiredBeforeRunAr,
  });

  final int order;
  final String stepKey;
  final String titleAr;
  final String executionMode;
  final String filePath;
  final bool allowed;
  final String requiredBeforeRunAr;
}

class NosokV29NegativeUatCase {
  const NosokV29NegativeUatCase({
    required this.caseKey,
    required this.actor,
    required this.target,
    required this.expectedResultAr,
    required this.status,
  });

  final String caseKey;
  final String actor;
  final String target;
  final String expectedResultAr;
  final String status;
}

class NosokV29RlsRpcPreflightRow {
  const NosokV29RlsRpcPreflightRow({
    required this.surfaceOrTable,
    required this.kind,
    required this.preflightRuleAr,
    required this.status,
  });

  final String surfaceOrTable;
  final String kind;
  final String preflightRuleAr;
  final String status;
}

class NosokV29ProductionGateDecision {
  const NosokV29ProductionGateDecision({
    required this.decision,
    required this.summaryAr,
    required this.nextAllowedStepAr,
    required this.blockedAr,
  });

  final String decision;
  final String summaryAr;
  final String nextAllowedStepAr;
  final String blockedAr;

  bool get productionApproved => decision == 'PRODUCTION_APPROVED';
}

class NosokV29AuthorizationPack {
  const NosokV29AuthorizationPack({
    required this.authorizationItems,
    required this.applySteps,
    required this.preflightRows,
    required this.negativeUatCases,
    required this.productionGateDecision,
  });

  final List<NosokV29AuthorizationItem> authorizationItems;
  final List<NosokV29StagingApplyStep> applySteps;
  final List<NosokV29RlsRpcPreflightRow> preflightRows;
  final List<NosokV29NegativeUatCase> negativeUatCases;
  final NosokV29ProductionGateDecision productionGateDecision;

  int get acceptedCount =>
      authorizationItems.where((item) => item.accepted).length;
  int get blockedCount =>
      authorizationItems.where((item) => item.blocked).length;
  int get pendingCount =>
      authorizationItems.where((item) => item.pending).length;
  int get runnableApplyStepCount =>
      applySteps.where((step) => step.allowed).length;

  static NosokV29AuthorizationPack baseline() {
    const authorizationItems = <NosokV29AuthorizationItem>[
      NosokV29AuthorizationItem(
        key: 'operator_request_intake',
        labelAr: 'استيعاب طلب v29',
        status: 'accepted',
        decision: 'AUTHORIZATION_INTAKE_ACCEPTED_FOR_PACK_PREPARATION',
        evidenceAr:
            'تم طلب حزمة v29 نصًا: Owner Schema DDL Authorization Intake + Staging Apply Gate + RLS/RPC/Negative UAT Preflight.',
      ),
      NosokV29AuthorizationItem(
        key: 'sql_apply_execution_by_assistant',
        labelAr: 'تنفيذ SQL بواسطة المساعد',
        status: 'blocked',
        decision: 'NO_SQL_EXECUTION_BY_ASSISTANT',
        evidenceAr:
            'الحزمة تجهز ملفات guarded staging apply فقط؛ لم يتم تنفيذ CREATE SCHEMA أو CREATE TABLE.',
        blockerAr:
            'التنفيذ الفعلي يتطلب DBA/operator داخل Supabase مع owner_authorization_id وتوثيق نتيجة التشغيل.',
      ),
      NosokV29AuthorizationItem(
        key: 'public_base_table_creation',
        labelAr: 'إنشاء جداول public',
        status: 'blocked',
        decision: 'PUBLIC_BASE_TABLE_CREATION_BLOCKED',
        evidenceAr: 'public يبقى views/RPC wrappers فقط؛ لا base tables جديدة.',
        blockerAr: 'أي CREATE TABLE public.* مرفوض تلقائيًا.',
      ),
      NosokV29AuthorizationItem(
        key: 'nosok_owner_schema_target',
        labelAr: 'هدف owner schema',
        status: 'accepted',
        decision: 'NOSOK_SCHEMA_TARGET_ONLY',
        evidenceAr:
            'جميع جداول التشغيل المرشحة داخل nosok.* فقط، مع reuse لـ core وbilling_system وplatform_access.',
      ),
      NosokV29AuthorizationItem(
        key: 'lottery_production_tables',
        labelAr: 'جداول القرعة الإنتاجية',
        status: 'pending',
        decision: 'LOTTERY_TABLES_DEFERRED_PENDING_LEGAL_ALGORITHM_APPROVAL',
        evidenceAr:
            'القرعة مؤجلة حتى اعتماد عقد الخوارزمية والتدقيق والاعتراضات وfreeze window.',
        blockerAr:
            'لا lottery_runs/lottery_entries production enablement في هذه الحزمة.',
      ),
      NosokV29AuthorizationItem(
        key: 'payment_production_enablement',
        labelAr: 'تفعيل الدفع الإنتاجي',
        status: 'pending',
        decision: 'PAYMENT_PRODUCTION_DEFERRED_BILLING_CONTRACT_REQUIRED',
        evidenceAr:
            'الدفع يمر عبر billing_system bridge ولا يخزن card/payment secrets في Flutter.',
        blockerAr: 'يلزم عقد دفع مستقل وUAT مالي قبل production.',
      ),
    ];

    const applySteps = <NosokV29StagingApplyStep>[
      NosokV29StagingApplyStep(
        order: 1,
        stepKey: 'read_only_gate',
        titleAr: 'تشغيل read-only gate',
        executionMode: 'READ_ONLY_ALLOWED',
        filePath: 'sql/27_nosok_v29_authorization_preflight_read_only.sql',
        allowed: true,
        requiredBeforeRunAr: 'يمكن تشغيله للتحقق فقط، ولا ينفذ DDL/DML.',
      ),
      NosokV29StagingApplyStep(
        order: 2,
        stepKey: 'owner_schema_staging_apply',
        titleAr: 'تطبيق nosok owner schema على staging',
        executionMode: 'GUARDED_NOT_APPLIED',
        filePath:
            'sql/guarded_not_applied/nosok_v29/01_nosok_owner_schema_staging_apply_GUARDED_NOT_RUN.sql',
        allowed: false,
        requiredBeforeRunAr:
            'يتطلب owner_authorization_id صريحًا، نسخة احتياطية، موافقة DBA، وقبول RLS/RPC/rollback matrices.',
      ),
      NosokV29StagingApplyStep(
        order: 3,
        stepKey: 'rls_rpc_negative_uat_preflight',
        titleAr: 'RLS/RPC/Negative UAT preflight',
        executionMode: 'READ_ONLY_AFTER_APPLY',
        filePath:
            'sql/guarded_not_applied/nosok_v29/02_nosok_v29_rls_rpc_negative_uat_preflight_READ_ONLY_AFTER_APPLY.sql',
        allowed: false,
        requiredBeforeRunAr:
            'يشغل بعد تطبيق staging فقط لإثبات RLS وسياسات المنع.',
      ),
      NosokV29StagingApplyStep(
        order: 4,
        stepKey: 'rollback_draft',
        titleAr: 'Rollback draft',
        executionMode: 'DRAFT_NOT_RUN',
        filePath:
            'sql/guarded_not_applied/nosok_v29/03_nosok_owner_schema_rollback_DRAFT_NOT_RUN.sql',
        allowed: false,
        requiredBeforeRunAr: 'لا يستخدم إلا في staging وبقرار rollback صريح.',
      ),
    ];

    const preflightRows = <NosokV29RlsRpcPreflightRow>[
      NosokV29RlsRpcPreflightRow(
          surfaceOrTable: 'nosok.campaigns',
          kind: 'RLS table',
          preflightRuleAr:
              'RLS enabled؛ public published read عبر view فقط؛ writes لصلاحيات manageNosokCampaigns.',
          status: 'planned-preflight'),
      NosokV29RlsRpcPreflightRow(
          surfaceOrTable: 'nosok.applications',
          kind: 'RLS table',
          preflightRuleAr:
              'submit/track عبر RPC محكوم؛ internal queue حسب role/scope؛ لا كشف بيانات حساسة.',
          status: 'planned-preflight'),
      NosokV29RlsRpcPreflightRow(
          surfaceOrTable: 'nosok.application_documents',
          kind: 'RLS table',
          preflightRuleAr:
              'metadata فقط؛ الملفات في Storage؛ منع enumeration للجمهور.',
          status: 'planned-preflight'),
      NosokV29RlsRpcPreflightRow(
          surfaceOrTable: 'nosok.eligibility_rules',
          kind: 'RLS table',
          preflightRuleAr:
              'published read عبر view؛ write لصلاحية legal/compliance.',
          status: 'planned-preflight'),
      NosokV29RlsRpcPreflightRow(
          surfaceOrTable: 'nosok.lgu_quotas',
          kind: 'RLS table',
          preflightRuleAr:
              'يقرأ LGU من core؛ لا quota truth خارج nosok؛ write مركزي/لجنة فقط.',
          status: 'planned-preflight'),
      NosokV29RlsRpcPreflightRow(
          surfaceOrTable: 'public.v_nosok_campaigns_public_v1',
          kind: 'public view',
          preflightRuleAr: 'public surface لاحقًا؛ لا public base table.',
          status: 'deferred-until-staging-apply'),
      NosokV29RlsRpcPreflightRow(
          surfaceOrTable: 'public.rpc_nosok_application_track_v1',
          kind: 'public RPC',
          preflightRuleAr: 'lookup محدود بالرمز ولا يعرض internal payload.',
          status: 'deferred-until-rpc-contract'),
    ];

    const negativeUatCases = <NosokV29NegativeUatCase>[
      NosokV29NegativeUatCase(
          caseKey: 'NEG_ANON_ADMIN',
          actor: 'anonymous',
          target: 'admin RPC / nosok internal tables',
          expectedResultAr: 'رفض كامل؛ لا قراءة داخلية ولا كتابة.',
          status: 'required-after-apply'),
      NosokV29NegativeUatCase(
          caseKey: 'NEG_PUBLIC_ENUM_DOCS',
          actor: 'anonymous/public applicant',
          target: 'application_documents',
          expectedResultAr:
              'منع enumeration للمرفقات، وعرض metadata محدود فقط لصاحب الطلب عبر مسار محكوم.',
          status: 'required-after-apply'),
      NosokV29NegativeUatCase(
          caseKey: 'NEG_WRONG_UNIT_QUEUE',
          actor: 'unit reviewer',
          target: 'طلبات LGU/وحدة أخرى',
          expectedResultAr: 'forbidden/scope denied ولا تظهر في queue.',
          status: 'required-after-apply'),
      NosokV29NegativeUatCase(
          caseKey: 'NEG_REVIEWER_RULE_WRITE',
          actor: 'reviewer',
          target: 'eligibility_rules / quota_rules',
          expectedResultAr: 'لا يستطيع تعديل الشروط أو الحصص.',
          status: 'required-after-apply'),
      NosokV29NegativeUatCase(
          caseKey: 'NEG_PUBLIC_TABLE_SCAN',
          actor: 'SQL reviewer',
          target: 'public base tables',
          expectedResultAr: 'لا يظهر أي public.nosok_* base table.',
          status: 'required-before-and-after-apply'),
      NosokV29NegativeUatCase(
          caseKey: 'NEG_WAQF_BOUNDARY',
          actor: 'SQL reviewer',
          target: 'waqf / waqf_assets / awqaf_system',
          expectedResultAr: 'لا DDL/DML ولا mutation في هذه schemas.',
          status: 'required-before-and-after-apply'),
    ];

    return const NosokV29AuthorizationPack(
      authorizationItems: authorizationItems,
      applySteps: applySteps,
      preflightRows: preflightRows,
      negativeUatCases: negativeUatCases,
      productionGateDecision: NosokV29ProductionGateDecision(
        decision: 'STAGING_APPLY_GATE_PREPARED_EXECUTION_NOT_PERFORMED',
        summaryAr:
            'تم استيعاب تفويض إعداد حزمة v29 وتجهيز بوابة تطبيق staging، لكن لم يتم تنفيذ DDL/DML بواسطة هذه الحزمة.',
        nextAllowedStepAr:
            'المسموح التالي: تشغيل read-only preflight، مراجعة ملفات guarded apply، ثم تنفيذ DBA/operator فقط إذا صدر owner_authorization_id صريح.',
        blockedAr:
            'محظور: CREATE TABLE public.*، الإنتاج، القرعة الفعلية، الدفع الإنتاجي، service_role من Flutter، وأي لمس لـ waqf/awqaf_system.',
      ),
    );
  }
}
