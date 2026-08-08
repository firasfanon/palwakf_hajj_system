class NosokServiceDeskSearchResult {
  const NosokServiceDeskSearchResult({
    required this.resultType,
    required this.entityId,
    required this.primaryLabel,
    this.secondaryLabel,
    this.status,
    this.routePath,
    this.matchedBy,
    this.lastActivityAt,
  });

  final String resultType;
  final String entityId;
  final String primaryLabel;
  final String? secondaryLabel;
  final String? status;
  final String? routePath;
  final String? matchedBy;
  final DateTime? lastActivityAt;

  factory NosokServiceDeskSearchResult.fromMap(Map<String, dynamic> map) {
    return NosokServiceDeskSearchResult(
      resultType: (map['result_type'] ?? '').toString(),
      entityId: (map['entity_id'] ?? '').toString(),
      primaryLabel: (map['primary_label'] ?? '').toString(),
      secondaryLabel: map['secondary_label']?.toString(),
      status: map['status']?.toString(),
      routePath: map['route_path']?.toString(),
      matchedBy: map['matched_by']?.toString(),
      lastActivityAt: _parseDateTime(map['last_activity_at']),
    );
  }
}

class NosokServiceDeskScript {
  const NosokServiceDeskScript({
    required this.scriptKey,
    required this.titleAr,
    required this.bodyAr,
    this.category = 'general',
    this.displayOrder = 100,
  });

  final String scriptKey;
  final String titleAr;
  final String bodyAr;
  final String category;
  final int displayOrder;

  factory NosokServiceDeskScript.fromMap(Map<String, dynamic> map) {
    return NosokServiceDeskScript(
      scriptKey: (map['script_key'] ?? '').toString(),
      titleAr: (map['title_ar'] ?? '').toString(),
      bodyAr: (map['body_ar'] ?? '').toString(),
      category: (map['category'] ?? 'general').toString(),
      displayOrder: (map['display_order'] as num?)?.toInt() ?? 100,
    );
  }
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
