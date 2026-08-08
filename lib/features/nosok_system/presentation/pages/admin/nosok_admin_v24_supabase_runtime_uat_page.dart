import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v24_uat_controller.dart';
import '../../../domain/models/nosok_v24_uat_models.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV24SupabaseRuntimeUatPage extends ConsumerWidget {
  const NosokAdminV24SupabaseRuntimeUatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV24UatPackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
          title: 'تعذر تحميل Supabase UAT',
          message:
              'تعذر تحميل حزمة فحص Supabase. لا يتم عرض stack trace للمستخدم.',
          tone: PwfSisNoticeTone.error),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title: 'Supabase Runtime UAT Pack',
            description:
                'حزمة فحص read-only لعقود schema/RPC/RLS/storage قبل أي SQL إنتاجي أو بيانات حقيقية.',
            badges: ['read-only', 'no DML', 'no waqf assets mutation'],
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'حد أمان SQL',
            message:
                'ملف v24 المرفق read-only فقط. أي seed أو إنشاء بيانات staging يحتاج موافقة صريحة لاحقة.',
            tone: PwfSisNoticeTone.info,
          ),
          const SizedBox(height: 12),
          for (final group in data.supabaseGroups) ...[
            _V24EvidenceGroupPanel(group: group),
            const SizedBox(height: 12),
          ],
          const PwfSisPanel(
            title: 'أوامر SQL UAT',
            subtitle:
                'نفذ الملف داخل Supabase SQL Editor بعد تطبيق العقود السابقة حسب التسلسل.',
            child: SelectableText(
                '-- read-only\n\\i sql/22_nosok_v24_read_only_uat_pack.sql\n\n-- أو انسخ محتواه إلى SQL Editor وشغل الاستعلامات كما هي.'),
          ),
        ],
      ),
    );
  }
}

class _V24EvidenceGroupPanel extends StatelessWidget {
  const _V24EvidenceGroupPanel({required this.group});
  final NosokV24EvidenceGroup group;
  @override
  Widget build(BuildContext context) {
    return PwfSisPanel(
      title: group.titleAr,
      subtitle: group.descriptionAr,
      actions: [
        PwfSisStatusBadge(
            label: '${group.passedCount}/${group.items.length} passed',
            tone: group.blockersCount == 0
                ? PwfSisNoticeTone.success
                : PwfSisNoticeTone.warning),
      ],
      child: Column(
        children: [for (final item in group.items) _V24CheckTile(item: item)],
      ),
    );
  }
}

class _V24CheckTile extends StatelessWidget {
  const _V24CheckTile({required this.item});
  final NosokV24CheckItem item;
  @override
  Widget build(BuildContext context) {
    final tone = switch (item.status) {
      'passed' => PwfSisNoticeTone.success,
      'blocked' => PwfSisNoticeTone.error,
      'ready' => PwfSisNoticeTone.info,
      _ => PwfSisNoticeTone.warning,
    };
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(item.blocked
          ? Icons.block_outlined
          : item.passed
              ? Icons.check_circle_outline
              : Icons.pending_actions_outlined),
      title: Text(item.titleAr),
      subtitle: Text(item.noteAr),
      trailing: Wrap(spacing: 6, children: [
        PwfSisStatusBadge(label: item.status, tone: tone),
        PwfSisStatusBadge(label: item.priority),
      ]),
    );
  }
}
