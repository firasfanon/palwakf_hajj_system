class NosokV30AuthorizationTokenItem {
  const NosokV30AuthorizationTokenItem({
    required this.key,
    required this.labelAr,
    required this.value,
    required this.status,
    required this.decision,
    required this.evidenceAr,
  });

  final String key;
  final String labelAr;
  final String value;
  final String status;
  final String decision;
  final String evidenceAr;

  bool get accepted => status == 'accepted';
  bool get blocked => status == 'blocked';
  bool get pending => status == 'pending';
}

class NosokV30ApplyResultItem {
  const NosokV30ApplyResultItem({
    required this.key,
    required this.labelAr,
    required this.expectedAr,
    required this.actualAr,
    required this.status,
  });

  final String key;
  final String labelAr;
  final String expectedAr;
  final String actualAr;
  final String status;

  bool get accepted => status == 'accepted';
  bool get blocked => status == 'blocked';
  bool get pending => status == 'pending';
}

class NosokV30NegativeUatExecutionCase {
  const NosokV30NegativeUatExecutionCase({
    required this.caseKey,
    required this.actor,
    required this.target,
    required this.expectedResultAr,
    required this.executionStatus,
    required this.gateDecision,
  });

  final String caseKey;
  final String actor;
  final String target;
  final String expectedResultAr;
  final String executionStatus;
  final String gateDecision;
}

class NosokV30RpcRlsSurfaceGate {
  const NosokV30RpcRlsSurfaceGate({
    required this.surface,
    required this.surfaceType,
    required this.requiredEvidenceAr,
    required this.status,
  });

  final String surface;
  final String surfaceType;
  final String requiredEvidenceAr;
  final String status;
}

class NosokV30Decision {
  const NosokV30Decision({
    required this.decision,
    required this.summaryAr,
    required this.nextAllowedStepAr,
    required this.blockedAr,
  });

  final String decision;
  final String summaryAr;
  final String nextAllowedStepAr;
  final String blockedAr;
}

class NosokV30ApplyGatePack {
  const NosokV30ApplyGatePack({
    required this.authorizationTokens,
    required this.applyResults,
    required this.rlsRpcSurfaces,
    required this.negativeUatCases,
    required this.decision,
  });

  final List<NosokV30AuthorizationTokenItem> authorizationTokens;
  final List<NosokV30ApplyResultItem> applyResults;
  final List<NosokV30RpcRlsSurfaceGate> rlsRpcSurfaces;
  final List<NosokV30NegativeUatExecutionCase> negativeUatCases;
  final NosokV30Decision decision;

  int get acceptedTokenCount =>
      authorizationTokens.where((item) => item.accepted).length;
  int get blockedTokenCount =>
      authorizationTokens.where((item) => item.blocked).length;
  int get pendingApplyResultCount =>
      applyResults.where((item) => item.pending).length;
  int get blockedUatCaseCount => negativeUatCases
      .where((item) => item.executionStatus == 'blocked-until-staging-apply')
      .length;

  static NosokV30ApplyGatePack baseline() {
    const authorizationTokens = <NosokV30AuthorizationTokenItem>[
      NosokV30AuthorizationTokenItem(
        key: 'v30_request_intake',
        labelAr: 'طلب v30',
        value: 'Nosok v30 requested',
        status: 'accepted',
        decision: 'V30_PACK_REQUEST_ACCEPTED',
        evidenceAr:
            'تم طلب حزمة v30 لاستيعاب التفويض ونتيجة تطبيق DDL ونتائج RLS/RPC/Negative UAT.',
      ),
      NosokV30AuthorizationTokenItem(
        key: 'owner_authorization_id',
        labelAr: 'owner_authorization_id',
        value: 'not supplied',
        status: 'blocked',
        decision: 'OWNER_AUTHORIZATION_ID_REQUIRED_BEFORE_APPLY',
        evidenceAr:
            'لم يتم تزويد معرف تفويض مالك schema أو سجل موافقة DBA/Operator. لذلك لا يسمح بتشغيل guarded DDL.',
      ),
      NosokV30AuthorizationTokenItem(
        key: 'staging_confirmation',
        labelAr: 'تأكيد staging',
        value: 'not supplied',
        status: 'blocked',
        decision: 'STAGING_TARGET_CONFIRMATION_REQUIRED',
        evidenceAr:
            'يجب إثبات أن التشغيل سيكون على staging فقط وليس production.',
      ),
      NosokV30AuthorizationTokenItem(
        key: 'backup_confirmation',
        labelAr: 'تأكيد النسخة الاحتياطية',
        value: 'not supplied',
        status: 'blocked',
        decision: 'BACKUP_CONFIRMATION_REQUIRED',
        evidenceAr: 'يجب توثيق نسخة احتياطية أو snapshot قبل أي DDL.',
      ),
      NosokV30AuthorizationTokenItem(
        key: 'v29_preflight',
        labelAr: 'نتيجة v29 preflight',
        value: 'passed read-only',
        status: 'accepted',
        decision: 'AUTHORIZATION_PREFLIGHT_READ_ONLY_ACCEPTED',
        evidenceAr:
            'نتيجة v29 أظهرت nosok_present=false وcandidate_conflicts=[] وDDL/DML false وpublic base table creation blocked.',
      ),
    ];

    const applyResults = <NosokV30ApplyResultItem>[
      NosokV30ApplyResultItem(
        key: 'create_schema_nosok',
        labelAr: 'إنشاء nosok schema',
        expectedAr: 'CREATE SCHEMA nosok على staging بعد التفويض فقط.',
        actualAr: 'لم تُقدّم نتيجة apply؛ الجرد ما زال nosok_present=false.',
        status: 'pending',
      ),
      NosokV30ApplyResultItem(
        key: 'create_owner_tables',
        labelAr: 'إنشاء جداول nosok.*',
        expectedAr: 'إنشاء الجداول المرشحة داخل nosok.* فقط؛ لا public.*.',
        actualAr: 'لم تُقدّم نتيجة تشغيل DDL؛ لا جدول جديد مثبت في هذه الحزمة.',
        status: 'pending',
      ),
      NosokV30ApplyResultItem(
        key: 'rls_enablement',
        labelAr: 'تفعيل RLS',
        expectedAr: 'RLS enabled لكل جدول owner بعد apply.',
        actualAr: 'غير قابل للتحقق قبل إنشاء schema والجداول.',
        status: 'pending',
      ),
      NosokV30ApplyResultItem(
        key: 'public_wrapper_absence',
        labelAr: 'منع public base tables',
        expectedAr: 'لا CREATE TABLE public.* إطلاقًا.',
        actualAr:
            'مقبول حتى الآن حسب v29 preflight؛ public base table creation blocked.',
        status: 'accepted',
      ),
      NosokV30ApplyResultItem(
        key: 'waqf_boundary',
        labelAr: 'حدود waqf/awqaf_system',
        expectedAr: 'لا DDL/DML على waqf أو waqf_assets أو awqaf_system.',
        actualAr: 'محفوظ؛ حزمة v30 لا تنفذ SQL إنتاجي ولا mutation.',
        status: 'accepted',
      ),
    ];

    const rlsRpcSurfaces = <NosokV30RpcRlsSurfaceGate>[
      NosokV30RpcRlsSurfaceGate(
          surface: 'nosok.campaigns',
          surfaceType: 'owner table',
          requiredEvidenceAr:
              'RLS enabled + policies للقراءة العامة عبر wrapper فقط وللإدارة بصلاحيات نسك.',
          status: 'blocked-until-apply'),
      NosokV30RpcRlsSurfaceGate(
          surface: 'nosok.applications',
          surfaceType: 'owner table',
          requiredEvidenceAr:
              'سياسات مقدم الطلب والموظف/الوحدة ومنع wrong-unit.',
          status: 'blocked-until-apply'),
      NosokV30RpcRlsSurfaceGate(
          surface: 'nosok.application_documents',
          surfaceType: 'owner table',
          requiredEvidenceAr:
              'metadata فقط؛ منع enumeration؛ Storage هو مالك الملفات.',
          status: 'blocked-until-apply'),
      NosokV30RpcRlsSurfaceGate(
          surface: 'nosok.eligibility_rules',
          surfaceType: 'owner table',
          requiredEvidenceAr:
              'write محصور بإدارة الحوكمة/القانون؛ read public عبر view منشور فقط.',
          status: 'blocked-until-apply'),
      NosokV30RpcRlsSurfaceGate(
          surface: 'public.v_nosok_campaigns_public_v1',
          surfaceType: 'public view',
          requiredEvidenceAr: 'view فقط لا base table؛ لا تعرض بيانات داخلية.',
          status: 'deferred-until-wrapper-apply'),
      NosokV30RpcRlsSurfaceGate(
          surface: 'public.rpc_nosok_application_track_v1',
          surfaceType: 'public RPC',
          requiredEvidenceAr:
              'RPC تتبع محدود بالرمز، لا raw payload ولا كشف بيانات حساسة.',
          status: 'deferred-until-rpc-apply'),
    ];

    const negativeUatCases = <NosokV30NegativeUatExecutionCase>[
      NosokV30NegativeUatExecutionCase(
          caseKey: 'NEG_SQL_PUBLIC_TABLE',
          actor: 'SQL reviewer',
          target: 'public.nosok_* base tables',
          expectedResultAr: 'لا تظهر أي جداول public جديدة.',
          executionStatus: 'pending-proof-after-apply',
          gateDecision: 'must-pass'),
      NosokV30NegativeUatExecutionCase(
          caseKey: 'NEG_ANON_ADMIN_RPC',
          actor: 'anonymous',
          target: 'admin RPC/internal tables',
          expectedResultAr: 'رفض كامل بلا تسريب payload.',
          executionStatus: 'blocked-until-staging-apply',
          gateDecision: 'must-pass'),
      NosokV30NegativeUatExecutionCase(
          caseKey: 'NEG_WRONG_UNIT',
          actor: 'unit reviewer',
          target: 'طلبات وحدة/LGU أخرى',
          expectedResultAr: 'forbidden/scope denied.',
          executionStatus: 'blocked-until-staging-apply',
          gateDecision: 'must-pass'),
      NosokV30NegativeUatExecutionCase(
          caseKey: 'NEG_REVIEWER_POLICY_WRITE',
          actor: 'reviewer',
          target: 'eligibility/quota rules',
          expectedResultAr: 'write denied.',
          executionStatus: 'blocked-until-staging-apply',
          gateDecision: 'must-pass'),
      NosokV30NegativeUatExecutionCase(
          caseKey: 'NEG_PUBLIC_DOC_ENUM',
          actor: 'public applicant',
          target: 'application_documents enumeration',
          expectedResultAr: 'deny enumeration; scoped owner-only tracking.',
          executionStatus: 'blocked-until-staging-apply',
          gateDecision: 'must-pass'),
      NosokV30NegativeUatExecutionCase(
          caseKey: 'NEG_WAQF_MUTATION',
          actor: 'SQL reviewer',
          target: 'waqf/waqf_assets/awqaf_system',
          expectedResultAr: 'لا DDL/DML ولا mutation.',
          executionStatus: 'accepted-boundary-static',
          gateDecision: 'must-remain-true'),
    ];

    return const NosokV30ApplyGatePack(
      authorizationTokens: authorizationTokens,
      applyResults: applyResults,
      rlsRpcSurfaces: rlsRpcSurfaces,
      negativeUatCases: negativeUatCases,
      decision: NosokV30Decision(
        decision:
            'V30_CONTROLLED_APPLY_RESULT_INTAKE_PREPARED_APPLY_NOT_AUTHORIZED',
        summaryAr:
            'تم تجهيز استيعاب تفويض التشغيل ونتيجة DDL وUAT، لكن لا يوجد owner_authorization_id ولا نتيجة تطبيق DDL؛ لذلك يبقى apply محجوبًا.',
        nextAllowedStepAr:
            'المسموح التالي: تزويد owner_authorization_id + staging target + backup evidence، أو تشغيل read-only v30 result gate فقط.',
        blockedAr:
            'محظور الآن: تشغيل guarded DDL، إنشاء nosok schema، إنشاء nosok tables، أي public base table، الإنتاج، أو أي لمس لـ waqf/awqaf_system.',
      ),
    );
  }
}
