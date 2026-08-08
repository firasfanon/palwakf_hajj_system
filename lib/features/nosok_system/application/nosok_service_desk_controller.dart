import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/nosok_supabase_repository.dart';
import '../domain/models/nosok_service_desk_search_result.dart';

final nosokServiceDeskQueryProvider = StateProvider<String>((ref) => '');

final nosokServiceDeskSearchResultsProvider =
    FutureProvider<List<NosokServiceDeskSearchResult>>((ref) {
  final query = ref.watch(nosokServiceDeskQueryProvider).trim();
  if (query.length < 2) {
    return Future.value(const <NosokServiceDeskSearchResult>[]);
  }
  return ref.read(nosokRepositoryProvider).searchServiceDesk(query);
});

final nosokServiceDeskScriptsProvider =
    FutureProvider<List<NosokServiceDeskScript>>((ref) {
  return ref.read(nosokRepositoryProvider).listServiceDeskScripts();
});
