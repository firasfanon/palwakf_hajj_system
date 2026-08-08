class NosokV31AuthorizationEvidenceItem {
  const NosokV31AuthorizationEvidenceItem({
    required this.key,
    required this.labelAr,
    required this.evidenceValue,
    required this.status,
    required this.decision,
    required this.notesAr,
  });

  final String key;
  final String labelAr;
  final String evidenceValue;
  final String status;
  final String decision;
  final String notesAr;

  bool get accepted => status == 'accepted';
  bool get pending => status == 'pending';
  bool get blocked => status == 'blocked';
}

class NosokV31ApplyCertificationItem {
  const NosokV31ApplyCertificationItem({
    required this.key,
    required this.labelAr,
    required this.expectedAr,
    required this.observedAr,
    required this.status,
    required this.requiredEvidenceAr,
  });

  final String key;
  final String labelAr;
  final String expectedAr;
  final String observedAr;
  final String status;
  final String requiredEvidenceAr;

  bool get accepted => status == 'accepted';
  bool get pending => status == 'pending';
  bool get blocked => status == 'blocked';
}

class NosokV31PostApplyUatCase {
  const NosokV31PostApplyUatCase({
    required this.caseKey,
    required this.actorAr,
    required this.surface,
    required this.expectedResultAr,
    required this.currentStatus,
    required this.closureGateAr,
  });

  final String caseKey;
  final String actorAr;
  final String surface;
  final String expectedResultAr;
  final String currentStatus;
  final String closureGateAr;
}

class NosokV31RlsRpcClosureSurface {
  const NosokV31RlsRpcClosureSurface({
    required this.surface,
    required this.surfaceType,
    required this.requiredAfterApplyAr,
    required this.status,
  });

  final String surface;
  final String surfaceType;
  final String requiredAfterApplyAr;
  final String status;
}

class NosokV31Decision {
  const NosokV31Decision({
    required this.decision,
    required this.summaryAr,
    required this.allowedNextStepAr,
    required this.blockedAr,
  });

  final String decision;
  final String summaryAr;
  final String allowedNextStepAr;
  final String blockedAr;
}

class NosokV31ApplyCertificationPack {
  const NosokV31ApplyCertificationPack({
    required this.authorizationEvidence,
    required this.applyCertification,
    required this.rlsRpcSurfaces,
    required this.negativeUatCases,
    required this.decision,
  });

  final List<NosokV31AuthorizationEvidenceItem> authorizationEvidence;
  final List<NosokV31ApplyCertificationItem> applyCertification;
  final List<NosokV31RlsRpcClosureSurface> rlsRpcSurfaces;
  final List<NosokV31PostApplyUatCase> negativeUatCases;
  final NosokV31Decision decision;

  int get acceptedAuthorizationEvidenceCount =>
      authorizationEvidence.where((item) => item.accepted).length;
  int get pendingAuthorizationEvidenceCount => authorizationEvidence
      .where((item) => item.pending || item.blocked)
      .length;
  int get certifiedApplyCount =>
      applyCertification.where((item) => item.accepted).length;
  int get pendingApplyCertificationCount =>
      applyCertification.where((item) => item.pending || item.blocked).length;
  int get blockedNegativeUatCount => negativeUatCases
      .where((item) => item.currentStatus.contains('blocked'))
      .length;

  static NosokV31ApplyCertificationPack baseline() {
    const authorizationEvidence = <NosokV31AuthorizationEvidenceItem>[
      NosokV31AuthorizationEvidenceItem(
        key: 'user_message_authorization',
        labelAr: 'تفويض المستخدم للدفعة v31',
        evidenceValue:
            'افوض Nosok v31 — Owner Authorization Token Evidence Intake + Controlled Staging DDL Apply Result Certification + Post-Apply RLS/RPC Negative UAT Closure',
        status: 'accepted',
        decision: 'USER_AUTHORIZATION_INTENT_ACCEPTED_FOR_V31_GATE_PACK',
        notesAr:
            'تم قبول التفويض كطلب تجهيز بوابة v31 واستيعاب token evidence، وليس كإثبات أن DDL نُفذ داخل قاعدة البيانات.',
      ),
      NosokV31AuthorizationEvidenceItem(
        key: 'owner_authorization_id',
        labelAr: 'owner_authorization_id',
        evidenceValue:
            'CHAT_AUTHORIZATION_NOSOK_V31_2026_06_04_PENDING_OPERATOR_BINDING',
        status: 'accepted',
        decision:
            'OWNER_AUTHORIZATION_INTENT_RECORDED_OPERATOR_BINDING_REQUIRED',
        notesAr:
            'تم اشتقاق معرف تفويض عملي من رسالة المستخدم، ويجب ربطه في جلسة DBA/operator عند تشغيل ملف SQL المحروس على staging فقط.',
      ),
      NosokV31AuthorizationEvidenceItem(
        key: 'staging_target_confirmation',
        labelAr: 'تأكيد بيئة staging',
        evidenceValue: 'not supplied as database-session evidence',
        status: 'pending',
        decision:
            'STAGING_DATABASE_SESSION_CONFIRMATION_REQUIRED_BEFORE_EXECUTION',
        notesAr:
            'يجب على المشغل إثبات أن الاتصال الحالي ليس production قبل تشغيل أي DDL.',
      ),
      NosokV31AuthorizationEvidenceItem(
        key: 'backup_confirmation',
        labelAr: 'تأكيد النسخة الاحتياطية',
        evidenceValue: 'not supplied',
        status: 'blocked',
        decision: 'BACKUP_OR_RESTORE_POINT_REQUIRED_BEFORE_DDL',
        notesAr:
            'لا يتم تشغيل controlled DDL apply دون مرجع backup/snapshot قابل للتحقق.',
      ),
      NosokV31AuthorizationEvidenceItem(
        key: 'v30_read_only_result',
        labelAr: 'نتيجة v30 read-only',
        evidenceValue:
            'NOSOK_SCHEMA_NOT_DETECTED_APPLY_RESULT_PENDING / nosok_present=false / public base table creation blocked',
        status: 'accepted',
        decision: 'V30_READ_ONLY_RESULT_ACCEPTED',
        notesAr:
            'الجرد السابق يثبت أن apply لم يحدث بعد وأن schema نسك غير موجودة قبل v31.',
      ),
    ];

    const applyCertification = <NosokV31ApplyCertificationItem>[
      NosokV31ApplyCertificationItem(
        key: 'controlled_apply_execution',
        labelAr: 'تنفيذ controlled staging DDL',
        expectedAr:
            'تشغيل ملف v31 operator-only داخل staging بعد إدخال authorization/backup/session evidence.',
        observedAr: 'لم تُرفق نتيجة تشغيل DDL بعد؛ هذه الحزمة لا تنفذ SQL.',
        status: 'pending',
        requiredEvidenceAr:
            'SQL output كامل يظهر CREATE SCHEMA/CREATE TABLE/RLS enablement أو rollback، مع decision row نهائي.',
      ),
      NosokV31ApplyCertificationItem(
        key: 'schema_nosok_detected',
        labelAr: 'ظهور nosok schema',
        expectedAr: 'nosok_present=true بعد apply فقط.',
        observedAr: 'آخر نتيجة v30: nosok_present=false.',
        status: 'pending',
        requiredEvidenceAr:
            'تشغيل post-apply read-only UAT وإرسال 01_schema_presence.',
      ),
      NosokV31ApplyCertificationItem(
        key: 'owner_tables_detected',
        labelAr: 'ظهور جداول nosok.* المعتمدة',
        expectedAr:
            'campaigns/applications/application_documents/eligibility_rules/quota_rules/lgu_quotas/workflow_events/audit_events كـ base tables داخل nosok فقط.',
        observedAr: 'غير مثبت بعد؛ لا توجد نتيجة apply.',
        status: 'pending',
        requiredEvidenceAr:
            'post-apply object status + table ownership matrix.',
      ),
      NosokV31ApplyCertificationItem(
        key: 'public_base_table_guard',
        labelAr: 'منع public base tables',
        expectedAr:
            'لا تظهر أي جداول public.nosok_* أو public.hajj_* أو public.umrah_*.',
        observedAr: 'مقبول قبل apply؛ يجب إعادة إثباته بعد apply.',
        status: 'accepted',
        requiredEvidenceAr:
            'new_public_nosok_base_tables_detected=false بعد apply.',
      ),
      NosokV31ApplyCertificationItem(
        key: 'waqf_boundary',
        labelAr: 'حدود waqf/awqaf_system',
        expectedAr: 'لا DDL/DML على waqf أو waqf_assets أو awqaf_system.',
        observedAr: 'محفوظ داخل حزمة v31؛ لا يوجد سكربت يمس تلك schemas.',
        status: 'accepted',
        requiredEvidenceAr: 'sovereign boundary proof يبقى true بعد أي تشغيل.',
      ),
    ];

    const rlsRpcSurfaces = <NosokV31RlsRpcClosureSurface>[
      NosokV31RlsRpcClosureSurface(
          surface: 'nosok.campaigns',
          surfaceType: 'owner table',
          requiredAfterApplyAr:
              'RLS enabled + admin scoped policies + public read عبر wrapper فقط.',
          status: 'blocked-until-controlled-apply'),
      NosokV31RlsRpcClosureSurface(
          surface: 'nosok.applications',
          surfaceType: 'owner table',
          requiredAfterApplyAr:
              'RLS يمنع anonymous/adminless/wrong-unit ويتيح applicant tracking محدودًا.',
          status: 'blocked-until-controlled-apply'),
      NosokV31RlsRpcClosureSurface(
          surface: 'nosok.application_documents',
          surfaceType: 'owner table',
          requiredAfterApplyAr:
              'RLS يمنع enumeration؛ metadata فقط؛ الملفات في storage.',
          status: 'blocked-until-controlled-apply'),
      NosokV31RlsRpcClosureSurface(
          surface: 'nosok.workflow_events',
          surfaceType: 'append-only audit/workflow table',
          requiredAfterApplyAr:
              'append/read policies محكومة؛ لا update/delete عام.',
          status: 'blocked-until-controlled-apply'),
      NosokV31RlsRpcClosureSurface(
          surface: 'nosok.audit_events',
          surfaceType: 'internal audit table',
          requiredAfterApplyAr:
              'read restricted؛ write عبر RPC/audit helper فقط بعد مراجعة مستقلة.',
          status: 'blocked-until-controlled-apply'),
      NosokV31RlsRpcClosureSurface(
          surface: 'public.v_nosok_campaigns_public_v1',
          surfaceType: 'future public view',
          requiredAfterApplyAr:
              'view/RPC فقط عند الحاجة، لا public base table.',
          status: 'deferred-wrapper-not-applied'),
      NosokV31RlsRpcClosureSurface(
          surface: 'public.rpc_nosok_application_track_v1',
          surfaceType: 'future public RPC',
          requiredAfterApplyAr: 'tracking آمن بالرمز دون كشف raw payload.',
          status: 'deferred-rpc-not-applied'),
    ];

    const negativeUatCases = <NosokV31PostApplyUatCase>[
      NosokV31PostApplyUatCase(
          caseKey: 'NEG_ANONYMOUS_OWNER_TABLE_READ',
          actorAr: 'anonymous',
          surface: 'nosok.applications',
          expectedResultAr: 'رفض مباشر عبر RLS/RPC gate.',
          currentStatus: 'blocked-until-controlled-apply',
          closureGateAr: 'must-pass-after-apply'),
      NosokV31PostApplyUatCase(
          caseKey: 'NEG_AUTH_NO_NOSOK_ROLE',
          actorAr: 'authenticated بدون دور نسك',
          surface: 'admin RPC/views',
          expectedResultAr: 'forbidden عربي / لا raw payload.',
          currentStatus: 'blocked-until-controlled-apply',
          closureGateAr: 'must-pass-after-apply'),
      NosokV31PostApplyUatCase(
          caseKey: 'NEG_WRONG_UNIT_SCOPE',
          actorAr: 'موظف وحدة خارج النطاق',
          surface: 'nosok.applications',
          expectedResultAr: 'scope denied.',
          currentStatus: 'blocked-until-controlled-apply',
          closureGateAr: 'must-pass-after-apply'),
      NosokV31PostApplyUatCase(
          caseKey: 'NEG_PUBLIC_DOCUMENT_ENUMERATION',
          actorAr: 'public applicant',
          surface: 'nosok.application_documents',
          expectedResultAr: 'منع enumeration وتسريب storage paths.',
          currentStatus: 'blocked-until-controlled-apply',
          closureGateAr: 'must-pass-after-apply'),
      NosokV31PostApplyUatCase(
          caseKey: 'NEG_REVIEWER_POLICY_WRITE',
          actorAr: 'reviewer',
          surface: 'nosok.eligibility_rules / nosok.quota_rules',
          expectedResultAr: 'write denied إلا لصلاحية حوكمة معتمدة.',
          currentStatus: 'blocked-until-controlled-apply',
          closureGateAr: 'must-pass-after-apply'),
      NosokV31PostApplyUatCase(
          caseKey: 'NEG_PUBLIC_TABLE_CREATION_SCAN',
          actorAr: 'SQL reviewer',
          surface: 'public.*',
          expectedResultAr: 'لا public base tables جديدة.',
          currentStatus: 'pending-post-apply-proof',
          closureGateAr: 'must-pass-after-apply'),
    ];

    return const NosokV31ApplyCertificationPack(
      authorizationEvidence: authorizationEvidence,
      applyCertification: applyCertification,
      rlsRpcSurfaces: rlsRpcSurfaces,
      negativeUatCases: negativeUatCases,
      decision: NosokV31Decision(
        decision:
            'V31_OWNER_AUTHORIZATION_TOKEN_EVIDENCE_INTAKE_PREPARED_APPLY_NOT_CERTIFIED',
        summaryAr:
            'تم قبول تفويض المستخدم كدليل نية للانتقال إلى v31، وتجهيز بوابة token evidence وcertification وpost-apply UAT. لم يتم تنفيذ DDL داخل هذه الحزمة، ولا يتم اعتماد apply دون output من قاعدة البيانات.',
        allowedNextStepAr:
            'المسموح التالي: تشغيل ملف read-only v31، ثم إن توفرت staging session + backup + operator binding يمكن تشغيل controlled operator SQL خارج Flutter وإرسال ناتجه.',
        blockedAr:
            'محظور: اعتبار schema منشأة دون نتيجة SQL، تشغيل production، إنشاء public base tables، لمس waqf/waqf_assets/awqaf_system، أو إغلاق RLS/RPC/Negative UAT قبل post-apply evidence.',
      ),
    );
  }
}
