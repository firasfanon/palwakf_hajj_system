import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/nosok_supabase_repository.dart';
import '../domain/models/nosok_dashboard_summary.dart';

final nosokDashboardControllerProvider =
    AsyncNotifierProvider<NosokDashboardController, NosokDashboardSummary>(
  NosokDashboardController.new,
);

class NosokDashboardController extends AsyncNotifier<NosokDashboardSummary> {
  @override
  Future<NosokDashboardSummary> build() {
    return ref.read(nosokRepositoryProvider).loadDashboardSummary();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(nosokRepositoryProvider).loadDashboardSummary(),
    );
  }
}
