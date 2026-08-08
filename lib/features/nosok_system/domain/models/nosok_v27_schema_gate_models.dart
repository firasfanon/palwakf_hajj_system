class NosokV27SchemaCensusFact {
  const NosokV27SchemaCensusFact({
    required this.key,
    required this.titleAr,
    required this.value,
    required this.decision,
    required this.noteAr,
    this.status = 'accepted',
  });

  final String key;
  final String titleAr;
  final String value;
  final String decision;
  final String noteAr;
  final String status;

  bool get accepted => status == 'accepted' || status == 'passed';
  bool get blocked => status == 'blocked';
  bool get pending => status.startsWith('pending');
}

class NosokV27ReconciliationItem {
  const NosokV27ReconciliationItem({
    required this.key,
    required this.objectName,
    required this.currentOwner,
    required this.proposedNosokUse,
    required this.decision,
    required this.reasonAr,
    this.risk = 'P1',
  });

  final String key;
  final String objectName;
  final String currentOwner;
  final String proposedNosokUse;
  final String decision;
  final String reasonAr;
  final String risk;
}

class NosokV27OwnerSchemaDiffItem {
  const NosokV27OwnerSchemaDiffItem({
    required this.proposedObject,
    required this.proposedAction,
    required this.ownerSchema,
    required this.publicSurface,
    required this.coreReferenceRule,
    required this.executionGate,
  });

  final String proposedObject;
  final String proposedAction;
  final String ownerSchema;
  final String publicSurface;
  final String coreReferenceRule;
  final String executionGate;
}

class NosokV27SafeSqlGateDecision {
  const NosokV27SafeSqlGateDecision({
    required this.status,
    required this.reasonAr,
    required this.allowedNowAr,
    required this.blockedNowAr,
    required this.nextAuthorizationAr,
  });

  final String status;
  final String reasonAr;
  final String allowedNowAr;
  final String blockedNowAr;
  final String nextAuthorizationAr;

  bool get executionAllowed => status == 'guarded-staging-execution-authorized';
}

class NosokV27SchemaGatePack {
  const NosokV27SchemaGatePack({
    required this.censusFacts,
    required this.reconciliationItems,
    required this.diffItems,
    required this.safeSqlGateDecision,
  });

  final List<NosokV27SchemaCensusFact> censusFacts;
  final List<NosokV27ReconciliationItem> reconciliationItems;
  final List<NosokV27OwnerSchemaDiffItem> diffItems;
  final NosokV27SafeSqlGateDecision safeSqlGateDecision;

  int get acceptedFacts => censusFacts.where((fact) => fact.accepted).length;
  int get blockedFacts => censusFacts.where((fact) => fact.blocked).length;
  int get pendingFacts => censusFacts.where((fact) => fact.pending).length;

  int get blockedReconciliation => reconciliationItems
      .where((item) => item.decision.contains('blocked'))
      .length;
  int get createCandidates =>
      diffItems.where((item) => item.proposedAction.contains('create')).length;
  int get wrapperCandidates =>
      diffItems.where((item) => item.publicSurface != 'none').length;

  static NosokV27SchemaGatePack baseline() {
    const facts = <NosokV27SchemaCensusFact>[
      NosokV27SchemaCensusFact(
          key: 'census_decision',
          titleAr: 'قرار الجرد',
          value: 'LIGHT_GLOBAL_SCHEMA_CENSUS_COMPLETED_READ_ONLY',
          decision: 'accepted',
          noteAr: 'الجرد المرسل read-only ولا يتضمن تفويض DDL/DML.'),
      NosokV27SchemaCensusFact(
          key: 'nosok_schema',
          titleAr: 'وجود schema نسك',
          value: 'not detected in light census',
          decision: 'owner schema build requires explicit SQL authorization',
          noteAr: 'لا يتم إنشاء nosok.* تلقائيًا داخل هذه الدفعة.',
          status: 'pending-authorization'),
      NosokV27SchemaCensusFact(
          key: 'core',
          titleAr: 'core',
          value: '37 base tables / 22 views',
          decision: 'sovereign reference priority',
          noteAr:
              'LGU/governorates/org_units تقرأ من core أو wrappers آمنة ولا تكرر كمصدر حقيقة.'),
      NosokV27SchemaCensusFact(
          key: 'public',
          titleAr: 'public',
          value: '9 base tables / 159 views',
          decision: 'public base table creation blocked',
          noteAr: 'public طبقة views/RPC فقط. أي CREATE TABLE public.* مرفوض.',
          status: 'blocked'),
      NosokV27SchemaCensusFact(
          key: 'billing_system',
          titleAr: 'billing_system',
          value: '4 base tables',
          decision: 'payment bridge required',
          noteAr:
              'الدفع الإلكتروني يمر عبر billing_system أو عقد دفع مستقل، لا بناء دفع مكرر داخل نسك.'),
      NosokV27SchemaCensusFact(
          key: 'platform_access',
          titleAr: 'platform_access',
          value: '9 base tables',
          decision: 'platform access remains owner',
          noteAr:
              'RBAC/AccessProfile مصدره المنصة، ونسك يستهلكه عبر gateway/provider override.'),
      NosokV27SchemaCensusFact(
          key: 'waqf_awqaf',
          titleAr: 'waqf / awqaf_system',
          value: 'present',
          decision: 'out of nosok mutation scope',
          noteAr: 'لا لمس لـ waqf_assets أو awqaf_system ضمن نسك.',
          status: 'blocked'),
    ];

    const reconciliation = <NosokV27ReconciliationItem>[
      NosokV27ReconciliationItem(
          key: 'org_units',
          objectName: 'core.org_units + core.v_org_units',
          currentOwner: 'core',
          proposedNosokUse: 'read-only reference wrapper',
          decision: 'reuse_existing_core_object',
          reasonAr:
              'الوحدات والـ slug والهيكل التنظيمي بيانات سيادية لا تكرر في nosok.',
          risk: 'P0'),
      NosokV27ReconciliationItem(
          key: 'lgus',
          objectName: 'core.core_lgus + core.v_lgus',
          currentOwner: 'core',
          proposedNosokUse: 'quota reference',
          decision: 'reuse_existing_core_object',
          reasonAr:
              'الحصص تعتمد LGU من core مع تخزين مفاتيح مرجعية فقط داخل nosok.lgu_quotas لاحقًا.',
          risk: 'P0'),
      NosokV27ReconciliationItem(
          key: 'governorates',
          objectName: 'core.core_governorates + core.v_governorates',
          currentOwner: 'core',
          proposedNosokUse: 'eligibility/address reference',
          decision: 'reuse_existing_core_object',
          reasonAr: 'لا نبني governorates داخل nosok أو public.',
          risk: 'P0'),
      NosokV27ReconciliationItem(
          key: 'public_org_units',
          objectName:
              'public.org_units / public.org_units_cache / public.pwf_org_units_cache',
          currentOwner: 'public compatibility/cache',
          proposedNosokUse: 'do not treat as truth',
          decision: 'blocked_as_owner_source',
          reasonAr:
              'الجرد يظهر تكرار أسماء مرجعية في public/core، والمالك المعتمد هو core.',
          risk: 'P0'),
      NosokV27ReconciliationItem(
          key: 'billing',
          objectName: 'billing_system.*',
          currentOwner: 'billing_system',
          proposedNosokUse: 'payment bridge only',
          decision: 'reuse_existing_billing_system',
          reasonAr:
              'الدفع الإلكتروني لا يبنى كجداول جديدة داخل public، ويحتاج عقد تكامل مالي مستقل.',
          risk: 'P0'),
      NosokV27ReconciliationItem(
          key: 'platform_access',
          objectName:
              'platform_access.admin_users / user_scope_assignments / permissions',
          currentOwner: 'platform_access',
          proposedNosokUse: 'RBAC provider override',
          decision: 'reuse_platform_access_owner',
          reasonAr: 'نسك لا يبني login/password/forbidden ولا يكرر RBAC.',
          risk: 'P0'),
      NosokV27ReconciliationItem(
          key: 'public_base_tables',
          objectName: 'public.* base tables',
          currentOwner: 'public existing only',
          proposedNosokUse: 'none',
          decision: 'new_public_table_creation_blocked',
          reasonAr: 'الجرد يمنع أي base table جديد في public.',
          risk: 'P0'),
      NosokV27ReconciliationItem(
          key: 'waqf_assets',
          objectName: 'waqf.waqf_assets / awqaf_system read surfaces',
          currentOwner: 'waqf + awqaf_system',
          proposedNosokUse: 'none',
          decision: 'blocked_out_of_scope',
          reasonAr: 'هذه أسطح سيادية خارج نسك ولا تدخل في قرعة الحج/العمرة.',
          risk: 'P0'),
    ];

    const diff = <NosokV27OwnerSchemaDiffItem>[
      NosokV27OwnerSchemaDiffItem(
          proposedObject: 'nosok schema',
          proposedAction: 'create-after-authorization',
          ownerSchema: 'nosok',
          publicSurface: 'none',
          coreReferenceRule: 'n/a',
          executionGate:
              'blocked until explicit guarded staging SQL authorization'),
      NosokV27OwnerSchemaDiffItem(
          proposedObject: 'nosok.campaigns',
          proposedAction: 'create-candidate',
          ownerSchema: 'nosok',
          publicSurface:
              'public.v_nosok_campaigns_public_v1 / RPC public list later',
          coreReferenceRule: 'unit_id references core.org_units where needed',
          executionGate: 'requires owner schema DDL pack + RLS matrix'),
      NosokV27OwnerSchemaDiffItem(
          proposedObject: 'nosok.applications',
          proposedAction: 'create-candidate',
          ownerSchema: 'nosok',
          publicSurface: 'public.rpc_nosok_application_submit_v1 guarded later',
          coreReferenceRule:
              'lgu_id/governorate_id reference core ids; no duplicated names as truth',
          executionGate: 'requires privacy/RLS/storage UAT before writes'),
      NosokV27OwnerSchemaDiffItem(
          proposedObject: 'nosok.application_documents',
          proposedAction: 'create-candidate',
          ownerSchema: 'nosok',
          publicSurface: 'none or guarded RPC',
          coreReferenceRule: 'metadata only; storage owns files',
          executionGate: 'requires storage bucket + RLS + malware/size policy'),
      NosokV27OwnerSchemaDiffItem(
          proposedObject: 'nosok.eligibility_rules',
          proposedAction: 'create-candidate',
          ownerSchema: 'nosok',
          publicSurface: 'public.v_nosok_requirements_public_v1 later',
          coreReferenceRule: 'no core duplication',
          executionGate: 'requires ministry approval workflow'),
      NosokV27OwnerSchemaDiffItem(
          proposedObject: 'nosok.quota_rules / nosok.lgu_quotas',
          proposedAction: 'create-candidate',
          ownerSchema: 'nosok',
          publicSurface: 'none before legal approval',
          coreReferenceRule: 'LGU read from core.core_lgus only',
          executionGate: 'requires legal quota algorithm contract'),
      NosokV27OwnerSchemaDiffItem(
          proposedObject: 'nosok.lottery_runs / nosok.lottery_entries',
          proposedAction: 'defer-create',
          ownerSchema: 'nosok',
          publicSurface: 'public results surface only after approval',
          coreReferenceRule: 'eligible applications refer to nosok + core LGU',
          executionGate: 'blocked until algorithm/audit/legal approval'),
      NosokV27OwnerSchemaDiffItem(
          proposedObject: 'nosok.workflow_events / nosok.audit_events',
          proposedAction: 'create-candidate',
          ownerSchema: 'nosok',
          publicSurface: 'none',
          coreReferenceRule: 'actor/unit from platform_access/core references',
          executionGate: 'requires append-only/audit design'),
      NosokV27OwnerSchemaDiffItem(
          proposedObject: 'public.* base table',
          proposedAction: 'reject',
          ownerSchema: 'public',
          publicSurface: 'views/RPC only',
          coreReferenceRule: 'n/a',
          executionGate: 'permanently blocked by platform contract'),
    ];

    return const NosokV27SchemaGatePack(
      censusFacts: facts,
      reconciliationItems: reconciliation,
      diffItems: diff,
      safeSqlGateDecision: NosokV27SafeSqlGateDecision(
        status: 'sql-execution-blocked-owner-review-required',
        reasonAr:
            'الجرد مقبول، لكنه يثبت أن بناء الجداول غير مسموح قبل owner review وتصميم RLS/RPC/rollback وتفويض SQL مستقل. لا توجد schema nosok ظاهرة في الجرد الحالي، وpublic ليس owner schema.',
        allowedNowAr:
            'المسموح الآن: read-only validation، إعداد owner schema design، تجهيز SQL guarded-not-applied، وتحديث Flutter adapters لقراءة حالة الجاهزية.',
        blockedNowAr:
            'الممنوع الآن: CREATE TABLE public.*، تشغيل قرعة، فتح طلبات إنتاجية، DML على core/platform/public/waqf/awqaf_system، أو إنشاء nosok.* دون تفويض.',
        nextAuthorizationAr:
            'التفويض التالي المطلوب: تفويض صريح لإنشاء nosok schema وجداول staging المرشحة فقط، بعد مراجعة NOSOK_OWNER_SCHEMA_DESIGN وRLS/RPC matrices.',
      ),
    );
  }
}
