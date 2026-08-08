import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/nosok_supabase_repository.dart';
import '../domain/models/nosok_notification_provider_adapter_uat.dart';

final nosokNotificationProviderAdaptersProvider =
    FutureProvider<List<NosokNotificationProviderAdapter>>((ref) {
  return ref.read(nosokRepositoryProvider).listNotificationProviderAdapters();
});

final nosokNotificationProviderUatResultsProvider =
    FutureProvider.family<List<NosokNotificationProviderUatResult>, String?>(
        (ref, providerKey) {
  return ref
      .read(nosokRepositoryProvider)
      .listNotificationProviderUatResults(providerKey: providerKey);
});

final nosokNotificationProviderUatControllerProvider =
    AsyncNotifierProvider<NosokNotificationProviderUatController, void>(
        NosokNotificationProviderUatController.new);

class NosokNotificationProviderUatController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<NosokNotificationProviderUatResult> run({
    required String providerKey,
    required String testKey,
    String? evidenceUrl,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() {
      return ref
          .read(nosokRepositoryProvider)
          .runNotificationProviderAdapterUat(
            providerKey: providerKey,
            testKey: testKey,
            evidenceUrl: evidenceUrl,
          );
    });
    state = result.whenData((_) {});
    if (result.hasError) {
      Error.throwWithStackTrace(result.error!, result.stackTrace!);
    }
    ref.invalidate(nosokNotificationProviderAdaptersProvider);
    ref.invalidate(nosokNotificationProviderUatResultsProvider(providerKey));
    ref.invalidate(nosokNotificationProviderUatResultsProvider(null));
    return result.requireValue;
  }
}
