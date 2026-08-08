import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/nosok_v28_owner_schema_models.dart';

final nosokV28OwnerSchemaDesignPackProvider = AsyncNotifierProvider<
    NosokV28OwnerSchemaController,
    NosokV28OwnerSchemaDesignPack>(NosokV28OwnerSchemaController.new);

class NosokV28OwnerSchemaController
    extends AsyncNotifier<NosokV28OwnerSchemaDesignPack> {
  @override
  FutureOr<NosokV28OwnerSchemaDesignPack> build() =>
      NosokV28OwnerSchemaDesignPack.baseline();
}
