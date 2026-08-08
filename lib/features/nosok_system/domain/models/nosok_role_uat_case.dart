class NosokRoleUatCase {
  const NosokRoleUatCase({
    required this.id,
    required this.roleKey,
    required this.surfaceKey,
    required this.expectedAccess,
    this.actualAccess,
    this.status = 'pending',
    this.notesAr,
    this.lastTestedAt,
  });

  final String id;
  final String roleKey;
  final String surfaceKey;
  final String expectedAccess;
  final String? actualAccess;
  final String status;
  final String? notesAr;
  final DateTime? lastTestedAt;

  factory NosokRoleUatCase.fromMap(Map<String, dynamic> map) {
    return NosokRoleUatCase(
      id: (map['id'] ?? '').toString(),
      roleKey: (map['role_key'] ?? '').toString(),
      surfaceKey: (map['surface_key'] ?? '').toString(),
      expectedAccess: (map['expected_access'] ?? '').toString(),
      actualAccess: map['actual_access']?.toString(),
      status: (map['status'] ?? 'pending').toString(),
      notesAr: map['notes_ar']?.toString(),
      lastTestedAt: _parseDateTime(map['last_tested_at']),
    );
  }
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
