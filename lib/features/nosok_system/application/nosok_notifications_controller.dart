import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/nosok_supabase_repository.dart';
import '../domain/models/nosok_notification_template.dart';

final nosokNotificationTemplatesProvider =
    FutureProvider<List<NosokNotificationTemplate>>((ref) {
  return ref.read(nosokRepositoryProvider).listNotificationTemplates();
});
