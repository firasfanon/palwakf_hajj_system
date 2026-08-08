class NosokV34AuthorizationItem {
  const NosokV34AuthorizationItem({
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
  bool get prepared => status == 'prepared';
}

class NosokV34WrapperRpcSurface {
  const NosokV34WrapperRpcSurface({
    required this.key,
    required this.objectName,
    required this.surfaceType,
    required this.allowedRoleAr,
    required this.dataBoundaryAr,
    required this.applyStatus,
  });

  final String key;
  final String objectName;
  final String surfaceType;
  final String allowedRoleAr;
  final String dataBoundaryAr;
  final String applyStatus;

  bool get applied => applyStatus == 'applied';
  bool get guarded => applyStatus.contains('guarded');
}

class NosokV34BrowserRoleEvidenceCase {
  const NosokV34BrowserRoleEvidenceCase({
    required this.key,
    required this.actorAr,
    required this.routeAr,
    required this.expectedAr,
    required this.status,
  });

  final String key;
  final String actorAr;
  final String routeAr;
  final String expectedAr;
  final String status;

  bool get accepted => status == 'accepted';
  bool get pending => status == 'pending';
  bool get blocked => status == 'blocked';
}

class NosokV34RepositoryBindingDecision {
  const NosokV34RepositoryBindingDecision({
    required this.mode,
    required this.allowedNow,
    required this.boundaryAr,
    required this.nextEvidenceAr,
  });

  final String mode;
  final bool allowedNow;
  final String boundaryAr;
  final String nextEvidenceAr;
}

class NosokV34GateDecision {
  const NosokV34GateDecision({
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

class NosokV34WrapperAuthorizationPack {
  const NosokV34WrapperAuthorizationPack({
    required this.authorizationItems,
    required this.wrapperRpcSurfaces,
    required this.browserRoleEvidenceCases,
    required this.repositoryBindingDecisions,
    required this.gateDecision,
  });

  final List<NosokV34AuthorizationItem> authorizationItems;
  final List<NosokV34WrapperRpcSurface> wrapperRpcSurfaces;
  final List<NosokV34BrowserRoleEvidenceCase> browserRoleEvidenceCases;
  final List<NosokV34RepositoryBindingDecision> repositoryBindingDecisions;
  final NosokV34GateDecision gateDecision;

  int get acceptedCount =>
      authorizationItems.where((item) => item.accepted).length;
  int get preparedCount =>
      authorizationItems.where((item) => item.prepared).length;
  int get pendingEvidenceCount =>
      browserRoleEvidenceCases.where((item) => item.pending).length;
  int get wrapperCount => wrapperRpcSurfaces.length;

  static NosokV34WrapperAuthorizationPack baseline() {
    return const NosokV34WrapperAuthorizationPack(
      authorizationItems: [
        NosokV34AuthorizationItem(
          key: 'post_apply_sql_evidence',
          titleAr: 'دليل SQL بعد إنشاء nosok.*',
          status: 'accepted',
          evidenceAr:
              'nosok schema موجودة، والجداول الثمانية موجودة، وRLS مفعّل، ولا توجد public base tables جديدة.',
          decisionAr:
              'قبول دليل SQL كأساس لتجهيز public wrappers/RPCs على staging فقط.',
        ),
        NosokV34AuthorizationItem(
          key: 'public_wrapper_authorization',
          titleAr: 'تفويض public wrapper/RPC staging',
          status: 'prepared',
          evidenceAr:
              'تم تجهيز SQL محروس لإنشاء views/RPCs داخل public دون إنشاء base tables.',
          decisionAr:
              'التنفيذ محجوب حتى إزالة guard بواسطة operator في staging فقط.',
        ),
        NosokV34AuthorizationItem(
          key: 'repository_binding',
          titleAr: 'ربط Repository',
          status: 'blocked',
          evidenceAr:
              'لا يوجد post-wrapper apply evidence ولا Browser/Role evidence حتى الآن.',
          decisionAr:
              'يبقى Flutter على preview/diagnostic binding حتى اعتماد wrappers وUAT.',
        ),
      ],
      wrapperRpcSurfaces: [
        NosokV34WrapperRpcSurface(
          key: 'campaigns_public_list',
          objectName:
              'public.v_nosok_campaigns_public_v1 + public.rpc_nosok_campaigns_public_list_v1',
          surfaceType: 'view + stable rpc',
          allowedRoleAr: 'anon/authenticated execute/select محدود',
          dataBoundaryAr:
              'حقول عامة فقط: campaign code/title/type/year/open-close/status.',
          applyStatus: 'guarded-not-applied',
        ),
        NosokV34WrapperRpcSurface(
          key: 'requirements_public_list',
          objectName:
              'public.v_nosok_requirements_public_v1 + public.rpc_nosok_requirements_public_list_v1',
          surfaceType: 'view + stable rpc',
          allowedRoleAr: 'anon/authenticated execute/select محدود',
          dataBoundaryAr:
              'شروط منشورة فقط من eligibility/quota rules دون payload إداري.',
          applyStatus: 'guarded-not-applied',
        ),
        NosokV34WrapperRpcSurface(
          key: 'application_submit',
          objectName: 'public.rpc_nosok_application_submit_v1',
          surfaceType: 'security definer rpc',
          allowedRoleAr: 'anon/authenticated execute بعد staging apply فقط',
          dataBoundaryAr:
              'إدخال طلب محكوم، توليد tracking code، وتسجيل workflow/audit event.',
          applyStatus: 'guarded-not-applied',
        ),
        NosokV34WrapperRpcSurface(
          key: 'application_track',
          objectName: 'public.rpc_nosok_application_track_v1',
          surfaceType: 'security definer rpc',
          allowedRoleAr: 'anon/authenticated execute محدود',
          dataBoundaryAr:
              'يعرض الحالة العامة فقط ولا يعرض رقم الهوية أو المرفقات أو audit payload.',
          applyStatus: 'guarded-not-applied',
        ),
      ],
      browserRoleEvidenceCases: [
        NosokV34BrowserRoleEvidenceCase(
          key: 'anonymous_public_campaigns',
          actorAr: 'anonymous',
          routeAr: '/services/nosok',
          expectedAr:
              'قراءة عامة من wrappers فقط دون direct table access ودون raw errors.',
          status: 'pending',
        ),
        NosokV34BrowserRoleEvidenceCase(
          key: 'anonymous_submit_privacy',
          actorAr: 'anonymous/public applicant',
          routeAr: '/services/nosok/apply',
          expectedAr:
              'submit عبر RPC فقط، وإرجاع tracking code دون payload داخلي.',
          status: 'pending',
        ),
        NosokV34BrowserRoleEvidenceCase(
          key: 'tracking_privacy',
          actorAr: 'anonymous/public applicant',
          routeAr: '/services/nosok/track',
          expectedAr: 'tracking يعرض حالة عامة فقط ولا يكشف بيانات حساسة.',
          status: 'pending',
        ),
        NosokV34BrowserRoleEvidenceCase(
          key: 'authenticated_no_role_admin',
          actorAr: 'authenticated without Nosok role',
          routeAr: '/admin/systems/nosok',
          expectedAr: 'forbidden عربي عبر Platform Access Gateway.',
          status: 'pending',
        ),
      ],
      repositoryBindingDecisions: [
        NosokV34RepositoryBindingDecision(
          mode: 'preview',
          allowedNow: true,
          boundaryAr: 'مسموح للواجهة والتصميم دون DB writes.',
          nextEvidenceAr: 'لا يحتاج wrappers.',
        ),
        NosokV34RepositoryBindingDecision(
          mode: 'standaloneSupabaseDevelopment',
          allowedNow: false,
          boundaryAr:
              'يرتبط فقط بـ public RPC wrappers بعد v34 apply evidence.',
          nextEvidenceAr: 'نتيجة SQL post-wrapper + Browser/Network evidence.',
        ),
        NosokV34RepositoryBindingDecision(
          mode: 'platformHosted',
          allowedNow: false,
          boundaryAr: 'يتطلب Platform Access Gateway + RBAC + scope proof.',
          nextEvidenceAr: 'Role/scope negative UAT + production gate مستقل.',
        ),
      ],
      gateDecision: NosokV34GateDecision(
        decision:
            'V34_PUBLIC_WRAPPER_RPC_AUTHORIZATION_PREPARED_APPLY_NOT_EXECUTED_REPOSITORY_BINDING_BLOCKED',
        summaryAr:
            'هذه دفعة تطوير محكومة: تم تجهيز public wrappers/RPCs وواجهات الاستيعاب والاختبارات، لكن لم يتم تشغيل SQL التطبيقي ولم يتم فتح الربط التشغيلي.',
        allowedNextStepAr:
            'تشغيل SQL 32 read-only، ثم تشغيل wrapper apply المحروس على staging فقط إذا تم التفويض، ثم تشغيل post-wrapper UAT read-only.',
        blockedAr:
            'الإنتاج، direct Flutter table access إلى nosok.*، public base tables، تشغيل القرعة، أو دفع إنتاجي.',
      ),
    );
  }
}
