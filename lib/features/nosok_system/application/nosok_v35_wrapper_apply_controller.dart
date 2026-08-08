import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/nosok_v35_wrapper_apply_models.dart';

final nosokV35WrapperApplyPackProvider = AsyncNotifierProvider<
    NosokV35WrapperApplyController,
    NosokV35WrapperApplyPack>(NosokV35WrapperApplyController.new);

class NosokV35WrapperApplyController
    extends AsyncNotifier<NosokV35WrapperApplyPack> {
  @override
  FutureOr<NosokV35WrapperApplyPack> build() =>
      NosokV35WrapperApplyPack.baseline();
}
