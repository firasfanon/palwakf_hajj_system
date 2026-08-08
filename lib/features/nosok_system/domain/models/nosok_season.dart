class NosokSeason {
  const NosokSeason({
    required this.id,
    required this.seasonCode,
    required this.titleAr,
    required this.serviceType,
    required this.status,
    required this.isPubliclyVisible,
    this.titleEn,
    this.hijriYear,
    this.gregorianYear,
    this.registrationStartAt,
    this.registrationEndAt,
    this.notes,
  });

  final String id;
  final String seasonCode;
  final String titleAr;
  final String? titleEn;
  final String serviceType;
  final int? hijriYear;
  final int? gregorianYear;
  final DateTime? registrationStartAt;
  final DateTime? registrationEndAt;
  final String status;
  final String? notes;
  final bool isPubliclyVisible;

  bool get isOpen => status == 'open';

  NosokSeason copyWith({
    String? id,
    String? seasonCode,
    String? titleAr,
    String? titleEn,
    String? serviceType,
    int? hijriYear,
    int? gregorianYear,
    DateTime? registrationStartAt,
    DateTime? registrationEndAt,
    String? status,
    String? notes,
    bool? isPubliclyVisible,
  }) {
    return NosokSeason(
      id: id ?? this.id,
      seasonCode: seasonCode ?? this.seasonCode,
      titleAr: titleAr ?? this.titleAr,
      titleEn: titleEn ?? this.titleEn,
      serviceType: serviceType ?? this.serviceType,
      hijriYear: hijriYear ?? this.hijriYear,
      gregorianYear: gregorianYear ?? this.gregorianYear,
      registrationStartAt: registrationStartAt ?? this.registrationStartAt,
      registrationEndAt: registrationEndAt ?? this.registrationEndAt,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      isPubliclyVisible: isPubliclyVisible ?? this.isPubliclyVisible,
    );
  }

  factory NosokSeason.empty() {
    return const NosokSeason(
      id: '',
      seasonCode: '',
      titleAr: '',
      titleEn: null,
      serviceType: 'hajj',
      hijriYear: null,
      gregorianYear: null,
      registrationStartAt: null,
      registrationEndAt: null,
      status: 'draft',
      notes: null,
      isPubliclyVisible: false,
    );
  }

  factory NosokSeason.fromMap(Map<String, dynamic> map) {
    return NosokSeason(
      id: (map['id'] ?? '').toString(),
      seasonCode: (map['season_code'] ?? '').toString(),
      titleAr: (map['title_ar'] ?? '').toString(),
      titleEn: map['title_en']?.toString(),
      serviceType: (map['service_type'] ?? '').toString(),
      hijriYear: (map['hijri_year'] as num?)?.toInt(),
      gregorianYear: (map['gregorian_year'] as num?)?.toInt(),
      registrationStartAt: _parseDateTime(map['registration_start_at']),
      registrationEndAt: _parseDateTime(map['registration_end_at']),
      status: (map['status'] ?? '').toString(),
      notes: map['notes']?.toString(),
      isPubliclyVisible: (map['is_publicly_visible'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toUpsertMap() {
    final map = <String, dynamic>{
      'season_code': seasonCode,
      'title_ar': titleAr,
      'title_en': titleEn,
      'service_type': serviceType,
      'hijri_year': hijriYear,
      'gregorian_year': gregorianYear,
      'registration_start_at': registrationStartAt?.toIso8601String(),
      'registration_end_at': registrationEndAt?.toIso8601String(),
      'status': status,
      'notes': notes,
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
