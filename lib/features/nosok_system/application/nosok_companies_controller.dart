import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/nosok_supabase_repository.dart';
import '../domain/models/nosok_company.dart';

final nosokCompaniesControllerProvider =
    AsyncNotifierProvider<NosokCompaniesController, List<NosokCompany>>(
  NosokCompaniesController.new,
);

final nosokPublicCompaniesProvider =
    FutureProvider.family<List<NosokCompany>, NosokPublicCompaniesFilter>(
        (ref, filter) {
  return ref.read(nosokRepositoryProvider).listCompanies(
        query: filter.query,
        publicOnly: true,
        seasonId: filter.seasonId,
      );
});

class NosokPublicCompaniesFilter {
  const NosokPublicCompaniesFilter({this.query, this.seasonId});

  final String? query;
  final String? seasonId;

  @override
  bool operator ==(Object other) {
    return other is NosokPublicCompaniesFilter &&
        other.query == query &&
        other.seasonId == seasonId;
  }

  @override
  int get hashCode => Object.hash(query, seasonId);
}

class NosokCompaniesController extends AsyncNotifier<List<NosokCompany>> {
  String? _lastQuery;

  @override
  Future<List<NosokCompany>> build() async {
    return ref.read(nosokRepositoryProvider).listCompanies();
  }

  Future<void> refreshList({String? query}) async {
    _lastQuery = query ?? _lastQuery;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(nosokRepositoryProvider)
          .listCompanies(query: _lastQuery, publicOnly: false),
    );
  }

  Future<void> saveCompany(NosokCompany company) async {
    await ref.read(nosokRepositoryProvider).saveCompany(company);
    await refreshList();
  }

  Future<void> deleteCompany(String id) async {
    await ref.read(nosokRepositoryProvider).deleteCompany(id);
    await refreshList();
  }
}
