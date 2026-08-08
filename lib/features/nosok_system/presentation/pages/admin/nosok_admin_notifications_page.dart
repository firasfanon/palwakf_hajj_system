import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_notifications_controller.dart';
import '../../widgets/nosok_async_view.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';

class NosokAdminNotificationsPage extends ConsumerWidget {
  const NosokAdminNotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(nosokNotificationTemplatesProvider);

    return NosokPageScaffold(
      title: 'قوالب الإشعارات',
      subtitle:
          'قوالب تشغيلية للأحداث الأساسية. الإرسال الحقيقي يجب أن يمر عبر خدمة إشعارات المنصة عند الدمج الإنتاجي.',
      children: [
        NosokAsyncView(
          value: templatesAsync,
          dataBuilder: (templates) => NosokSectionCard(
            title: 'القوالب',
            child: Column(
              children: [
                for (final template in templates)
                  ListTile(
                    leading: Icon(template.isActive
                        ? Icons.notifications_active_outlined
                        : Icons.notifications_off_outlined),
                    title: Text(template.titleAr),
                    subtitle: Text(
                        '${template.templateKey} — ${template.channel}\n${template.bodyAr}'),
                    trailing:
                        Chip(label: Text(template.triggerEvent ?? 'manual')),
                  ),
                if (templates.isEmpty)
                  const ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text('لا توجد قوالب بعد'),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
