class NosokStorageUploadResult {
  const NosokStorageUploadResult({
    required this.bucket,
    required this.path,
    required this.publicUrl,
    required this.originalFileName,
    this.mimeType,
    this.fileSizeBytes,
  });

  final String bucket;
  final String path;
  final String publicUrl;
  final String originalFileName;
  final String? mimeType;
  final int? fileSizeBytes;
}
