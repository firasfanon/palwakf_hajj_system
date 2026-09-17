import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/nosok_v38_public_runtime_contract.dart';

final nosokV38PublicRuntimeContractProvider =
    Provider<NosokV38PublicRuntimeContract>((ref) {
  return const NosokV38PublicRuntimeContract(
    version: 'v38',
    decision:
        'PUBLIC_CAMPAIGNS_REQUIREMENTS_RUNTIME_ADAPTER_INTEGRATED_NETWORK_RPC_EVIDENCE_CLOSABLE_PRODUCTION_DEFERRED',
    adapterIntegrations: [
      NosokV38AdapterIntegration(
        surface: '/services/nosok',
        rpcName: 'public.rpc_nosok_campaigns_public_list_v1',
        flutterEntry:
            'NosokPublicHomePage -> nosokV38PublicRuntimeControllerProvider',
        statusAr: 'مربوط بواجهة المواطن عبر Adapter آمن',
        noteAr:
            'تظهر الحملات العامة من RPC wrapper فقط، مع fallback آمن إذا تعذر الاتصال.',
      ),
      NosokV38AdapterIntegration(
        surface: '/services/nosok/requirements',
        rpcName: 'public.rpc_nosok_requirements_public_list_v1',
        flutterEntry:
            'NosokRequirementsPage -> nosokV38PublicRuntimeControllerProvider',
        statusAr: 'مربوط بواجهة المتطلبات العامة',
        noteAr:
            'يدعم p_campaign_code وp_campaign_id ثم fallback parameterless حسب شكل RPC الحالي.',
      ),
    ],
    networkEvidenceCases: [
      NosokV38NetworkEvidenceCase(
        caseKey: 'N38_NET_001',
        route: '/services/nosok',
        expectedRpc: 'rpc_nosok_campaigns_public_list_v1',
        expectedNetworkFilter: 'XHR/fetch + rpc_nosok_campaigns_public_list_v1',
        evidenceStatusAr:
            'قابل للإغلاق بعد لقطة Network فعلية تظهر نداء RPC وHTTP 200/204 دون raw error.',
      ),
      NosokV38NetworkEvidenceCase(
        caseKey: 'N38_NET_002',
        route: '/services/nosok/requirements',
        expectedRpc: 'rpc_nosok_requirements_public_list_v1',
        expectedNetworkFilter:
            'XHR/fetch + rpc_nosok_requirements_public_list_v1',
        evidenceStatusAr:
            'قابل للإغلاق بعد لقطة Network فعلية تظهر نداء RPC وpayload public-safe.',
      ),
      NosokV38NetworkEvidenceCase(
        caseKey: 'N38_NET_003',
        route: '/services/nosok/requirements',
        expectedRpc: 'no direct nosok.* table request',
        expectedNetworkFilter:
            'Network لا يحتوي REST /nosok/campaigns أو /nosok/eligibility_rules',
        evidenceStatusAr:
            'يجب أن يؤكد المشغّل غياب direct table REST calls من واجهة Flutter العامة.',
      ),
    ],
    productionGateItems: [
      NosokV38ProductionGateItem(
        key: 'public_campaigns_requirements_runtime',
        titleAr: 'تشغيل الحملات والمتطلبات العامة',
        status: 'closed-by-code-pending-actual-network-screenshot',
        reasonAr:
            'الواجهتان أصبحتا تقرآن عبر public RPC Adapter مع fallback آمن ودون nosok.* direct read.',
      ),
      NosokV38ProductionGateItem(
        key: 'submit_track_privacy',
        titleAr: 'خصوصية submit/track العام',
        status: 'pending',
        reasonAr:
            'لم تُقدّم في هذه الدفعة أدلة Network/Browser لإرسال طلب حقيقي وتتبع public-safe.',
      ),
      NosokV38ProductionGateItem(
        key: 'role_scope_negative',
        titleAr: 'أدلة no-role/wrong-scope السلبية',
        status: 'pending',
        reasonAr:
            'ما زالت أدلة actor identity وwrong-unit/no-role مطلوبة قبل أي اعتماد إنتاج.',
      ),
      NosokV38ProductionGateItem(
        key: 'production_approval',
        titleAr: 'اعتماد الإنتاج',
        status: 'not-approved',
        reasonAr:
            'إغلاق campaigns/requirements لا يكفي لاعتماد الإنتاج الكامل لنظام نسك.',
      ),
    ],
    boundaryRules: [
      'لا direct nosok.* read من Flutter للصفحات العامة التي عولجت في v38.',
      'public هو سطح RPC/view wrappers فقط وليس مالك بيانات.',
      'لا service_role داخل Flutter ولا أسرار في الكود.',
      'لا إنشاء public base tables ولا DDL/DML في هذه الدفعة.',
      'لا مساس بـ waqf_assets أو waqf أو awqaf_system.',
      'Production approval يبقى محجوبًا حتى إغلاق submit/track privacy وأدلة الدور/النطاق.',
    ],
  );
});
