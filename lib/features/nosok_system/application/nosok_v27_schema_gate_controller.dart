import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/nosok_v27_schema_gate_models.dart';

final nosokV27SchemaGatePackProvider =
    AsyncNotifierProvider<NosokV27SchemaGateController, NosokV27SchemaGatePack>(
        NosokV27SchemaGateController.new);

class NosokV27SchemaGateController
    extends AsyncNotifier<NosokV27SchemaGatePack> {
  @override
  FutureOr<NosokV27SchemaGatePack> build() => NosokV27SchemaGatePack.baseline();
}
