class NosokV37EvidenceItem {
  const NosokV37EvidenceItem({
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

class NosokV37RuntimeSwitchCandidate {
  const NosokV37RuntimeSwitchCandidate({
    required this.surface,
    required this.currentSource,
    required this.candidateSource,
    required this.switchMode,
    required this.decision,
    required this.requiredEvidenceAr,
  });

  final String surface;
  final String currentSource;
  final String candidateSource;
  final String switchMode;
  final String decision;
  final String requiredEvidenceAr;

  bool get allowed => decision == 'candidate';
  bool get blocked => decision == 'blocked';
  bool get deferred => decision == 'deferred';
}

class NosokV37BrowserEvidenceCase {
  const NosokV37BrowserEvidenceCase({
    required this.caseKey,
    required this.actorAr,
    required this.surface,
    required this.observedEvidenceAr,
    required this.networkEvidenceAr,
    required this.status,
  });

  final String caseKey;
  final String actorAr;
  final String surface;
  final String observedEvidenceAr;
  final String networkEvidenceAr;
  final String status;

  bool get accepted => status == 'accepted';
  bool get pending => status == 'pending';
  bool get blocked => status == 'blocked';
}

class NosokV37RepositoryBindingDecision {
  const NosokV37RepositoryBindingDecision({
    required this.decision,
    required this.summaryAr,
    required this.allowedNowAr,
    required this.blockedAr,
    required this.nextStepAr,
  });

  final String decision;
  final String summaryAr;
  final String allowedNowAr;
  final String blockedAr;
  final String nextStepAr;
}

class NosokV37RuntimeSwitchPack {
  const NosokV37RuntimeSwitchPack({
    required this.evidenceItems,
    required this.switchCandidates,
    required this.browserEvidenceCases,
    required this.repositoryBindingDecision,
  });

  final List<NosokV37EvidenceItem> evidenceItems;
  final List<NosokV37RuntimeSwitchCandidate> switchCandidates;
  final List<NosokV37BrowserEvidenceCase> browserEvidenceCases;
  final NosokV37RepositoryBindingDecision repositoryBindingDecision;

  int get acceptedEvidenceCount =>
      evidenceItems.where((item) => item.accepted).length;
  int get candidateSwitchCount =>
      switchCandidates.where((item) => item.allowed).length;
  int get pendingCaseCount =>
      browserEvidenceCases.where((item) => item.pending).length;
  int get blockedSwitchCount =>
      switchCandidates.where((item) => item.blocked).length;

  static NosokV37RuntimeSwitchPack baseline() {
    return const NosokV37RuntimeSwitchPack(
      evidenceItems: [
        NosokV37EvidenceItem(
          key: 'v36_sql_gate',
          titleAr: 'نتيجة SQL v36',
          status: 'accepted',
          evidenceAr:
              'wrappers موجودة إجمالًا، والجداول في nosok موجودة، ولا توجد public base tables جديدة، مع بقاء الربط غير معتمد.',
          decisionAr:
              'تُقبل كمدخل لدفعة v37 مع إصلاح فحص signature الخاص بدالة submit في SQL v37.',
        ),
        NosokV37EvidenceItem(
          key: 'public_home_browser',
          titleAr: 'واجهة /services/nosok',
          status: 'accepted',
          evidenceAr:
              'الواجهة العامة تظهر بنجاح، Console لا يعرض أخطاء runtime حمراء، وSupabase init مكتمل.',
          decisionAr:
              'مقبول كدليل browser startup، وليس دليل repository RPC switch بعد.',
        ),
        NosokV37EvidenceItem(
          key: 'admin_home_browser',
          titleAr: 'لوحة /admin/systems/nosok',
          status: 'accepted',
          evidenceAr:
              'لوحة النظام الداخلية تظهر مع الشريط الجانبي وActor/role context.',
          decisionAr:
              'مقبول كدليل route rendering ضمن وضع Superuser/Platform override.',
        ),
        NosokV37EvidenceItem(
          key: 'users_roles_browser',
          titleAr: 'صفحة المستخدمون والأدوار',
          status: 'accepted',
          evidenceAr:
              'صفحة الأدوار تعرض قاعدة PalWakf الحاكمة وقوالب الصلاحيات دون الاعتماد على جدول مستخدمي نسك مستقل.',
          decisionAr: 'يدعم أن platform_access يبقى مالك الوصول والصلاحيات.',
        ),
        NosokV37EvidenceItem(
          key: 'network_rpc_switch',
          titleAr: 'Network RPC switch evidence',
          status: 'pending',
          evidenceAr:
              'لقطة Network الحالية تُظهر تحميل favicon فقط، ولا تثبت بعد استدعاء RPCs الأربعة من الواجهات العامة.',
          decisionAr:
              'لا يتم اعتماد global runtime switch قبل ظهور RPC calls في Network أو فحص adapter مخصص.',
        ),
      ],
      switchCandidates: [
        NosokV37RuntimeSwitchCandidate(
          surface: 'Public campaigns list',
          currentSource: 'preview/static public cards',
          candidateSource: 'public.rpc_nosok_campaigns_public_list_v1',
          switchMode: 'runtime candidate / fallback-safe',
          decision: 'candidate',
          requiredEvidenceAr:
              'Network call أو empty-safe عبر adapter مع console clean.',
        ),
        NosokV37RuntimeSwitchCandidate(
          surface: 'Public requirements list',
          currentSource: 'preview/static requirements panel',
          candidateSource: 'public.rpc_nosok_requirements_public_list_v1',
          switchMode: 'runtime candidate / fallback-safe',
          decision: 'candidate',
          requiredEvidenceAr:
              'يعرض published-only requirements ولا يكسر الصفحة عند empty set.',
        ),
        NosokV37RuntimeSwitchCandidate(
          surface: 'Public application submit',
          currentSource: 'preview/staging guarded submit',
          candidateSource: 'public.rpc_nosok_application_submit_v1',
          switchMode: 'staging-only candidate',
          decision: 'deferred',
          requiredEvidenceAr:
              'يتطلب rate-limit/privacy/error-normalizer evidence قبل إدخاله في واجهة المواطن.',
        ),
        NosokV37RuntimeSwitchCandidate(
          surface: 'Public application tracking',
          currentSource: 'preview/tracking mock',
          candidateSource: 'public.rpc_nosok_application_track_v1',
          switchMode: 'privacy-gated candidate',
          decision: 'deferred',
          requiredEvidenceAr: 'يتطلب إثبات عدم كشف PII/documents/audit events.',
        ),
        NosokV37RuntimeSwitchCandidate(
          surface: 'Admin queues/review',
          currentSource: 'preview/admin read models',
          candidateSource: 'future authenticated admin RPCs',
          switchMode: 'not in public wrapper scope',
          decision: 'blocked',
          requiredEvidenceAr:
              'يحتاج Admin RPC/RLS batch مستقل، ولا يستخدم public wrappers.',
        ),
      ],
      browserEvidenceCases: [
        NosokV37BrowserEvidenceCase(
          caseKey: 'public_home_render',
          actorAr: 'anonymous/public',
          surface: '/services/nosok',
          observedEvidenceAr:
              'Rendered successfully with service cards and no red runtime errors in console.',
          networkEvidenceAr: 'No RPC evidence yet; startup only.',
          status: 'accepted',
        ),
        NosokV37BrowserEvidenceCase(
          caseKey: 'admin_home_render',
          actorAr: 'Superuser / Platform override',
          surface: '/admin/systems/nosok',
          observedEvidenceAr:
              'Rendered successfully with internal dashboard and sidebar.',
          networkEvidenceAr: 'Console clean, Supabase init completed.',
          status: 'accepted',
        ),
        NosokV37BrowserEvidenceCase(
          caseKey: 'users_roles_render',
          actorAr: 'Superuser / Platform override',
          surface: '/admin/systems/nosok/users-roles',
          observedEvidenceAr:
              'Rendered successfully, confirms platform_access remains owner for RBAC.',
          networkEvidenceAr: 'No unsafe backend error observed.',
          status: 'accepted',
        ),
        NosokV37BrowserEvidenceCase(
          caseKey: 'public_campaigns_rpc_network',
          actorAr: 'anonymous/public',
          surface: '/services/nosok',
          observedEvidenceAr: 'Visual render accepted.',
          networkEvidenceAr:
              'RPC call must appear before certifying runtime switch.',
          status: 'pending',
        ),
        NosokV37BrowserEvidenceCase(
          caseKey: 'public_requirements_rpc_network',
          actorAr: 'anonymous/public',
          surface: '/services/nosok/requirements',
          observedEvidenceAr: 'Not yet supplied in v37 evidence set.',
          networkEvidenceAr: 'RPC call / empty-safe evidence pending.',
          status: 'pending',
        ),
        NosokV37BrowserEvidenceCase(
          caseKey: 'no_role_negative',
          actorAr: 'authenticated without Nosok role',
          surface: '/admin/systems/nosok',
          observedEvidenceAr: 'Not yet supplied as a negative actor.',
          networkEvidenceAr: 'Forbidden/hidden route evidence pending.',
          status: 'pending',
        ),
      ],
      repositoryBindingDecision: NosokV37RepositoryBindingDecision(
        decision:
            'V37_PUBLIC_REPOSITORY_BINDING_RUNTIME_SWITCH_CANDIDATE_PREPARED_PRODUCTION_DEFERRED',
        summaryAr:
            'تم قبول أدلة browser rendering وتجهيز runtime switch candidate للقراءة العامة عبر wrappers، لكن لم يتم تفعيل global repository switch.',
        allowedNowAr:
            'يسمح بتحضير fallback-safe candidate للـ campaigns/requirements في standaloneSupabaseDevelopment فقط.',
        blockedAr:
            'global platformHosted switch، public submit، public tracking، وadmin repository binding محجوبة حتى Browser/Network/Role/Scope evidence.',
        nextStepAr:
            'تنفيذ v38 كدفعة runtime integration موسعة تربط campaigns/requirements فعليًا عبر adapter مع fallback، ثم إحضار Network evidence.',
      ),
    );
  }
}
