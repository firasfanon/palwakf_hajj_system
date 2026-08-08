import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/nosok_supabase_repository.dart';
import '../domain/models/nosok_application_document.dart';

final nosokApplicationDocumentsProvider =
    FutureProvider.family<List<NosokApplicationDocument>, String>(
        (ref, applicationId) {
  return ref
      .read(nosokRepositoryProvider)
      .listApplicationDocuments(applicationId);
});
