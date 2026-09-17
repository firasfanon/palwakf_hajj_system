import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/repositories/nosok_public_wrapper_rpc_adapter.dart';
import '../data/repositories/nosok_supabase_repository.dart';

class NosokV38PublicRuntimeState {
  const NosokV38PublicRuntimeState({
    required this.campaigns,
    required this.requirements,
    required this.runtimeSource,
    required this.campaignsRpcName,
    required this.requirementsRpcName,
    required this.networkEvidenceStatus,
    required this.productionDecision,
    required this.directNosokTableAccessUsed,
    required this.safeMessageAr,
    required this.loadedFromLiveRpc,
  });

  final List<NosokPublicCampaignDto> campaigns;
  final List<NosokPublicRequirementDto> requirements;
  final String runtimeSource;
  final String campaignsRpcName;
  final String requirementsRpcName;
  final String networkEvidenceStatus;
  final String productionDecision;
  final bool directNosokTableAccessUsed;
  final String safeMessageAr;
  final bool loadedFromLiveRpc;

  bool get hasCampaigns => campaigns.isNotEmpty;
  bool get hasRequirements => requirements.isNotEmpty;
}

final nosokV38PublicRuntimeControllerProvider = AsyncNotifierProvider<
    NosokV38PublicRuntimeController, NosokV38PublicRuntimeState>(
  NosokV38PublicRuntimeController.new,
);

class NosokV38PublicRuntimeController
    extends AsyncNotifier<NosokV38PublicRuntimeState> {
  @override
  Future<NosokV38PublicRuntimeState> build() async {
    final mode = ref.watch(nosokRuntimeDataModeProvider);
    final canUseSupabase = mode != NosokRuntimeDataMode.preview;

    if (!canUseSupabase) {
      return _previewState(
        runtimeSource: 'preview-fallback-no-supabase-runtime',
        safeMessageAr:
            'تعمل صفحة نسك العامة بوضع المعاينة لأن Supabase غير مفعّل في هذه البيئة.',
      );
    }

    try {
      final adapter = NosokPublicWrapperRpcAdapter(Supabase.instance.client);
      final campaigns = await adapter.listPublicCampaigns();
      final requirements = await adapter.listPublicRequirements(
        campaignCode: _firstCampaignCode(campaigns),
      );

      return NosokV38PublicRuntimeState(
        campaigns: campaigns,
        requirements: requirements,
        runtimeSource: 'public-rpc-wrapper-runtime',
        campaignsRpcName: 'public.rpc_nosok_campaigns_public_list_v1',
        requirementsRpcName: 'public.rpc_nosok_requirements_public_list_v1',
        networkEvidenceStatus:
            'browser-network-rpc-evidence-closable-when-XHR-shows-these-RPCs',
        productionDecision:
            'production-not-approved-submit-track-negative-evidence-still-required',
        directNosokTableAccessUsed: false,
        safeMessageAr:
            'تم تحميل الحملات والمتطلبات العامة عبر RPC wrappers فقط، دون قراءة مباشرة من nosok.* داخل Flutter.',
        loadedFromLiveRpc: true,
      );
    } catch (error) {
      return _previewState(
        runtimeSource: 'preview-fallback-after-public-rpc-failure',
        safeMessageAr:
            'تعذر إغلاق قراءة RPC الحية في هذه البيئة؛ تم عرض بيانات عامة آمنة للمعاينة دون كشف خطأ خام.',
      );
    }
  }

  NosokV38PublicRuntimeState _previewState({
    required String runtimeSource,
    required String safeMessageAr,
  }) {
    return NosokV38PublicRuntimeState(
      campaigns: _previewCampaigns,
      requirements: _previewRequirements,
      runtimeSource: runtimeSource,
      campaignsRpcName: 'public.rpc_nosok_campaigns_public_list_v1',
      requirementsRpcName: 'public.rpc_nosok_requirements_public_list_v1',
      networkEvidenceStatus: 'network-rpc-evidence-pending-in-current-runtime',
      productionDecision: 'production-not-approved',
      directNosokTableAccessUsed: false,
      safeMessageAr: safeMessageAr,
      loadedFromLiveRpc: false,
    );
  }

  String? _firstCampaignCode(List<NosokPublicCampaignDto> campaigns) {
    if (campaigns.isEmpty) return null;
    final code = campaigns.first.campaignCode.trim();
    if (code.isNotEmpty) return code;
    final id = campaigns.first.id.trim();
    return id.isEmpty ? null : id;
  }
}

const _previewCampaigns = <NosokPublicCampaignDto>[
  NosokPublicCampaignDto(
    id: 'preview-campaign-hajj-1447',
    campaignCode: 'HAJJ-1447-PREVIEW',
    titleAr: 'حملة الحج 1447هـ — معاينة عامة',
    serviceType: 'hajj',
    status: 'published-preview',
    descriptionAr:
        'بطاقة عامة آمنة تظهر عندما لا تكون RPC الحية متاحة في بيئة التشغيل الحالية.',
    seasonYear: 2026,
  ),
  NosokPublicCampaignDto(
    id: 'preview-campaign-umrah-1447',
    campaignCode: 'UMRAH-1447-PREVIEW',
    titleAr: 'حملة العمرة — معاينة عامة',
    serviceType: 'umrah',
    status: 'published-preview',
    descriptionAr:
        'نموذج عرض للعمرة لا يقرأ من جداول nosok مباشرة ولا يمنح اعتماد إنتاج.',
    seasonYear: 2026,
  ),
];

const _previewRequirements = <NosokPublicRequirementDto>[
  NosokPublicRequirementDto(
    id: 'preview-identity',
    titleAr: 'هوية فلسطينية سارية',
    requirementType: 'identity',
    descriptionAr: 'تستخدم للتحقق من العنوان والتجمع السكاني ضمن قواعد الموسم.',
    campaignCode: 'HAJJ-1447-PREVIEW',
  ),
  NosokPublicRequirementDto(
    id: 'preview-passport',
    titleAr: 'جواز سفر ساري',
    requirementType: 'passport',
    descriptionAr: 'تظهر مدة الصلاحية النهائية حسب إعلان الوزارة لكل موسم.',
    campaignCode: 'HAJJ-1447-PREVIEW',
  ),
  NosokPublicRequirementDto(
    id: 'preview-phone',
    titleAr: 'رقم هاتف قابل للتحقق',
    requirementType: 'contact',
    descriptionAr: 'يستخدم للتواصل الرسمي ولا يعرض في التتبع العام.',
    campaignCode: 'HAJJ-1447-PREVIEW',
  ),
  NosokPublicRequirementDto(
    id: 'preview-address',
    titleAr: 'عنوان مطابق للبطاقة الشخصية',
    requirementType: 'lgu-address',
    descriptionAr: 'تُحسب الحصة والقرعة حسب التجمع السكاني المعتمد.',
    campaignCode: 'HAJJ-1447-PREVIEW',
  ),
];
