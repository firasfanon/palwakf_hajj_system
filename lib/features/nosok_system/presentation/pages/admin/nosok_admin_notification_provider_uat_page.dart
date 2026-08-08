import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_notification_provider_uat_controller.dart';
import '../../../domain/models/nosok_notification_provider_adapter_uat.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';
import '../../widgets/nosok_stat_card.dart';

class NosokAdminNotificationProviderUatPage extends ConsumerWidget {
  const NosokAdminNotificationProviderUatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adaptersAsync = ref.watch(nosokNotificationProviderAdaptersProvider);
    final resultsAsync =
        ref.watch(nosokNotificationProviderUatResultsProvider(null));

    return NosokPageScaffold(
      title: 'UAT مزودات الإشعارات',
      subtitle:
          'اختبارات تكامل جسر إشعارات نسك مع خدمات إشعارات PalWakf دون تحويل نسك إلى محرك SMS/Email مستقل.',
      children: [
        adaptersAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => NosokSectionCard(
              title: 'تعذر تحميل الـ Adapters',
              child: const Text(
                  'تعذر تحميل البيانات حاليًا. أعد المحاولة أو تواصل مع الدعم الفني إذا استمرت المشكلة.')),
          data: (adapters) => _AdaptersSection(adapters: adapters),
        ),
        const SizedBox(height: 16),
        resultsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => NosokSectionCard(
              title: 'تعذر تحميل نتائج UAT',
              child: const Text(
                  'تعذر تحميل البيانات حاليًا. أعد المحاولة أو تواصل مع الدعم الفني إذا استمرت المشكلة.')),
          data: (results) => _ResultsSection(results: results),
        ),
      ],
    );
  }
}

class _AdaptersSection extends ConsumerWidget {
  const _AdaptersSection({required this.adapters});
  final List<NosokNotificationProviderAdapter> adapters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ready = adapters
        .where((item) =>
            item.healthStatus == 'passed' ||
            item.healthStatus == 'contract_ready')
        .length;
    return NosokSectionCard(
      title: 'مزودات الإشعارات المسجلة',
      subtitle:
          'كل Adapter يمثل عقدًا مع خدمة إشعارات المنصة، وليس تخزينًا لأسرار مزود خارجي داخل نسك.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              NosokStatCard(
                  label: 'المزودات', value: adapters.length.toString()),
              NosokStatCard(label: 'جاهزة/عقدية', value: ready.toString()),
            ],
          ),
          const SizedBox(height: 16),
          if (adapters.isEmpty)
            const Text('لا توجد مزودات إشعارات مسجلة.')
          else
            Column(
              children: adapters.map((adapter) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(adapter.titleAr,
                                style: Theme.of(context).textTheme.titleMedium),
                            _Badge(label: adapter.channel),
                            _Badge(label: adapter.healthStatus),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('provider_key: ${adapter.providerKey}'),
                        Text(
                            'mode: ${adapter.adapterMode} — signature: ${adapter.requiresSignature ? 'مطلوب' : 'غير مطلوب'}'),
                        if ((adapter.callbackPath ?? '').trim().isNotEmpty)
                          Text('callback: ${adapter.callbackPath}'),
                        if ((adapter.notesAr ?? '').trim().isNotEmpty)
                          Text(adapter.notesAr!),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            FilledButton.tonal(
                              onPressed: () => _run(
                                  context, ref, adapter, 'contract_health'),
                              child: const Text('اختبار العقد'),
                            ),
                            OutlinedButton(
                              onPressed: () => _run(context, ref, adapter,
                                  'safe_payload_preview'),
                              child: const Text('اختبار خصوصية النص'),
                            ),
                            OutlinedButton(
                              onPressed: () => _run(context, ref, adapter,
                                  'dispatch_queue_bridge'),
                              child: const Text('اختبار الطابور'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Future<void> _run(BuildContext context, WidgetRef ref,
      NosokNotificationProviderAdapter adapter, String testKey) async {
    await ref.read(nosokNotificationProviderUatControllerProvider.notifier).run(
          providerKey: adapter.providerKey,
          testKey: testKey,
        );
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('تم تشغيل اختبار UAT.')));
    }
  }
}

class _ResultsSection extends StatelessWidget {
  const _ResultsSection({required this.results});
  final List<NosokNotificationProviderUatResult> results;

  @override
  Widget build(BuildContext context) {
    final passed = results.where((item) => item.passed).length;
    return NosokSectionCard(
      title: 'نتائج UAT',
      subtitle:
          'هذه الأدلة تدخل لاحقًا ضمن قرار readiness/production gate ولا تعني اعتماد الإنتاج تلقائيًا.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              NosokStatCard(label: 'النتائج', value: results.length.toString()),
              NosokStatCard(label: 'ناجحة', value: passed.toString()),
            ],
          ),
          const SizedBox(height: 16),
          if (results.isEmpty)
            const Text('لا توجد نتائج بعد.')
          else
            Column(
              children: results.map((result) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(result.passed
                      ? Icons.check_circle_outline
                      : Icons.info_outline),
                  title: Text('${result.providerKey} — ${result.testKey}'),
                  subtitle: Text([
                    result.status,
                    result.actualAr ?? '',
                    result.errorMessage ?? '',
                  ].where((item) => item.trim().isNotEmpty).join(' • ')),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(label),
      ),
    );
  }
}
