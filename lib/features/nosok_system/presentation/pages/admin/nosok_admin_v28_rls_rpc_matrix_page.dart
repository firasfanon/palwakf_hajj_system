import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v28_owner_schema_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV28RlsRpcMatrixPage extends ConsumerWidget {
  const NosokAdminV28RlsRpcMatrixPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV28OwnerSchemaDesignPackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
          title: 'تعذر تحميل matrices',
          message: 'تعذر تحميل RLS/RPC matrices.',
          tone: PwfSisNoticeTone.error),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'Nosok v28 — RLS/RPC Surface Matrix',
            description:
                'مصفوفة أولية للسياسات والأسطح قبل أي تطبيق SQL. كل surface عام يجب أن يكون view/RPC فقط وليس public table.',
            badges: const ['RLS matrix', 'RPC surfaces', 'negative UAT'],
            actions: [
              PwfSisStatusBadge(
                  label: '${data.publicSurfaceCount} public surfaces draft',
                  tone: PwfSisNoticeTone.info)
            ],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'RLS Policy Matrix',
            subtitle: 'هذه قواعد تصميمية وليست policies مطبقة بعد.',
            child: PwfSisDataTable(
              columns: const [
                'الجدول',
                'النطاق',
                'قاعدة القراءة',
                'قاعدة الكتابة',
                'Negative UAT'
              ],
              rows: [
                for (final row in data.rlsRows)
                  [
                    Text(row.tableName),
                    Text(row.policyScope),
                    Text(row.readRule),
                    Text(row.writeRule),
                    Text(row.negativeUat)
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'RPC/View Surface Plan',
            subtitle: 'public يبقى compatibility/RPC surface فقط.',
            child: PwfSisDataTable(
              columns: const [
                'surface',
                'النوع',
                'التعرض',
                'المصدر المالك',
                'الحالة'
              ],
              rows: [
                for (final row in data.rpcSurfaces)
                  [
                    Text(row.surfaceName),
                    Text(row.surfaceType),
                    Text(row.exposureLevel),
                    Text(row.ownerSource),
                    PwfSisStatusBadge(
                        label: row.status, tone: PwfSisNoticeTone.warning)
                  ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
