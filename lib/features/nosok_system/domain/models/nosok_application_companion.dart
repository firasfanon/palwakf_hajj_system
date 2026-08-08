class NosokApplicationCompanion {
  const NosokApplicationCompanion({
    this.id,
    required this.fullName,
    this.nationalId,
    this.relationType,
    this.birthDate,
    this.phone,
    this.notes,
  });

  final String? id;
  final String fullName;
  final String? nationalId;
  final String? relationType;
  final DateTime? birthDate;
  final String? phone;
  final String? notes;

  NosokApplicationCompanion copyWith({
    String? id,
    String? fullName,
    String? nationalId,
    String? relationType,
    DateTime? birthDate,
    String? phone,
    String? notes,
  }) {
    return NosokApplicationCompanion(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      nationalId: nationalId ?? this.nationalId,
      relationType: relationType ?? this.relationType,
      birthDate: birthDate ?? this.birthDate,
      phone: phone ?? this.phone,
      notes: notes ?? this.notes,
    );
  }

  factory NosokApplicationCompanion.fromMap(Map<String, dynamic> map) {
    return NosokApplicationCompanion(
      id: map['id']?.toString(),
      fullName: (map['full_name'] ?? '').toString(),
      nationalId: map['national_id']?.toString(),
      relationType: map['relation_type']?.toString(),
      birthDate: map['birth_date'] == null
          ? null
          : DateTime.tryParse(map['birth_date'].toString()),
      phone: map['phone']?.toString(),
      notes: map['notes']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if ((id ?? '').trim().isNotEmpty) 'id': id,
      'full_name': fullName,
      'national_id': nationalId,
      'relation_type': relationType,
      'birth_date': birthDate == null
          ? null
          : '${birthDate!.year.toString().padLeft(4, '0')}-${birthDate!.month.toString().padLeft(2, '0')}-${birthDate!.day.toString().padLeft(2, '0')}',
      'phone': phone,
      'notes': notes,
    };
  }
}
