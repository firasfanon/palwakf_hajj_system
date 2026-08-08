class NosokFollowupInboxItem {
  const NosokFollowupInboxItem({
    required this.id,
    required this.applicationId,
    required this.applicationNo,
    required this.actionKey,
    required this.actionTitleAr,
    required this.status,
    this.priority = 'normal',
    this.applicantMaskedName,
    this.noteAr,
    this.assignedUnitId,
    this.assignedUnitNameAr,
    this.resolutionNoteAr,
    this.createdAt,
    this.resolvedAt,
  });

  final String id;
  final String applicationId;
  final String applicationNo;
  final String actionKey;
  final String actionTitleAr;
  final String status;
  final String priority;
  final String? applicantMaskedName;
  final String? noteAr;
  final String? assignedUnitId;
  final String? assignedUnitNameAr;
  final String? resolutionNoteAr;
  final DateTime? createdAt;
  final DateTime? resolvedAt;

  bool get isOpen =>
      status == 'submitted' ||
      status == 'in_progress' ||
      status == 'needs_response';

  factory NosokFollowupInboxItem.fromMap(Map<String, dynamic> map) {
    return NosokFollowupInboxItem(
      id: (map['id'] ?? map['followup_id'] ?? '').toString(),
      applicationId: (map['application_id'] ?? '').toString(),
      applicationNo: (map['application_no'] ?? '').toString(),
      actionKey: (map['action_key'] ?? '').toString(),
      actionTitleAr:
          (map['action_title_ar'] ?? map['title_ar'] ?? map['action_key'] ?? '')
              .toString(),
      status: (map['status'] ?? 'submitted').toString(),
      priority: (map['priority'] ?? 'normal').toString(),
      applicantMaskedName: map['applicant_masked_name']?.toString(),
      noteAr: map['note_ar']?.toString(),
      assignedUnitId: map['assigned_unit_id']?.toString(),
      assignedUnitNameAr: map['assigned_unit_name_ar']?.toString(),
      resolutionNoteAr: map['resolution_note_ar']?.toString(),
      createdAt: _parseDateTime(map['created_at']),
      resolvedAt: _parseDateTime(map['resolved_at']),
    );
  }
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
