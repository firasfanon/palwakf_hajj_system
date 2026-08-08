import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/nosok_supabase_repository.dart';
import '../domain/models/nosok_company_season_qualification.dart';

final nosokCompanyQualificationsProvider = FutureProvider.family<
    List<NosokCompanySeasonQualification>,
    NosokCompanyQualificationFilter>((ref, filter) {
  return ref.read(nosokRepositoryProvider).listCompanyQualifications(
        companyId: filter.companyId,
        seasonId: filter.seasonId,
      );
});

class NosokCompanyQualificationFilter {
  const NosokCompanyQualificationFilter({this.companyId, this.seasonId});

  final String? companyId;
  final String? seasonId;

  @override
  bool operator ==(Object other) {
    return other is NosokCompanyQualificationFilter &&
        other.companyId == companyId &&
        other.seasonId == seasonId;
  }

  @override
  int get hashCode => Object.hash(companyId, seasonId);
}
