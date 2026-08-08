class NosokApplication {
  const NosokApplication({
    required this.id,
    required this.applicationNo,
    required this.applicantFullName,
    required this.nationalId,
    required this.serviceType,
    required this.applicationStatus,
    this.seasonId,
    this.programId,
    this.mobile,
    this.phone,
    this.email,
    this.submittedAt,
    this.trackingToken,
    this.eligibilityStatus,
    this.seasonTitleAr,
    this.programTitleAr,
    this.reviewedAt,
    this.trackingTokenIssuedAt,
    this.documentsCount,
    this.paymentsCount,
    this.totalPaidAmount,
    this.lastPaymentStatus,
  });

  final String id;
  final String applicationNo;
  final String applicantFullName;
  final String nationalId;
  final String serviceType;
  final String applicationStatus;
  final String? seasonId;
  final String? programId;
  final String? mobile;
  final String? phone;
  final String? email;
  final DateTime? submittedAt;
  final String? trackingToken;
  final String? eligibilityStatus;
  final String? seasonTitleAr;
  final String? programTitleAr;
  final DateTime? reviewedAt;
  final DateTime? trackingTokenIssuedAt;
  final int? documentsCount;
  final int? paymentsCount;
  final double? totalPaidAmount;
  final String? lastPaymentStatus;

  factory NosokApplication.fromMap(Map<String, dynamic> map) {
    return NosokApplication(
      id: (map['id'] ?? '').toString(),
      applicationNo: (map['application_no'] ?? '').toString(),
      applicantFullName: (map['applicant_full_name'] ?? '').toString(),
      nationalId: (map['national_id'] ?? '').toString(),
      serviceType: (map['service_type'] ?? '').toString(),
      applicationStatus: (map['application_status'] ?? '').toString(),
      seasonId: map['season_id']?.toString(),
      programId: map['program_id']?.toString(),
      mobile: map['mobile']?.toString(),
      phone: map['phone']?.toString(),
      email: map['email']?.toString(),
      submittedAt: map['submitted_at'] == null
          ? null
          : DateTime.tryParse(map['submitted_at'].toString()),
      trackingToken: map['tracking_token']?.toString(),
      eligibilityStatus: map['eligibility_status']?.toString(),
      seasonTitleAr: map['season_title_ar']?.toString(),
      programTitleAr: map['program_title_ar']?.toString(),
      reviewedAt: map['reviewed_at'] == null
          ? null
          : DateTime.tryParse(map['reviewed_at'].toString()),
      trackingTokenIssuedAt: map['tracking_token_issued_at'] == null
          ? null
          : DateTime.tryParse(map['tracking_token_issued_at'].toString()),
      documentsCount: (map['documents_count'] as num?)?.toInt(),
      paymentsCount: (map['payments_count'] as num?)?.toInt(),
      totalPaidAmount: (map['total_paid_amount'] as num?)?.toDouble(),
      lastPaymentStatus: map['last_payment_status']?.toString(),
    );
  }
}
