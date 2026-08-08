import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/nosok_v24_uat_models.dart';

final nosokV24UatPackProvider =
    AsyncNotifierProvider<NosokV24UatController, NosokV24UatPack>(
        NosokV24UatController.new);

class NosokV24UatController extends AsyncNotifier<NosokV24UatPack> {
  @override
  FutureOr<NosokV24UatPack> build() => NosokV24UatPack.baseline();
}
