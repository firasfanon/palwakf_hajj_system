class NosokUnitApplicationQueueItem {
  const NosokUnitApplicationQueueItem({
    required this.id,
    required this.applicationNo,
    required this.applicantFullName,
    required this.serviceType,
    required this.applicationStatus,
    this.eligibilityStatus,
    this.unitId,
    this.unitSlug,
    this.unitNameAr,
    this.seasonTitleAr,
    this.programTitleAr,
    this.mobile,
    this.submittedAt,
    this.documentsCount,
    this.pendingDocumentsCount,
    this.rejectedDocumentsCount,
    this.paymentsCount,
    this.totalPaidAmount,
    this.pendingPaymentsCount,
    this.verifiedPaymentsCount,
    this.needsAction = false,
  });

  final String id;
  final String applicationNo;
  final String applicantFullName;
  final String serviceType;
  final String applicationStatus;
  final String? eligibilityStatus;
  final String? unitId;
  final String? unitSlug;
  final String? unitNameAr;
  final String? seasonTitleAr;
  final String? programTitleAr;
  final String? mobile;
  final DateTime? submittedAt;
  final int? documentsCount;
  final int? pendingDocumentsCount;
  final int? rejectedDocumentsCount;
  final int? paymentsCount;
  final double? totalPaidAmount;
  final int? pendingPaymentsCount;
  final int? verifiedPaymentsCount;
  final bool needsAction;

  factory NosokUnitApplicationQueueItem.fromMap(Map<String, dynamic> map) {
    return NosokUnitApplicationQueueItem(
      id: (map['id'] ?? '').toString(),
      applicationNo: (map['application_no'] ?? '').toString(),
      applicantFullName: (map['applicant_full_name'] ?? '').toString(),
      serviceType: (map['service_type'] ?? '').toString(),
      applicationStatus: (map['application_status'] ?? '').toString(),
      eligibilityStatus: map['eligibility_status']?.toString(),
      unitId: map['unit_id']?.toString(),
      unitSlug: map['unit_slug']?.toString(),
      unitNameAr: map['unit_name_ar']?.toString(),
      seasonTitleAr: map['season_title_ar']?.toString(),
      programTitleAr: map['program_title_ar']?.toString(),
      mobile: map['mobile']?.toString(),
      submittedAt: _parseDateTime(map['submitted_at']),
      documentsCount: (map['documents_count'] as num?)?.toInt(),
      pendingDocumentsCount: (map['pending_documents_count'] as num?)?.toInt(),
      rejectedDocumentsCount:
          (map['rejected_documents_count'] as num?)?.toInt(),
      paymentsCount: (map['payments_count'] as num?)?.toInt(),
      totalPaidAmount: (map['total_paid_amount'] as num?)?.toDouble(),
      pendingPaymentsCount: (map['pending_payments_count'] as num?)?.toInt(),
      verifiedPaymentsCount: (map['verified_payments_count'] as num?)?.toInt(),
      needsAction: map['needs_action'] == true ||
          map['needs_action']?.toString() == 'true',
    );
  }
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
