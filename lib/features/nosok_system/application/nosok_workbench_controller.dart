import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/nosok_supabase_repository.dart';
import '../domain/models/nosok_workflow_bucket.dart';

final nosokWorkflowBucketsProvider =
    FutureProvider<List<NosokWorkflowBucket>>((ref) {
  return ref.read(nosokRepositoryProvider).listWorkflowBuckets();
});
