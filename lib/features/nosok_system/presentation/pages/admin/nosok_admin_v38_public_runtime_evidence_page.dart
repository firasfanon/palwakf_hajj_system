import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v38_public_runtime_contract_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV38PublicRuntimeEvidencePage extends ConsumerWidget {
  const NosokAdminV38PublicRuntimeEvidencePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contract = ref.watch(nosokV38PublicRuntimeContractProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title:
                'Nosok v38 — Public Campaigns/Requirements Runtime Adapter Integration',
            description:
                'إغلاق تشغيلي لقراءة الحملات والمتطلبات العامة عبر public RPC wrappers، مع قرار بوابة إنتاج محافظ يمنع اعتماد الإنتاج الكامل قبل submit/track privacy وrole/scope negative evidence.',
            badges: [
              contract.version,
              'public-rpc-adapter',
              'network-evidence-gate',
              'production-not-approved',
              'no-waqf-assets-mutation',
            ],
            actions: const [
              PwfSisStatusBadge(
                label: 'campaigns/requirements integrated',
                icon: Icons.api_outlined,
                tone: PwfSisNoticeTone.success,
              ),
              PwfSisStatusBadge(
                label: 'submit/track still gated',
                icon: Icons.lock_clock_outlined,
                tone: PwfSisNoticeTone.warning,
              ),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'قرار الدفعة',
            subtitle: contract.decision,
            child: const Text(
              'تم دمج Adapter الحملات والمتطلبات في واجهات المواطن العامة، لكن هذه الدفعة لا تعتمد الإنتاج الكامل. المطلوب التالي هو لقطة Network فعلية للنداءات، ثم أدلة submit/track privacy وأدلة no-role/wrong-scope.',
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Runtime Adapter Integration',
            subtitle: 'الصفحات العامة لا تقرأ مباشرة من nosok.* في هذا المسار.',
            child: PwfSisDataTable(
              columns: const [
                'السطح',
                'RPC',
                'مدخل Flutter',
                'الحالة',
                'ملاحظة'
              ],
              rows: [
                for (final item in contract.adapterIntegrations)
                  [
                    Text(item.surface),
                    Text(item.rpcName),
                    Text(item.flutterEntry),
                    PwfSisStatusBadge(
                      label: item.statusAr,
                      icon: Icons.check_circle_outline,
                      tone: PwfSisNoticeTone.success,
                    ),
                    Text(item.noteAr),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Network RPC Evidence Closure Matrix',
            subtitle:
                'هذه الحالات تحدد ما يجب التقاطه من DevTools Network قبل إغلاق الدليل الحي.',
            child: PwfSisDataTable(
              columns: const [
                'Case',
                'Route',
                'RPC المتوقع',
                'فلتر Network',
                'حالة الدليل'
              ],
              rows: [
                for (final item in contract.networkEvidenceCases)
                  [
                    Text(item.caseKey),
                    Text(item.route),
                    Text(item.expectedRpc),
                    Text(item.expectedNetworkFilter),
                    Text(item.evidenceStatusAr),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Production Gate Re-decision',
            subtitle: 'إعادة القرار بعد دمج الحملات والمتطلبات العامة.',
            child: PwfSisDataTable(
              columns: const ['المفتاح', 'البند', 'الحالة', 'السبب'],
              rows: [
                for (final item in contract.productionGateItems)
                  [
                    Text(item.key),
                    Text(item.titleAr),
                    PwfSisStatusBadge(
                      label: item.status,
                      icon: item.status.contains('pending') ||
                              item.status.contains('not-approved')
                          ? Icons.lock_clock_outlined
                          : Icons.check_circle_outline,
                      tone: item.status.contains('pending') ||
                              item.status.contains('not-approved')
                          ? PwfSisNoticeTone.warning
                          : PwfSisNoticeTone.success,
                    ),
                    Text(item.reasonAr),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'حدود السلامة',
            subtitle: 'لا تتجاوز هذه الدفعة حدود نسك قبل الانضمام.',
            child: PwfSisTimeline(items: contract.boundaryRules),
          ),
        ],
      ),
    );
  }
}
