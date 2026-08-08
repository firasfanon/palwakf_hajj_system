import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_role_uat_controller.dart';
import '../../../application/nosok_role_uat_evidence_controller.dart';
import '../../../domain/models/nosok_role_uat_case.dart';
import '../../../domain/models/nosok_role_uat_evidence.dart';
import '../../widgets/nosok_async_view.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';

class NosokAdminRoleUatPage extends ConsumerWidget {
  const NosokAdminRoleUatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final casesAsync = ref.watch(nosokRoleUatCasesProvider);
    final evidenceAsync = ref.watch(nosokRoleUatEvidenceProvider);

    return NosokPageScaffold(
      title: 'مصفوفة اختبار الأدوار والأدلة',
      subtitle:
          'استيعاب أدلة Role UAT من المتصفح: الدور، السطح، المتوقع، الفعلي، النتيجة، ورابط/ملاحظة الدليل.',
      children: [
        NosokAsyncView(
          value: casesAsync,
          dataBuilder: (cases) => NosokSectionCard(
            title: 'Role-Based UAT Matrix',
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('الدور')),
                  DataColumn(label: Text('السطح')),
                  DataColumn(label: Text('المتوقع')),
                  DataColumn(label: Text('الفعلي')),
                  DataColumn(label: Text('الحالة')),
                  DataColumn(label: Text('دليل')),
                ],
                rows: [
                  for (final item in cases)
                    DataRow(cells: [
                      DataCell(Text(item.roleKey)),
                      DataCell(Text(item.surfaceKey)),
                      DataCell(Text(item.expectedAccess)),
                      DataCell(Text(item.actualAccess ?? 'غير مختبر')),
                      DataCell(Chip(label: Text(item.status))),
                      DataCell(TextButton.icon(
                        onPressed: () =>
                            _openEvidenceDialog(context, ref, item),
                        icon: const Icon(Icons.add_a_photo_outlined),
                        label: const Text('إضافة دليل'),
                      )),
                    ]),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        NosokAsyncView(
          value: evidenceAsync,
          dataBuilder: (evidence) => NosokSectionCard(
            title: 'أدلة الاختبار المستوعبة',
            child: Column(
              children: [
                for (final item in evidence)
                  ListTile(
                    leading: Icon(item.resultStatus == 'passed'
                        ? Icons.verified_outlined
                        : Icons.warning_amber_outlined),
                    title: Text('${item.roleKey} — ${item.surfaceKey}'),
                    subtitle: Text([
                      'المتوقع: ${item.expectedAccess}',
                      'الفعلي: ${item.actualAccess}',
                      'النتيجة: ${item.resultStatus}',
                      if ((item.evidenceUrl ?? '').trim().isNotEmpty)
                        'دليل: ${item.evidenceUrl}',
                    ].join(' • ')),
                  ),
                if (evidence.isEmpty)
                  const ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text('لم يتم إدخال أدلة بعد.'),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openEvidenceDialog(
      BuildContext context, WidgetRef ref, NosokRoleUatCase item) async {
    final actualController = TextEditingController(
        text: item.expectedAccess == 'deny' ? 'deny' : 'allow');
    final evidenceController = TextEditingController();
    final notesController = TextEditingController();
    String resultStatus = 'passed';

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('إضافة دليل Role UAT'),
            content: SizedBox(
              width: 520,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${item.roleKey} — ${item.surfaceKey}'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: actualController,
                    decoration: const InputDecoration(
                        labelText: 'الوصول الفعلي',
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: resultStatus,
                    decoration: const InputDecoration(
                        labelText: 'نتيجة الاختبار',
                        border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'passed', child: Text('passed')),
                      DropdownMenuItem(value: 'failed', child: Text('failed')),
                      DropdownMenuItem(
                          value: 'blocked', child: Text('blocked')),
                      DropdownMenuItem(
                          value: 'needs_retest', child: Text('needs_retest')),
                    ],
                    onChanged: (value) =>
                        setState(() => resultStatus = value ?? 'passed'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: evidenceController,
                    decoration: const InputDecoration(
                        labelText: 'رابط لقطة/دليل اختياري',
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: notesController,
                    minLines: 2,
                    maxLines: 3,
                    decoration: const InputDecoration(
                        labelText: 'ملاحظات', border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('إلغاء')),
              FilledButton(
                onPressed: () async {
                  await ref
                      .read(nosokRoleUatEvidenceControllerProvider.notifier)
                      .saveEvidence(
                        NosokRoleUatEvidence(
                          id: '',
                          matrixCaseId: item.id,
                          roleKey: item.roleKey,
                          surfaceKey: item.surfaceKey,
                          expectedAccess: item.expectedAccess,
                          actualAccess: actualController.text.trim(),
                          resultStatus: resultStatus,
                          evidenceUrl: evidenceController.text.trim().isEmpty
                              ? null
                              : evidenceController.text.trim(),
                          notesAr: notesController.text.trim().isEmpty
                              ? null
                              : notesController.text.trim(),
                        ),
                      );
                  if (dialogContext.mounted) Navigator.of(dialogContext).pop();
                },
                child: const Text('حفظ الدليل'),
              ),
            ],
          ),
        );
      },
    );
  }
}
