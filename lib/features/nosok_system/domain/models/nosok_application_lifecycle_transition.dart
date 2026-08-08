class NosokApplicationLifecycleTransition {
  const NosokApplicationLifecycleTransition({
    required this.id,
    required this.applicationId,
    required this.applicationNo,
    required this.transitionKey,
    required this.fromStatus,
    required this.toStatus,
    this.eligibilityStatus,
    this.actorRole,
    this.reasonAr,
    this.noteAr,
    this.isAllowed = true,
    this.blockerReasonAr,
    this.createdAt,
  });

  final String id;
  final String applicationId;
  final String applicationNo;
  final String transitionKey;
  final String fromStatus;
  final String toStatus;
  final String? eligibilityStatus;
  final String? actorRole;
  final String? reasonAr;
  final String? noteAr;
  final bool isAllowed;
  final String? blockerReasonAr;
  final DateTime? createdAt;

  factory NosokApplicationLifecycleTransition.fromMap(
      Map<String, dynamic> map) {
    return NosokApplicationLifecycleTransition(
      id: (map['id'] ?? map['transition_id'] ?? '').toString(),
      applicationId: (map['application_id'] ?? '').toString(),
      applicationNo: (map['application_no'] ?? '').toString(),
      transitionKey: (map['transition_key'] ?? '').toString(),
      fromStatus: (map['from_status'] ?? '').toString(),
      toStatus: (map['to_status'] ?? '').toString(),
      eligibilityStatus: map['eligibility_status']?.toString(),
      actorRole: map['actor_role']?.toString(),
      reasonAr: map['reason_ar']?.toString(),
      noteAr: map['note_ar']?.toString(),
      isAllowed: map['is_allowed'] == null
          ? true
          : map['is_allowed'] == true || map['is_allowed'].toString() == 'true',
      blockerReasonAr: map['blocker_reason_ar']?.toString(),
      createdAt: _parseDateTime(map['created_at']),
    );
  }
}

class NosokApplicationLifecycleRule {
  const NosokApplicationLifecycleRule({
    required this.transitionKey,
    required this.titleAr,
    required this.fromStatus,
    required this.toStatus,
    this.descriptionAr,
    this.requiredPermission,
    this.requiresReason = false,
    this.isEnabled = true,
    this.displayOrder = 100,
  });

  final String transitionKey;
  final String titleAr;
  final String fromStatus;
  final String toStatus;
  final String? descriptionAr;
  final String? requiredPermission;
  final bool requiresReason;
  final bool isEnabled;
  final int displayOrder;

  factory NosokApplicationLifecycleRule.fromMap(Map<String, dynamic> map) {
    return NosokApplicationLifecycleRule(
      transitionKey: (map['transition_key'] ?? '').toString(),
      titleAr: (map['title_ar'] ?? '').toString(),
      fromStatus: (map['from_status'] ?? '').toString(),
      toStatus: (map['to_status'] ?? '').toString(),
      descriptionAr: map['description_ar']?.toString(),
      requiredPermission: map['required_permission']?.toString(),
      requiresReason: map['requires_reason'] == true ||
          map['requires_reason']?.toString() == 'true',
      isEnabled: map['is_enabled'] == null
          ? true
          : map['is_enabled'] == true || map['is_enabled'].toString() == 'true',
      displayOrder: (map['display_order'] as num?)?.toInt() ?? 100,
    );
  }
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
