import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/nosok_supabase_repository.dart';
import '../domain/models/nosok_season.dart';

final nosokSeasonsControllerProvider =
    AsyncNotifierProvider<NosokSeasonsController, List<NosokSeason>>(
  NosokSeasonsController.new,
);

final nosokPublicSeasonsProvider = FutureProvider<List<NosokSeason>>((ref) {
  return ref.read(nosokRepositoryProvider).listSeasons(publicOnly: true);
});

class NosokSeasonsController extends AsyncNotifier<List<NosokSeason>> {
  @override
  Future<List<NosokSeason>> build() async {
    return ref.read(nosokRepositoryProvider).listSeasons();
  }

  Future<void> refreshList() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(nosokRepositoryProvider).listSeasons(),
    );
  }

  Future<void> saveSeason(NosokSeason season) async {
    await ref.read(nosokRepositoryProvider).saveSeason(season);
    await refreshList();
    ref.invalidate(nosokPublicSeasonsProvider);
  }

  Future<void> deleteSeason(String id) async {
    await ref.read(nosokRepositoryProvider).deleteSeason(id);
    await refreshList();
    ref.invalidate(nosokPublicSeasonsProvider);
  }
}
