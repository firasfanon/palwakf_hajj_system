import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/nosok_supabase_repository.dart';
import '../domain/models/nosok_application_payment.dart';

final nosokApplicationPaymentsProvider =
    FutureProvider.family<List<NosokApplicationPayment>, String>(
        (ref, applicationId) {
  return ref
      .read(nosokRepositoryProvider)
      .listApplicationPayments(applicationId);
});
