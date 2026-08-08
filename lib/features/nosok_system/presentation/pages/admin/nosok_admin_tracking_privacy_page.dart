import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_tracking_privacy_controller.dart';
import '../../../domain/models/nosok_public_tracking_privacy_check.dart';
import '../../widgets/nosok_async_view.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';

class NosokAdminTrackingPrivacyPage extends ConsumerWidget {
  const NosokAdminTrackingPrivacyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checksAsync = ref.watch(nosokTrackingPrivacyChecksProvider);
    final commandState = ref.watch(nosokTrackingPrivacyCommandProvider);

    ref.listen<AsyncValue<void>>(nosokTrackingPrivacyCommandProvider,
        (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('فشل حفظ مراجعة الخصوصية: ${next.error}')));
      } else if (previous?.isLoading == true && next.hasValue) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم حفظ مراجعة خصوصية التتبع.')));
      }
    });

    return NosokPageScaffold(
      title: 'مراجعة خصوصية التتبع العام',
      subtitle:
          'تضمن أن صفحة متابعة الطلب تعرض الحد الأدنى فقط عبر tracking_token ولا تكشف رقم الهوية أو الهاتف أو تفاصيل مالية/وثائقية حساسة.',
      children: [
        NosokSectionCard(
          title: 'حد العرض العام المسموح',
          subtitle: 'أي حقل خارج هذه القائمة يحتاج قرار خصوصية صريح قبل النشر.',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              Chip(label: Text('application_no')),
              Chip(label: Text('application_status')),
              Chip(label: Text('eligibility_status')),
              Chip(label: Text('service_type')),
              Chip(label: Text('submitted_at')),
              Chip(label: Text('مؤشرات إجمالية فقط للوثائق/الدفعات')),
            ],
          ),
        ),
        const SizedBox(height: 12),
        NosokAsyncView(
          value: checksAsync,
          dataBuilder: (checks) => NosokSectionCard(
            title: 'فحوص الخصوصية',
            subtitle:
                'الفحوص blocker تمنع إعلان production readiness حتى يتم إغلاقها بدليل Browser/SQL.',
            child: Column(
              children: [
                for (final check in checks)
                  _PrivacyCheckTile(
                      check: check, isBusy: commandState.isLoading),
                if (checks.isEmpty)
                  const ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text(
                        'لا توجد فحوص خصوصية. شغّل SQL v13 لإضافة matrix الخصوصية.'),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PrivacyCheckTile extends ConsumerWidget {
  const _PrivacyCheckTile({required this.check, required this.isBusy});

  final NosokPublicTrackingPrivacyCheck check;
  final bool isBusy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(check.titleAr,
                        style: Theme.of(context).textTheme.titleMedium)),
                Icon(check.isBlocking
                    ? Icons.lock_outline
                    : Icons.verified_outlined),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text(check.checkKey)),
                Chip(label: Text('الحالة: ${check.status}')),
                Chip(label: Text('الأثر: ${check.severity}')),
              ],
            ),
            if (check.publicDataFields.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('حقول مسموحة: ${check.publicDataFields.join(', ')}'),
            ],
            if (check.blockedFields.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('حقول محجوبة: ${check.blockedFields.join(', ')}'),
            ],
            if ((check.evidenceNoteAr ?? '').trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(check.evidenceNoteAr!),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: isBusy
                      ? null
                      : () => ref
                          .read(nosokTrackingPrivacyCommandProvider.notifier)
                          .markReviewed(
                            checkKey: check.checkKey,
                            status: 'passed',
                            evidenceNote:
                                'تمت المراجعة من صفحة خصوصية التتبع v13؛ يلزم إرفاق Screenshot/SQL evidence في readiness evidence قبل اعتماد الإنتاج.',
                          ),
                  icon: const Icon(Icons.verified_outlined),
                  label: const Text('تمييز كمجتاز'),
                ),
                OutlinedButton.icon(
                  onPressed: isBusy
                      ? null
                      : () => ref
                          .read(nosokTrackingPrivacyCommandProvider.notifier)
                          .markReviewed(
                            checkKey: check.checkKey,
                            status: 'needs_evidence',
                            evidenceNote:
                                'يحتاج دليلًا إضافيًا قبل إغلاق بوابة الخصوصية.',
                          ),
                  icon: const Icon(Icons.pending_actions_outlined),
                  label: const Text('يحتاج دليلًا'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
