import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/nosok_supabase_repository.dart';
import '../domain/models/nosok_role_uat_evidence.dart';
import 'nosok_role_uat_controller.dart';

final nosokRoleUatEvidenceProvider =
    FutureProvider<List<NosokRoleUatEvidence>>((ref) {
  return ref.read(nosokRepositoryProvider).listRoleUatEvidence();
});

class NosokRoleUatEvidenceController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> saveEvidence(NosokRoleUatEvidence evidence) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(nosokRepositoryProvider).saveRoleUatEvidence(evidence);
      ref.invalidate(nosokRoleUatEvidenceProvider);
      ref.invalidate(nosokRoleUatCasesProvider);
    });
  }
}

final nosokRoleUatEvidenceControllerProvider =
    AsyncNotifierProvider<NosokRoleUatEvidenceController, void>(
  NosokRoleUatEvidenceController.new,
);
