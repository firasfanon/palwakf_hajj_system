import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/nosok_supabase_repository.dart';
import '../domain/models/nosok_notification_dispatch.dart';

final nosokNotificationDispatchStatusFilterProvider =
    StateProvider<String?>((ref) => null);

final nosokNotificationDispatchesProvider =
    FutureProvider<List<NosokNotificationDispatch>>((ref) {
  final status = ref.watch(nosokNotificationDispatchStatusFilterProvider);
  return ref
      .read(nosokRepositoryProvider)
      .listNotificationDispatches(status: status);
});

final nosokNotificationDispatchControllerProvider =
    AsyncNotifierProvider<NosokNotificationDispatchController, void>(
        NosokNotificationDispatchController.new);

class NosokNotificationDispatchController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<NosokNotificationDispatch> create({
    required String eventKey,
    required String templateKey,
    required String relatedEntityType,
    required String relatedEntityId,
    String channel = 'in_app',
    String recipientScope = 'citizen',
    String? payloadPreviewAr,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() {
      return ref.read(nosokRepositoryProvider).createNotificationDispatch(
            eventKey: eventKey,
            templateKey: templateKey,
            relatedEntityType: relatedEntityType,
            relatedEntityId: relatedEntityId,
            channel: channel,
            recipientScope: recipientScope,
            payloadPreviewAr: payloadPreviewAr,
          );
    });
    state = result.whenData((_) {});
    if (result.hasError) {
      Error.throwWithStackTrace(result.error!, result.stackTrace!);
    }
    ref.invalidate(nosokNotificationDispatchesProvider);
    return result.requireValue;
  }

  Future<NosokNotificationDispatch> mark({
    required String dispatchId,
    required String status,
    String? providerReference,
    String? errorMessage,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() {
      return ref.read(nosokRepositoryProvider).markNotificationDispatch(
            dispatchId: dispatchId,
            status: status,
            providerReference: providerReference,
            errorMessage: errorMessage,
          );
    });
    state = result.whenData((_) {});
    if (result.hasError) {
      Error.throwWithStackTrace(result.error!, result.stackTrace!);
    }
    ref.invalidate(nosokNotificationDispatchesProvider);
    return result.requireValue;
  }
}
