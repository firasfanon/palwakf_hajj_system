import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/nosok_supabase_repository.dart';
import '../domain/models/nosok_announcement.dart';
import '../domain/models/nosok_faq_item.dart';

class NosokPublicHomeState {
  const NosokPublicHomeState({
    required this.announcements,
    required this.faqItems,
  });

  final List<NosokAnnouncement> announcements;
  final List<NosokFaqItem> faqItems;
}

final nosokPublicHomeControllerProvider =
    AsyncNotifierProvider<NosokPublicHomeController, NosokPublicHomeState>(
  NosokPublicHomeController.new,
);

class NosokPublicHomeController extends AsyncNotifier<NosokPublicHomeState> {
  @override
  Future<NosokPublicHomeState> build() async {
    final repo = ref.read(nosokRepositoryProvider);
    final announcements = await repo.listAnnouncements();
    final faqItems = await repo.listFaqItems();

    return NosokPublicHomeState(
      announcements: announcements,
      faqItems: faqItems,
    );
  }
}
