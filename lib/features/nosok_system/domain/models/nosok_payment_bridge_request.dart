class NosokPaymentBridgeRequest {
  const NosokPaymentBridgeRequest({
    required this.id,
    required this.applicationId,
    this.applicationNo,
    this.paymentId,
    this.amount,
    this.currencyCode = 'ILS',
    this.bridgeStatus = 'draft',
    this.billingReference,
    this.providerReference,
    this.paymentMethod,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String applicationId;
  final String? applicationNo;
  final String? paymentId;
  final double? amount;
  final String currencyCode;
  final String bridgeStatus;
  final String? billingReference;
  final String? providerReference;
  final String? paymentMethod;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory NosokPaymentBridgeRequest.fromMap(Map<String, dynamic> map) {
    return NosokPaymentBridgeRequest(
      id: (map['id'] ?? '').toString(),
      applicationId: (map['application_id'] ?? '').toString(),
      applicationNo: map['application_no']?.toString(),
      paymentId: map['payment_id']?.toString(),
      amount: (map['amount'] as num?)?.toDouble(),
      currencyCode: (map['currency_code'] ?? 'ILS').toString(),
      bridgeStatus: (map['bridge_status'] ?? 'draft').toString(),
      billingReference: map['billing_reference']?.toString(),
      providerReference: map['provider_reference']?.toString(),
      paymentMethod: map['payment_method']?.toString(),
      notes: map['notes']?.toString(),
      createdAt: _parseDateTime(map['created_at']),
      updatedAt: _parseDateTime(map['updated_at']),
    );
  }
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
