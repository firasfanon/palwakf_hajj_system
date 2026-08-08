import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/nosok_v38f_prejoin_operational_contract.dart';
import '../system_routes.dart';

final nosokV38FPrejoinOperationalContractProvider =
    Provider<NosokV38FPrejoinOperationalContract>((ref) {
  return const NosokV38FPrejoinOperationalContract(
    version: 'v38F',
    adminToolingItems: [
      NosokV38FOperationalItem(
        key: 'homepage_sections_mock_runtime',
        titleAr: 'إدارة أقسام الصفحة الرئيسية — mock runtime',
        descriptionAr:
            'تحويل صفحة أقسام الصفحة الرئيسية من عرض عقد فقط إلى نموذج تشغيل تحضيري يوضح الإظهار والإخفاء والترتيب ونافذة النشر.',
        runtimePreviewAr:
            'يعرض نسك شكل التحكم الإداري المتوقع قبل وجود nosok.homepage_sections الفعلي.',
        backendRequirementAr:
            'يتطلب لاحقًا nosok.homepage_sections + RPC upsert + audit + publish window.',
        statusAr: 'prejoin-ready',
      ),
      NosokV38FOperationalItem(
        key: 'dynamic_pages_builder_mock_runtime',
        titleAr: 'منشئ الصفحات والأقسام — قوالب آمنة',
        descriptionAr:
            'تجهيز مسار إضافة صفحات عامة وأقسام مستقبلية دون الرجوع للمطور، بشرط القوالب والـ slug والنشر والتدقيق.',
        runtimePreviewAr:
            'يعرض سجل قوالب وصفحات وأقسام كمحاكاة إدارية لا تحفظ في قاعدة بيانات.',
        backendRequirementAr:
            'يتطلب لاحقًا page_registry/page_sections/page_actions مع منع HTML أو script حر.',
        statusAr: 'prejoin-ready',
      ),
      NosokV38FOperationalItem(
        key: 'registration_governance_mock_runtime',
        titleAr: 'حوكمة التسجيل — فتح/إغلاق/استكمال/تجميد',
        descriptionAr:
            'تجهيز أداة إدارية توضح أثر انتهاء الفترة القانونية على المواطن والموظف، وتمنع التعديل غير الموثق بعد الإغلاق.',
        runtimePreviewAr:
            'تعرض مراحل الموسم وأثر كل مرحلة على الطلبات دون تنفيذ فعلي.',
        backendRequirementAr:
            'يتطلب registration_governance_windows + admin_override_events + immutable audit.',
        statusAr: 'prejoin-ready',
      ),
      NosokV38FOperationalItem(
        key: 'unit_scope_mock_runtime',
        titleAr: 'نطاق الموظفين حسب slug/LGU',
        descriptionAr:
            'تثبيت أن موظف المديرية يرى فقط سجلات التجمعات التابعة لنطاقه حسب AccessProfile وLGU mapping.',
        runtimePreviewAr:
            'يعرض نموذج بيت لحم/الخليل/القدس كمثال تشغيل بصري فقط.',
        backendRequirementAr:
            'يتطلب PalWakf AccessProfile + core.org_units + LGU snapshot + RPC/RLS.',
        statusAr: 'prejoin-ready',
      ),
    ],
    legalSimulationScenarios: [
      NosokV38FLegalSimulationScenario(
        key: 'single_request_quota',
        titleAr: 'حصة التجمع طلب واحد',
        inputAr: 'LGU حصته طلب واحد، ويوجد أكثر من طلب مؤهل.',
        expectedAr:
            'يطبق الاختيار الأول العشوائي ولا تدخل بقية فروع الخوارزمية.',
        auditAr: 'يسجل branch=single_request_quota وalgorithm_policy_version.',
      ),
      NosokV38FLegalSimulationScenario(
        key: 'two_remaining_three_names',
        titleAr: 'تبقي مقعدين وطلب بثلاثة أسماء',
        inputAr:
            'تبقى مقعدان في التجمع ووقع الاختيار على طلب يحتوي ثلاثة أسماء.',
        expectedAr:
            'يعتمد الطلب وتتوقف قرعة التجمع عند هذا الطلب وفق العقد القانوني.',
        auditAr: 'يسجل legal_overfill_accept_and_stop مع سبب قانوني واضح.',
      ),
      NosokV38FLegalSimulationScenario(
        key: 'two_remaining_one_name',
        titleAr: 'تبقي مقعدين وطلب باسم واحد',
        inputAr: 'تبقى مقعدان ووقع الاختيار على طلب فيه اسم واحد.',
        expectedAr:
            'تبحث الخوارزمية عشوائيًا في طلبات اسم أو اسمين، ثم تنتقل لطلبات ثلاثة أسماء عند عدم وجود مرشح.',
        auditAr: 'يسجل candidate_bucket_search_order=one_or_two_then_three.',
      ),
      NosokV38FLegalSimulationScenario(
        key: 'committee_exception',
        titleAr: 'حالة تحتاج لجنة الحج',
        inputAr:
            'حالة لا يمكن حسمها آليًا أو تتطلب استثناءً موثقًا من السياسة.',
        expectedAr:
            'لا نقل تلقائي للحصة ولا تعديل يدوي؛ ترفع للجنة الحج مع سبب واضح.',
        auditAr: 'يسجل committee_decision_required ولا يسمح بالنشر قبل القرار.',
      ),
    ],
    companyWorkspaceItems: [
      NosokV38FOperationalItem(
        key: 'company_profile_scope',
        titleAr: 'نطاق ممثل الشركة',
        descriptionAr:
            'ممثل الشركة يرى بيانات شركته وحملاته فقط، ولا يرى طلبات شركات أخرى أو تفاصيل غير لازمة للمواطنين.',
        runtimePreviewAr:
            'تعرض بوابة الشركة الأقسام المتوقعة: الملف، الحملات، القوائم، النواقص، الرسائل.',
        backendRequirementAr:
            'يتطلب company_representative identity + company assignment + RLS company_id.',
        statusAr: 'contract-ready',
      ),
      NosokV38FOperationalItem(
        key: 'campaign_capacity_planning',
        titleAr: 'تخطيط الحملات والسعة',
        descriptionAr:
            'تجهيز عقود توزيع الحجاج على الحملات بعد نتائج القرعة واعتماد القوائم.',
        runtimePreviewAr:
            'يعرض dashboard تحضيري للسعات والمقاعد والنواقص دون حفظ فعلي.',
        backendRequirementAr:
            'يتطلب nosok.campaigns + campaign_allocations + admin transition RPC.',
        statusAr: 'contract-ready',
      ),
      NosokV38FOperationalItem(
        key: 'company_documents_messages',
        titleAr: 'وثائق ومراسلات الشركة',
        descriptionAr:
            'تجهيز مسار تواصل آمن بين الوزارة والشركة بخصوص نواقص الحملات والوثائق.',
        runtimePreviewAr: 'يعرض thread تحضيري ورسائل حالة فقط.',
        backendRequirementAr:
            'يتطلب storage policy + company messages + audit events.',
        statusAr: 'contract-ready',
      ),
    ],
    publicResponsiveUatItems: [
      NosokV38FResponsiveUatItem(
        route: NosokSystemRoutes.publicHome,
        desktopExpectationAr: 'Hero واضح، أزرار رئيسية ظاهرة، لا لغة تقنية.',
        mobileExpectationAr: 'الأزرار تتحول إلى عرض مريح، ولا يوجد overflow.',
        consoleExpectationAr:
            'لا أخطاء حمراء؛ تحذير viewport فقط مقبول في Flutter Web.',
        statusAr: 'evidence-ready',
      ),
      NosokV38FResponsiveUatItem(
        route: NosokSystemRoutes.apply,
        desktopExpectationAr: 'نموذج التقديم يظهر بدون Stepper runtime crash.',
        mobileExpectationAr:
            'Progress bar/steps لا تتجاوز العرض وتبقى قابلة للنقر.',
        consoleExpectationAr: 'لا RenderFlex ولا Unexpected null.',
        statusAr: 'retest-required',
      ),
      NosokV38FResponsiveUatItem(
        route: NosokSystemRoutes.track,
        desktopExpectationAr: 'متابعة الطلب بنموذج مختصر وحماية خصوصية.',
        mobileExpectationAr: 'حقل التتبع والزر بعرض مناسب.',
        consoleExpectationAr: 'لا raw backend errors.',
        statusAr: 'evidence-ready',
      ),
      NosokV38FResponsiveUatItem(
        route: NosokSystemRoutes.lotteryResults,
        desktopExpectationAr: 'النتائج تعرض كبحث آمن دون كشف بيانات الآخرين.',
        mobileExpectationAr: 'بطاقات مختصرة لا جداول مزدحمة.',
        consoleExpectationAr: 'لا errors، لا ألوان وردية.',
        statusAr: 'evidence-ready',
      ),
      NosokV38FResponsiveUatItem(
        route: NosokSystemRoutes.companies,
        desktopExpectationAr: 'الشركات المؤهلة تظهر كدليل عام لا كلوحة إدارة.',
        mobileExpectationAr: 'البطاقات تتكدس عموديًا بشكل نظيف.',
        consoleExpectationAr: 'لا errors ولا بيانات داخلية.',
        statusAr: 'evidence-ready',
      ),
    ],
    prejoinGates: [
      'إغلاق Public Runtime UAT للصفحات العامة والإجرائية دون RenderFlex أو overflow.',
      'إثبات أن أدوات الإدارة تحضيرية ولا تدعي تنفيذ schema/RPC قبل الاستضافة داخل PalWakf.',
      'تثبيت محاكاة خوارزمية الحج القانونية كـ preview فقط، والتنفيذ الحقيقي لاحقًا عبر RPC مدقق.',
      'إغلاق نطاق الشركات كشروط وواجهات تحضيرية، دون تمكين وصول شركة حقيقي قبل RBAC/RLS.',
      'تحديث Join Package النهائي ليُسلَّم لمسار منصة PalWakf، لا ليُنفذ داخل نسك.',
    ],
    schemaContracts: [
      NosokV38FSchemaContract(
          objectName: 'nosok.homepage_sections',
          objectType: 'table',
          ownerAr: 'admin content / public safe view',
          statusAr: 'draft not applied'),
      NosokV38FSchemaContract(
          objectName: 'nosok.page_registry',
          objectType: 'table',
          ownerAr: 'dynamic pages admin',
          statusAr: 'draft not applied'),
      NosokV38FSchemaContract(
          objectName: 'nosok.registration_governance_windows',
          objectType: 'table',
          ownerAr: 'season governance',
          statusAr: 'draft not applied'),
      NosokV38FSchemaContract(
          objectName: 'nosok.rpc_lottery_algorithm_simulate_v1',
          objectType: 'rpc',
          ownerAr: 'legal lottery contract',
          statusAr: 'draft not deployed'),
      NosokV38FSchemaContract(
          objectName: 'nosok.company_representative_assignments',
          objectType: 'table',
          ownerAr: 'company workspace',
          statusAr: 'draft not applied'),
      NosokV38FSchemaContract(
          objectName: 'nosok.public_runtime_uat_evidence',
          objectType: 'table/view',
          ownerAr: 'evidence center',
          statusAr: 'draft not applied'),
    ],
  );
});
