import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/nosok_supabase_repository.dart';
import '../domain/models/nosok_citizen_followup_action.dart';

final nosokCitizenFollowupTokenProvider = StateProvider<String>((ref) => '');

final nosokCitizenFollowupActionsProvider =
    FutureProvider<List<NosokCitizenFollowupAction>>((ref) {
  final token = ref.watch(nosokCitizenFollowupTokenProvider).trim();
  if (token.isEmpty) return Future.value(const <NosokCitizenFollowupAction>[]);
  return ref.read(nosokRepositoryProvider).listCitizenFollowupActions(token);
});

final nosokCitizenFollowupControllerProvider =
    AsyncNotifierProvider<NosokCitizenFollowupController, void>(
        NosokCitizenFollowupController.new);

class NosokCitizenFollowupController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<NosokCitizenFollowupRequest> submit({
    required String trackingToken,
    required String actionKey,
    String? noteAr,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() {
      return ref.read(nosokRepositoryProvider).submitCitizenFollowupAction(
            trackingToken: trackingToken,
            actionKey: actionKey,
            noteAr: noteAr,
          );
    });
    state = result.whenData((_) {});
    if (result.hasError) {
      Error.throwWithStackTrace(result.error!, result.stackTrace!);
    }
    ref.invalidate(nosokCitizenFollowupActionsProvider);
    return result.requireValue;
  }
}
