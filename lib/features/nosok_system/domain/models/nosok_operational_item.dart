class NosokOperationalItem {
  const NosokOperationalItem({
    required this.key,
    required this.titleAr,
    required this.status,
    required this.severity,
    this.detailsAr,
    this.ownerRole,
    this.source,
    this.dueAt,
    this.updatedAt,
  });

  final String key;
  final String titleAr;
  final String status;
  final String severity;
  final String? detailsAr;
  final String? ownerRole;
  final String? source;
  final DateTime? dueAt;
  final DateTime? updatedAt;

  bool get isBlocking => severity == 'blocker' || status == 'failed';

  factory NosokOperationalItem.fromMap(Map<String, dynamic> map) {
    return NosokOperationalItem(
      key: (map['check_key'] ?? map['key'] ?? '').toString(),
      titleAr: (map['title_ar'] ?? map['title'] ?? '').toString(),
      status: (map['status'] ?? 'pending').toString(),
      severity: (map['severity'] ?? 'info').toString(),
      detailsAr: map['details_ar']?.toString() ?? map['note']?.toString(),
      ownerRole: map['owner_role']?.toString(),
      source: map['source']?.toString(),
      dueAt: _parseDateTime(map['due_at']),
      updatedAt: _parseDateTime(map['updated_at']),
    );
  }
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
