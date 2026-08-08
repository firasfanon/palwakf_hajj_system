class NosokComplaint {
  const NosokComplaint({
    required this.id,
    required this.complaintNo,
    required this.subject,
    required this.complainantName,
    required this.status,
    required this.priority,
  });

  final String id;
  final String complaintNo;
  final String subject;
  final String complainantName;
  final String status;
  final String priority;

  factory NosokComplaint.fromMap(Map<String, dynamic> map) {
    return NosokComplaint(
      id: (map['id'] ?? '').toString(),
      complaintNo: (map['complaint_no'] ?? '').toString(),
      subject: (map['subject'] ?? '').toString(),
      complainantName: (map['complainant_name'] ?? '').toString(),
      status: (map['status'] ?? '').toString(),
      priority: (map['priority'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toInsertMap() {
    return <String, dynamic>{
      'complaint_no': complaintNo,
      'subject': subject,
      'complainant_name': complainantName,
      'status': status,
      'priority': priority,
    };
  }
}
