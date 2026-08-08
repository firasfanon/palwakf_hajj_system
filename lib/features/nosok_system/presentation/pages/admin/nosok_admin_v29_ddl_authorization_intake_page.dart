import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v29_authorization_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV29DdlAuthorizationIntakePage extends ConsumerWidget {
  const NosokAdminV29DdlAuthorizationIntakePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV29AuthorizationPackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
          title: 'تعذر تحميل v29',
          message: 'تعذر تحميل استيعاب التفويض.',
          tone: PwfSisNoticeTone.error),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'Nosok v29 — Owner Schema DDL Authorization Intake',
            description:
                'استيعاب تفويض إعداد حزمة تطبيق staging لإنشاء nosok.* فقط. لا يتم تنفيذ SQL من Flutter أو من هذه الشاشة، ولا يتم إنشاء public base tables.',
            badges: const [
              'v29',
              'authorization intake',
              'nosok.* only',
              'no public tables'
            ],
            actions: [
              PwfSisStatusBadge(
                  label: 'accepted ${data.acceptedCount}',
                  tone: PwfSisNoticeTone.success),
              PwfSisStatusBadge(
                  label: 'blocked ${data.blockedCount}',
                  tone: PwfSisNoticeTone.error),
              PwfSisStatusBadge(
                  label: 'pending ${data.pendingCount}',
                  tone: PwfSisNoticeTone.warning),
            ],
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'حد التنفيذ',
            message:
                'هذه الصفحة لا تمنح تفويض production ولا تنفذ CREATE SCHEMA/CREATE TABLE. التنفيذ الفعلي يبقى خارج Flutter ويحتاج owner_authorization_id واضحًا ونتيجة SQL مرفقة.',
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Authorization Intake Matrix',
            subtitle: 'تفصل بين تفويض إعداد الحزمة وبين تنفيذ SQL الفعلي.',
            child: PwfSisDataTable(
              columns: const ['البند', 'الحالة', 'القرار', 'الدليل / المانع'],
              rows: [
                for (final item in data.authorizationItems)
                  [
                    Text(item.labelAr),
                    PwfSisStatusBadge(
                        label: item.status,
                        tone: item.accepted
                            ? PwfSisNoticeTone.success
                            : item.blocked
                                ? PwfSisNoticeTone.error
                                : PwfSisNoticeTone.warning),
                    Text(item.decision),
                    Text(item.blockerAr ?? item.evidenceAr),
                  ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
