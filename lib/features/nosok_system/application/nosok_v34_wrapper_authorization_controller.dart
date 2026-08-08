import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/nosok_v34_wrapper_authorization_models.dart';

final nosokV34WrapperAuthorizationPackProvider = AsyncNotifierProvider<
        NosokV34WrapperAuthorizationController,
        NosokV34WrapperAuthorizationPack>(
    NosokV34WrapperAuthorizationController.new);

class NosokV34WrapperAuthorizationController
    extends AsyncNotifier<NosokV34WrapperAuthorizationPack> {
  @override
  FutureOr<NosokV34WrapperAuthorizationPack> build() =>
      NosokV34WrapperAuthorizationPack.baseline();
}
