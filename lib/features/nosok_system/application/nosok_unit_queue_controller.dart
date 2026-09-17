import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/nosok_supabase_repository.dart';
import '../domain/models/nosok_unit_application_queue_item.dart';

class NosokUnitQueueFilter {
  const NosokUnitQueueFilter({this.unitId, this.status});

  final String? unitId;
  final String? status;

  NosokUnitQueueFilter copyWith({String? unitId, String? status}) {
    return NosokUnitQueueFilter(
      unitId: unitId ?? this.unitId,
      status: status ?? this.status,
    );
  }
}

final nosokUnitQueueFilterProvider =
    StateProvider<NosokUnitQueueFilter>((ref) => const NosokUnitQueueFilter());

final nosokUnitApplicationQueueProvider =
    FutureProvider<List<NosokUnitApplicationQueueItem>>((ref) {
  final filter = ref.watch(nosokUnitQueueFilterProvider);
  return ref.read(nosokRepositoryProvider).listUnitApplicationQueue(
        unitId: filter.unitId,
        unitSlug: null,
        status: filter.status,
      );
});
