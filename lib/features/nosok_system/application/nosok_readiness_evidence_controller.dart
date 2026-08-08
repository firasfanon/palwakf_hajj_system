import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/nosok_supabase_repository.dart';
import '../domain/models/nosok_production_readiness_evidence.dart';

final nosokProductionReadinessEvidenceProvider =
    FutureProvider.autoDispose<List<NosokProductionReadinessEvidence>>((ref) {
  return ref.watch(nosokRepositoryProvider).listProductionReadinessEvidence();
});

final nosokReadinessEvidenceCommandProvider = AutoDisposeAsyncNotifierProvider<
    NosokReadinessEvidenceCommandController, void>(
  NosokReadinessEvidenceCommandController.new,
);

class NosokReadinessEvidenceCommandController
    extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> save(NosokProductionReadinessEvidence evidence) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(() async {
      await ref
          .read(nosokRepositoryProvider)
          .saveProductionReadinessEvidence(evidence);
      ref.invalidate(nosokProductionReadinessEvidenceProvider);
    });
  }
}
