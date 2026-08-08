import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/nosok_supabase_repository.dart';
import '../domain/models/nosok_public_tracking_privacy_check.dart';

final nosokTrackingPrivacyChecksProvider =
    FutureProvider.autoDispose<List<NosokPublicTrackingPrivacyCheck>>((ref) {
  return ref.watch(nosokRepositoryProvider).listPublicTrackingPrivacyChecks();
});

final nosokTrackingPrivacyCommandProvider = AutoDisposeAsyncNotifierProvider<
    NosokTrackingPrivacyCommandController, void>(
  NosokTrackingPrivacyCommandController.new,
);

class NosokTrackingPrivacyCommandController
    extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> markReviewed({
    required String checkKey,
    required String status,
    String? evidenceNote,
  }) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(() async {
      await ref.read(nosokRepositoryProvider).savePublicTrackingPrivacyReview(
            checkKey: checkKey,
            status: status,
            evidenceNote: evidenceNote,
          );
      ref.invalidate(nosokTrackingPrivacyChecksProvider);
    });
  }
}
