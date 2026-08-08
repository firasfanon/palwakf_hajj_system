import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/nosok_supabase_repository.dart';
import '../domain/models/nosok_operational_item.dart';

final nosokOperationalReadinessProvider =
    FutureProvider<List<NosokOperationalItem>>((ref) {
  return ref.read(nosokRepositoryProvider).listOperationalReadiness();
});
