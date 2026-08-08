import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/nosok_supabase_repository.dart';
import '../domain/models/nosok_application_lifecycle_transition.dart';

final nosokLifecycleRulesProvider =
    FutureProvider.family<List<NosokApplicationLifecycleRule>, String?>(
        (ref, fromStatus) {
  return ref
      .read(nosokRepositoryProvider)
      .listLifecycleRules(fromStatus: fromStatus);
});

final nosokApplicationLifecycleTransitionsProvider =
    FutureProvider.family<List<NosokApplicationLifecycleTransition>, String?>(
        (ref, applicationId) {
  return ref
      .read(nosokRepositoryProvider)
      .listApplicationLifecycleTransitions(applicationId: applicationId);
});

final nosokApplicationLifecycleControllerProvider =
    AsyncNotifierProvider<NosokApplicationLifecycleController, void>(
        NosokApplicationLifecycleController.new);

class NosokApplicationLifecycleController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<NosokApplicationLifecycleTransition> transition({
    required String applicationId,
    required String transitionKey,
    String? reasonAr,
    String? noteAr,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() {
      return ref.read(nosokRepositoryProvider).transitionApplicationLifecycle(
            applicationId: applicationId,
            transitionKey: transitionKey,
            reasonAr: reasonAr,
            noteAr: noteAr,
          );
    });
    state = result.whenData((_) {});
    if (result.hasError) {
      Error.throwWithStackTrace(result.error!, result.stackTrace!);
    }
    ref.invalidate(nosokApplicationLifecycleTransitionsProvider(applicationId));
    return result.requireValue;
  }
}
