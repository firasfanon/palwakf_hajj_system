import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/nosok_v29_authorization_models.dart';

final nosokV29AuthorizationPackProvider = AsyncNotifierProvider<
    NosokV29AuthorizationController,
    NosokV29AuthorizationPack>(NosokV29AuthorizationController.new);

class NosokV29AuthorizationController
    extends AsyncNotifier<NosokV29AuthorizationPack> {
  @override
  FutureOr<NosokV29AuthorizationPack> build() =>
      NosokV29AuthorizationPack.baseline();
}
