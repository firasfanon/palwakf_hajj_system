import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/nosok_v38_final_production_gate_contract.dart';

final nosokV38FinalProductionGateContractProvider =
    Provider<NosokV38FinalProductionGateContract>((ref) {
  return const NosokV38FinalProductionGateContract(
    version: 'v38-final',
    decision:
        'SUBMIT_TRACK_PRIVACY_HARDENED_NEGATIVE_UAT_MATRIX_PREPARED_PRODUCTION_NOT_APPROVED_PENDING_ACTUAL_BROWSER_EVIDENCE',
    summaryAr:
        'تم إغلاق الخلل البرمجي في Adapter العام، وحصر submit/track في public RPC wrappers دون fallback مباشر إلى nosok.* من واجهة المواطن. بوابة الإنتاج النهائية لا تعتمد الإنتاج لأن أدلة المتصفح والشبكة السلبية يجب تشغيلها محليًا وتزويد نتائجها.',
    privacyNetworkCases: [
      NosokV38EvidenceCase(
        caseKey: 'N38_PRIV_001',
        surface: '/services/nosok/apply',
        expectedSignal:
            'XHR/fetch rpc_nosok_public_submit_application_v1 فقط، دون REST direct إلى /nosok/applications',
        status: 'code-hardened-browser-evidence-required',
        noteAr:
            'إرسال الطلب أصبح يعتمد RPC فقط في NosokSupabaseRepository؛ أي فشل RPC يعرض رسالة آمنة ولا ينفذ DML مباشر من Flutter.',
      ),
      NosokV38EvidenceCase(
        caseKey: 'N38_PRIV_002',
        surface: '/services/nosok/track',
        expectedSignal:
            'XHR/fetch rpc_nosok_public_application_status_by_token_v1 فقط، ودون REST direct إلى /nosok/applications',
        status: 'code-hardened-browser-evidence-required',
        noteAr:
            'تم حذف fallback القراءة المباشرة الذي كان يطلب حقولًا حساسة مثل الاسم والهوية والهاتف من surface المواطن.',
      ),
      NosokV38EvidenceCase(
        caseKey: 'N38_PRIV_003',
        surface: '/services/nosok/track',
        expectedSignal:
            'Response public-safe: application_no/status/eligibility/service/submitted_at فقط؛ لا national_id ولا phone/mobile/email ولا document URLs',
        status: 'sql-and-network-proof-required',
        noteAr:
            'الصفحة لا تعرض الحقول الحساسة، لكن الاعتماد النهائي يحتاج إثباتًا من Network/SQL أن RPC نفسه لا يعيدها.',
      ),
    ],
    negativeUatCases: [
      NosokV38EvidenceCase(
        caseKey: 'N38_NEG_001',
        surface: '/admin/systems/nosok/v38-public-runtime-evidence',
        expectedSignal: 'anonymous/no-session denied by NosokAccessGate',
        status: 'browser-evidence-required',
        noteAr:
            'يجب فتح الرابط دون جلسة والتقاط شاشة منع الدخول أو إعادة التوجيه الآمنة.',
      ),
      NosokV38EvidenceCase(
        caseKey: 'N38_NEG_002',
        surface: '/admin/systems/nosok/v38-final-production-gate',
        expectedSignal: 'authenticated user without redecideNosokProductionGate denied',
        status: 'browser-evidence-required',
        noteAr:
            'المستخدم العام أو موظف بلا صلاحية قرار الإنتاج لا يرى لوحة القرار النهائي.',
      ),
      NosokV38EvidenceCase(
        caseKey: 'N38_NEG_003',
        surface: '/admin/systems/nosok/role-uat',
        expectedSignal: 'wrong-role denied or limited by permission keys',
        status: 'browser-evidence-required',
        noteAr:
            'إغلاق role/scope يحتاج actor name + role + route + denial reason من المتصفح.',
      ),
      NosokV38EvidenceCase(
        caseKey: 'N38_NEG_004',
        surface: '/admin/systems/nosok/unit-queues',
        expectedSignal: 'wrong-unit/wrong-scope cannot view or mutate another unit queue',
        status: 'browser-and-network-evidence-required',
        noteAr:
            'يجب إثبات absence of unsafe 200 responses عند استخدام ممثل وحدة خاطئة.',
      ),
    ],
    productionGateItems: [
      NosokV38GateItem(
        key: 'campaigns_requirements_runtime',
        titleAr: 'تشغيل الحملات والمتطلبات العامة',
        status: 'code-integrated-network-proof-pending',
        reasonAr:
            'تم الربط عبر public RPC wrappers، لكن لقطة Network الفعلية لا تزال مطلوبة.',
      ),
      NosokV38GateItem(
        key: 'submit_track_privacy',
        titleAr: 'خصوصية submit/track العام',
        status: 'code-hardened-proof-pending',
        reasonAr:
            'تم منع direct fallback، لكن يجب إثبات RPC response shape وغياب الحقول الحساسة من Network.',
      ),
      NosokV38GateItem(
        key: 'role_scope_negative_uat',
        titleAr: 'Role/Scope Negative UAT',
        status: 'matrix-prepared-evidence-pending',
        reasonAr:
            'تم تحديد حالات no-role/wrong-scope، ولم تُرفق لقطات تشغيل محلية بعد.',
      ),
      NosokV38GateItem(
        key: 'compile_runtime_retest',
        titleAr: 'فحص compile/runtime المحلي',
        status: 'required',
        reasonAr:
            'بيئة الحاوية لا تحتوي Flutter؛ يلزم dart format + flutter analyze + flutter run محليًا.',
      ),
      NosokV38GateItem(
        key: 'production_approval',
        titleAr: 'اعتماد الإنتاج',
        status: 'not-approved',
        reasonAr:
            'لا اعتماد إنتاج قبل أدلة Network/Browser/Negative فعلية مع analyzer/run ناجحين.',
      ),
    ],
    boundaryRules: [
      'public submit/track في SupabaseRepository لا يستخدمان fallback مباشر إلى nosok.* من واجهة المواطن.',
      'public schema يبقى سطح RPC wrappers فقط، وليس مالك بيانات.',
      'لا service_role ولا مفاتيح مرتفعة داخل Flutter.',
      'لا DDL/DML/GRANT/REVOKE في هذه الدفعة.',
      'لا platformHosted switch ولا Join كامل إلى PalWakf في هذه الحزمة.',
      'لا مساس بـ waqf_assets أو waqf أو awqaf_system.',
    ],
    localRetestCommands: [
      'dart format lib/features/nosok_system/data/repositories/nosok_public_wrapper_rpc_adapter.dart lib/features/nosok_system/data/repositories/nosok_supabase_repository.dart lib/features/nosok_system/domain/models/nosok_v38_final_production_gate_contract.dart lib/features/nosok_system/application/nosok_v38_final_production_gate_controller.dart lib/features/nosok_system/presentation/pages/admin/nosok_admin_v38_final_production_gate_page.dart lib/features/nosok_system/system_routes.dart lib/features/nosok_system/presentation/routes/nosok_routes.dart lib/features/nosok_system/system_navigation.dart',
      'flutter analyze',
      'flutter run -d chrome',
      'فتح DevTools Network ثم اختبار /services/nosok/apply و/services/nosok/track بعد reload أو submit/track فعلي.',
      'اختبار anonymous/no-role/wrong-scope على /admin/systems/nosok/v38-final-production-gate و/role-uat و/unit-queues.',
    ],
  );
});
