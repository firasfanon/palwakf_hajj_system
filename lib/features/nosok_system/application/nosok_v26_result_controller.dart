import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/nosok_v26_result_models.dart';

final nosokV26ResultPackProvider =
    AsyncNotifierProvider<NosokV26ResultController, NosokV26ResultPack>(
        NosokV26ResultController.new);

class NosokV26ResultController extends AsyncNotifier<NosokV26ResultPack> {
  @override
  FutureOr<NosokV26ResultPack> build() => NosokV26ResultPack.baseline();
}
