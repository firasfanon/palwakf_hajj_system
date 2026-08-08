class NosokPublicTrackingPrivacyCheck {
  const NosokPublicTrackingPrivacyCheck({
    required this.checkKey,
    required this.titleAr,
    this.status = 'pending',
    this.severity = 'blocker',
    this.publicDataFields = const <String>[],
    this.blockedFields = const <String>[],
    this.evidenceNoteAr,
    this.lastReviewedAt,
    this.updatedAt,
  });

  final String checkKey;
  final String titleAr;
  final String status;
  final String severity;
  final List<String> publicDataFields;
  final List<String> blockedFields;
  final String? evidenceNoteAr;
  final DateTime? lastReviewedAt;
  final DateTime? updatedAt;

  bool get isBlocking => severity == 'blocker' && status != 'passed';

  factory NosokPublicTrackingPrivacyCheck.fromMap(Map<String, dynamic> map) {
    return NosokPublicTrackingPrivacyCheck(
      checkKey: (map['check_key'] ?? '').toString(),
      titleAr: (map['title_ar'] ?? map['check_key'] ?? '').toString(),
      status: (map['status'] ?? 'pending').toString(),
      severity: (map['severity'] ?? 'blocker').toString(),
      publicDataFields: _stringList(map['public_data_fields']),
      blockedFields: _stringList(map['blocked_fields']),
      evidenceNoteAr: map['evidence_note_ar']?.toString() ??
          map['evidence_note']?.toString(),
      lastReviewedAt: _parseDateTime(map['last_reviewed_at']),
      updatedAt: _parseDateTime(map['updated_at']),
    );
  }
}

List<String> _stringList(dynamic value) {
  if (value is List) {
    return value.map((item) => item.toString()).toList(growable: false);
  }
  if (value is String && value.trim().isNotEmpty) {
    return value
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }
  return const <String>[];
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
