import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v28_owner_schema_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV28OwnerSchemaDesignPage extends ConsumerWidget {
  const NosokAdminV28OwnerSchemaDesignPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV28OwnerSchemaDesignPackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
          title: 'تعذر تحميل تصميم schema',
          message: 'تعذر تحميل حزمة Nosok v28.',
          tone: PwfSisNoticeTone.error),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'Nosok v28 — Owner Schema Design',
            description:
                'تصميم schema المالكة لنسك بعد جرد v27: كل الجداول المرشحة داخل nosok.* فقط، مع منع public base tables وإعادة استخدام core كمصدر سيادي.',
            badges: const [
              'owner schema',
              'guarded-not-applied',
              'no public tables'
            ],
            actions: [
              PwfSisStatusBadge(
                  label: '${data.draftObjectCount} draft objects',
                  tone: PwfSisNoticeTone.info),
              PwfSisStatusBadge(
                  label: '${data.blockedObjectCount} blocked/deferred',
                  tone: PwfSisNoticeTone.warning),
            ],
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'قرار التصميم',
            message:
                'هذه الصفحة لا تنفذ SQL. هي owner-review surface لتأكيد ما سيبنى داخل nosok.* وما سيبقى محظورًا أو مؤجلًا.',
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          PwfSisDataTable(
            columns: const [
              'الكائن',
              'النوع',
              'الحالة',
              'الغاية',
              'قاعدة core',
              'public surface'
            ],
            rows: [
              for (final item in data.objects)
                [
                  Text(item.objectName),
                  Text(item.objectType),
                  PwfSisStatusBadge(
                      label: item.executionState,
                      tone: item.isBlocked
                          ? PwfSisNoticeTone.error
                          : PwfSisNoticeTone.info),
                  Text(item.purposeAr),
                  Text(item.coreDependencyRule),
                  Text(item.publicSurfaceRule),
                ],
            ],
          ),
        ],
      ),
    );
  }
}
