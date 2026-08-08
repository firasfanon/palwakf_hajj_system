class NosokUnitScope {
  const NosokUnitScope({
    required this.unitId,
    required this.unitSlug,
    required this.unitNameAr,
    required this.isEnabled,
    this.publicTitleAr,
    this.publicIntroAr,
    this.activeSeasonId,
    this.notes,
  });

  final String unitId;
  final String unitSlug;
  final String unitNameAr;
  final bool isEnabled;
  final String? publicTitleAr;
  final String? publicIntroAr;
  final String? activeSeasonId;
  final String? notes;

  factory NosokUnitScope.fromMap(Map<String, dynamic> map) {
    return NosokUnitScope(
      unitId: (map['unit_id'] ?? '').toString(),
      unitSlug: (map['unit_slug'] ?? '').toString(),
      unitNameAr: (map['unit_name_ar'] ?? map['name_ar'] ?? '').toString(),
      isEnabled: (map['is_enabled'] as bool?) ?? false,
      publicTitleAr: map['public_title_ar']?.toString(),
      publicIntroAr: map['public_intro_ar']?.toString(),
      activeSeasonId: map['active_season_id']?.toString(),
      notes: map['notes']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'unit_id': unitId,
      'unit_slug': unitSlug,
      'unit_name_ar': unitNameAr,
      'is_enabled': isEnabled,
      'public_title_ar': publicTitleAr,
      'public_intro_ar': publicIntroAr,
      'active_season_id': activeSeasonId,
      'notes': notes,
    };
  }
}
