class NosokAnnouncement {
  const NosokAnnouncement({
    required this.id,
    required this.titleAr,
    required this.bodyAr,
    required this.priority,
    required this.isPublished,
  });

  final String id;
  final String titleAr;
  final String bodyAr;
  final int priority;
  final bool isPublished;

  factory NosokAnnouncement.fromMap(Map<String, dynamic> map) {
    return NosokAnnouncement(
      id: map['id'].toString(),
      titleAr: (map['title_ar'] ?? '') as String,
      bodyAr: (map['body_ar'] ?? '') as String,
      priority: (map['priority'] ?? 0) as int,
      isPublished: (map['is_published'] ?? false) as bool,
    );
  }
}
