import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/repositories/nosok_public_wrapper_rpc_adapter.dart';

enum NosokV37PublicRepositoryBindingMode {
  previewFallback,
  standaloneSupabaseDevelopmentCandidate,
  platformHostedBlocked,
}

class NosokV37PublicRepositoryBindingCandidate {
  const NosokV37PublicRepositoryBindingCandidate({
    required this.mode,
    required this.adapter,
    required this.canReadPublicCampaigns,
    required this.canReadPublicRequirements,
    required this.canSubmitPublicApplication,
    required this.canTrackPublicApplication,
    required this.reasonAr,
  });

  final NosokV37PublicRepositoryBindingMode mode;
  final NosokPublicWrapperRpcAdapter adapter;
  final bool canReadPublicCampaigns;
  final bool canReadPublicRequirements;
  final bool canSubmitPublicApplication;
  final bool canTrackPublicApplication;
  final String reasonAr;

  bool get isPlatformHosted =>
      mode == NosokV37PublicRepositoryBindingMode.platformHostedBlocked;
}

final nosokV37PublicRepositoryBindingCandidateProvider =
    Provider<NosokV37PublicRepositoryBindingCandidate>((ref) {
  final adapter = NosokPublicWrapperRpcAdapter(Supabase.instance.client);
  return NosokV37PublicRepositoryBindingCandidate(
    mode: NosokV37PublicRepositoryBindingMode
        .standaloneSupabaseDevelopmentCandidate,
    adapter: adapter,
    canReadPublicCampaigns: true,
    canReadPublicRequirements: true,
    canSubmitPublicApplication: false,
    canTrackPublicApplication: false,
    reasonAr:
        'v37 يجهز switch candidate للقراءة العامة فقط. submit/track وplatformHosted binding ما زالت محجوبة حتى UAT.',
  );
});
