class NosokNotificationDispatch {
  const NosokNotificationDispatch({
    required this.id,
    required this.eventKey,
    required this.templateKey,
    required this.channel,
    required this.recipientScope,
    required this.relatedEntityType,
    required this.relatedEntityId,
    required this.status,
    this.payloadPreviewAr,
    this.providerReference,
    this.errorMessage,
    this.createdAt,
    this.dispatchedAt,
  });

  final String id;
  final String eventKey;
  final String templateKey;
  final String channel;
  final String recipientScope;
  final String relatedEntityType;
  final String relatedEntityId;
  final String status;
  final String? payloadPreviewAr;
  final String? providerReference;
  final String? errorMessage;
  final DateTime? createdAt;
  final DateTime? dispatchedAt;

  factory NosokNotificationDispatch.fromMap(Map<String, dynamic> map) {
    return NosokNotificationDispatch(
      id: (map['id'] ?? '').toString(),
      eventKey: (map['event_key'] ?? '').toString(),
      templateKey: (map['template_key'] ?? '').toString(),
      channel: (map['channel'] ?? 'in_app').toString(),
      recipientScope: (map['recipient_scope'] ?? 'citizen').toString(),
      relatedEntityType: (map['related_entity_type'] ?? '').toString(),
      relatedEntityId: (map['related_entity_id'] ?? '').toString(),
      status: (map['status'] ?? 'queued').toString(),
      payloadPreviewAr: map['payload_preview_ar']?.toString(),
      providerReference: map['provider_reference']?.toString(),
      errorMessage: map['error_message']?.toString(),
      createdAt: _parseDateTime(map['created_at']),
      dispatchedAt: _parseDateTime(map['dispatched_at']),
    );
  }
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
