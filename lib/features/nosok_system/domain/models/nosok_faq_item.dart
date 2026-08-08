class NosokFaqItem {
  const NosokFaqItem({
    required this.id,
    required this.questionAr,
    required this.answerAr,
    required this.displayOrder,
    required this.isPublished,
  });

  final String id;
  final String questionAr;
  final String answerAr;
  final int displayOrder;
  final bool isPublished;

  factory NosokFaqItem.fromMap(Map<String, dynamic> map) {
    return NosokFaqItem(
      id: map['id'].toString(),
      questionAr: (map['question_ar'] ?? '') as String,
      answerAr: (map['answer_ar'] ?? '') as String,
      displayOrder: (map['display_order'] ?? 0) as int,
      isPublished: (map['is_published'] ?? false) as bool,
    );
  }
}
