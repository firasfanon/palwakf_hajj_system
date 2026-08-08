import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/nosok_supabase_repository.dart';
import '../domain/models/nosok_service_program.dart';

final nosokProgramsControllerProvider =
    AsyncNotifierProvider<NosokProgramsController, List<NosokServiceProgram>>(
  NosokProgramsController.new,
);

final nosokPublicProgramsProvider =
    FutureProvider.family<List<NosokServiceProgram>, NosokPublicProgramsFilter>(
        (ref, filter) {
  return ref.read(nosokRepositoryProvider).listPrograms(
        seasonId: filter.seasonId,
        publicOnly: true,
        serviceType: filter.serviceType,
      );
});

class NosokPublicProgramsFilter {
  const NosokPublicProgramsFilter({this.seasonId, this.serviceType});

  final String? seasonId;
  final String? serviceType;

  @override
  bool operator ==(Object other) {
    return other is NosokPublicProgramsFilter &&
        other.seasonId == seasonId &&
        other.serviceType == serviceType;
  }

  @override
  int get hashCode => Object.hash(seasonId, serviceType);
}

class NosokProgramsController extends AsyncNotifier<List<NosokServiceProgram>> {
  String? _seasonId;

  @override
  Future<List<NosokServiceProgram>> build() async {
    return ref.read(nosokRepositoryProvider).listPrograms();
  }

  Future<void> refreshList({String? seasonId}) async {
    _seasonId = seasonId ?? _seasonId;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(nosokRepositoryProvider).listPrograms(seasonId: _seasonId),
    );
  }

  Future<void> saveProgram(NosokServiceProgram program) async {
    await ref.read(nosokRepositoryProvider).saveProgram(program);
    await refreshList(seasonId: _seasonId);
    ref.invalidate(
        nosokPublicProgramsProvider(const NosokPublicProgramsFilter()));
  }

  Future<void> deleteProgram(String id) async {
    await ref.read(nosokRepositoryProvider).deleteProgram(id);
    await refreshList(seasonId: _seasonId);
    ref.invalidate(
        nosokPublicProgramsProvider(const NosokPublicProgramsFilter()));
  }
}
