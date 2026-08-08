class NosokCompanySeasonQualification {
  const NosokCompanySeasonQualification({
    required this.id,
    required this.companyId,
    required this.seasonId,
    required this.qualificationStatus,
    required this.isPubliclyVisible,
    this.seasonTitleAr,
    this.qualificationNotes,
    this.startsAt,
    this.endsAt,
  });

  final String id;
  final String companyId;
  final String seasonId;
  final String qualificationStatus;
  final bool isPubliclyVisible;
  final String? seasonTitleAr;
  final String? qualificationNotes;
  final DateTime? startsAt;
  final DateTime? endsAt;

  factory NosokCompanySeasonQualification.empty({String? companyId}) {
    return NosokCompanySeasonQualification(
      id: '',
      companyId: companyId ?? '',
      seasonId: '',
      qualificationStatus: 'draft',
      isPubliclyVisible: false,
    );
  }

  factory NosokCompanySeasonQualification.fromMap(Map<String, dynamic> map) {
    return NosokCompanySeasonQualification(
      id: (map['id'] ?? '').toString(),
      companyId: (map['company_id'] ?? '').toString(),
      seasonId: (map['season_id'] ?? '').toString(),
      qualificationStatus: (map['qualification_status'] ?? '').toString(),
      isPubliclyVisible: (map['is_publicly_visible'] as bool?) ?? false,
      seasonTitleAr: map['season_title_ar']?.toString(),
      qualificationNotes: map['qualification_notes']?.toString(),
      startsAt: _parseDateTime(map['starts_at']),
      endsAt: _parseDateTime(map['ends_at']),
    );
  }

  Map<String, dynamic> toUpsertMap() {
    final map = <String, dynamic>{
      'company_id': companyId,
      'season_id': seasonId,
      'qualification_status': qualificationStatus,
      'is_publicly_visible': isPubliclyVisible,
      'qualification_notes': qualificationNotes,
      'starts_at': startsAt?.toIso8601String(),
      'ends_at': endsAt?.toIso8601String(),
    };
    if (id.trim().isNotEmpty) {
      map['id'] = id;
    }
    return map;
  }
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
