import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/nosok_v30_apply_gate_models.dart';

final nosokV30ApplyGatePackProvider =
    AsyncNotifierProvider<NosokV30ApplyGateController, NosokV30ApplyGatePack>(
        NosokV30ApplyGateController.new);

class NosokV30ApplyGateController extends AsyncNotifier<NosokV30ApplyGatePack> {
  @override
  FutureOr<NosokV30ApplyGatePack> build() => NosokV30ApplyGatePack.baseline();
}
