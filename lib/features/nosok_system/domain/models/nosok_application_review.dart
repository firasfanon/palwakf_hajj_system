class NosokApplicationReview {
  const NosokApplicationReview({
    required this.id,
    required this.applicationId,
    required this.reviewAction,
    this.reviewerUserId,
    this.reviewReason,
    this.createdAt,
  });

  final String id;
  final String applicationId;
  final String reviewAction;
  final String? reviewerUserId;
  final String? reviewReason;
  final DateTime? createdAt;

  factory NosokApplicationReview.fromMap(Map<String, dynamic> map) {
    return NosokApplicationReview(
      id: (map['id'] ?? '').toString(),
      applicationId: (map['application_id'] ?? '').toString(),
      reviewAction: (map['review_action'] ?? '').toString(),
      reviewerUserId: map['reviewer_user_id']?.toString(),
      reviewReason: map['review_reason']?.toString(),
      createdAt: map['created_at'] == null
          ? null
          : DateTime.tryParse(map['created_at'].toString()),
    );
  }
}
