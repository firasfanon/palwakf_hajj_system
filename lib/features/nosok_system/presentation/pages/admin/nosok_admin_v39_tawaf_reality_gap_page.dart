import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v39_tawaf_reality_gap_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV39TawafRealityGapPage extends ConsumerWidget {
  const NosokAdminV39TawafRealityGapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contract = ref.watch(nosokV39TawafRealityGapContractProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title:
                'Nosok v39 — Tawaf Public Reality Gap Adapter + Evidence Matrix',
            description: contract.summaryAr,
            badges: const [
              'v39',
              'tawaf-public-reality-gap',
              'contract-only',
              'production-not-approved',
              'no-external-integration',
            ],
            actions: const [
              PwfSisStatusBadge(
                label: 'evidence matrix prepared',
                icon: Icons.fact_check_outlined,
                tone: PwfSisNoticeTone.success,
              ),
              PwfSisStatusBadge(
                label: 'authority/provider gaps remain',
                icon: Icons.lock_clock_outlined,
                tone: PwfSisNoticeTone.warning,
              ),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisNotice(
            title: 'قرار v39',
            message: contract.decision,
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Public Source Observations',
            subtitle:
                'مصادر عامة فقط؛ لا يتم تشغيلها كاعتماد Runtime ولا يتم سحب بيانات خاصة منها.',
            child: PwfSisDataTable(
              columns: const [
                'Source',
                'العنوان',
                'الرابط',
                'الإشارة المرصودة',
                'الحالة',
                'أثرها على Adapter',
              ],
              rows: [
                for (final item in contract.observedPublicSources)
                  [
                    Text(item.sourceKey),
                    Text(item.titleAr),
                    Text(item.url),
                    Text(item.observedSignalAr),
                    PwfSisStatusBadge(
                      label: item.status,
                      icon: Icons.public_outlined,
                      tone: PwfSisNoticeTone.neutral,
                    ),
                    Text(item.adapterImplicationAr),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Tawaf/Nosok Public Reality Gaps',
            subtitle:
                'الفجوات التي تمنع اعتبار نسك مكافئًا للنظام الرسمي أو جاهزًا للإنتاج.',
            child: PwfSisDataTable(
              columns: const [
                'Gap',
                'المجال',
                'الإشارة الرسمية',
                'حالة v38',
                'قرار Adapter',
                'الدليل المطلوب',
              ],
              rows: [
                for (final item in contract.realityGaps)
                  [
                    Text(item.key),
                    Text(item.domainAr),
                    Text(item.officialSignalAr),
                    Text(item.nosokV38StateAr),
                    Text(item.adapterDecisionAr),
                    Text(item.evidenceRequiredAr),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Civil Registry / OTP / Payment / Company / Captcha / Lottery Evidence Matrix',
            subtitle:
                'هذه ليست اختبارات منفذة؛ إنها acceptance matrix ملزمة قبل أي قرار إنتاج لاحق.',
            child: PwfSisDataTable(
              columns: const [
                'Case',
                'المجال',
                'السطح',
                'الإشارة المتوقعة',
                'الفحص السلبي',
                'الحالة',
                'دليل القبول',
              ],
              rows: [
                for (final item in contract.evidenceMatrix)
                  [
                    Text(item.caseKey),
                    Text(item.domainAr),
                    Text(item.surface),
                    Text(item.expectedSignalAr),
                    Text(item.negativeProbeAr),
                    PwfSisStatusBadge(
                      label: item.status,
                      icon: item.status.contains('required')
                          ? Icons.pending_actions_outlined
                          : Icons.rule_folder_outlined,
                      tone: item.status.contains('contract-integrated')
                          ? PwfSisNoticeTone.success
                          : PwfSisNoticeTone.warning,
                    ),
                    Text(item.acceptanceEvidenceAr),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Final Production Gate Re-decision',
            subtitle:
                'إعادة القرار بعد استيعاب فجوات Tawaf العامة داخل نسك v39.',
            child: PwfSisDataTable(
              columns: const ['المفتاح', 'البند', 'الحالة', 'السبب'],
              rows: [
                for (final item in contract.productionGateItems)
                  [
                    Text(item.key),
                    Text(item.titleAr),
                    PwfSisStatusBadge(
                      label: item.status,
                      icon: item.status == 'contract-integrated'
                          ? Icons.check_circle_outline
                          : Icons.lock_clock_outlined,
                      tone: item.status == 'contract-integrated'
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
            subtitle: 'لا تغلق v39 تشغيليًا دون هذه البوابة في بيئة Flutter محلية.',
            child: PwfSisTimeline(items: contract.localRetestCommands),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'حدود السلامة السيادية',
            subtitle: 'قيود تمنع الخلط بين evidence adapter والتكامل الرسمي.',
            child: PwfSisTimeline(items: contract.boundaryRules),
          ),
        ],
      ),
    );
  }
}
