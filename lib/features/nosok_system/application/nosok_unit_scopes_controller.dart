import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/nosok_supabase_repository.dart';
import '../domain/models/nosok_unit_scope.dart';

final nosokAdminUnitScopesProvider =
    FutureProvider<List<NosokUnitScope>>((ref) {
  return ref.watch(nosokRepositoryProvider).listUnitScopes();
});

final nosokPublicUnitScopeProvider =
    FutureProvider.family<NosokUnitScope?, String>((ref, unitSlug) {
  return ref.watch(nosokRepositoryProvider).getPublicUnitScope(unitSlug);
});
