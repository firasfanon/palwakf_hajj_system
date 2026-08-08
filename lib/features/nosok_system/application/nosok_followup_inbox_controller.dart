import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/nosok_supabase_repository.dart';
import '../domain/models/nosok_followup_inbox_item.dart';

final nosokFollowupInboxStatusFilterProvider =
    StateProvider<String?>((ref) => null);
final nosokFollowupInboxUnitFilterProvider =
    StateProvider<String?>((ref) => null);

final nosokFollowupInboxProvider =
    FutureProvider<List<NosokFollowupInboxItem>>((ref) {
  final status = ref.watch(nosokFollowupInboxStatusFilterProvider);
  final unitId = ref.watch(nosokFollowupInboxUnitFilterProvider);
  return ref
      .read(nosokRepositoryProvider)
      .listFollowupInbox(status: status, unitId: unitId);
});

final nosokFollowupInboxControllerProvider =
    AsyncNotifierProvider<NosokFollowupInboxController, void>(
        NosokFollowupInboxController.new);

class NosokFollowupInboxController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<NosokFollowupInboxItem> updateFollowupInboxItem({
    required String followupId,
    required String status,
    String? assignedUnitId,
    String? resolutionNoteAr,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() {
      return ref.read(nosokRepositoryProvider).updateFollowupInboxItem(
            followupId: followupId,
            status: status,
            assignedUnitId: assignedUnitId,
            resolutionNoteAr: resolutionNoteAr,
          );
    });
    state = result.whenData((_) {});
    if (result.hasError) {
      Error.throwWithStackTrace(result.error!, result.stackTrace!);
    }
    ref.invalidate(nosokFollowupInboxProvider);
    return result.requireValue;
  }
}
