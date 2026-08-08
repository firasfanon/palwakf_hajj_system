import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/nosok_supabase_repository.dart';
import '../domain/models/nosok_complaint.dart';

final nosokComplaintsControllerProvider =
    AsyncNotifierProvider<NosokComplaintsController, List<NosokComplaint>>(
  NosokComplaintsController.new,
);

class NosokComplaintsController extends AsyncNotifier<List<NosokComplaint>> {
  @override
  Future<List<NosokComplaint>> build() async {
    return ref.read(nosokRepositoryProvider).listComplaints();
  }

  Future<void> refreshList() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(nosokRepositoryProvider).listComplaints(),
    );
  }
}
