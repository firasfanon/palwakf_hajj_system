import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/nosok_legal_lottery_regulation_contract.dart';

final nosokLegalLotteryRegulationContractProvider =
    Provider<NosokLegalLotteryRegulationContract>((ref) {
  return const NosokLegalLotteryRegulationContract(
    version: 'v38E',
    regulationTitleAr: 'نظام تنظيم شؤون الحج رقم (15) لسنة 2025م',
    regulationNumber: '15',
    regulationYear: '2025',
    sourceNameAr: 'منشور عبر مقام/جريدة الوقائع الفلسطينية - العدد 233',
    publicationReferenceAr:
        'الوقائع الفلسطينية، العدد 233، صفحة 12، تاريخ النشر 2025-12-29',
    statusAr: 'ساري النفاذ في الضفة الغربية وغزة حسب المصدر القانوني المنشور',
    prejoinDecisionAr:
        'يجب تعديل عقد قرعة نسك قبل أي انضمام للمنصة حتى لا تبقى الخوارزمية السابقة وحدها هي المرجع.',
    registrationRules: [
      NosokLegalRegistrationRule(
        key: 'one_application_only',
        titleAr: 'طلب تسجيل واحد فقط',
        contractAr:
            'يعتمد النظام طلبًا واحدًا للمواطن، وعند التكرار يعالج الطلب الأول كمرجع بحسب سياسة التسجيل القانونية.',
        uiImpactAr:
            'تظهر للمواطن رسالة واضحة بأن التسجيل مرة واحدة، وأن التكرار لا يمنح أولوية إضافية.',
        backendImpactAr:
            'يتطلب unique identity key + duplicate detection + audit event قبل قبول الطلب في pool القرعة.',
      ),
      NosokLegalRegistrationRule(
        key: 'previous_hajj_exclusion_except_mahram',
        titleAr: 'استبعاد من أدى الحج سابقًا مع استثناء المحرم',
        contractAr:
            'الأصل استبعاد من أدى الحج سابقًا، مع استثناء المحرم وفق السياسة القانونية والموسمية المعتمدة.',
        uiImpactAr:
            'نموذج الطلب يطلب إفادة الحج السابق ودور الشخص داخل الطلب، ولا يعرض قرارًا نهائيًا من الواجهة فقط.',
        backendImpactAr:
            'يتطلب lookup مؤهلية وسبب استثناء محفوظ في eligibility snapshot.',
      ),
      NosokLegalRegistrationRule(
        key: 'minimum_age_and_companions',
        titleAr: 'العمر والمرافقون',
        contractAr:
            'الحد الأدنى للعمر 16 سنة في العقد القانوني الحالي، وحد المرافقين موسمي/قانوني ويجب أن يبقى قابلًا للتعديل.',
        uiImpactAr:
            'النموذج يوضح العمر وحد المرافقين دون hardcode بصري غير قابل للتغيير لاحقًا.',
        backendImpactAr:
            'يقرأ min_age/max_companions من registration_policy_versions لا من كود Flutter.',
      ),
      NosokLegalRegistrationRule(
        key: 'identity_address_lgu_registration',
        titleAr: 'التسجيل حسب عنوان البطاقة الشخصية/LGU',
        contractAr:
            'يعتمد نطاق القرعة على العنوان في البطاقة الشخصية، مع دعم إثبات السكن عند اختلاف العنوان حسب السياسة.',
        uiImpactAr:
            'يعرض للمواطن التجمع المعتمد وسبب الربط، ولا يسمح باختيار تجمع أسهل للقرعة.',
        backendImpactAr:
            'يتطلب normalized LGU snapshot + address evidence + unitSlug mapping + audit.',
      ),
      NosokLegalRegistrationRule(
        key: 'fee_and_mutable_season_policy',
        titleAr: 'بدل الخدمات وتغير الشروط',
        contractAr:
            'قبول الطلب مرتبط بسياسة الرسوم/بدل الخدمات، وشروط التسجيل قابلة للتغيير حسب مستجدات الموسم والمملكة.',
        uiImpactAr:
            'تظهر حالة الرسوم والسياسة الموسمية كمعلومة، ولا يدعي النظام فتح خدمة غير مفعلة.',
        backendImpactAr:
            'يتطلب policy version + payment bridge + refund/exception rules لاحقًا بعد الربط الحقيقي.',
      ),
    ],
    algorithmRules: [
      NosokLegalLotteryAlgorithmRule(
        key: 'algorithm_definition_required',
        titleAr: 'تعريف الخوارزمية كعقد حاكم',
        ruleAr:
            'القرعة ليست اختيارًا عشوائيًا عامًا فقط؛ يجب أن تكون خطوات رياضية/منطقية معلنة في contract وتنفذ عبر RPC مدقق.',
        previousModelImpactAr:
            'نموذج capacity-aware السابق يبقى أساسًا لكنه ليس كافيًا وحده.',
        requiredRuntimeGuardAr:
            'إضافة algorithm_policy_version وdraw_simulation_events وaudit hash قبل أي تنفيذ حقيقي.',
      ),
      NosokLegalLotteryAlgorithmRule(
        key: 'first_random_selection_ignores_remaining_quota',
        titleAr: 'الاختيار الأول العشوائي قبل محددات الحصة المتبقية',
        ruleAr:
            'كل طلب يخضع لاختيار عشوائي أولي، ولا يبدأ تطبيق محددات الحصة المتبقية بنفس الصرامة من أول خطوة.',
        previousModelImpactAr:
            'يمنع اعتبار الحصة المتبقية قيدًا مطلقًا من بداية القرعة.',
        requiredRuntimeGuardAr:
            'تسجيل مرحلة initial_random_pick لكل LGU في simulation/audit events.',
      ),
      NosokLegalLotteryAlgorithmRule(
        key: 'single_request_quota_bypass',
        titleAr: 'حصة طلب واحد',
        ruleAr:
            'إذا كانت حصة التجمع السكاني طلبًا واحدًا، يطبق الاختيار الأول ولا تخضع الحالة لباقي محددات الخوارزمية.',
        previousModelImpactAr:
            'لا تستخدم قواعد البحث عن تركيب أشخاص داخل الحصة في هذه الحالة.',
        requiredRuntimeGuardAr:
            'RPC draw يجب أن يفرع الحالة إلى single_request_quota branch مع audit.',
      ),
      NosokLegalLotteryAlgorithmRule(
        key: 'two_remaining_three_person_accept_stop',
        titleAr: 'تبقي مقعدين واختيار طلب بثلاثة أسماء',
        ruleAr:
            'إذا تبقى من حصة التجمع مقعدان ووقع الاختيار على طلب يحتوي ثلاثة أسماء، يعتمد الطلب وتتوقف قرعة التجمع عند هذا الطلب.',
        previousModelImpactAr:
            'يصَحح قاعدة نسك السابقة التي كانت تمنع أي تجاوز للحصة كقاعدة مطلقة.',
        requiredRuntimeGuardAr:
            'إضافة legal_overfill_accept_and_stop مع سبب قانوني وsnapshot في draw results.',
      ),
      NosokLegalLotteryAlgorithmRule(
        key: 'two_remaining_one_person_search_rule',
        titleAr: 'تبقي مقعدين واختيار طلب باسم واحد',
        ruleAr:
            'إذا تبقى مقعدان ووقع الاختيار على طلب باسم واحد، تبحث الخوارزمية عن طلب فيه اسم واحد أو اثنان عشوائيًا، وإذا لم تجد تنتقل لطلبات ثلاثة أسماء عشوائيًا.',
        previousModelImpactAr:
            'يستبدل البحث البسيط عن أي طلب يناسب السعة بفرع قانوني مرتب.',
        requiredRuntimeGuardAr:
            'تسجيل candidate_bucket_search_order: one_or_two_then_three داخل audit.',
      ),
      NosokLegalLotteryAlgorithmRule(
        key: 'committee_and_publication_controls',
        titleAr: 'ضوابط اللجنة والنشر',
        ruleAr:
            'لا تنشر النتائج أو تعدل القرعة أو تعيد تشغيلها دون policy version وقرار لجنة وسجل تدقيق عند الحاجة.',
        previousModelImpactAr:
            'يبقى شرط لجنة الحج عند الاستثناءات لكن يجب ربطه بمواد النظام لا كقرار UI فقط.',
        requiredRuntimeGuardAr:
            'committee_decision_required + immutable draw run + publication window.',
      ),
    ],
    impactDecisions: [
      NosokLegalImpactDecision(
        areaAr: 'نموذج الحصة',
        oldContractAr: 'لا يتجاوز مجموع الأشخاص الحصة دائمًا.',
        newContractAr:
            'الحصة محكومة بالخوارزمية القانونية، وقد يوجد overfill قانوني عند تبقي مقعدين واختيار طلب بثلاثة أسماء.',
        statusAr: 'must-update-before-join',
      ),
      NosokLegalImpactDecision(
        areaAr: 'محرك القرعة',
        oldContractAr: 'Capacity-aware draw فقط.',
        newContractAr:
            'Legal algorithm branches + capacity awareness + committee/audit.',
        statusAr: 'contract-updated-v38E',
      ),
      NosokLegalImpactDecision(
        areaAr: 'سياسة التسجيل',
        oldContractAr: 'شروط موسمية قابلة للتعديل بصورة عامة.',
        newContractAr:
            'نسخة سياسة تسجيل قانونية مرتبطة بنظام 15/2025 وبنوافذ الموسم والتعليمات.',
        statusAr: 'contract-updated-v38E',
      ),
      NosokLegalImpactDecision(
        areaAr: 'صفحات المشروع',
        oldContractAr: 'لا توجد صفحة قانون مستقلة.',
        newContractAr:
            'صفحة قانون عامة مختصرة + صفحة امتثال قانوني إدارية + صفحة v38E.',
        statusAr: 'applied',
      ),
    ],
    requiredTables: [
      NosokLegalSchemaContract(
          name: 'nosok.legal_regulation_versions',
          type: 'table',
          purposeAr:
              'تخزين مرجع النظام القانوني ونسخته وحالة النفاذ وروابط المصدر.',
          statusAr: 'draft / not applied'),
      NosokLegalSchemaContract(
          name: 'nosok.registration_policy_versions',
          type: 'table',
          purposeAr:
              'سياسات التسجيل القانونية والموسمية: العمر، الحج السابق، المرافقون، العنوان، الرسوم.',
          statusAr: 'draft / not applied'),
      NosokLegalSchemaContract(
          name: 'nosok.lottery_algorithm_rules',
          type: 'table',
          purposeAr:
              'فروع خوارزمية القرعة القانونية وترتيب تطبيقها حسب الموسم.',
          statusAr: 'draft / not applied'),
      NosokLegalSchemaContract(
          name: 'nosok.lottery_draw_simulation_events',
          type: 'table',
          purposeAr:
              'سجل محاكاة القرعة قبل التشغيل الحقيقي لإثبات الفروع والخطوات.',
          statusAr: 'draft / not applied'),
      NosokLegalSchemaContract(
          name: 'nosok.legal_compliance_audit_events',
          type: 'table',
          purposeAr:
              'سجل مراجعات الامتثال القانوني وتحديثات السياسة والتجاوزات.',
          statusAr: 'draft / not applied'),
    ],
    requiredRpcs: [
      NosokLegalSchemaContract(
          name: 'nosok.rpc_legal_regulation_active_v1',
          type: 'rpc',
          purposeAr:
              'إرجاع النظام القانوني النشط وسياسة التسجيل/القرعة المربوطة به.',
          statusAr: 'draft / not deployed'),
      NosokLegalSchemaContract(
          name: 'nosok.rpc_lottery_algorithm_simulate_v1',
          type: 'rpc',
          purposeAr: 'محاكاة خوارزمية القرعة قانونيًا قبل التنفيذ الحقيقي.',
          statusAr: 'draft / not deployed'),
      NosokLegalSchemaContract(
          name: 'nosok.rpc_lottery_draw_execute_v1',
          type: 'rpc',
          purposeAr:
              'تنفيذ القرعة بفروع النظام القانوني مع audit hash وcommittee gates.',
          statusAr: 'draft / not deployed'),
      NosokLegalSchemaContract(
          name: 'nosok.rpc_registration_policy_validate_v1',
          type: 'rpc',
          purposeAr: 'فحص طلب التسجيل مقابل سياسة القانون والموسم.',
          statusAr: 'draft / not deployed'),
    ],
    implementationGates: [
      'لا يجوز الانضمام إلى المنصة قبل تحديث عقد القرعة القانوني داخل نسك.',
      'لا يجوز إنشاء schema أو RPC قبل استضافة نسك داخل PalWakf واعتماد schema creation pack.',
      'لا يجوز تنفيذ القرعة من Flutter أو UI؛ التنفيذ الحقيقي يجب أن يكون RPC مدققًا.',
      'يجب أن تحمل كل قرعة algorithm_policy_version وregistration_policy_version وquota_snapshot_id.',
      'أي اختلاف بين سياسة الموسم والنظام القانوني يجب أن يمر عبر لجنة الحج وسجل تدقيق.',
      'صفحة القانون داخل المشروع لا تغني عن الرجوع للنص الرسمي المنشور عند الاعتماد القانوني النهائي.',
    ],
  );
});
