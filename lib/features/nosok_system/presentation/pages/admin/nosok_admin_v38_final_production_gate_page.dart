import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v38_final_production_gate_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV38FinalProductionGatePage extends ConsumerWidget {
  const NosokAdminV38FinalProductionGatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contract = ref.watch(nosokV38FinalProductionGateContractProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title:
                'Nosok v38 — Submit/Track Privacy + Role/Scope Negative UAT + Final Production Gate',
            description: contract.summaryAr,
            badges: const [
              'v38-final',
              'submit-track-privacy',
              'role-scope-negative-uat',
              'production-not-approved',
              'no-waqf-assets-mutation',
            ],
            actions: const [
              PwfSisStatusBadge(
                label: 'public fallback hardened',
                icon: Icons.privacy_tip_outlined,
                tone: PwfSisNoticeTone.success,
              ),
              PwfSisStatusBadge(
                label: 'browser evidence required',
                icon: Icons.monitor_heart_outlined,
                tone: PwfSisNoticeTone.warning,
              ),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisNotice(
            title: 'قرار الإنتاج النهائي لهذه الدفعة',
            message: contract.decision,
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Submit/Track Privacy Network Evidence',
            subtitle:
                'هذه الحالات تُغلق فقط بعد تشغيل محلي مع DevTools Network مفتوح قبل submit/track أو reload.',
            child: PwfSisDataTable(
              columns: const ['Case', 'السطح', 'الإشارة المتوقعة', 'الحالة', 'ملاحظة'],
              rows: [
                for (final item in contract.privacyNetworkCases)
                  [
                    Text(item.caseKey),
                    Text(item.surface),
                    Text(item.expectedSignal),
                    PwfSisStatusBadge(
                      label: item.status,
                      icon: Icons.pending_actions_outlined,
                      tone: PwfSisNoticeTone.warning,
                    ),
                    Text(item.noteAr),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Role/Scope Negative UAT Closure Matrix',
            subtitle:
                'لا يُقبل اعتماد الإنتاج دون إثبات منع anonymous/no-role/wrong-scope من الأسطح الإدارية والتشغيلية.',
            child: PwfSisDataTable(
              columns: const ['Case', 'السطح', 'الإشارة المتوقعة', 'الحالة', 'ملاحظة'],
              rows: [
                for (final item in contract.negativeUatCases)
                  [
                    Text(item.caseKey),
                    Text(item.surface),
                    Text(item.expectedSignal),
                    PwfSisStatusBadge(
                      label: item.status,
                      icon: Icons.gpp_maybe_outlined,
                      tone: PwfSisNoticeTone.warning,
                    ),
                    Text(item.noteAr),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Final Production Gate Re-decision',
            subtitle: 'إعادة القرار بعد hardening submit/track وتجهيز مصفوفة UAT السلبية.',
            child: PwfSisDataTable(
              columns: const ['المفتاح', 'البند', 'الحالة', 'السبب'],
              rows: [
                for (final item in contract.productionGateItems)
                  [
                    Text(item.key),
                    Text(item.titleAr),
                    PwfSisStatusBadge(
                      label: item.status,
                      icon: item.status == 'not-approved'
                          ? Icons.lock_clock_outlined
                          : Icons.rule_folder_outlined,
                      tone: item.status.contains('approved') &&
                              !item.status.contains('not-approved')
                          ? PwfSisNoticeTone.success
                          : PwfSisNoticeTone.warning,
                    ),
                    Text(item.reasonAr),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'أوامر Retest المحلية',
            subtitle: 'يلزم تنفيذها خارج الحاوية قبل أي قرار إنتاج لاحق.',
            child: PwfSisTimeline(items: contract.localRetestCommands),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'حدود السلامة السيادية',
            subtitle: 'قيود لا يجوز تجاوزها في v38 النهائي.',
            child: PwfSisTimeline(items: contract.boundaryRules),
          ),
        ],
      ),
    );
  }
}
