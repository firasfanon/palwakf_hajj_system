class NosokV32EvidenceItem {
  const NosokV32EvidenceItem({
    required this.key,
    required this.labelAr,
    required this.observedAr,
    required this.status,
    required this.decisionAr,
  });

  final String key;
  final String labelAr;
  final String observedAr;
  final String status;
  final String decisionAr;

  bool get accepted => status == 'accepted';
  bool get pending => status == 'pending';
  bool get blocked => status == 'blocked';
}

class NosokV32OperatorFileDecision {
  const NosokV32OperatorFileDecision({
    required this.filePath,
    required this.whenToRunAr,
    required this.allowedNow,
    required this.notesAr,
  });

  final String filePath;
  final String whenToRunAr;
  final bool allowedNow;
  final String notesAr;
}

class NosokV32ProductionGateDecision {
  const NosokV32ProductionGateDecision({
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

class NosokV32ApplyEvidencePack {
  const NosokV32ApplyEvidencePack({
    required this.evidenceItems,
    required this.operatorFileDecisions,
    required this.productionGate,
  });

  final List<NosokV32EvidenceItem> evidenceItems;
  final List<NosokV32OperatorFileDecision> operatorFileDecisions;
  final NosokV32ProductionGateDecision productionGate;

  int get acceptedEvidenceCount =>
      evidenceItems.where((item) => item.accepted).length;
  int get blockedEvidenceCount =>
      evidenceItems.where((item) => item.blocked).length;
  int get pendingEvidenceCount =>
      evidenceItems.where((item) => item.pending).length;

  static NosokV32ApplyEvidencePack baseline() {
    return const NosokV32ApplyEvidencePack(
      evidenceItems: [
        NosokV32EvidenceItem(
          key: 'v31_read_only_gate',
          labelAr: 'نتيجة v31 read-only',
          observedAr:
              'NOSOK_V31_APPLY_NOT_CERTIFIED_OR_POST_APPLY_EVIDENCE_INCOMPLETE / nosok_present=false / expected nosok tables=false',
          status: 'accepted',
          decisionAr:
              'تم قبول نتيجة read-only كدليل أن controlled apply لم يحدث بعد.',
        ),
        NosokV32EvidenceItem(
          key: 'public_base_table_guard',
          labelAr: 'حراسة public',
          observedAr:
              'public_hajj_base_tables=0 / public_nosok_base_tables=0 / public_umrah_base_tables=0 / new_public_service_base_tables_detected=false',
          status: 'accepted',
          decisionAr:
              'لا توجد جداول خدمة جديدة داخل public قبل apply، ويجب إعادة الإثبات بعد apply.',
        ),
        NosokV32EvidenceItem(
          key: 'flutter_analyze',
          labelAr: 'تحليل Flutter',
          observedAr: 'No issues found! بعد v31.',
          status: 'accepted',
          decisionAr: 'طبقة Flutter نظيفة من analyzer.',
        ),
        NosokV32EvidenceItem(
          key: 'chrome_runtime',
          labelAr: 'تشغيل Chrome',
          observedAr:
              'فشل تحميل CanvasKit من gstatic: TypeError Failed to fetch dynamically imported module canvaskit.js.',
          status: 'blocked',
          decisionAr:
              'هذا blocker بيئة/شبكة CDN وليس خطأ Dart compile، لكنه يمنع قبول Browser runtime evidence حتى إعادة التشغيل بنجاح.',
        ),
        NosokV32EvidenceItem(
          key: 'controlled_apply_output',
          labelAr: 'نتيجة controlled DDL apply',
          observedAr: 'غير مرفقة؛ ملف operator-only لم يُنفذ بعد.',
          status: 'pending',
          decisionAr:
              'Post-apply census/RLS لا يمكن إغلاقه قبل تنفيذ ملف apply ثم تشغيل read-only post-apply.',
        ),
      ],
      operatorFileDecisions: [
        NosokV32OperatorFileDecision(
          filePath:
              'sql/guarded_not_applied/nosok_v31/00_READ_ME_V31_OPERATOR_ONLY.md',
          whenToRunAr: 'اقرأه أولًا فقط؛ لا يغير قاعدة البيانات.',
          allowedNow: true,
          notesAr: 'هذا ملف تعليمات تشغيل للمشغل.',
        ),
        NosokV32OperatorFileDecision(
          filePath:
              'sql/guarded_not_applied/nosok_v31/01_nosok_owner_schema_controlled_staging_apply_OPERATOR_ONLY_NOT_RUN.sql',
          whenToRunAr:
              'يشغّل فقط على staging بعد تأكيد backup/restore point وoperator session وتفويض إنشاء nosok.* فقط.',
          allowedNow: true,
          notesAr:
              'هذا هو ملف apply المحروس. لا تشغله على production ولا تعدّل public/waqf/awqaf_system.',
        ),
        NosokV32OperatorFileDecision(
          filePath:
              'sql/guarded_not_applied/nosok_v31/02_nosok_v31_post_apply_rls_rpc_negative_uat_READ_ONLY.sql',
          whenToRunAr:
              'يشغّل بعد 01 فقط لاستخراج post-apply census/RLS/RPC/negative UAT evidence.',
          allowedNow: false,
          notesAr: 'لا معنى له قبل apply؛ سيبقى يثبت أن nosok غير موجودة.',
        ),
        NosokV32OperatorFileDecision(
          filePath:
              'sql/guarded_not_applied/nosok_v31/03_nosok_v31_controlled_rollback_DRAFT_NOT_RUN.sql',
          whenToRunAr: 'لا يشغّل إلا عند فشل apply أو قرار rollback صريح.',
          allowedNow: false,
          notesAr: 'ملف رجوع فقط وليس جزءًا من المسار الطبيعي.',
        ),
      ],
      productionGate: NosokV32ProductionGateDecision(
        decision:
            'V32_APPLY_EVIDENCE_INTAKE_PREPARED_CONTROLLED_APPLY_STILL_REQUIRED',
        summaryAr:
            'تم قبول أدلة read-only/analyzer، لكن controlled DDL apply لم يثبت بعد، وChrome runtime لديه blocker CanvasKit CDN.',
        allowedNextStepAr:
            'تشغيل 00 قراءة، ثم 01 على staging فقط، ثم 02 read-only بعد apply، ثم إرسال كامل SQL output.',
        blockedAr:
            'إنتاج، تشغيل 03 rollback دون سبب، إنشاء public base tables، أو لمس waqf/awqaf_system.',
      ),
    );
  }
}
