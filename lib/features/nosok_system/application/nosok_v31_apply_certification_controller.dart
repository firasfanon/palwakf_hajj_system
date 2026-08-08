import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/nosok_v31_apply_certification_models.dart';

final nosokV31ApplyCertificationPackProvider = AsyncNotifierProvider<
    NosokV31ApplyCertificationController,
    NosokV31ApplyCertificationPack>(NosokV31ApplyCertificationController.new);

class NosokV31ApplyCertificationController
    extends AsyncNotifier<NosokV31ApplyCertificationPack> {
  @override
  FutureOr<NosokV31ApplyCertificationPack> build() =>
      NosokV31ApplyCertificationPack.baseline();
}
