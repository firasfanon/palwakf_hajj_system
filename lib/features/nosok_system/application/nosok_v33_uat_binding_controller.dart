import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/nosok_v33_uat_binding_models.dart';

final nosokV33UatBindingPackProvider =
    AsyncNotifierProvider<NosokV33UatBindingController, NosokV33UatBindingPack>(
        NosokV33UatBindingController.new);

class NosokV33UatBindingController
    extends AsyncNotifier<NosokV33UatBindingPack> {
  @override
  FutureOr<NosokV33UatBindingPack> build() => NosokV33UatBindingPack.baseline();
}
