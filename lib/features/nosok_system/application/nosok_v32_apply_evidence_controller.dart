import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/nosok_v32_apply_evidence_models.dart';

final nosokV32ApplyEvidencePackProvider = AsyncNotifierProvider<
    NosokV32ApplyEvidenceController,
    NosokV32ApplyEvidencePack>(NosokV32ApplyEvidenceController.new);

class NosokV32ApplyEvidenceController
    extends AsyncNotifier<NosokV32ApplyEvidencePack> {
  @override
  FutureOr<NosokV32ApplyEvidencePack> build() =>
      NosokV32ApplyEvidencePack.baseline();
}
