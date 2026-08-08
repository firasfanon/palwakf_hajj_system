import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/nosok_v36_binding_models.dart';

final nosokV36BindingPackProvider =
    AsyncNotifierProvider<NosokV36BindingController, NosokV36BindingPack>(
        NosokV36BindingController.new);

class NosokV36BindingController extends AsyncNotifier<NosokV36BindingPack> {
  @override
  FutureOr<NosokV36BindingPack> build() => NosokV36BindingPack.baseline();
}
