import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/nosok_lottery_backend_contract.dart';

final nosokLotteryBackendContractProvider =
    Provider<NosokLotteryBackendContract>((ref) {
  return const NosokLotteryBackendContract(
    version: 'v28B-sandbox-sql-evidence-intake',
    status:
        'flutter-retest-passed / actual-sandbox-sql-apply-evidence-not-attached / readiness-rpc-result-pending / backend-binding-deferred / production-not-approved',
    schemaName: 'nosok',
    tables: [
      NosokLotteryBackendTableContract(
        name: 'nosok.lottery_policies',
        purposeAr:
            'سياسة قرعة موسمية قابلة للتعديل: العمر، المرافقون، المحرم، الدفع، مصدر السكان، معامل الحصة، وحصة الحج الوطنية.',
        ownerScope: 'nosok backend / ministry policy owner',
        keyColumns: [
          'id',
          'season_id',
          'policy_version',
          'quota_divisor',
          'total_national_hajj_quota',
          'status'
        ],
        privacyGateAr: 'لا تعرض للجمهور إلا ملخصًا منشورًا عبر RPC عام آمن.',
        rlsContractAr:
            'إدارة السياسة للمدير/لجنة الحج فقط؛ قراءة مختصرة عبر wrapper.',
        stage: 'draft-not-applied',
      ),
      NosokLotteryBackendTableContract(
        name: 'nosok.lgu_quota_snapshots',
        purposeAr:
            'تثبيت Snapshot لكل تجمع/LGU قبل القرعة: السكان، الحصة المحسوبة، override اليدوي، السعة النهائية، مصدر العنوان.',
        ownerScope: 'nosok lottery + LGU registry integration',
        keyColumns: [
          'id',
          'policy_id',
          'lgu_code',
          'population_snapshot',
          'final_capacity',
          'freeze_status'
        ],
        privacyGateAr:
            'الجمهور يرى تجمعه وحصته فقط دون أسماء الآخرين أو قوائم داخلية.',
        rlsContractAr:
            'قراءة داخلية حسب صلاحية القرعة؛ public wrapper لا يكشف إلا إحصاءً آمنًا.',
        stage: 'draft-not-applied',
      ),
      NosokLotteryBackendTableContract(
        name: 'nosok.lottery_eligibility_snapshots',
        purposeAr:
            'تجميد أهلية الطلب قبل القرعة: LGU المشتق من البطاقة، عدد الأشخاص، اكتمال الوثائق، الحج السابق، الدفع، وأسباب الاستبعاد.',
        ownerScope: 'nosok eligibility engine',
        keyColumns: [
          'id',
          'policy_id',
          'application_id',
          'lgu_code',
          'total_people_count',
          'eligibility_status'
        ],
        privacyGateAr:
            'المواطن يرى حالة طلبه فقط عبر tracking token وبيانات تحقق.',
        rlsContractAr: 'لا قراءة عامة مباشرة؛ الموظفون حسب الدور والنطاق.',
        stage: 'draft-not-applied',
      ),
      NosokLotteryBackendTableContract(
        name: 'nosok.lottery_draw_runs',
        purposeAr:
            'سجل تشغيل القرعة: run id، algorithm version، snapshot hash، المشغل، الوقت، والحالة.',
        ownerScope: 'nosok lottery manager + audit',
        keyColumns: [
          'id',
          'policy_id',
          'run_code',
          'algorithm_version',
          'policy_snapshot_hash',
          'status'
        ],
        privacyGateAr: 'لا تكشف تفاصيل seed أو مدخلات داخلية للجمهور.',
        rlsContractAr:
            'append-only بعد الإغلاق؛ إعادة التشغيل تحتاج authorization وتدقيق.',
        stage: 'draft-not-applied',
      ),
      NosokLotteryBackendTableContract(
        name: 'nosok.lottery_draw_results',
        purposeAr:
            'نتائج القرعة حسب الطلب: selected/waiting/excluded/capacity_overflow/committee_review مع الترتيب والسعة المتبقية.',
        ownerScope: 'nosok lottery result surface',
        keyColumns: [
          'id',
          'draw_run_id',
          'application_id',
          'decision',
          'rank_no',
          'remaining_capacity_after_decision'
        ],
        privacyGateAr:
            'RPC عام يعيد نتيجة طلب واحد فقط ولا يكشف نتائج الآخرين.',
        rlsContractAr:
            'النتائج الداخلية حسب الدور؛ public by secure lookup only.',
        stage: 'draft-not-applied',
      ),
      NosokLotteryBackendTableContract(
        name: 'nosok.lottery_committee_decisions',
        purposeAr:
            'قرارات لجنة الحج للحصص غير المستكملة أو الاستثناءات أو إعادة التوزيع الرسمية.',
        ownerScope: 'hajj committee governed workflow',
        keyColumns: [
          'id',
          'draw_run_id',
          'lgu_quota_snapshot_id',
          'decision_type',
          'reason_ar',
          'evidence_ref'
        ],
        privacyGateAr:
            'يعرض للجمهور أثر القرار على طلبه فقط، لا محاضر اللجنة الداخلية.',
        rlsContractAr:
            'لا تعديل صامت؛ كل قرار يحتاج سببًا ومرفقًا أو مرجع محضر.',
        stage: 'draft-not-applied',
      ),
      NosokLotteryBackendTableContract(
        name: 'nosok.lottery_objections',
        purposeAr:
            'اعتراضات المواطنين على التجمع المعتمد، الأهلية، عدد الأشخاص، أو قرار الحصة.',
        ownerScope: 'public support + lottery review',
        keyColumns: [
          'id',
          'application_id',
          'objection_type',
          'status',
          'submitted_at',
          'resolved_at'
        ],
        privacyGateAr:
            'المواطن يرى اعتراضه فقط؛ الموظف يرى حسب صلاحية المراجعة.',
        rlsContractAr: 'إدخال عام عبر RPC فقط؛ لا direct insert عام.',
        stage: 'draft-not-applied',
      ),
      NosokLotteryBackendTableContract(
        name: 'nosok.lottery_audit_events',
        purposeAr:
            'سجل تدقيق append-only لكل تغيير في سياسة القرعة أو snapshot أو التشغيل أو النتائج أو اللجنة.',
        ownerScope: 'audit / superuser / nosok governance',
        keyColumns: [
          'id',
          'entity_type',
          'entity_id',
          'event_key',
          'actor_user_id',
          'event_hash'
        ],
        privacyGateAr: 'داخلي فقط؛ لا يظهر في portal الجمهور.',
        rlsContractAr: 'append-only؛ لا حذف ولا تحديث صامت.',
        stage: 'draft-not-applied',
      ),
    ],
    rpcs: [
      NosokLotteryBackendRpcContract(
        name: 'public.rpc_nosok_lottery_public_result_v1',
        purposeAr:
            'إرجاع نتيجة طلب واحد للمواطن باستخدام tracking_code + identity token.',
        visibility: 'public safe wrapper',
        mutationPolicyAr: 'read-only',
        requiredRoleAr: 'public secure lookup',
        outputSafetyAr: 'لا يعيد أسماء الآخرين أو seed أو audit داخلي.',
      ),
      NosokLotteryBackendRpcContract(
        name: 'public.rpc_nosok_lottery_submit_objection_v1',
        purposeAr:
            'تقديم اعتراض عام مرتبط بطلب واحد مع نوع الاعتراض وملخص السبب.',
        visibility: 'public controlled insert wrapper',
        mutationPolicyAr: 'insert only into objections + audit event',
        requiredRoleAr:
            'public with tracking proof / authenticated citizen later',
        outputSafetyAr: 'يرجع reference فقط لا تفاصيل داخلية.',
      ),
      NosokLotteryBackendRpcContract(
        name: 'public.rpc_nosok_lottery_admin_policy_snapshot_v1',
        purposeAr: 'قراءة سياسة الموسم ولقطات LGU للوحة الإدارة.',
        visibility: 'admin wrapper',
        mutationPolicyAr: 'read-only',
        requiredRoleAr: 'viewNosokLottery/manageNosokLotteryEligibility',
        outputSafetyAr: 'يعرض بيانات تشغيلية للإدارة فقط.',
      ),
      NosokLotteryBackendRpcContract(
        name: 'public.rpc_nosok_lottery_admin_freeze_eligibility_v1',
        purposeAr: 'تثبيت snapshot الأهلية قبل القرعة بعد إغلاق التسجيل.',
        visibility: 'admin mutating wrapper',
        mutationPolicyAr: 'controlled insert snapshot + audit; no result draw',
        requiredRoleAr: 'manageNosokLotteryEligibility',
        outputSafetyAr: 'يرجع counts وأسباب الاستبعاد مجمعة.',
      ),
      NosokLotteryBackendRpcContract(
        name: 'public.rpc_nosok_lottery_admin_execute_draw_v1',
        purposeAr: 'تنفيذ قرعة LGU capacity-aware بناءً على snapshot مثبت.',
        visibility: 'admin mutating wrapper',
        mutationPolicyAr:
            'single run per policy unless committee/superuser unlock with audit',
        requiredRoleAr: 'executeNosokLotteryDraw + audit context',
        outputSafetyAr: 'يرجع run evidence وcounts لا بيانات حساسة غير لازمة.',
      ),
      NosokLotteryBackendRpcContract(
        name: 'public.rpc_nosok_lottery_committee_decision_v1',
        purposeAr:
            'تسجيل قرار لجنة الحج عند نقص الحصة أو تعذر الاستكمال من نفس LGU.',
        visibility: 'committee/admin wrapper',
        mutationPolicyAr:
            'insert decision + update affected result status + audit',
        requiredRoleAr: 'manageNosokLotteryCommittee',
        outputSafetyAr: 'كل قرار يحتاج reason/evidence_ref.',
      ),
      NosokLotteryBackendRpcContract(
        name: 'public.rpc_nosok_v28_lottery_backend_readiness_v1',
        purposeAr:
            'فحص جاهزية schema/RPC/RLS/Views بعد التطبيق في sandbox أو Supabase.',
        visibility: 'admin/readiness wrapper',
        mutationPolicyAr: 'read-only',
        requiredRoleAr: 'intakeNosokSqlUatResults',
        outputSafetyAr: 'يعيد مصفوفة checks دون بيانات مواطنين.',
      ),
    ],
    integrationSteps: [
      NosokLotteryIntegrationStep(
        key: 'schema_review',
        titleAr: 'مراجعة مخطط schema',
        descriptionAr:
            'اعتماد الجداول والقيود وRLS قبل أي تطبيق فعلي على Supabase.',
        status: 'draft-ready',
      ),
      NosokLotteryIntegrationStep(
        key: 'sandbox_apply',
        titleAr: 'تطبيق Sandbox فقط',
        descriptionAr:
            'تشغيل draft في بيئة sandbox بعد تغيير ROLLBACK إلى COMMIT، وليس في الإنتاج.',
        status: 'pending-actual-sql-result-v28b',
      ),
      NosokLotteryIntegrationStep(
        key: 'v28a_frontend_retest_intake',
        titleAr: 'استيعاب نتيجة Flutter v28',
        descriptionAr:
            'dart format نجح، flutter analyze بلا issues، وChrome startup وصل إلى Debug Service حسب سجل المستخدم المحلي.',
        status: 'passed-local-evidence',
      ),
      NosokLotteryIntegrationStep(
        key: 'v28b_actual_sandbox_sql_apply_evidence',
        titleAr: 'استيعاب نتيجة تطبيق SQL Sandbox',
        descriptionAr:
            'لم تصل نتيجة SQL apply فعلية في الرسالة الحالية؛ تم تجهيز سطح intake وUAT read-only، لكن لا يجوز اعتبار backend مطبقًا.',
        status: 'missing-evidence-binding-blocked',
      ),
      NosokLotteryIntegrationStep(
        key: 'v28b_readiness_rpc_result_intake',
        titleAr: 'استيعاب نتيجة Readiness RPC',
        descriptionAr:
            'لا توجد نتيجة public.rpc_nosok_v28_lottery_backend_readiness_v1 مرفقة؛ تبقى readiness pending حتى وصول جدول checks من Supabase.',
        status: 'pending-readiness-rpc-output',
      ),
      NosokLotteryIntegrationStep(
        key: 'rls_rpc_security_review',
        titleAr: 'مراجعة RLS/RPC الأمنية',
        descriptionAr:
            'تم تثبيت القرار الأمني: لا قراءة مباشرة عامة للجداول، public wrappers فقط، admin wrappers حسب الدور، وmutation عبر RPC محكومة بتدقيق.',
        status: 'reviewed-decision-recorded',
      ),
      NosokLotteryIntegrationStep(
        key: 'backend_binding_decision',
        titleAr: 'قرار ربط Backend الحقيقي',
        descriptionAr:
            'الربط الحقيقي مؤجل؛ لا يتم تحويل repository إلى Supabase runtime حتى وصول SQL sandbox apply + readiness RPC + role UAT.',
        status: 'deferred-by-v28b-gate',
      ),
      NosokLotteryIntegrationStep(
        key: 'sql_uat',
        titleAr: 'تشغيل SQL UAT',
        descriptionAr:
            'تشغيل ملف read-only UAT للتحقق من الجداول وRPCs وسياسة عدم كشف البيانات.',
        status: 'v28b-read-only-pack-added-not-run',
      ),
      NosokLotteryIntegrationStep(
        key: 'repository_binding',
        titleAr: 'ربط Repository حقيقي',
        descriptionAr:
            'تحويل controller من preview provider إلى Supabase repository بعد نجاح UAT.',
        status: 'deferred-by-v28b-decision',
      ),
      NosokLotteryIntegrationStep(
        key: 'role_uat',
        titleAr: 'Role/Browser UAT',
        descriptionAr:
            'اختبار citizen/employee/supervisor/admin/superuser/restricted قبل أي Production Gate.',
        status: 'pending-after-backend-binding',
      ),
    ],
    uatChecks: [
      NosokLotteryBackendUatCheck(
        key: 'draft_is_non_persistent_by_default',
        titleAr: 'ملف draft لا يترك أثرًا افتراضيًا',
        sqlSurfaceAr: 'sql/27_nosok_v28_lottery_backend_schema_rpc_draft.sql',
        expectedResultAr: 'يعمل داخل transaction وينتهي بـ ROLLBACK.',
        status: 'ready-not-applied',
      ),
      NosokLotteryBackendUatCheck(
        key: 'v28_flutter_retest_clean',
        titleAr: 'نتيجة Flutter v28 المحلية',
        sqlSurfaceAr: 'ليس SQL؛ سجل تشغيل محلي مرفق من المستخدم',
        expectedResultAr:
            'dart format نجح، flutter analyze No issues found، وChrome startup passed.',
        status: 'passed',
      ),
      NosokLotteryBackendUatCheck(
        key: 'sandbox_sql_apply_result_missing',
        titleAr: 'نتيجة Sandbox SQL غير مرفقة',
        sqlSurfaceAr: 'sql/27_nosok_v28_lottery_backend_schema_rpc_draft.sql',
        expectedResultAr:
            'يجب إرفاق نتيجة تطبيق sandbox قبل أي backend binding.',
        status: 'pending',
      ),
      NosokLotteryBackendUatCheck(
        key: 'v28b_actual_apply_evidence_gate',
        titleAr: 'بوابة نتيجة SQL الفعلية',
        sqlSurfaceAr: 'Supabase SQL Editor / sandbox apply log',
        expectedResultAr:
            'يجب أن يظهر إنشاء schema/tables/RPCs أو نتائج موجودة دون أخطاء قبل تحويل الربط إلى enabled.',
        status: 'not-provided',
      ),
      NosokLotteryBackendUatCheck(
        key: 'v28b_readiness_rpc_result_gate',
        titleAr: 'بوابة readiness RPC',
        sqlSurfaceAr: 'public.rpc_nosok_v28_lottery_backend_readiness_v1()',
        expectedResultAr:
            'يجب أن يرجع checks passed لكل الجداول/RPC/RLS وعدم لمس waqf_assets.',
        status: 'pending-output',
      ),
      NosokLotteryBackendUatCheck(
        key: 'readiness_rpc_contract',
        titleAr: 'عقد readiness RPC محدد',
        sqlSurfaceAr: 'public.rpc_nosok_v28_lottery_backend_readiness_v1',
        expectedResultAr: 'يعيد checks دون mutation ودون بيانات مواطنين.',
        status: 'draft-pending-sql-apply',
      ),
      NosokLotteryBackendUatCheck(
        key: 'public_result_privacy',
        titleAr: 'خصوصية نتيجة المواطن',
        sqlSurfaceAr: 'public.rpc_nosok_lottery_public_result_v1',
        expectedResultAr: 'نتيجة طلب واحد فقط؛ لا قوائم أسماء ولا audit داخلي.',
        status: 'draft',
      ),
      NosokLotteryBackendUatCheck(
        key: 'capacity_aware_draw_contract',
        titleAr: 'قرعة LGU حسب عدد الأشخاص',
        sqlSurfaceAr: 'public.rpc_nosok_lottery_admin_execute_draw_v1',
        expectedResultAr: 'لا يتجاوز selected_people السعة النهائية لكل LGU.',
        status: 'draft',
      ),
      NosokLotteryBackendUatCheck(
        key: 'committee_gap_required',
        titleAr: 'نقص الحصة يحتاج لجنة',
        sqlSurfaceAr: 'nosok.lottery_committee_decisions',
        expectedResultAr: 'لا تحويل تلقائي لتجمع آخر دون قرار موثق.',
        status: 'draft',
      ),
    ],
    productionBlockers: [
      'لم يتم إرفاق نتيجة تطبيق schema في Supabase sandbox ضمن v28B؛ لا توجد أدلة actual SQL apply.',
      'لم يتم تشغيل SQL UAT الحقيقي وإرفاق النتائج.',
      'قرار v28B: backend binding مؤجل؛ لا ربط Repository حقيقي قبل SQL sandbox/readiness/role evidence.',
      'لم يتم إجراء Role/Responsive/Browser console UAT بعد backend binding.',
      'لا توجد موافقة Production Gate.',
    ],
  );
});
