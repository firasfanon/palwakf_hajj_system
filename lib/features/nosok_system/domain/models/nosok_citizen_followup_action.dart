class NosokCitizenFollowupAction {
  const NosokCitizenFollowupAction({
    required this.actionKey,
    required this.titleAr,
    required this.descriptionAr,
    this.actionType = 'request',
    this.routePath,
    this.enabled = true,
    this.requiresNote = false,
    this.status = 'available',
    this.displayOrder = 100,
  });

  final String actionKey;
  final String titleAr;
  final String descriptionAr;
  final String actionType;
  final String? routePath;
  final bool enabled;
  final bool requiresNote;
  final String status;
  final int displayOrder;

  factory NosokCitizenFollowupAction.fromMap(Map<String, dynamic> map) {
    return NosokCitizenFollowupAction(
      actionKey: (map['action_key'] ?? '').toString(),
      titleAr: (map['title_ar'] ?? '').toString(),
      descriptionAr: (map['description_ar'] ?? '').toString(),
      actionType: (map['action_type'] ?? 'request').toString(),
      routePath: map['route_path']?.toString(),
      enabled: map['enabled'] == null
          ? true
          : map['enabled'] == true || map['enabled'].toString() == 'true',
      requiresNote: map['requires_note'] == true ||
          map['requires_note']?.toString() == 'true',
      status: (map['status'] ?? 'available').toString(),
      displayOrder: (map['display_order'] as num?)?.toInt() ?? 100,
    );
  }
}

class NosokCitizenFollowupRequest {
  const NosokCitizenFollowupRequest({
    required this.id,
    required this.applicationNo,
    required this.actionKey,
    required this.status,
    this.noteAr,
    this.createdAt,
  });

  final String id;
  final String applicationNo;
  final String actionKey;
  final String status;
  final String? noteAr;
  final DateTime? createdAt;

  factory NosokCitizenFollowupRequest.fromMap(Map<String, dynamic> map) {
    return NosokCitizenFollowupRequest(
      id: (map['id'] ?? '').toString(),
      applicationNo: (map['application_no'] ?? '').toString(),
      actionKey: (map['action_key'] ?? '').toString(),
      status: (map['status'] ?? 'submitted').toString(),
      noteAr: map['note_ar']?.toString(),
      createdAt: _parseDateTime(map['created_at']),
    );
  }
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
