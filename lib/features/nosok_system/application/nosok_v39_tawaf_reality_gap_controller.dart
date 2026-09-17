import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/nosok_v39_tawaf_reality_gap_contract.dart';

final nosokV39TawafRealityGapContractProvider =
    Provider<NosokV39TawafRealityGapContract>((ref) {
  return const NosokV39TawafRealityGapContract(
    version: 'v39-tawaf-public-reality-gap',
    decision: 'NOSOK_V39_ADMINISTRATIVE_UNIT_SCOPE_RECONCILED_PRODUCTION_DEFERRED',
    summaryAr:
        'تم إغلاق أدلة الحملات والمتطلبات والتتبع العام عبر RPC الحية، ومصالحة نطاق الوحدة الإدارية على canonical orgUnitId مع governorate مشتقة وLGU fail-closed. التقديم الحي ما زال مؤجلًا: لا توجد حملة مفتوحة، وعقد تخزين PII غير معتمد. كما بقي drift إداري قديم في seasons/programs، وbackend طابور الوحدات غير متاح، والتكاملات السيادية الخارجية غير منفذة.',
    observedPublicSources: [
      NosokV39ObservedPublicSource(
        sourceKey: 'TWF_SRC_001',
        titleAr: 'شروط وطريقة تسجيل حج 1448هـ/2027م',
        url: 'https://nosok.pal-wakf.ps/pilgrimage.php',
        observedSignalAr:
            'الصفحة العامة تعرض قواعد الموسم: عدم الحج سابقًا، فوق 16 سنة، عدم تكرار الطلب، دفع 1000 دينار، مرافقان بحد أقصى، العنوان حسب السجل المدني، هوية فلسطينية/مقدسية، OTP، إرفاق الهوية المقدسية، كود دفع وبنك، ورسالة قبول بعد الدفع.',
        status: 'public-observed-contract-only',
        adapterImplicationAr:
            'يلزم فصل قواعد الموسم إلى Seasonal Rule Pack مرتبط بمصدر رسمي ونسخة زمنية، ولا يجوز تمثيلها كقواعد ثابتة داخل الواجهة فقط.',
      ),
      NosokV39ObservedPublicSource(
        sourceKey: 'TWF_SRC_002',
        titleAr: 'فحص التسجيل العام',
        url: 'https://nosok.pal-wakf.ps/check_register.php',
        observedSignalAr:
            'السطح العام يطلب رقم الهوية أو رقم التسجيل لفحص التسجيل، وهذا يختلف عن tracking-token-only privacy model في v38.',
        status: 'public-observed-privacy-gap',
        adapterImplicationAr:
            'أي دعم لاحق لفحص الهوية يحتاج RPC privacy envelope، rate limits، masking، وnegative evidence قبل الإنتاج.',
      ),
      NosokV39ObservedPublicSource(
        sourceKey: 'TWF_SRC_003',
        titleAr: 'الشركات المؤهلة',
        url: 'https://nosok.pal-wakf.ps/company.php',
        observedSignalAr:
            'الصفحة تعرض دليلًا عامًا لشركات الحج والعمرة مع الاسم ورقم الهاتف والمحافظة/العنوان.',
        status: 'public-observed-directory-gap',
        adapterImplicationAr:
            'يلزم Company Directory Import/Versioning contract قبل عرض directory حي من مصدر رسمي أو مزامنته داخليًا.',
      ),
      NosokV39ObservedPublicSource(
        sourceKey: 'TWF_SRC_004',
        titleAr: 'دخول الشركات',
        url: 'https://nosok.pal-wakf.ps/company/',
        observedSignalAr:
            'بوابة الشركات تعرض username/password وCaptcha قبل تسجيل الدخول.',
        status: 'public-observed-auth-gap',
        adapterImplicationAr:
            'لا يجوز محاكاة دخول الشركات كصفحة داخلية بسيطة؛ يلزم Company Auth + Captcha/session threat model وأدلة منع bot/credential replay.',
      ),
    ],
    realityGaps: [
      NosokV39RealityGapItem(
        key: 'GAP_CIVIL_REGISTRY_ADDRESS',
        domainAr: 'السجل المدني والعنوان',
        officialSignalAr:
            'العنوان المعتمد حسب الهوية وبيانات السجل المدني، ومراجعة المديرية عند غياب التجمع.',
        nosokV38StateAr:
            'نموذج نسك يملك حقول عنوان ومتابعة، لكنه لا يملك Authority binding فعلي للسجل المدني أو التجمعات.',
        adapterDecisionAr:
            'إضافة Civil Registry Boundary Adapter كعقد evidence فقط دون أي اتصال فعلي.',
        evidenceRequiredAr:
            'read-only registry contract، allowlist محافظات/تجمعات، negative test لعنوان غير مخول، وسجل مصدر رسمي.',
      ),
      NosokV39RealityGapItem(
        key: 'GAP_IDENTITY_TYPES',
        domainAr: 'أنواع الهوية',
        officialSignalAr:
            'تحديد هوية فلسطينية أو هوية مقدسية، وإرفاق صورة الهوية المقدسية.',
        nosokV38StateAr:
            'يوجد مسار مرفقات عام، لكن لا توجد سياسة تشغيل مغلقة لهوية مقدسية/فلسطينية وربط تخزين آمن.',
        adapterDecisionAr:
            'تعريف Identity Evidence Contract منفصل عن نموذج الطلب الحالي.',
        evidenceRequiredAr:
            'upload storage policy، mime/size limits، signed URL absence from public track، وحذف الحقول الحساسة من Network.',
      ),
      NosokV39RealityGapItem(
        key: 'GAP_OTP_SMS',
        domainAr: 'OTP/SMS',
        officialSignalAr:
            'إدخال رقم الهاتف والرمز المرسل، ورسالة قبول بعد الدفع.',
        nosokV38StateAr:
            'الإشعارات ومزوداتها موجودة كعقود، لكن OTP runtime provider غير مثبت.',
        adapterDecisionAr:
            'إضافة OTP Provider Evidence Adapter كمسار مشروط بمزود معتمد.',
        evidenceRequiredAr:
            'provider receipt، delivery receipt، retry/expiry policy، negative tests لرمز منتهي وخاطئ ومكرر.',
      ),
      NosokV39RealityGapItem(
        key: 'GAP_PAYMENT_RECONCILIATION',
        domainAr: 'الدفع البنكي/eSadad',
        officialSignalAr:
            'قبول الطلب بعد دفع 1000 دينار، نسخ رمز الدفع، الدفع عبر بنك أو eSadad، ورسالة قبول بعد الدفع.',
        nosokV38StateAr:
            'جسر الدفع موجود كتصور/إدارة داخلية، وليس تسوية دفع رسمية.',
        adapterDecisionAr: 'تعريف Payment Reconciliation Matrix لا تكامل دفع.',
        evidenceRequiredAr:
            'payment-code generation، bank/eSadad callback contract، idempotency، refund semantics، reconciliation report.',
      ),
      NosokV39RealityGapItem(
        key: 'GAP_MAHRAM_COMPANIONS',
        domainAr: 'المحرم والمرافقون',
        officialSignalAr:
            'بدء التسجيل بالمحرم الذكر، اعتماد عنوان المحرم أو الزوج، ومرافقان بحد أقصى.',
        nosokV38StateAr:
            'توجد نماذج Companion، لكن enforcement الرسمي غير مغلق على backend.',
        adapterDecisionAr:
            'إضافة Workflow/Constraint Evidence لحالات المرافقين دون تغيير قاعدة البيانات.',
        evidenceRequiredAr:
            'backend rejection لأكثر من مرافقين، positive/negative mahram flow، audit reason لكل رفض.',
      ),
      NosokV39RealityGapItem(
        key: 'GAP_DUPLICATE_REQUESTS',
        domainAr: 'منع التكرار',
        officialSignalAr:
            'منع تسجيل المواطن في أكثر من طلب واعتماد الطلب الأول فقط.',
        nosokV38StateAr:
            'لا يوجد إثبات constraint رسمي ضد duplicate identity/application.',
        adapterDecisionAr:
            'تحويلها إلى DB/RPC uniqueness evidence قبل أي production.',
        evidenceRequiredAr:
            'unique key/functional index أو RPC idempotency، وسيناريو تكرار يثبت اعتماد الطلب الأول فقط.',
      ),
      NosokV39RealityGapItem(
        key: 'GAP_COMPANY_CAPTCHA_PORTAL',
        domainAr: 'بوابة الشركات/Captcha',
        officialSignalAr: 'دخول الشركات يظهر username/password وCaptcha.',
        nosokV38StateAr:
            'بوابة الشركات الحالية staging سطح إدارة/دليل، لا تمثل Captcha/session الرسمي.',
        adapterDecisionAr:
            'تجميد أي ادعاء تكافؤ مع بوابة الشركات الرسمية حتى اعتماد Auth/Captcha Evidence.',
        evidenceRequiredAr:
            'captcha challenge proof، login denial proof، session expiry، wrong company scope, no scraping bypass.',
      ),
      NosokV39RealityGapItem(
        key: 'GAP_LOTTERY_RESULTS',
        domainAr: 'القرعة وفحص النتائج',
        officialSignalAr: 'يوجد فحص قرعة ضمن الأسطح العامة للموقع الرسمي.',
        nosokV38StateAr:
            'نسك يملك قرعة/سياسات ومحاكاة، لكن لا يملك نتيجة رسمية أو تشغيل قرعة audit-safe.',
        adapterDecisionAr:
            'القرعة تبقى planned/contract-only حتى توفر authority result feed أو authorization.',
        evidenceRequiredAr:
            'algorithm audit، seed custody، official result source، public-safe lookup، وnegative privacy evidence.',
      ),
    ],
    evidenceMatrix: [
      NosokV39EvidenceCase(
        caseKey: 'V39_CIV_001',
        domainAr: 'Civil Registry',
        surface: '/services/nosok/apply',
        expectedSignalAr:
            'لا ينجح إرسال الطلب بعناوين غير مطابقة لمصدر رسمي أو خارج allowed registry scope.',
        negativeProbeAr:
            'عنوان غير موجود / تجمع مفقود / محافظة لا تطابق هوية صاحب الطلب.',
        status: 'matrix-ready-authority-integration-required',
        acceptanceEvidenceAr:
            'لقطة Network/RPC تظهر رفضًا masked وآمنًا دون كشف بيانات سجل مدني.',
      ),
      NosokV39EvidenceCase(
        caseKey: 'V39_ID_001',
        domainAr: 'Identity Documents',
        surface: '/services/nosok/apply',
        expectedSignalAr:
            'الهوية المقدسية تتطلب مرفقًا، والهوية الفلسطينية لا تكشف صورة أو document URL في التتبع العام.',
        negativeProbeAr:
            'هوية مقدسية دون مرفق / ملف نوعه غير مسموح / حجم غير مقبول.',
        status: 'matrix-ready-storage-policy-required',
        acceptanceEvidenceAr:
            'Storage policy + Network proof لغياب signed URL من public track.',
      ),
      NosokV39EvidenceCase(
        caseKey: 'V39_OTP_001',
        domainAr: 'OTP/SMS',
        surface: '/services/nosok/apply',
        expectedSignalAr:
            'طلب OTP وتحقق OTP يتمان عبر provider/RPC آمن مع expiry/retry limit.',
        negativeProbeAr:
            'رمز خاطئ / رمز منتهي / رمز مستخدم سابقًا / رقم هاتف غير صالح.',
        status: 'matrix-ready-provider-required',
        acceptanceEvidenceAr:
            'provider receipt آمن + عدم ظهور OTP في logs أو client payload بعد التحقق.',
      ),
      NosokV39EvidenceCase(
        caseKey: 'V39_PAY_001',
        domainAr: 'Payment',
        surface: '/services/nosok/apply + payment bridge',
        expectedSignalAr:
            'إنشاء رمز دفع ثم قبول الطلب بعد تسوية bank/eSadad فقط.',
        negativeProbeAr:
            'callback مكرر / مبلغ ناقص / رمز دفع غير معروف / محاولة قبول دون دفع.',
        status: 'matrix-ready-payment-provider-required',
        acceptanceEvidenceAr:
            'payment reconciliation report + idempotency proof + safe SMS acceptance proof.',
      ),
      NosokV39EvidenceCase(
        caseKey: 'V39_COMP_001',
        domainAr: 'Company Directory',
        surface: '/services/nosok/companies',
        expectedSignalAr:
            'الدليل العام للشركات يستند إلى source snapshot بنسخة وتاريخ، لا بيانات hardcoded بلا مصدر.',
        negativeProbeAr:
            'شركة مكررة / فرع بلا parent / رقم هاتف placeholder / محافظة غير معروفة.',
        status: 'matrix-ready-import-versioning-required',
        acceptanceEvidenceAr:
            'import manifest + checksum + diff report بين المصدر العام والنسخة المعروضة.',
      ),
      NosokV39EvidenceCase(
        caseKey: 'V39_AUTH_001',
        domainAr: 'Company Portal + Captcha',
        surface:
            '/services/nosok/company-login أو /admin/systems/nosok/companies',
        expectedSignalAr:
            'لا يوجد ادعاء تكافؤ مع بوابة الشركات الرسمية قبل إثبات Captcha/session/auth.',
        negativeProbeAr:
            'wrong password / missing captcha / expired captcha / company tries other company scope.',
        status: 'matrix-ready-auth-threat-model-required',
        acceptanceEvidenceAr:
            'browser evidence لدورة login denied/expired + no bypass/no elevated token in Flutter.',
      ),
      NosokV39EvidenceCase(
        caseKey: 'V39_LOT_001',
        domainAr: 'Lottery',
        surface: '/services/nosok/lottery-results أو /services/nosok/track',
        expectedSignalAr:
            'فحص القرعة يعيد نتيجة عامة آمنة فقط من مصدر رسمي/خوارزمية مدققة.',
        negativeProbeAr:
            'هوية غير مشاركة / رقم تسجيل خاطئ / محاولة enumeration / نتيجة قبل النشر.',
        status: 'matrix-ready-official-result-feed-required',
        acceptanceEvidenceAr:
            'rate limit proof + response masking + audit trail للقرعة أو source result feed.',
      ),
      NosokV39EvidenceCase(
        caseKey: 'V39_RPC_001',
        domainAr: 'Public RPC Runtime',
        surface: '/services/nosok + /services/nosok/requirements',
        expectedSignalAr:
            'campaigns/requirements عبر RPC عامة فقط دون direct table REST.',
        negativeProbeAr:
            'إعادة تحميل كاملة مع Network capture وفحص absence of direct nosok table calls.',
        status: 'pass-network-200-no-direct-table',
        acceptanceEvidenceAr:
            'POST campaigns=200 وrequirements=200، direct-table=0، external-authority=0، browser exceptions=0.',
      ),
      NosokV39EvidenceCase(
        caseKey: 'V39_TRACK_001',
        domainAr: 'Track Privacy',
        surface: '/services/nosok/track',
        expectedSignalAr:
            'rpc_nosok_application_track_v1 فقط وباستجابة عامة غير حساسة.',
        negativeProbeAr:
            'رمز تتبع غير موجود مع منع أي fallback إلى nosok.applications.',
        status: 'pass-network-200-no-direct-table',
        acceptanceEvidenceAr:
            'POST track=200، direct applications REST=0، external calls=0، والـRPC يعيد tracking/campaign/service/status فقط.',
      ),
      NosokV39EvidenceCase(
        caseKey: 'V39_SUBMIT_001',
        domainAr: 'Submit Runtime',
        surface: '/services/nosok/apply',
        expectedSignalAr:
            'rpc_nosok_application_submit_v1 مع campaign contract معتمد وPII storage contract صريح.',
        negativeProbeAr:
            'campaign غير مفتوحة + تحقق من عدم زيادة nosok.applications.',
        status: 'partial-negative-pass-success-blocked',
        acceptanceEvidenceAr:
            'الـRPC موجود وممنوح للـanon/authenticated؛ negative submit رجع HTTP 400 وعدد التطبيقات بقي 0. لا successful submit لعدم وجود حملة مفتوحة، وPII metadata محظور محليًا.',
      ),
      NosokV39EvidenceCase(
        caseKey: 'V39_SCOPE_001',
        domainAr: 'RBAC / Unit Scope',
        surface:
            '/admin/systems/nosok/v39-tawaf-reality-gap + /admin/systems/nosok/units/:unitId',
        expectedSignalAr:
            'anonymous/no-role/wrong-permission denied؛ التفويض بالـcanonical orgUnitId يسمح لمديرية بيت لحم ويرفض مديرية الخليل، والـslug alias فقط.',
        negativeProbeAr:
            'فتح الروابط مباشرة عبر URL دون الاعتماد على إخفاء زر الواجهة.',
        status: 'pass-canonical-org-unit-negative-uat-lgu-fail-closed',
        acceptanceEvidenceAr:
            'canonical Bethlehem orgUnitId=1b39cc65-dc74-401f-a431-1fbf78cfbd0e ALLOW، Hebron orgUnitId=8e0238db-2e20-49d4-8cf2-db7c376d512b DENY؛ slug=bth alias فقط؛ governorate مشتقة من core؛ LGU fail-closed لحين mapping صريح.',
      ),
      NosokV39EvidenceCase(
        caseKey: 'V39_ADMIN_DRIFT_001',
        domainAr: 'Admin Schema Alignment',
        surface: '/admin/systems/nosok/*',
        expectedSignalAr:
            'Admin adapters تعتمد campaign/core.org_units الحالية ولا تعيد seasons/service_programs/unit_service_scopes legacy.',
        negativeProbeAr: 'تشغيل admin surfaces ومراقبة 404/direct fallback.',
        status: 'blocked-legacy-schema-drift',
        acceptanceEvidenceAr:
            'ما زالت rpc_nosok_admin_unit_scopes_v1 وunit_service_scopes legacy تعيدان 404، وأجزاء Admin seasons/programs مرتبطة بنموذج قديم.',
      ),
      NosokV39EvidenceCase(
        caseKey: 'V39_PROD_001',
        domainAr: 'Production Gate',
        surface: '/admin/systems/nosok/v39-tawaf-reality-gap',
        expectedSignalAr:
            'الصفحة تعرض أن v39 contract/evidence فقط وأن الإنتاج غير معتمد.',
        negativeProbeAr: 'anonymous/no-role/wrong-scope لا يرى لوحة v39.',
        status: 'browser-role-scope-evidence-pass-production-deferred',
        acceptanceEvidenceAr:
            'flutter analyze PASS + Browser RBAC matrix PASS + unit-scope denial PASS؛ Production مؤجل لبقية blockers.',
      ),
    ],
    productionGateItems: [
      NosokV39GateItem(
        key: 'public_reality_gap_adapter',
        titleAr: 'Adapter فجوات الواقع العام',
        status: 'contract-integrated',
        reasonAr:
            'تم تحويل الفجوات العامة إلى عقد تشغيل ومصفوفة أدلة داخلية دون تكامل خارجي.',
      ),
      NosokV39GateItem(
        key: 'civil_registry',
        titleAr: 'السجل المدني والعنوان',
        status: 'not-integrated-authority-required',
        reasonAr: 'لا يوجد مصدر سيادي أو authorization أو read-only proof.',
      ),
      NosokV39GateItem(
        key: 'otp_sms',
        titleAr: 'OTP/SMS',
        status: 'not-integrated-provider-required',
        reasonAr: 'لا يوجد مزود SMS/OTP مع receipt وnegative evidence.',
      ),
      NosokV39GateItem(
        key: 'payment_bank_esadad',
        titleAr: 'الدفع البنكي/eSadad',
        status: 'not-integrated-provider-required',
        reasonAr: 'لا توجد تسوية فعلية أو callback/idempotency evidence.',
      ),
      NosokV39GateItem(
        key: 'company_captcha',
        titleAr: 'بوابة الشركات/Captcha',
        status: 'not-integrated-security-required',
        reasonAr: 'لا توجد دورة Auth/Captcha/session رسمية مثبتة.',
      ),
      NosokV39GateItem(
        key: 'lottery',
        titleAr: 'القرعة الرسمية',
        status: 'not-integrated-authority-required',
        reasonAr: 'لا توجد نتيجة رسمية أو خوارزمية/seed custody مدققة.',
      ),
      NosokV39GateItem(
        key: 'production_approval',
        titleAr: 'اعتماد الإنتاج',
        status: 'not-approved',
        reasonAr:
            'v39 أغلق مصفوفة الفجوات فقط. الإنتاج يتطلب تكاملات وأدلة تشغيل فعلية لاحقة.',
      ),
    ],
    boundaryRules: [
      'لا scraping ولا تجاوز Captcha ولا استخدام بيانات اعتماد أو جلسات طرف ثالث.',
      'لا جلب بيانات مواطنين أو طلبات غير منشورة علنًا.',
      'لا اتصال فعلي بالسجل المدني أو SMS أو الدفع أو بوابة الشركات في هذه الدفعة.',
      'لا DDL/DML/GRANT/REVOKE ولا service_role ولا platformHosted switch.',
      'لا public base tables ولا direct citizen Flutter read من nosok.*.',
      'لا اعتماد إنتاج ولا Join approval ولا mutation على waqf_assets/waqf/awqaf_system.',
      'Tawaf/Nosok official public site is treated as reference evidence, not as runtime dependency.',
    ],
    localRetestCommands: [
      'dart format lib/features/nosok_system/domain/models/nosok_v39_tawaf_reality_gap_contract.dart lib/features/nosok_system/application/nosok_v39_tawaf_reality_gap_controller.dart lib/features/nosok_system/presentation/pages/admin/nosok_admin_v39_tawaf_reality_gap_page.dart lib/features/nosok_system/system_routes.dart lib/features/nosok_system/presentation/routes/nosok_routes.dart lib/features/nosok_system/system_navigation.dart',
      'flutter analyze',
      'flutter run -d chrome',
      'افتح /admin/systems/nosok/v39-tawaf-reality-gap بمستخدم يملك redecideNosokProductionGate.',
      'نفّذ anonymous/no-role/wrong-scope للصفحة نفسها واحفظ Browser evidence.',
      'راجع DevTools Network للتأكد أن الصفحة لا تستدعي tawaf/nosok official site ولا أي endpoint خارجي.',
    ],
  );
});
