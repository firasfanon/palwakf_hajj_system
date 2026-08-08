import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/nosok_v37_runtime_switch_models.dart';

final nosokV37RuntimeSwitchPackProvider = AsyncNotifierProvider<
    NosokV37RuntimeSwitchController,
    NosokV37RuntimeSwitchPack>(NosokV37RuntimeSwitchController.new);

class NosokV37RuntimeSwitchController
    extends AsyncNotifier<NosokV37RuntimeSwitchPack> {
  @override
  FutureOr<NosokV37RuntimeSwitchPack> build() =>
      NosokV37RuntimeSwitchPack.baseline();
}
