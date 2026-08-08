class NosokServiceProgram {
  const NosokServiceProgram({
    required this.id,
    required this.seasonId,
    required this.code,
    required this.titleAr,
    required this.serviceType,
    required this.status,
    required this.isPubliclyVisible,
    this.titleEn,
    this.description,
    this.registrationStartAt,
    this.registrationEndAt,
    this.maxCompanions,
    this.notes,
  });

  final String id;
  final String seasonId;
  final String code;
  final String titleAr;
  final String? titleEn;
  final String serviceType;
  final String? description;
  final DateTime? registrationStartAt;
  final DateTime? registrationEndAt;
  final int? maxCompanions;
  final String? notes;
  final String status;
  final bool isPubliclyVisible;

  bool get isActive => status == 'active';

  NosokServiceProgram copyWith({
    String? id,
    String? seasonId,
    String? code,
    String? titleAr,
    String? titleEn,
    String? serviceType,
    String? description,
    DateTime? registrationStartAt,
    DateTime? registrationEndAt,
    int? maxCompanions,
    String? notes,
    String? status,
    bool? isPubliclyVisible,
  }) {
    return NosokServiceProgram(
      id: id ?? this.id,
      seasonId: seasonId ?? this.seasonId,
      code: code ?? this.code,
      titleAr: titleAr ?? this.titleAr,
      titleEn: titleEn ?? this.titleEn,
      serviceType: serviceType ?? this.serviceType,
      description: description ?? this.description,
      registrationStartAt: registrationStartAt ?? this.registrationStartAt,
      registrationEndAt: registrationEndAt ?? this.registrationEndAt,
      maxCompanions: maxCompanions ?? this.maxCompanions,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      isPubliclyVisible: isPubliclyVisible ?? this.isPubliclyVisible,
    );
  }

  factory NosokServiceProgram.empty() {
    return const NosokServiceProgram(
      id: '',
      seasonId: '',
      code: '',
      titleAr: '',
      titleEn: null,
      serviceType: 'hajj',
      description: null,
      registrationStartAt: null,
      registrationEndAt: null,
      maxCompanions: null,
      notes: null,
      status: 'draft',
      isPubliclyVisible: false,
    );
  }

  factory NosokServiceProgram.fromMap(Map<String, dynamic> map) {
    return NosokServiceProgram(
      id: (map['id'] ?? '').toString(),
      seasonId: (map['season_id'] ?? '').toString(),
      code: (map['code'] ?? '').toString(),
      titleAr: (map['title_ar'] ?? '').toString(),
      titleEn: map['title_en']?.toString(),
      serviceType: (map['service_type'] ?? '').toString(),
      description: map['description']?.toString(),
      registrationStartAt: _parseDateTime(map['registration_start_at']),
      registrationEndAt: _parseDateTime(map['registration_end_at']),
      maxCompanions: (map['max_companions'] as num?)?.toInt(),
      notes: map['notes']?.toString(),
      status: (map['status'] ?? '').toString(),
      isPubliclyVisible: (map['is_publicly_visible'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toUpsertMap() {
    final map = <String, dynamic>{
      'season_id': seasonId,
      'code': code,
      'title_ar': titleAr,
      'title_en': titleEn,
      'service_type': serviceType,
      'description': description,
      'registration_start_at': registrationStartAt?.toIso8601String(),
      'registration_end_at': registrationEndAt?.toIso8601String(),
      'max_companions': maxCompanions,
      'notes': notes,
      'status': status,
      'is_publicly_visible': isPubliclyVisible,
    };
    if (id.trim().isNotEmpty) {
      map['id'] = id;
    }
    return map;
  }
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) {
    return null;
  }
  return DateTime.tryParse(value.toString());
}
