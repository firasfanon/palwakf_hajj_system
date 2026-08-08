class NosokApplicationDocument {
  const NosokApplicationDocument({
    required this.id,
    required this.applicationId,
    required this.documentType,
    required this.reviewStatus,
    this.documentTitle,
    this.originalFileName,
    this.fileUrl,
    this.storageBucket,
    this.storagePath,
    this.mimeType,
    this.fileSizeBytes,
    this.reviewNotes,
    this.notes,
    this.uploadedAt,
    this.reviewedAt,
  });

  final String id;
  final String applicationId;
  final String documentType;
  final String reviewStatus;
  final String? documentTitle;
  final String? originalFileName;
  final String? fileUrl;
  final String? storageBucket;
  final String? storagePath;
  final String? mimeType;
  final int? fileSizeBytes;
  final String? reviewNotes;
  final String? notes;
  final DateTime? uploadedAt;
  final DateTime? reviewedAt;

  factory NosokApplicationDocument.empty({String? applicationId}) {
    return NosokApplicationDocument(
      id: '',
      applicationId: applicationId ?? '',
      documentType: 'identity',
      reviewStatus: 'pending',
    );
  }

  factory NosokApplicationDocument.fromMap(Map<String, dynamic> map) {
    return NosokApplicationDocument(
      id: (map['id'] ?? '').toString(),
      applicationId: (map['application_id'] ?? '').toString(),
      documentType: (map['document_type'] ?? '').toString(),
      reviewStatus: (map['review_status'] ?? '').toString(),
      documentTitle: map['document_title']?.toString(),
      originalFileName: map['original_file_name']?.toString(),
      fileUrl: map['file_url']?.toString(),
      storageBucket: map['storage_bucket']?.toString(),
      storagePath: map['storage_path']?.toString(),
      mimeType: map['mime_type']?.toString(),
      fileSizeBytes: (map['file_size_bytes'] as num?)?.toInt(),
      reviewNotes: map['review_notes']?.toString(),
      notes: map['notes']?.toString(),
      uploadedAt: _parseDateTime(map['uploaded_at']),
      reviewedAt: _parseDateTime(map['reviewed_at']),
    );
  }

  NosokApplicationDocument copyWith({
    String? id,
    String? applicationId,
    String? documentType,
    String? reviewStatus,
    String? documentTitle,
    String? originalFileName,
    String? fileUrl,
    String? storageBucket,
    String? storagePath,
    String? mimeType,
    int? fileSizeBytes,
    String? reviewNotes,
    String? notes,
    DateTime? uploadedAt,
    DateTime? reviewedAt,
  }) {
    return NosokApplicationDocument(
      id: id ?? this.id,
      applicationId: applicationId ?? this.applicationId,
      documentType: documentType ?? this.documentType,
      reviewStatus: reviewStatus ?? this.reviewStatus,
      documentTitle: documentTitle ?? this.documentTitle,
      originalFileName: originalFileName ?? this.originalFileName,
      fileUrl: fileUrl ?? this.fileUrl,
      storageBucket: storageBucket ?? this.storageBucket,
      storagePath: storagePath ?? this.storagePath,
      mimeType: mimeType ?? this.mimeType,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      reviewNotes: reviewNotes ?? this.reviewNotes,
      notes: notes ?? this.notes,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
    );
  }

  Map<String, dynamic> toUpsertMap() {
    final map = <String, dynamic>{
      'application_id': applicationId,
      'document_type': documentType,
      'document_title': documentTitle,
      'original_file_name': originalFileName,
      'file_url': fileUrl,
      'storage_bucket': storageBucket,
      'storage_path': storagePath,
      'mime_type': mimeType,
      'file_size_bytes': fileSizeBytes,
      'review_status': reviewStatus,
      'review_notes': reviewNotes,
      'notes': notes,
    };
    if (id.trim().isNotEmpty) {
      map['id'] = id;
    }
    return map;
  }
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
