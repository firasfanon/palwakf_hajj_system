class NosokCompany {
  const NosokCompany({
    required this.id,
    required this.companyNameAr,
    required this.status,
    required this.isPubliclyVisible,
    this.companyNameEn,
    this.phone,
    this.mobile,
    this.email,
    this.addressText,
    this.licenseNo,
    this.governorateId,
    this.unitId,
    this.notes,
    this.currentSeasonQualificationStatus,
  });

  final String id;
  final String companyNameAr;
  final String? companyNameEn;
  final String status;
  final bool isPubliclyVisible;
  final String? phone;
  final String? mobile;
  final String? email;
  final String? addressText;
  final String? licenseNo;
  final String? governorateId;
  final String? unitId;
  final String? notes;
  final String? currentSeasonQualificationStatus;

  factory NosokCompany.empty() {
    return const NosokCompany(
      id: '',
      companyNameAr: '',
      companyNameEn: null,
      status: 'draft',
      isPubliclyVisible: false,
      phone: null,
      mobile: null,
      email: null,
      addressText: null,
      licenseNo: null,
      governorateId: null,
      unitId: null,
      notes: null,
      currentSeasonQualificationStatus: null,
    );
  }

  factory NosokCompany.fromMap(Map<String, dynamic> map) {
    return NosokCompany(
      id: (map['id'] ?? '').toString(),
      companyNameAr: (map['company_name_ar'] ?? '').toString(),
      companyNameEn: map['company_name_en']?.toString(),
      status: (map['status'] ?? '').toString(),
      isPubliclyVisible: (map['is_publicly_visible'] as bool?) ?? false,
      phone: map['phone']?.toString(),
      mobile: map['mobile']?.toString(),
      email: map['email']?.toString(),
      addressText: map['address_text']?.toString(),
      licenseNo: map['license_no']?.toString(),
      governorateId: map['governorate_id']?.toString(),
      unitId: map['unit_id']?.toString(),
      notes: map['notes']?.toString(),
      currentSeasonQualificationStatus:
          map['current_season_qualification_status']?.toString(),
    );
  }

  Map<String, dynamic> toUpsertMap() {
    final map = <String, dynamic>{
      'company_name_ar': companyNameAr,
      'company_name_en': companyNameEn,
      'status': status,
      'is_publicly_visible': isPubliclyVisible,
      'phone': phone,
      'mobile': mobile,
      'email': email,
      'address_text': addressText,
      'license_no': licenseNo,
      'governorate_id': governorateId,
      'unit_id': unitId,
      'notes': notes,
    };
    if (id.trim().isNotEmpty) {
      map['id'] = id;
    }
    return map;
  }
}
