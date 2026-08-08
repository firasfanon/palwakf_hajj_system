import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/nosok_v36_seasonal_operations_contract.dart';

final nosokV36SeasonalOperationsContractProvider =
    Provider<NosokV36SeasonalOperationsContract>((ref) {
  return const NosokV36SeasonalOperationsContract(
    version: 'v36-seasonal-operations-enhancement-pack',
    status:
        'large-seasonal-enhancement-pack-applied / reports-payment-doc-intelligence-assistant-campaigns-ux-policy-contracts-ready / integrations-disabled-until-palwakf-merge-and-nosok-schema',
    productionDecision:
        'production-not-approved / seasonal operations candidate only / real runtime requires PalWakf merge, nosok schema, RPC deployment, role UAT, and ministry policy approval',
    databaseDecision:
        'no nosok schema created in this package; all SQL/RPC/RLS remain draft/readiness contracts until PalWakf merge and Supabase sandbox approval',
    advancedReports: [
      NosokV36Capability(
        key: 'seasonal_command_center_reports',
        titleAr: 'تقارير مركز القيادة الموسمية',
        descriptionAr:
            'لوحة تقارير تجمع الطلبات حسب الموسم، الحالة، المديرية، LGU، نوع الخدمة، الحملة، الشركة، والنواقص الحرجة دون تحويل الصفحة الرئيسية إلى جدول ثقيل.',
        runtimeMode: 'frontend contract + future RPC summary',
        integrationTarget: 'nosok.rpc_nosok_seasonal_reports_summary_v1',
        securityNoteAr:
            'تعرض إحصاءات مجمعة فقط؛ لا تكشف هوية المواطنين أو تفاصيل الطلب إلا لمن يملك صلاحية تشغيلية.',
        status: 'ready-as-contract',
      ),
      NosokV36Capability(
        key: 'lottery_quota_reports',
        titleAr: 'تقارير الحصص والقرعة حسب التجمع',
        descriptionAr:
            'تقرير يوضح حصة كل LGU، عدد المتقدمين، المؤهلين، المختارين، قائمة الانتظار، والحالات التي تحتاج قرار لجنة الحج.',
        runtimeMode: 'contract-only until lottery RPCs exist',
        integrationTarget: 'nosok.rpc_nosok_lgu_quota_report_v1',
        securityNoteAr:
            'العرض العام يبقى مختصرًا؛ التفاصيل التشغيلية داخل لوحة الموظف فقط.',
        status: 'ready-as-contract',
      ),
      NosokV36Capability(
        key: 'export_governance',
        titleAr: 'حوكمة التصدير CSV/PDF',
        descriptionAr:
            'إعداد نقاط تصدير مستقبلية للتقارير مع سجل تدقيق وسبب التصدير ونطاق البيانات.',
        runtimeMode: 'disabled until policy approval',
        integrationTarget: 'platform document/export service',
        securityNoteAr:
            'لا تصدير لبيانات حساسة قبل موافقة سياسة الوزارة وRLS/Audit.',
        status: 'disabled-policy-required',
      ),
    ],
    paymentBridge: [
      NosokV36Capability(
        key: 'registration_fee_bridge',
        titleAr: 'ربط رسوم التسجيل',
        descriptionAr:
            'تجهيز عقد ربط مع billing_system لإصدار مطالبة رسوم التسجيل وربط حالة الدفع بمراحل الأهلية والقرعة.',
        runtimeMode: 'bridge disabled / billing contract ready',
        integrationTarget: 'billing_system.rpc_billing_create_nosok_charge_v1',
        securityNoteAr:
            'لا يتم تحصيل أو تحديث حالة دفع حقيقية قبل اعتماد مزود الدفع وربط audit.',
        status: 'candidate-ready-disabled',
      ),
      NosokV36Capability(
        key: 'payment_verification_queue',
        titleAr: 'طابور تحقق الدفعات',
        descriptionAr:
            'قائمة تشغيلية لموظف الدفع تعرض الحالات المعلّقة، المتضاربة، المدفوعة، والمرفوضة مع أسباب واضحة.',
        runtimeMode: 'frontend-ready / backend pending',
        integrationTarget: 'nosok.payments + billing_system reconciliation RPC',
        securityNoteAr:
            'عرض بيانات الدفع محدود لمن يملك صلاحية الدفع فقط ولا يظهر للمواطن إلا ملخص حالته.',
        status: 'ready-as-contract',
      ),
      NosokV36Capability(
        key: 'refund_and_exception_policy',
        titleAr: 'سياسة الاسترداد والاستثناءات',
        descriptionAr:
            'إضافة عقد سياسة موسمية لحالات الاسترداد أو الإعفاء أو الترحيل بين المواسم وفق قرار الوزارة.',
        runtimeMode: 'policy contract only',
        integrationTarget: 'ministry seasonal policy + billing_system',
        securityNoteAr: 'أي إعفاء أو استرداد يحتاج سببًا وصلاحية وسجل تدقيق.',
        status: 'policy-approval-required',
      ),
    ],
    documentIntelligence: [
      NosokV36Capability(
        key: 'document_quality_panel',
        titleAr: 'مؤشر جودة الوثائق',
        descriptionAr:
            'لوحة توضح جودة الصورة، وضوح الهوية/الجواز، نوع الوثيقة، وحالة المطابقة دون جعل الذكاء الاصطناعي صاحب قرار نهائي.',
        runtimeMode: 'document intelligence bridge disabled',
        integrationTarget:
            'document_intelligence.rpc_document_quality_assessment_v1',
        securityNoteAr:
            'النتائج توصية مساعدة فقط، والقرار يبقى لموظف نسك مع audit.',
        status: 'candidate-ready-disabled',
      ),
      NosokV36Capability(
        key: 'missing_document_detection',
        titleAr: 'كشف النواقص آليًا كمساعدة',
        descriptionAr:
            'تجهيز ربط يساعد على اكتشاف نقص وثيقة أو عدم تطابقها مع نوع الخدمة والموسم.',
        runtimeMode: 'planned bridge',
        integrationTarget: 'document_intelligence + nosok.documents',
        securityNoteAr: 'لا يرفض الطلب تلقائيًا؛ يضيف علامة مراجعة فقط.',
        status: 'planned-disabled',
      ),
      NosokV36Capability(
        key: 'ocr_metadata_contract',
        titleAr: 'عقد OCR للبيانات الوصفية',
        descriptionAr:
            'تصميم payload آمن لاستخراج بيانات وصفية من الوثيقة وربطها بمراجعة الموظف دون استبدال بيانات الهوية الرسمية.',
        runtimeMode: 'contract-only',
        integrationTarget: 'document_intelligence OCR/RAG pipeline',
        securityNoteAr:
            'المخرجات لا تكتب فوق بيانات المواطن الرسمية إلا بعد مراجعة وتأكيد.',
        status: 'ready-as-contract',
      ),
    ],
    assistantBridge: [
      NosokV36Capability(
        key: 'public_nosok_assistant',
        titleAr: 'مساعد نسك العام',
        descriptionAr:
            'مساعد يشرح الشروط، خطوات التسجيل، المتطلبات، الاعتراضات، والشركات المؤهلة دون كشف أي بيانات خاصة.',
        runtimeMode: 'assistant scope contract',
        integrationTarget: 'assistant public knowledge scope',
        securityNoteAr:
            'لا يجيب عن حالة طلب محدد إلا عبر RPC تتبع آمن وبحدود المواطن نفسه.',
        status: 'scope-ready-not-bound',
      ),
      NosokV36Capability(
        key: 'internal_nosok_assistant',
        titleAr: 'مساعد نسك الداخلي',
        descriptionAr:
            'مساعد للموظفين يشرح السياسات، يوجه إلى المسارات، ويلخص حالات تشغيلية حسب الصلاحية.',
        runtimeMode: 'internal assistant scope draft',
        integrationTarget: 'assistant internal RBAC-scoped knowledge',
        securityNoteAr:
            'أي استرجاع لبيانات تشغيلية يجب أن يمر عبر AccessProfile ولا يعتمد على ذاكرة عامة.',
        status: 'scope-ready-not-bound',
      ),
      NosokV36Capability(
        key: 'policy_answer_grounding',
        titleAr: 'إجابات موثقة بسياسة الوزارة',
        descriptionAr:
            'ربط إجابات المساعد بنسخة سياسة الموسم المعتمدة، لا باجتهاد حر.',
        runtimeMode: 'knowledge contract',
        integrationTarget: 'assistant + nosok.seasonal_policy snapshot',
        securityNoteAr:
            'كل إجابة حساسة يجب أن تشير إلى سياسة معتمدة أو تقول إن القرار يحتاج لجنة/موظف.',
        status: 'policy-source-required',
      ),
    ],
    campaignCompanyEnhancements: [
      NosokV36Capability(
        key: 'company_season_scorecard',
        titleAr: 'بطاقة أداء الشركة الموسمية',
        descriptionAr:
            'تقييم تشغيلي للشركة حسب السعة، اكتمال الوثائق، الالتزام بالمواعيد، المراسلات، والشكاوى.',
        runtimeMode: 'frontend contract + future aggregate RPC',
        integrationTarget: 'nosok.companies / campaigns / complaints',
        securityNoteAr:
            'لا تظهر تقييمات داخلية للشركات للعامة قبل سياسة نشر واضحة.',
        status: 'ready-as-contract',
      ),
      NosokV36Capability(
        key: 'campaign_capacity_planning',
        titleAr: 'تخطيط سعة الحملات',
        descriptionAr:
            'تحسين توزيع الفائزين على الحملات والمجموعات وفق السعة والشركة والـ LGU والجاهزية.',
        runtimeMode: 'operations model ready',
        integrationTarget: 'nosok.campaigns / groups / lottery_results',
        securityNoteAr:
            'أي إعادة توزيع بعد القرعة تحتاج سببًا وصلاحية وتدقيقًا.',
        status: 'ready-as-contract',
      ),
      NosokV36Capability(
        key: 'partner_workspace_tasks',
        titleAr: 'مهام الشركات الشريكة',
        descriptionAr:
            'تجهيز مساحة عمل للشركة تعرض المطلوب منها: استكمال قوائم، رفع وثائق جماعية، متابعة رسائل الوزارة.',
        runtimeMode: 'company portal enhancement disabled until RBAC',
        integrationTarget: 'company portal + tasks bridge',
        securityNoteAr: 'الشركة ترى نطاقها فقط ولا ترى طلبات شركات أخرى.',
        status: 'candidate-ready-disabled',
      ),
    ],
    uxEnhancements: [
      NosokV36Capability(
        key: 'seasonal_home_summary',
        titleAr: 'ملخص موسمي بدل ازدحام الصفحة',
        descriptionAr:
            'توحيد أولويات الصفحة: حالة الموسم، الإجراء التالي، المواعيد، والتحذيرات، مع إخفاء التفاصيل في accordions/tabs.',
        runtimeMode: 'PWF-SIS UX contract',
        integrationTarget: 'public portal + internal dashboard',
        securityNoteAr: 'لا تعرض الصفحة العامة مؤشرات داخلية أو أرقام حساسة.',
        status: 'applied-as-guidance',
      ),
      NosokV36Capability(
        key: 'mobile_first_tables_to_cards',
        titleAr: 'تحويل الجداول إلى بطاقات على الموبايل',
        descriptionAr:
            'اعتماد قاعدة أن الجداول الثقيلة تعرض كبطاقات مختصرة على الشاشات الصغيرة مع filter drawer.',
        runtimeMode: 'PWF-SIS adaptive pattern',
        integrationTarget: 'requests/reports/companies/documents pages',
        securityNoteAr:
            'لا يتم إخفاء تحذيرات الأمان عند التحويل إلى mobile cards.',
        status: 'pattern-ready',
      ),
      NosokV36Capability(
        key: 'safe_runtime_messages',
        titleAr: 'رسائل تشغيل آمنة',
        descriptionAr:
            'تثبيت نمط رسائل عربية مفهومة بدل raw backend errors في الدفع والوثائق والمساعد والتقارير.',
        runtimeMode: 'error-boundary guidance',
        integrationTarget: 'all seasonal operation surfaces',
        securityNoteAr:
            'لا تعرض stack trace أو PostgREST الخام للمواطن أو الشركة.',
        status: 'applied-as-guidance',
      ),
    ],
    ministryPolicyAddons: [
      NosokV36Capability(
        key: 'seasonal_policy_versioning',
        titleAr: 'نسخ سياسة الموسم',
        descriptionAr:
            'كل موسم يحتفظ بنسخة سياسة مستقلة للشروط والحصص والدفع والاعتراضات والشركات.',
        runtimeMode: 'schema/rpc contract',
        integrationTarget: 'nosok.seasonal_policy_versions',
        securityNoteAr:
            'لا تعديل رجعي على سياسة منشورة إلا بإصدار جديد وتدقيق.',
        status: 'draft-finalized-not-applied',
      ),
      NosokV36Capability(
        key: 'committee_exception_registry',
        titleAr: 'سجل استثناءات لجنة الحج',
        descriptionAr:
            'تجهيز سجل واضح لاستثناءات نقص الحصة، الاعتراضات المقبولة، والإعفاءات الموسمية.',
        runtimeMode: 'committee contract',
        integrationTarget: 'nosok.committee_decisions + audit_events',
        securityNoteAr: 'كل استثناء يحتاج سببًا ومرفقًا وصاحب قرار.',
        status: 'draft-finalized-not-applied',
      ),
      NosokV36Capability(
        key: 'public_announcement_policy',
        titleAr: 'سياسة إعلان النتائج والتعليمات',
        descriptionAr:
            'تحديد ما ينشر للجمهور من تعليمات ونتائج وإعلانات حج وعمرة عبر المركز الإعلامي أو صفحة نسك.',
        runtimeMode: 'content governance contract',
        integrationTarget: 'media_center + nosok public portal',
        securityNoteAr:
            'لا نشر لأسماء أو بيانات حساسة إلا وفق سياسة قانونية واضحة.',
        status: 'policy-approval-required',
      ),
    ],
    runtimeGates: [
      NosokV36RuntimeGate(
        key: 'palwakf_merge_gate',
        titleAr: 'بوابة الدمج مع PalWakf',
        requiredEvidenceAr:
            'تطبيق الحزمة داخل ريبو PalWakf وتشغيل analyzer وChrome داخل المنصة.',
        decisionAr: 'الروابط الخارجية تبقى disabled حتى نجاح الدمج.',
        status: 'pending-palwakf-merge',
      ),
      NosokV36RuntimeGate(
        key: 'nosok_schema_gate',
        titleAr: 'بوابة إنشاء schema نسك',
        requiredEvidenceAr:
            'إنشاء nosok schema في sandbox وتشغيل SQL UAT وRLS/RPC review.',
        decisionAr: 'لا backend binding قبل هذه البوابة.',
        status: 'pending-schema-creation',
      ),
      NosokV36RuntimeGate(
        key: 'ministry_policy_gate',
        titleAr: 'بوابة سياسة الوزارة',
        requiredEvidenceAr:
            'اعتماد شروط الموسم والدفع والحصص والإعلان والاستثناءات.',
        decisionAr: 'أي قواعد موسمية تبقى configurable وليست hardcoded.',
        status: 'policy-approval-required',
      ),
      NosokV36RuntimeGate(
        key: 'role_uat_gate',
        titleAr: 'بوابة Role/Responsive UAT',
        requiredEvidenceAr:
            'اختبار المواطن، الشركة، الموظف، المشرف، المدير، superuser، والمستخدم المقيد على desktop/tablet/mobile.',
        decisionAr: 'لا production candidate قبل إغلاق هذه الأدلة.',
        status: 'uat-required',
      ),
    ],
    acceptanceChecklist: [
      'تقارير متقدمة كعقود تشغيلية دون backend فعلي قبل schema.',
      'ربط الدفع جاهز كـ bridge disabled مع سياسة دفع واسترداد قابلة للاعتماد.',
      'document intelligence جاهز كربط مساعد لا كقرار آلي نهائي.',
      'assistant bridge محدد بنطاق عام/داخلي وبضوابط RBAC.',
      'تحسينات الشركات والحملات جاهزة كـ Partner Workspace contracts.',
      'تحسينات UX الموسمية موثقة تحت PWF-SIS وAnti-Overload.',
      'إضافات سياسة الوزارة قابلة للتعديل حسب الموسم ولا توجد قواعد hardcoded.',
    ],
    remainingBlockers: [
      'PalWakf repo merge evidence غير مرفق بعد.',
      'nosok schema لم يُنشأ عمدًا بانتظار الدمج.',
      'payment/document/assistant integrations غير مفعلة حتى توفر الأنظمة المستهدفة داخل PalWakf.',
      'Role/Responsive Browser UAT داخل المنصة لم يغلق بعد.',
      'اعتماد سياسة الوزارة للحصص والدفع والاستثناءات والإعلان ما زال مطلوبًا.',
    ],
  );
});
