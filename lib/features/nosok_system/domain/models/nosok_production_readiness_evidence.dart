class NosokProductionReadinessEvidence {
  const NosokProductionReadinessEvidence({
    required this.id,
    required this.evidenceKey,
    required this.evidenceType,
    this.status = 'pending',
    this.evidenceUrl,
    this.evidenceSummaryAr,
    this.ownerRole,
    this.collectedAt,
    this.approvedAt,
    this.notesAr,
  });

  final String id;
  final String evidenceKey;
  final String evidenceType;
  final String status;
  final String? evidenceUrl;
  final String? evidenceSummaryAr;
  final String? ownerRole;
  final DateTime? collectedAt;
  final DateTime? approvedAt;
  final String? notesAr;

  bool get isAccepted => status == 'accepted' || status == 'passed';

  Map<String, dynamic> toUpsertMap() {
    return <String, dynamic>{
      if (id.trim().isNotEmpty) 'id': id,
      'evidence_key': evidenceKey,
      'evidence_type': evidenceType,
      'status': status,
      'evidence_url': evidenceUrl,
      'evidence_summary_ar': evidenceSummaryAr,
      'owner_role': ownerRole,
      'collected_at': collectedAt?.toIso8601String(),
      'approved_at': approvedAt?.toIso8601String(),
      'notes_ar': notesAr,
    };
  }

  factory NosokProductionReadinessEvidence.fromMap(Map<String, dynamic> map) {
    return NosokProductionReadinessEvidence(
      id: (map['id'] ?? '').toString(),
      evidenceKey: (map['evidence_key'] ?? '').toString(),
      evidenceType: (map['evidence_type'] ?? 'browser_uat').toString(),
      status: (map['status'] ?? 'pending').toString(),
      evidenceUrl: map['evidence_url']?.toString(),
      evidenceSummaryAr: map['evidence_summary_ar']?.toString(),
      ownerRole: map['owner_role']?.toString(),
      collectedAt: _parseDateTime(map['collected_at']),
      approvedAt: _parseDateTime(map['approved_at']),
      notesAr: map['notes_ar']?.toString(),
    );
  }
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
