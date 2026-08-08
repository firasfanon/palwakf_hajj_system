class NosokV35ApplyResultItem {
  const NosokV35ApplyResultItem({
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
  bool get ready => status == 'ready';
  bool get pending => status == 'pending';
  bool get blocked => status == 'blocked';
}

class NosokV35WrapperRpcObject {
  const NosokV35WrapperRpcObject({
    required this.objectName,
    required this.objectType,
    required this.expectedPostApplyStatus,
    required this.dataBoundaryAr,
    required this.bindingDecisionAr,
  });

  final String objectName;
  final String objectType;
  final String expectedPostApplyStatus;
  final String dataBoundaryAr;
  final String bindingDecisionAr;

  bool get expectedPresent =>
      expectedPostApplyStatus == 'expected-present-after-apply';
}

class NosokV35RepositoryBindingPreflight {
  const NosokV35RepositoryBindingPreflight({
    required this.mode,
    required this.allowedBeforeWrapperApply,
    required this.allowedAfterWrapperEvidence,
    required this.requiredEvidenceAr,
  });

  final String mode;
  final bool allowedBeforeWrapperApply;
  final bool allowedAfterWrapperEvidence;
  final String requiredEvidenceAr;
}

class NosokV35UatCase {
  const NosokV35UatCase({
    required this.caseKey,
    required this.actorAr,
    required this.surfaceAr,
    required this.expectedAr,
    required this.status,
  });

  final String caseKey;
  final String actorAr;
  final String surfaceAr;
  final String expectedAr;
  final String status;

  bool get accepted => status == 'accepted';
  bool get pending => status == 'pending';
  bool get blocked => status == 'blocked';
}

class NosokV35GateDecision {
  const NosokV35GateDecision({
    required this.decision,
    required this.summaryAr,
    required this.nextSqlAr,
    required this.blockedAr,
  });

  final String decision;
  final String summaryAr;
  final String nextSqlAr;
  final String blockedAr;
}

class NosokV35WrapperApplyPack {
  const NosokV35WrapperApplyPack({
    required this.applyResultItems,
    required this.wrapperRpcObjects,
    required this.repositoryBindingPreflight,
    required this.uatCases,
    required this.gateDecision,
  });

  final List<NosokV35ApplyResultItem> applyResultItems;
  final List<NosokV35WrapperRpcObject> wrapperRpcObjects;
  final List<NosokV35RepositoryBindingPreflight> repositoryBindingPreflight;
  final List<NosokV35UatCase> uatCases;
  final NosokV35GateDecision gateDecision;

  int get acceptedCount =>
      applyResultItems.where((item) => item.accepted).length;
  int get readyCount => applyResultItems.where((item) => item.ready).length;
  int get pendingCount => uatCases.where((item) => item.pending).length;
  int get wrapperCount => wrapperRpcObjects.length;

  static NosokV35WrapperApplyPack baseline() {
    return const NosokV35WrapperApplyPack(
      applyResultItems: [
        NosokV35ApplyResultItem(
          key: 'operator_authorization_intent',
          titleAr: 'تفويض تشغيل wrapper/RPC على staging',
          status: 'accepted',
          evidenceAr:
              'تم قبول التفويض كمقصد تشغيل محكوم لأسطح public views/RPC فقط، دون public base tables.',
          decisionAr:
              'يجوز تشغيل SQL operator-ready على staging بعد تثبيت backup/restore reference.',
        ),
        NosokV35ApplyResultItem(
          key: 'pre_apply_read_only_evidence',
          titleAr: 'دليل ما قبل التطبيق v34.1',
          status: 'accepted',
          evidenceAr:
              'الجداول الثمانية داخل nosok.* موجودة، وRLS مفعّل، والـ wrappers غير موجودة قبل v35.',
          decisionAr: 'يؤهل ذلك لتطبيق public wrapper/RPC فقط.',
        ),
        NosokV35ApplyResultItem(
          key: 'controlled_wrapper_apply_result',
          titleAr: 'نتيجة تطبيق wrapper/RPC',
          status: 'pending',
          evidenceAr:
              'لم تُستلم بعد نتيجة تشغيل SQL v35 operator-ready ولا نتيجة post-apply read-only.',
          decisionAr:
              'يبقى repository binding محجوبًا حتى ظهور public wrappers/RPCs في SQL result.',
        ),
      ],
      wrapperRpcObjects: [
        NosokV35WrapperRpcObject(
          objectName: 'public.v_nosok_campaigns_public_v1',
          objectType: 'view',
          expectedPostApplyStatus: 'expected-present-after-apply',
          dataBoundaryAr:
              'عرض مواسم منشورة/مغلقة فقط دون بيانات إدارية أو payload داخلي.',
          bindingDecisionAr:
              'مصدر قراءة عام للواجهة العامة بعد post-apply evidence.',
        ),
        NosokV35WrapperRpcObject(
          objectName: 'public.rpc_nosok_campaigns_public_list_v1',
          objectType: 'stable rpc',
          expectedPostApplyStatus: 'expected-present-after-apply',
          dataBoundaryAr: 'قائمة مواسم عامة مرتبة دون direct table exposure.',
          bindingDecisionAr:
              'مرشح للـ public repository في standaloneSupabaseDevelopment.',
        ),
        NosokV35WrapperRpcObject(
          objectName: 'public.v_nosok_requirements_public_v1',
          objectType: 'view',
          expectedPostApplyStatus: 'expected-present-after-apply',
          dataBoundaryAr: 'شروط منشورة فقط مرتبطة بموسم منشور/مغلق.',
          bindingDecisionAr: 'مصدر requirements العام بعد evidence.',
        ),
        NosokV35WrapperRpcObject(
          objectName: 'public.rpc_nosok_requirements_public_list_v1',
          objectType: 'stable rpc',
          expectedPostApplyStatus: 'expected-present-after-apply',
          dataBoundaryAr:
              'RPC قراءة فقط لشروط عامة، مع optional campaign filter.',
          bindingDecisionAr: 'مرشح لصفحة المتطلبات العامة.',
        ),
        NosokV35WrapperRpcObject(
          objectName: 'public.rpc_nosok_application_submit_v1',
          objectType: 'security definer rpc',
          expectedPostApplyStatus: 'expected-present-after-apply',
          dataBoundaryAr:
              'إدخال طلب staging محكوم مع tracking code وworkflow/audit event.',
          bindingDecisionAr: 'لا يربط إنتاجيًا قبل privacy/browser/role UAT.',
        ),
        NosokV35WrapperRpcObject(
          objectName: 'public.rpc_nosok_application_track_v1',
          objectType: 'security definer rpc',
          expectedPostApplyStatus: 'expected-present-after-apply',
          dataBoundaryAr:
              'إرجاع حالة عامة فقط دون رقم هوية أو مرفقات أو audit payload.',
          bindingDecisionAr: 'مرشح لتتبع الطلب بعد tracking privacy evidence.',
        ),
      ],
      repositoryBindingPreflight: [
        NosokV35RepositoryBindingPreflight(
          mode: 'preview',
          allowedBeforeWrapperApply: true,
          allowedAfterWrapperEvidence: true,
          requiredEvidenceAr: 'لا يحتاج قاعدة بيانات؛ يبقى للعرض فقط.',
        ),
        NosokV35RepositoryBindingPreflight(
          mode: 'standaloneSupabaseDevelopment',
          allowedBeforeWrapperApply: false,
          allowedAfterWrapperEvidence: true,
          requiredEvidenceAr:
              'يتطلب post-apply SQL يثبت وجود wrappers/RPCs + grants + function search_path.',
        ),
        NosokV35RepositoryBindingPreflight(
          mode: 'platformHosted',
          allowedBeforeWrapperApply: false,
          allowedAfterWrapperEvidence: false,
          requiredEvidenceAr:
              'يتطلب Browser/Role/Scope evidence وقرار منصة مستقل قبل الإنتاج.',
        ),
      ],
      uatCases: [
        NosokV35UatCase(
          caseKey: 'anon_campaigns_rpc',
          actorAr: 'anonymous',
          surfaceAr: 'rpc_nosok_campaigns_public_list_v1',
          expectedAr: '200/empty-safe أو data-safe دون raw table payload.',
          status: 'pending',
        ),
        NosokV35UatCase(
          caseKey: 'anon_requirements_rpc',
          actorAr: 'anonymous',
          surfaceAr: 'rpc_nosok_requirements_public_list_v1',
          expectedAr: 'قراءة شروط منشورة فقط ودون direct nosok.* exposure.',
          status: 'pending',
        ),
        NosokV35UatCase(
          caseKey: 'public_submit_rpc',
          actorAr: 'anonymous/public applicant',
          surfaceAr: 'rpc_nosok_application_submit_v1',
          expectedAr:
              'إرجاع tracking_code على staging فقط أو fail-safe عند عدم وجود campaign مفتوح.',
          status: 'pending',
        ),
        NosokV35UatCase(
          caseKey: 'public_track_privacy_rpc',
          actorAr: 'anonymous/public applicant',
          surfaceAr: 'rpc_nosok_application_track_v1',
          expectedAr:
              'حالة عامة فقط، بلا بيانات حساسة أو وثائق أو audit payload.',
          status: 'pending',
        ),
      ],
      gateDecision: NosokV35GateDecision(
        decision: 'V35_WRAPPER_RPC_CONTROLLED_APPLY_AUTHORIZED_RESULT_PENDING',
        summaryAr:
            'تم قبول التفويض وتجهيز apply/result/UAT gate. التنفيذ الفعلي يتم في staging بواسطة operator، ثم يستخرج post-apply read-only evidence.',
        nextSqlAr:
            'شغل 01_public_wrapper_rpc_surface_AUTHORIZED_STAGING_ONLY.sql ثم 02_post_apply_wrapper_rpc_evidence_READ_ONLY.sql وأرسل النتائج كاملة.',
        blockedAr:
            'لا production approval، لا repository binding، لا public base tables، ولا أي تعديل على waqf/awqaf_system.',
      ),
    );
  }
}
