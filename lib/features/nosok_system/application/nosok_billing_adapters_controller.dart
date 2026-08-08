import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/nosok_supabase_repository.dart';
import '../domain/models/nosok_billing_provider_adapter.dart';

final nosokBillingProviderAdaptersProvider =
    FutureProvider.autoDispose<List<NosokBillingProviderAdapter>>((ref) {
  return ref.watch(nosokRepositoryProvider).listBillingProviderAdapters();
});

final nosokBillingAdapterCommandProvider = AutoDisposeAsyncNotifierProvider<
    NosokBillingAdapterCommandController, void>(
  NosokBillingAdapterCommandController.new,
);

class NosokBillingAdapterCommandController
    extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> runHealthCheck(String adapterId) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(() async {
      await ref
          .read(nosokRepositoryProvider)
          .runBillingProviderAdapterHealthCheck(adapterId: adapterId);
      ref.invalidate(nosokBillingProviderAdaptersProvider);
    });
  }
}
