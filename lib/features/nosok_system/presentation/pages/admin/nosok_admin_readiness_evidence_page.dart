import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_readiness_evidence_controller.dart';
import '../../../domain/models/nosok_production_readiness_evidence.dart';
import '../../widgets/nosok_async_view.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';

class NosokAdminReadinessEvidencePage extends ConsumerStatefulWidget {
  const NosokAdminReadinessEvidencePage({super.key});

  @override
  ConsumerState<NosokAdminReadinessEvidencePage> createState() =>
      _NosokAdminReadinessEvidencePageState();
}

class _NosokAdminReadinessEvidencePageState
    extends ConsumerState<NosokAdminReadinessEvidencePage> {
  final _keyController = TextEditingController();
  final _urlController = TextEditingController();
  final _summaryController = TextEditingController();
  String _type = 'browser_uat';
  String _status = 'submitted';

  @override
  void dispose() {
    _keyController.dispose();
    _urlController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final evidenceAsync = ref.watch(nosokProductionReadinessEvidenceProvider);
    final commandState = ref.watch(nosokReadinessEvidenceCommandProvider);

    ref.listen<AsyncValue<void>>(nosokReadinessEvidenceCommandProvider,
        (previous, next) {
      if (!mounted) return;
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('فشل حفظ دليل الجاهزية: ${next.error}')));
      } else if (previous?.isLoading == true && next.hasValue) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم حفظ دليل الجاهزية.')));
        _keyController.clear();
        _urlController.clear();
        _summaryController.clear();
      }
    });

    return NosokPageScaffold(
      title: 'Production Readiness Evidence Closure',
      subtitle:
          'تجميع أدلة الإغلاق: Browser UAT، Role UAT، Console review، SQL UAT، Privacy review، Billing adapter evidence. لا ينتج عنه اعتماد إنتاج تلقائي.',
      children: [
        NosokSectionCard(
          title: 'إدخال دليل جاهزية',
          subtitle:
              'أدخل رابط/مسار الدليل أو ملخصه. الاعتماد النهائي يبقى قرار platform gate.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                      width: 240,
                      child: TextField(
                          controller: _keyController,
                          decoration: const InputDecoration(
                              labelText: 'مفتاح الدليل',
                              border: OutlineInputBorder()))),
                  SizedBox(
                    width: 220,
                    child: DropdownButtonFormField<String>(
                      value: _type,
                      decoration: const InputDecoration(
                          labelText: 'نوع الدليل',
                          border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(
                            value: 'browser_uat', child: Text('Browser UAT')),
                        DropdownMenuItem(
                            value: 'role_uat', child: Text('Role UAT')),
                        DropdownMenuItem(
                            value: 'sql_uat', child: Text('SQL UAT')),
                        DropdownMenuItem(
                            value: 'privacy_review',
                            child: Text('Privacy Review')),
                        DropdownMenuItem(
                            value: 'billing_adapter',
                            child: Text('Billing Adapter')),
                        DropdownMenuItem(
                            value: 'console_review',
                            child: Text('Console Review')),
                      ],
                      onChanged: (value) =>
                          setState(() => _type = value ?? _type),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: DropdownButtonFormField<String>(
                      value: _status,
                      decoration: const InputDecoration(
                          labelText: 'الحالة', border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(
                            value: 'submitted', child: Text('مرفق')),
                        DropdownMenuItem(
                            value: 'accepted', child: Text('مقبول')),
                        DropdownMenuItem(
                            value: 'rejected', child: Text('مرفوض')),
                        DropdownMenuItem(
                            value: 'needs_retest', child: Text('إعادة فحص')),
                      ],
                      onChanged: (value) =>
                          setState(() => _status = value ?? _status),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                  controller: _urlController,
                  decoration: const InputDecoration(
                      labelText: 'رابط/مسار الدليل',
                      border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(
                controller: _summaryController,
                decoration: const InputDecoration(
                    labelText: 'ملخص الدليل', border: OutlineInputBorder()),
                minLines: 2,
                maxLines: 4,
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: commandState.isLoading ? null : _saveEvidence,
                icon: commandState.isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.save_outlined),
                label: const Text('حفظ الدليل'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        NosokAsyncView(
          value: evidenceAsync,
          dataBuilder: (items) => NosokSectionCard(
            title: 'الأدلة المسجلة',
            subtitle:
                'حتى مع قبول كل الأدلة، يبقى الحكم production-approved قرارًا حاكمًا بعد SQL/Browser/Role UAT.',
            child: Column(
              children: [
                for (final item in items) _EvidenceTile(item: item),
                if (items.isEmpty)
                  const ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text('لا توجد أدلة جاهزية مسجلة بعد.'),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveEvidence() async {
    if (_keyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('مفتاح الدليل مطلوب.')));
      return;
    }
    await ref.read(nosokReadinessEvidenceCommandProvider.notifier).save(
          NosokProductionReadinessEvidence(
            id: '',
            evidenceKey: _keyController.text.trim(),
            evidenceType: _type,
            status: _status,
            evidenceUrl: _urlController.text.trim().isEmpty
                ? null
                : _urlController.text.trim(),
            evidenceSummaryAr: _summaryController.text.trim().isEmpty
                ? null
                : _summaryController.text.trim(),
            collectedAt: DateTime.now(),
          ),
        );
  }
}

class _EvidenceTile extends StatelessWidget {
  const _EvidenceTile({required this.item});

  final NosokProductionReadinessEvidence item;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(item.isAccepted
            ? Icons.verified_outlined
            : Icons.pending_actions_outlined),
        title: Text('${item.evidenceKey} — ${item.evidenceType}'),
        subtitle: Text([
          'الحالة: ${item.status}',
          if ((item.evidenceUrl ?? '').trim().isNotEmpty)
            'الدليل: ${item.evidenceUrl}',
          if ((item.evidenceSummaryAr ?? '').trim().isNotEmpty)
            item.evidenceSummaryAr!,
        ].join('\n')),
        isThreeLine: true,
      ),
    );
  }
}
