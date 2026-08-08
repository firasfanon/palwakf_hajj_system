class NosokBillingProviderAdapter {
  const NosokBillingProviderAdapter({
    required this.id,
    required this.providerKey,
    required this.titleAr,
    this.adapterStatus = 'draft',
    this.adapterMode = 'contract_only',
    this.supportsWebhook = false,
    this.requiresSignature = true,
    this.idempotencyPolicy = 'required',
    this.callbackUrlPath,
    this.healthStatus = 'unknown',
    this.lastHealthAt,
    this.notesAr,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String providerKey;
  final String titleAr;
  final String adapterStatus;
  final String adapterMode;
  final bool supportsWebhook;
  final bool requiresSignature;
  final String idempotencyPolicy;
  final String? callbackUrlPath;
  final String healthStatus;
  final DateTime? lastHealthAt;
  final String? notesAr;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isOperational =>
      adapterStatus == 'enabled' && healthStatus == 'passed';
  bool get isHardened => requiresSignature && idempotencyPolicy == 'required';

  factory NosokBillingProviderAdapter.fromMap(Map<String, dynamic> map) {
    return NosokBillingProviderAdapter(
      id: (map['id'] ?? '').toString(),
      providerKey: (map['provider_key'] ?? '').toString(),
      titleAr: (map['title_ar'] ?? map['provider_key'] ?? '').toString(),
      adapterStatus: (map['adapter_status'] ?? 'draft').toString(),
      adapterMode: (map['adapter_mode'] ?? 'contract_only').toString(),
      supportsWebhook: map['supports_webhook'] == true,
      requiresSignature: map['requires_signature'] != false,
      idempotencyPolicy: (map['idempotency_policy'] ?? 'required').toString(),
      callbackUrlPath: map['callback_url_path']?.toString(),
      healthStatus: (map['health_status'] ?? 'unknown').toString(),
      lastHealthAt: _parseDateTime(map['last_health_at']),
      notesAr: map['notes_ar']?.toString() ?? map['notes']?.toString(),
      createdAt: _parseDateTime(map['created_at']),
      updatedAt: _parseDateTime(map['updated_at']),
    );
  }
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
