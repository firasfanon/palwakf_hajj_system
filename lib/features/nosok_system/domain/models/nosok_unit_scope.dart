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
    this.unitType,
    this.governorateId,
  });

  final String unitId;
  final String unitSlug;
  final String unitNameAr;
  final bool isEnabled;
  final String? publicTitleAr;
  final String? publicIntroAr;
  final String? activeSeasonId;
  final String? notes;
  final String? unitType;
  final String? governorateId;

  factory NosokUnitScope.fromMap(Map<String, dynamic> map) {
    return NosokUnitScope(
      unitId: (map['unit_id'] ?? map['id'] ?? '').toString(),
      unitSlug: (map['unit_slug'] ?? map['slug'] ?? '').toString(),
      unitNameAr: (map['unit_name_ar'] ?? map['name_ar'] ?? map['nameAr'] ?? '')
          .toString(),
      isEnabled: (map['is_enabled'] as bool?) ??
          (map['is_active'] as bool?) ??
          (map['isActive'] as bool?) ??
          false,
      publicTitleAr: map['public_title_ar']?.toString(),
      publicIntroAr: map['public_intro_ar']?.toString(),
      activeSeasonId: map['active_season_id']?.toString(),
      notes: map['notes']?.toString(),
      unitType: (map['unit_type'] ?? map['unitType'])?.toString(),
      governorateId: map['governorate_id']?.toString(),
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
      'unit_type': unitType,
      'governorate_id': governorateId,
    };
  }
}
