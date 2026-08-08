import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/nosok_v25_candidate_models.dart';

final nosokV25EvidencePackProvider =
    AsyncNotifierProvider<NosokV25CandidateController, NosokV25EvidencePack>(
        NosokV25CandidateController.new);

class NosokV25CandidateController extends AsyncNotifier<NosokV25EvidencePack> {
  @override
  FutureOr<NosokV25EvidencePack> build() => NosokV25EvidencePack.baseline();
}
