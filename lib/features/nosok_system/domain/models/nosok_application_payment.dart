class NosokApplicationPayment {
  const NosokApplicationPayment({
    required this.id,
    required this.applicationId,
    required this.paymentType,
    required this.amount,
    required this.currencyCode,
    required this.paymentStatus,
    required this.verificationStatus,
    this.paymentReference,
    this.paymentMethod,
    this.providerName,
    this.externalTransactionId,
    this.receiptUrl,
    this.receiptStorageBucket,
    this.receiptStoragePath,
    this.receiptOriginalFileName,
    this.receiptMimeType,
    this.receiptFileSizeBytes,
    this.paidAt,
    this.verifiedAt,
    this.verificationNotes,
    this.notes,
  });

  final String id;
  final String applicationId;
  final String paymentType;
  final double amount;
  final String currencyCode;
  final String paymentStatus;
  final String verificationStatus;
  final String? paymentReference;
  final String? paymentMethod;
  final String? providerName;
  final String? externalTransactionId;
  final String? receiptUrl;
  final String? receiptStorageBucket;
  final String? receiptStoragePath;
  final String? receiptOriginalFileName;
  final String? receiptMimeType;
  final int? receiptFileSizeBytes;
  final DateTime? paidAt;
  final DateTime? verifiedAt;
  final String? verificationNotes;
  final String? notes;

  factory NosokApplicationPayment.empty({String? applicationId}) {
    return NosokApplicationPayment(
      id: '',
      applicationId: applicationId ?? '',
      paymentType: 'registration_fee',
      amount: 0,
      currencyCode: 'ILS',
      paymentStatus: 'pending',
      verificationStatus: 'pending',
    );
  }

  factory NosokApplicationPayment.fromMap(Map<String, dynamic> map) {
    return NosokApplicationPayment(
      id: (map['id'] ?? '').toString(),
      applicationId: (map['application_id'] ?? '').toString(),
      paymentType: (map['payment_type'] ?? '').toString(),
      amount: ((map['amount'] as num?) ?? 0).toDouble(),
      currencyCode: (map['currency_code'] ?? 'ILS').toString(),
      paymentStatus: (map['payment_status'] ?? '').toString(),
      verificationStatus: (map['verification_status'] ?? 'pending').toString(),
      paymentReference: map['payment_reference']?.toString(),
      paymentMethod: map['payment_method']?.toString(),
      providerName: map['provider_name']?.toString(),
      externalTransactionId: map['external_transaction_id']?.toString(),
      receiptUrl: map['receipt_url']?.toString(),
      receiptStorageBucket: map['receipt_storage_bucket']?.toString(),
      receiptStoragePath: map['receipt_storage_path']?.toString(),
      receiptOriginalFileName: map['receipt_original_file_name']?.toString(),
      receiptMimeType: map['receipt_mime_type']?.toString(),
      receiptFileSizeBytes: (map['receipt_file_size_bytes'] as num?)?.toInt(),
      paidAt: _parseDateTime(map['paid_at']),
      verifiedAt: _parseDateTime(map['verified_at']),
      verificationNotes: map['verification_notes']?.toString(),
      notes: map['notes']?.toString(),
    );
  }

  NosokApplicationPayment copyWith({
    String? id,
    String? applicationId,
    String? paymentType,
    double? amount,
    String? currencyCode,
    String? paymentStatus,
    String? verificationStatus,
    String? paymentReference,
    String? paymentMethod,
    String? providerName,
    String? externalTransactionId,
    String? receiptUrl,
    String? receiptStorageBucket,
    String? receiptStoragePath,
    String? receiptOriginalFileName,
    String? receiptMimeType,
    int? receiptFileSizeBytes,
    DateTime? paidAt,
    DateTime? verifiedAt,
    String? verificationNotes,
    String? notes,
  }) {
    return NosokApplicationPayment(
      id: id ?? this.id,
      applicationId: applicationId ?? this.applicationId,
      paymentType: paymentType ?? this.paymentType,
      amount: amount ?? this.amount,
      currencyCode: currencyCode ?? this.currencyCode,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      paymentReference: paymentReference ?? this.paymentReference,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      providerName: providerName ?? this.providerName,
      externalTransactionId:
          externalTransactionId ?? this.externalTransactionId,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      receiptStorageBucket: receiptStorageBucket ?? this.receiptStorageBucket,
      receiptStoragePath: receiptStoragePath ?? this.receiptStoragePath,
      receiptOriginalFileName:
          receiptOriginalFileName ?? this.receiptOriginalFileName,
      receiptMimeType: receiptMimeType ?? this.receiptMimeType,
      receiptFileSizeBytes: receiptFileSizeBytes ?? this.receiptFileSizeBytes,
      paidAt: paidAt ?? this.paidAt,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      verificationNotes: verificationNotes ?? this.verificationNotes,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toUpsertMap() {
    final map = <String, dynamic>{
      'application_id': applicationId,
      'payment_type': paymentType,
      'amount': amount,
      'currency_code': currencyCode,
      'payment_status': paymentStatus,
      'verification_status': verificationStatus,
      'payment_reference': paymentReference,
      'payment_method': paymentMethod,
      'provider_name': providerName,
      'external_transaction_id': externalTransactionId,
      'receipt_url': receiptUrl,
      'receipt_storage_bucket': receiptStorageBucket,
      'receipt_storage_path': receiptStoragePath,
      'receipt_original_file_name': receiptOriginalFileName,
      'receipt_mime_type': receiptMimeType,
      'receipt_file_size_bytes': receiptFileSizeBytes,
      'paid_at': paidAt?.toIso8601String(),
      'verified_at': verifiedAt?.toIso8601String(),
      'verification_notes': verificationNotes,
      'notes': notes,
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
