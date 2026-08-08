class NosokNotificationProviderAdapter {
  const NosokNotificationProviderAdapter({
    required this.id,
    required this.providerKey,
    required this.titleAr,
    required this.channel,
    required this.adapterMode,
    required this.healthStatus,
    this.requiresSignature = true,
    this.callbackPath,
    this.lastCheckedAt,
    this.notesAr,
  });

  final String id;
  final String providerKey;
  final String titleAr;
  final String channel;
  final String adapterMode;
  final String healthStatus;
  final bool requiresSignature;
  final String? callbackPath;
  final DateTime? lastCheckedAt;
  final String? notesAr;

  factory NosokNotificationProviderAdapter.fromMap(Map<String, dynamic> map) {
    return NosokNotificationProviderAdapter(
      id: (map['id'] ?? map['adapter_id'] ?? '').toString(),
      providerKey: (map['provider_key'] ?? '').toString(),
      titleAr: (map['title_ar'] ?? map['provider_key'] ?? '').toString(),
      channel: (map['channel'] ?? 'in_app').toString(),
      adapterMode: (map['adapter_mode'] ?? 'bridge').toString(),
      healthStatus: (map['health_status'] ?? 'unknown').toString(),
      requiresSignature: map['requires_signature'] == null
          ? true
          : map['requires_signature'] == true ||
              map['requires_signature'].toString() == 'true',
      callbackPath: map['callback_path']?.toString(),
      lastCheckedAt: _parseDateTime(map['last_checked_at']),
      notesAr: map['notes_ar']?.toString(),
    );
  }
}

class NosokNotificationProviderUatResult {
  const NosokNotificationProviderUatResult({
    required this.id,
    required this.providerKey,
    required this.channel,
    required this.testKey,
    required this.status,
    this.expectedAr,
    this.actualAr,
    this.evidenceUrl,
    this.errorMessage,
    this.createdAt,
  });

  final String id;
  final String providerKey;
  final String channel;
  final String testKey;
  final String status;
  final String? expectedAr;
  final String? actualAr;
  final String? evidenceUrl;
  final String? errorMessage;
  final DateTime? createdAt;

  bool get passed => status == 'passed';

  factory NosokNotificationProviderUatResult.fromMap(Map<String, dynamic> map) {
    return NosokNotificationProviderUatResult(
      id: (map['id'] ?? map['uat_id'] ?? '').toString(),
      providerKey: (map['provider_key'] ?? '').toString(),
      channel: (map['channel'] ?? 'in_app').toString(),
      testKey: (map['test_key'] ?? '').toString(),
      status: (map['status'] ?? 'pending').toString(),
      expectedAr: map['expected_ar']?.toString(),
      actualAr: map['actual_ar']?.toString(),
      evidenceUrl: map['evidence_url']?.toString(),
      errorMessage: map['error_message']?.toString(),
      createdAt: _parseDateTime(map['created_at']),
    );
  }
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
