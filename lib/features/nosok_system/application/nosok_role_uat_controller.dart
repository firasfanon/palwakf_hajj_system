import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/nosok_supabase_repository.dart';
import '../domain/models/nosok_role_uat_case.dart';

final nosokRoleUatCasesProvider = FutureProvider<List<NosokRoleUatCase>>((ref) {
  return ref.read(nosokRepositoryProvider).listRoleUatCases();
});
