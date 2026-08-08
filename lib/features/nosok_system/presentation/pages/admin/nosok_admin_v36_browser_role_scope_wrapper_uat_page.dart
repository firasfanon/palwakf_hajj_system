import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v36_binding_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV36BrowserRoleScopeWrapperUatPage extends ConsumerWidget {
  const NosokAdminV36BrowserRoleScopeWrapperUatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV36BindingPackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
        title: 'تعذر تحميل v36',
        message: 'تعذر تحميل حزمة Nosok v36. راجع console وسجل Riverpod.',
        tone: PwfSisNoticeTone.error,
      ),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title:
                'Nosok v36 — Browser/Role/Scope Wrapper RPC UAT Evidence Intake',
            description:
                'استيعاب أدلة المتصفح والشبكة والأدوار بعد نجاح تطبيق public wrappers/RPCs، مع إبقاء الإنتاج محجوبًا حتى إغلاق كل السيناريوهات.',
            badges: ['browser UAT', 'role/scope', 'network evidence'],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'أدلة SQL المقبولة',
            subtitle:
                'هذه الأدلة قبل Browser UAT ولا تكفي وحدها لاعتماد الإنتاج.',
            child: PwfSisDataTable(
              columns: const ['البند', 'الحالة', 'الدليل', 'القرار'],
              rows: [
                for (final item in data.evidenceItems)
                  [
                    Text(item.titleAr),
                    PwfSisStatusBadge(
                      label: item.status,
                      tone: item.accepted
                          ? PwfSisNoticeTone.success
                          : item.pending
                              ? PwfSisNoticeTone.warning
                              : PwfSisNoticeTone.error,
                    ),
                    Text(item.evidenceAr),
                    Text(item.decisionAr),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'مصفوفة Browser/Role/Scope UAT',
            subtitle:
                'المطلوب تصويره: route، Network RPC، Console، actor/role/scope، وردّ آمن.',
            child: PwfSisDataTable(
              columns: const [
                'case',
                'actor',
                'surface',
                'RPC/guard',
                'expected',
                'evidence',
                'status'
              ],
              rows: [
                for (final item in data.runtimeCases)
                  [
                    Text(item.caseKey),
                    Text(item.actorAr),
                    Text(item.routeOrSurface),
                    Text(item.rpcSurface),
                    Text(item.expectedAr),
                    Text(item.requiredEvidenceAr),
                    PwfSisStatusBadge(
                      label: item.status,
                      tone: item.pending
                          ? PwfSisNoticeTone.warning
                          : item.accepted
                              ? PwfSisNoticeTone.success
                              : PwfSisNoticeTone.error,
                    ),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisNotice(
            title: 'قرار v36',
            message: data.productionGateDecision.blockedAr,
            tone: PwfSisNoticeTone.warning,
          ),
        ],
      ),
    );
  }
}
