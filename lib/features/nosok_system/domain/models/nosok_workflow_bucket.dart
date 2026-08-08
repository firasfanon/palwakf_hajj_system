class NosokWorkflowBucket {
  const NosokWorkflowBucket({
    required this.bucketKey,
    required this.titleAr,
    this.descriptionAr,
    this.routePath,
    this.severity = 'normal',
    this.displayOrder = 100,
    this.itemCount = 0,
    this.blockerCount = 0,
    this.warningCount = 0,
    this.lastUpdatedAt,
  });

  final String bucketKey;
  final String titleAr;
  final String? descriptionAr;
  final String? routePath;
  final String severity;
  final int displayOrder;
  final int itemCount;
  final int blockerCount;
  final int warningCount;
  final DateTime? lastUpdatedAt;

  bool get hasWork => itemCount > 0 || blockerCount > 0 || warningCount > 0;
  bool get isBlocker =>
      blockerCount > 0 || severity == 'blocker' || severity == 'high';

  factory NosokWorkflowBucket.fromMap(Map<String, dynamic> map) {
    return NosokWorkflowBucket(
      bucketKey: (map['bucket_key'] ?? '').toString(),
      titleAr: (map['title_ar'] ?? '').toString(),
      descriptionAr: map['description_ar']?.toString(),
      routePath: map['route_path']?.toString(),
      severity: (map['severity'] ?? 'normal').toString(),
      displayOrder: (map['display_order'] as num?)?.toInt() ?? 100,
      itemCount: (map['item_count'] as num?)?.toInt() ?? 0,
      blockerCount: (map['blocker_count'] as num?)?.toInt() ?? 0,
      warningCount: (map['warning_count'] as num?)?.toInt() ?? 0,
      lastUpdatedAt: _parseDateTime(map['last_updated_at']),
    );
  }
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
