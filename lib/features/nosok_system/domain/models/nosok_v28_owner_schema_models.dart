class NosokV28OwnerSchemaObject {
  const NosokV28OwnerSchemaObject({
    required this.objectName,
    required this.objectType,
    required this.ownerSchema,
    required this.executionState,
    required this.purposeAr,
    required this.coreDependencyRule,
    required this.publicSurfaceRule,
    required this.rlsRequirement,
    this.priority = 'P1',
  });

  final String objectName;
  final String objectType;
  final String ownerSchema;
  final String executionState;
  final String purposeAr;
  final String coreDependencyRule;
  final String publicSurfaceRule;
  final String rlsRequirement;
  final String priority;

  bool get isBlocked =>
      executionState.contains('blocked') || executionState.contains('deferred');
  bool get isDraftCandidate => executionState.contains('draft');
}

class NosokV28RlsPolicyRow {
  const NosokV28RlsPolicyRow({
    required this.tableName,
    required this.policyScope,
    required this.readRule,
    required this.writeRule,
    required this.negativeUat,
  });

  final String tableName;
  final String policyScope;
  final String readRule;
  final String writeRule;
  final String negativeUat;
}

class NosokV28RpcSurfaceRow {
  const NosokV28RpcSurfaceRow({
    required this.surfaceName,
    required this.surfaceType,
    required this.exposureLevel,
    required this.ownerSource,
    required this.status,
  });

  final String surfaceName;
  final String surfaceType;
  final String exposureLevel;
  final String ownerSource;
  final String status;
}

class NosokV28ExecutionGate {
  const NosokV28ExecutionGate({
    required this.decision,
    required this.summaryAr,
    required this.allowedNowAr,
    required this.blockedNowAr,
    required this.requiredAuthorizationAr,
  });

  final String decision;
  final String summaryAr;
  final String allowedNowAr;
  final String blockedNowAr;
  final String requiredAuthorizationAr;

  bool get executionAllowed => decision == 'GUARDED_STAGING_DDL_AUTHORIZED';
}

class NosokV28OwnerSchemaDesignPack {
  const NosokV28OwnerSchemaDesignPack({
    required this.objects,
    required this.rlsRows,
    required this.rpcSurfaces,
    required this.executionGate,
  });

  final List<NosokV28OwnerSchemaObject> objects;
  final List<NosokV28RlsPolicyRow> rlsRows;
  final List<NosokV28RpcSurfaceRow> rpcSurfaces;
  final NosokV28ExecutionGate executionGate;

  int get draftObjectCount =>
      objects.where((object) => object.isDraftCandidate).length;
  int get blockedObjectCount =>
      objects.where((object) => object.isBlocked).length;
  int get publicSurfaceCount => rpcSurfaces.length;

  static NosokV28OwnerSchemaDesignPack baseline() {
    const objects = <NosokV28OwnerSchemaObject>[
      NosokV28OwnerSchemaObject(
        objectName: 'nosok schema',
        objectType: 'schema',
        ownerSchema: 'nosok',
        executionState: 'draft-guarded-not-applied',
        purposeAr: 'إنشاء نطاق ملكية تشغيلية مستقل لنسك بعد التفويض فقط.',
        coreDependencyRule:
            'لا يعتمد على core كمالك؛ يقرأ core عبر مفاتيح مرجعية وwrappers.',
        publicSurfaceRule:
            'لا public base tables؛ public لاحقًا views/RPC فقط.',
        rlsRequirement: 'n/a before table creation',
        priority: 'P0',
      ),
      NosokV28OwnerSchemaObject(
        objectName: 'nosok.campaigns',
        objectType: 'base table draft',
        ownerSchema: 'nosok',
        executionState: 'draft-create-candidate',
        purposeAr:
            'مواسم/حملات الحج والعمرة، مع إغلاق/فتح محكوم لا يساوي production opening.',
        coreDependencyRule:
            'unit_id اختياري يقرأ من core.org_units عند ربط النطاق.',
        publicSurfaceRule:
            'public.v_nosok_campaigns_public_v1 لاحقًا للقراءة العامة فقط.',
        rlsRequirement:
            'read public only for published campaigns through surface; admin writes require manageNosokCampaigns.',
        priority: 'P0',
      ),
      NosokV28OwnerSchemaObject(
        objectName: 'nosok.applications',
        objectType: 'base table draft',
        ownerSchema: 'nosok',
        executionState: 'draft-create-candidate',
        purposeAr:
            'طلبات المواطنين مع tracking_code وstatus ودون تكرار بيانات LGU/governorate كحقيقة.',
        coreDependencyRule:
            'lgu_id/governorate_id مفاتيح مرجعية إلى core؛ snapshots نصية للتدقيق فقط عند الحاجة.',
        publicSurfaceRule:
            'public.rpc_nosok_application_submit_v1 وpublic.rpc_nosok_application_track_v1 لاحقًا بعد UAT.',
        rlsRequirement:
            'applicant can read own tracking subset; reviewers scoped by unit/LGU; writes gated.',
        priority: 'P0',
      ),
      NosokV28OwnerSchemaObject(
        objectName: 'nosok.application_documents',
        objectType: 'base table draft',
        ownerSchema: 'nosok',
        executionState: 'draft-create-candidate',
        purposeAr:
            'Metadata للمرفقات فقط؛ الملفات الفعلية في Supabase Storage.',
        coreDependencyRule: 'لا تكرار بيانات مرجعية.',
        publicSurfaceRule:
            'لا surface عام مباشر؛ access عبر RPC محكوم أو signed URL لاحقًا.',
        rlsRequirement:
            'owner/reviewer scoped read; upload metadata guarded; no public raw list.',
      ),
      NosokV28OwnerSchemaObject(
        objectName: 'nosok.eligibility_rules',
        objectType: 'base table draft',
        ownerSchema: 'nosok',
        executionState: 'draft-create-candidate',
        purposeAr: 'شروط الأهلية القابلة للتعديل بإذن إداري/وزاري.',
        coreDependencyRule:
            'لا تكرار core؛ القواعد تستدعي مراجع core عند الحاجة.',
        publicSurfaceRule:
            'public.v_nosok_requirements_public_v1 لاحقًا للعرض العام.',
        rlsRequirement:
            'public published read; admin write requires legal/compliance permission.',
      ),
      NosokV28OwnerSchemaObject(
        objectName: 'nosok.quota_rules / nosok.lgu_quotas',
        objectType: 'base table draft',
        ownerSchema: 'nosok',
        executionState: 'draft-create-candidate',
        purposeAr: 'قواعد الحصص ونسب المقاعد لكل LGU، دون ملكية LGU داخل نسك.',
        coreDependencyRule:
            'lgu_id يجب أن يرجع إلى core.core_lgus/core.v_lgus.',
        publicSurfaceRule: 'لا نشر عام قبل الاعتماد القانوني.',
        rlsRequirement:
            'supervisor/committee read; write requires committee/central admin approval.',
        priority: 'P0',
      ),
      NosokV28OwnerSchemaObject(
        objectName: 'nosok.workflow_events / nosok.audit_events',
        objectType: 'base table draft',
        ownerSchema: 'nosok',
        executionState: 'draft-create-candidate',
        purposeAr: 'سجل انتقالات الطلب والتدقيق، append-only قدر الإمكان.',
        coreDependencyRule:
            'actor/unit references from platform_access/core snapshots only for audit.',
        publicSurfaceRule: 'لا surface عام.',
        rlsRequirement:
            'internal audit read only; inserts through RPC/trigger guarded.',
        priority: 'P0',
      ),
      NosokV28OwnerSchemaObject(
        objectName: 'nosok.lottery_runs / nosok.lottery_entries',
        objectType: 'deferred base table draft',
        ownerSchema: 'nosok',
        executionState:
            'deferred-draft-blocked-before-legal-algorithm-approval',
        purposeAr:
            'تشغيلات القرعة ونتائجها؛ مؤجلة حتى اعتماد عقد الخوارزمية والتدقيق واللجنة.',
        coreDependencyRule: 'eligible applications + core LGU only.',
        publicSurfaceRule: 'public results surface only after approval.',
        rlsRequirement:
            'immutable/audited results; no production draw before legal gate.',
        priority: 'P0',
      ),
      NosokV28OwnerSchemaObject(
        objectName: 'public.* base table',
        objectType: 'forbidden target',
        ownerSchema: 'public',
        executionState: 'blocked-permanently',
        purposeAr: 'مرفوض: public ليس مالك بيانات نسك.',
        coreDependencyRule: 'n/a',
        publicSurfaceRule: 'views/RPC wrappers only.',
        rlsRequirement: 'n/a',
        priority: 'P0',
      ),
    ];

    const rlsRows = <NosokV28RlsPolicyRow>[
      NosokV28RlsPolicyRow(
          tableName: 'nosok.campaigns',
          policyScope: 'public published read + admin write',
          readRule:
              'published campaigns may be exposed through public view only',
          writeRule:
              'manageNosokCampaigns or platform superuser through gateway',
          negativeUat:
              'anonymous cannot write; scoped employee cannot edit central campaign'),
      NosokV28RlsPolicyRow(
          tableName: 'nosok.applications',
          policyScope: 'applicant tracking + unit/reviewer scope',
          readRule:
              'public tracking returns minimal status by tracking code; internal read requires role/scope',
          writeRule: 'submit/update through guarded RPC only',
          negativeUat: 'wrong unit cannot read another LGU queue'),
      NosokV28RlsPolicyRow(
          tableName: 'nosok.application_documents',
          policyScope: 'applicant/reviewer metadata only',
          readRule:
              'document metadata only to applicant/reviewer; no public list',
          writeRule: 'upload metadata via guarded RPC/storage policy',
          negativeUat: 'anonymous cannot enumerate documents'),
      NosokV28RlsPolicyRow(
          tableName: 'nosok.eligibility_rules',
          policyScope: 'published read + legal/admin write',
          readRule: 'published rules exposed via public view',
          writeRule: 'manageNosokLegalCompliance required',
          negativeUat: 'reviewer cannot change eligibility rule'),
      NosokV28RlsPolicyRow(
          tableName: 'nosok.lgu_quotas',
          policyScope: 'committee/supervisor only before approval',
          readRule: 'internal role only until legal approval',
          writeRule: 'committee controlled workflow',
          negativeUat: 'unit admin cannot alter another LGU quota'),
      NosokV28RlsPolicyRow(
          tableName: 'nosok.audit_events',
          policyScope: 'internal audit only',
          readRule: 'platform superuser/audit permission',
          writeRule: 'append-only trigger/RPC',
          negativeUat: 'normal reviewer cannot delete or update audit'),
    ];

    const rpcSurfaces = <NosokV28RpcSurfaceRow>[
      NosokV28RpcSurfaceRow(
          surfaceName: 'public.v_nosok_campaigns_public_v1',
          surfaceType: 'view',
          exposureLevel: 'public read',
          ownerSource: 'nosok.campaigns',
          status: 'draft-later-after-ddl'),
      NosokV28RpcSurfaceRow(
          surfaceName: 'public.v_nosok_requirements_public_v1',
          surfaceType: 'view',
          exposureLevel: 'public read',
          ownerSource: 'nosok.eligibility_rules',
          status: 'draft-later-after-ddl'),
      NosokV28RpcSurfaceRow(
          surfaceName: 'public.rpc_nosok_application_submit_v1',
          surfaceType: 'RPC',
          exposureLevel: 'public guarded write',
          ownerSource: 'nosok.applications',
          status: 'deferred-until-privacy-and-rls-uat'),
      NosokV28RpcSurfaceRow(
          surfaceName: 'public.rpc_nosok_application_track_v1',
          surfaceType: 'RPC',
          exposureLevel: 'public minimal lookup',
          ownerSource: 'nosok.applications + nosok.tracking_events',
          status: 'draft-later-after-rls'),
      NosokV28RpcSurfaceRow(
          surfaceName: 'public.rpc_nosok_admin_queue_v1',
          surfaceType: 'RPC',
          exposureLevel: 'authenticated RBAC',
          ownerSource: 'nosok.applications',
          status: 'draft-later-after-platform-access-binding'),
    ];

    return const NosokV28OwnerSchemaDesignPack(
      objects: objects,
      rlsRows: rlsRows,
      rpcSurfaces: rpcSurfaces,
      executionGate: NosokV28ExecutionGate(
        decision: 'GUARDED_DDL_DRAFT_PREPARED_NOT_APPLIED',
        summaryAr:
            'تم إعداد تصميم owner schema وحزمة DDL guarded-not-applied فقط. لم يتم تنفيذ CREATE SCHEMA أو CREATE TABLE.',
        allowedNowAr:
            'المسموح الآن: مراجعة التصميم، تشغيل read-only validation، وفحص SQL draft يدويًا.',
        blockedNowAr:
            'الممنوع الآن: تنفيذ DDL، إنشاء public base tables، تشغيل قرعة، فتح طلبات إنتاجية، أو استخدام service_role في Flutter.',
        requiredAuthorizationAr:
            'التفويض التالي يجب أن يكون نصًا صريحًا لإنشاء nosok schema وجداول staging المحددة فقط، بعد قبول RLS/RPC/UAT/rollback matrices.',
      ),
    );
  }
}
