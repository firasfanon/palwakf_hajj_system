import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mime/mime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/nosok_storage_upload_result.dart';

final nosokFileUploadServiceProvider = Provider<NosokFileUploadService>((ref) {
  try {
    return NosokFileUploadService.supabase(Supabase.instance.client);
  } catch (_) {
    return NosokFileUploadService.disabled();
  }
});

class NosokFileUploadService {
  NosokFileUploadService.supabase(SupabaseClient client) : _client = client;
  NosokFileUploadService.disabled() : _client = null;

  static const String publicBucket = 'nosok-public';

  final SupabaseClient? _client;

  bool get isEnabled => _client != null;

  Future<NosokStorageUploadResult?> pickAndUpload({
    required String folder,
    List<String>? allowedExtensions,
    String bucket = publicBucket,
  }) async {
    final client = _client;
    if (client == null) {
      throw StateError(
          'رفع الملفات يحتاج Supabase مفعّلًا. في standalone preview أضف SUPABASE_URL وSUPABASE_ANON_KEY أو استخدم بيانات نصية تجريبية.');
    }

    final picked = await FilePicker.platform.pickFiles(
      withData: true,
      type: allowedExtensions == null || allowedExtensions.isEmpty
          ? FileType.any
          : FileType.custom,
      allowedExtensions: allowedExtensions,
    );
    if (picked == null || picked.files.isEmpty) {
      return null;
    }

    final file = picked.files.first;
    final bytes = file.bytes;
    if (bytes == null || bytes.isEmpty) {
      throw StateError('تعذر قراءة الملف المختار من الجهاز.');
    }

    final cleanName = _sanitizeFileName(file.name);
    final path = '$folder/${DateTime.now().microsecondsSinceEpoch}-$cleanName';
    final mimeType =
        lookupMimeType(file.name, headerBytes: bytes.take(12).toList()) ??
            'application/octet-stream';

    await client.storage.from(bucket).uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            upsert: false,
            contentType: mimeType,
          ),
        );

    final publicUrl = client.storage.from(bucket).getPublicUrl(path);

    return NosokStorageUploadResult(
      bucket: bucket,
      path: path,
      publicUrl: publicUrl,
      originalFileName: file.name,
      mimeType: mimeType,
      fileSizeBytes: file.size,
    );
  }

  String _sanitizeFileName(String input) {
    return input.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
  }
}
