class NosokRoleUatEvidence {
  const NosokRoleUatEvidence({
    required this.id,
    required this.roleKey,
    required this.surfaceKey,
    required this.expectedAccess,
    required this.actualAccess,
    required this.resultStatus,
    this.matrixCaseId,
    this.testedBy,
    this.evidenceUrl,
    this.notesAr,
    this.testedAt,
  });

  final String id;
  final String? matrixCaseId;
  final String roleKey;
  final String surfaceKey;
  final String expectedAccess;
  final String actualAccess;
  final String resultStatus;
  final String? testedBy;
  final String? evidenceUrl;
  final String? notesAr;
  final DateTime? testedAt;

  factory NosokRoleUatEvidence.fromMap(Map<String, dynamic> map) {
    return NosokRoleUatEvidence(
      id: (map['id'] ?? '').toString(),
      matrixCaseId: map['matrix_case_id']?.toString(),
      roleKey: (map['role_key'] ?? '').toString(),
      surfaceKey: (map['surface_key'] ?? '').toString(),
      expectedAccess: (map['expected_access'] ?? '').toString(),
      actualAccess: (map['actual_access'] ?? '').toString(),
      resultStatus: (map['result_status'] ?? 'pending_review').toString(),
      testedBy: map['tested_by']?.toString(),
      evidenceUrl: map['evidence_url']?.toString(),
      notesAr: map['notes_ar']?.toString(),
      testedAt: _parseDateTime(map['tested_at']),
    );
  }

  Map<String, dynamic> toUpsertMap() {
    return <String, dynamic>{
      if (id.trim().isNotEmpty) 'id': id,
      'matrix_case_id': _nullIfBlank(matrixCaseId),
      'role_key': roleKey.trim(),
      'surface_key': surfaceKey.trim(),
      'expected_access': expectedAccess.trim(),
      'actual_access': actualAccess.trim(),
      'result_status': resultStatus.trim(),
      'tested_by': _nullIfBlank(testedBy),
      'evidence_url': _nullIfBlank(evidenceUrl),
      'notes_ar': _nullIfBlank(notesAr),
    };
  }
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}

String? _nullIfBlank(String? value) {
  final trimmed = (value ?? '').trim();
  return trimmed.isEmpty ? null : trimmed;
}
