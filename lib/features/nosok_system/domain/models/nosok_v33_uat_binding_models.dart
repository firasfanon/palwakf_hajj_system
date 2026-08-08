class NosokV33NegativeUatCase {
  const NosokV33NegativeUatCase({
    required this.key,
    required this.scopeAr,
    required this.expectedAr,
    required this.evidenceStatus,
    required this.decisionAr,
  });

  final String key;
  final String scopeAr;
  final String expectedAr;
  final String evidenceStatus;
  final String decisionAr;

  bool get accepted => evidenceStatus == 'accepted';
  bool get pending => evidenceStatus == 'pending';
  bool get blocked => evidenceStatus == 'blocked';
}

class NosokV33WrapperDraft {
  const NosokV33WrapperDraft({
    required this.surfaceKey,
    required this.objectName,
    required this.surfaceType,
    required this.sourceAr,
    required this.status,
    required this.securityNotesAr,
  });

  final String surfaceKey;
  final String objectName;
  final String surfaceType;
  final String sourceAr;
  final String status;
  final String securityNotesAr;
}

class NosokV33RepositoryBindingGate {
  const NosokV33RepositoryBindingGate({
    required this.mode,
    required this.allowedNow,
    required this.bindingTargetAr,
    required this.requiredEvidenceAr,
  });

  final String mode;
  final bool allowedNow;
  final String bindingTargetAr;
  final String requiredEvidenceAr;
}

class NosokV33ProductionGateDecision {
  const NosokV33ProductionGateDecision({
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

class NosokV33UatBindingPack {
  const NosokV33UatBindingPack({
    required this.negativeUatCases,
    required this.wrapperDrafts,
    required this.repositoryBindingGates,
    required this.productionGate,
  });

  final List<NosokV33NegativeUatCase> negativeUatCases;
  final List<NosokV33WrapperDraft> wrapperDrafts;
  final List<NosokV33RepositoryBindingGate> repositoryBindingGates;
  final NosokV33ProductionGateDecision productionGate;

  int get acceptedCount =>
      negativeUatCases.where((item) => item.accepted).length;
  int get pendingCount => negativeUatCases.where((item) => item.pending).length;
  int get blockedCount => negativeUatCases.where((item) => item.blocked).length;
  int get wrapperDraftCount => wrapperDrafts.length;

  static NosokV33UatBindingPack baseline() {
    return const NosokV33UatBindingPack(
      negativeUatCases: [
        NosokV33NegativeUatCase(
          key: 'schema_and_tables',
          scopeAr: 'Post-apply schema census',
          expectedAr:
              'nosok schema موجودة، و8/8 owner tables موجودة كـ base tables.',
          evidenceStatus: 'accepted',
          decisionAr: 'تم قبول post-apply census كدليل تطبيق staging أولي.',
        ),
        NosokV33NegativeUatCase(
          key: 'rls_enabled',
          scopeAr: 'RLS on owner tables',
          expectedAr:
              'RLS مفعّل على campaigns/applications/application_documents/eligibility_rules/quota_rules/lgu_quotas/workflow_events/audit_events.',
          evidenceStatus: 'accepted',
          decisionAr:
              'تم قبول RLS presence، لكن force_rls=false ويحتاج قرار لاحق قبل الإنتاج.',
        ),
        NosokV33NegativeUatCase(
          key: 'anon_direct_denial_policy',
          scopeAr: 'Anonymous direct table access',
          expectedAr:
              'وجود سياسات anon ALL بعبارتي qual/with_check تمنع الوصول المباشر.',
          evidenceStatus: 'accepted',
          decisionAr:
              'تم قبول policy presence كدليل SQL سلبي أولي، مع بقاء الاختبار العملي عبر anon client مطلوبًا.',
        ),
        NosokV33NegativeUatCase(
          key: 'public_base_table_guard',
          scopeAr: 'Public schema guard',
          expectedAr:
              'لا توجد public_nosok/public_hajj/public_umrah base tables جديدة.',
          evidenceStatus: 'accepted',
          decisionAr: 'public يبقى wrapper/RPC surface فقط وليس owner schema.',
        ),
        NosokV33NegativeUatCase(
          key: 'authenticated_no_role',
          scopeAr: 'Authenticated user without Nosok role',
          expectedAr:
              'رفض إداري عربي عبر Platform Access Gateway، وليس raw auth error.',
          evidenceStatus: 'pending',
          decisionAr:
              'يتطلب Browser/role evidence بحساب مصادق لا يحمل صلاحيات نسك.',
        ),
        NosokV33NegativeUatCase(
          key: 'wrong_unit_scope',
          scopeAr: 'Wrong LGU/unit scope',
          expectedAr: 'مستخدم وحدة لا يرى طلبات/حصص وحدة أخرى.',
          evidenceStatus: 'pending',
          decisionAr:
              'يتطلب role/scope evidence بعد توفير بيانات اختبار أو RPCs نطاقية.',
        ),
        NosokV33NegativeUatCase(
          key: 'public_tracking_privacy',
          scopeAr: 'Public tracking privacy',
          expectedAr: 'public tracking لا يكشف payload داخلي أو بيانات حساسة.',
          evidenceStatus: 'pending',
          decisionAr: 'يتطلب wrapper/RPC draft ثم UAT بعد apply مستقل.',
        ),
      ],
      wrapperDrafts: [
        NosokV33WrapperDraft(
          surfaceKey: 'campaigns_public_list',
          objectName:
              'public.v_nosok_campaigns_public_v1 / public.rpc_nosok_campaigns_public_list_v1',
          surfaceType: 'view + rpc draft',
          sourceAr: 'nosok.campaigns مع أعمدة عامة فقط.',
          status: 'draft-not-applied',
          securityNotesAr:
              'قراءة عامة محدودة؛ لا تعرض إعدادات داخلية أو quotas تشغيلية.',
        ),
        NosokV33WrapperDraft(
          surfaceKey: 'application_submit',
          objectName: 'public.rpc_nosok_application_submit_v1',
          surfaceType: 'rpc draft',
          sourceAr:
              'nosok.applications + nosok.workflow_events + nosok.audit_events.',
          status: 'draft-not-applied',
          securityNotesAr:
              'يحتاج validation، idempotency، privacy envelope، وعدم استخدام service_role من Flutter.',
        ),
        NosokV33WrapperDraft(
          surfaceKey: 'application_tracking',
          objectName: 'public.rpc_nosok_application_track_v1',
          surfaceType: 'rpc draft',
          sourceAr: 'nosok.applications مع output عام محدود.',
          status: 'draft-not-applied',
          securityNotesAr: 'لا يعرض رقم هوية كامل أو مرفقات أو audit payload.',
        ),
        NosokV33WrapperDraft(
          surfaceKey: 'requirements_public',
          objectName:
              'public.v_nosok_requirements_public_v1 / public.rpc_nosok_requirements_public_list_v1',
          surfaceType: 'view + rpc draft',
          sourceAr:
              'nosok.eligibility_rules + nosok.quota_rules بقراءة عامة مضبوطة.',
          status: 'draft-not-applied',
          securityNotesAr:
              'يعرض نصوص المتطلبات فقط، ولا يفعّل قبولًا إنتاجيًا.',
        ),
      ],
      repositoryBindingGates: [
        NosokV33RepositoryBindingGate(
          mode: 'preview',
          allowedNow: true,
          bindingTargetAr: 'in-memory/demo data',
          requiredEvidenceAr: 'لا يتطلب DB؛ يبقى متاحًا للتصميم والواجهات.',
        ),
        NosokV33RepositoryBindingGate(
          mode: 'standaloneSupabaseDevelopment',
          allowedNow: false,
          bindingTargetAr: 'public RPC wrappers فقط، وليس direct table writes.',
          requiredEvidenceAr:
              'تطبيق wrapper/RPC مستقل + negative UAT + anon/auth/browser evidence.',
        ),
        NosokV33RepositoryBindingGate(
          mode: 'platformHosted',
          allowedNow: false,
          bindingTargetAr: 'Platform Access Gateway + RBAC + scoped RPCs.',
          requiredEvidenceAr:
              'اعتماد role/scope/browser evidence، وتوثيق gateway adoption، وproduction gate مستقل.',
        ),
      ],
      productionGate: NosokV33ProductionGateDecision(
        decision:
            'V33_POST_APPLY_RLS_PRESENT_PUBLIC_WRAPPER_DRAFT_PREPARED_REPOSITORY_BINDING_BLOCKED_PENDING_UAT',
        summaryAr:
            'تم قبول وجود nosok.* وRLS وسياسات anon deny وعدم إنشاء public base tables. بقيت أدلة browser/role/scope وwrapper apply غير منفذة، لذلك الإنتاج والربط التشغيلي محجوبان.',
        allowedNextStepAr:
            'تشغيل SQL 31 read-only، ثم مراجعة draft wrappers، ثم طلب تفويض v34 لتطبيق public wrappers/RPCs على staging فقط.',
        blockedAr:
            'الإنتاج، direct Flutter table writes إلى nosok.*، public base tables، تشغيل القرعة، أو الدفع الإنتاجي.',
      ),
    );
  }
}
