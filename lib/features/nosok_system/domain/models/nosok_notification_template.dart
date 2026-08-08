class NosokNotificationTemplate {
  const NosokNotificationTemplate({
    required this.id,
    required this.templateKey,
    required this.channel,
    required this.titleAr,
    required this.bodyAr,
    this.triggerEvent,
    this.isActive = true,
    this.notesAr,
  });

  final String id;
  final String templateKey;
  final String channel;
  final String titleAr;
  final String bodyAr;
  final String? triggerEvent;
  final bool isActive;
  final String? notesAr;

  factory NosokNotificationTemplate.fromMap(Map<String, dynamic> map) {
    return NosokNotificationTemplate(
      id: (map['id'] ?? '').toString(),
      templateKey: (map['template_key'] ?? '').toString(),
      channel: (map['channel'] ?? 'in_app').toString(),
      titleAr: (map['title_ar'] ?? '').toString(),
      bodyAr: (map['body_ar'] ?? '').toString(),
      triggerEvent: map['trigger_event']?.toString(),
      isActive: map['is_active'] == null ? true : map['is_active'] == true,
      notesAr: map['notes_ar']?.toString(),
    );
  }
}
