import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v38h_supabase_binding_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV38HSupabaseBindingPage extends ConsumerWidget {
  const NosokAdminV38HSupabaseBindingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contract = ref.watch(nosokV38HSupabaseBindingContractProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title: 'Nosok v38H — اكتشاف عقد Supabase وتجهيز Adapter',
            description:
                'دفعة تحضيرية تربط تصميم نسك بطريقة اتصال PalWakf بسوبا بيس: Supabase.initialize مركزي في المنصة، SupabaseService/Provider من PalWakf، ونسك يستخدم RPC-first Repository بعد الاستضافة. لا SQL ولا schema ولا مفاتيح اتصال داخل نسك.',
            badges: [
              'v38H',
              'supabase-binding',
              'adapter-contract',
              'rpc-first',
              'shape-discovery',
              'no-sql-apply',
            ],
            actions: [
              PwfSisStatusBadge(
                label: 'No SQL apply',
                icon: Icons.storage_outlined,
                tone: PwfSisNoticeTone.warning,
              ),
              PwfSisStatusBadge(
                label: 'No independent client',
                icon: Icons.link_off_outlined,
                tone: PwfSisNoticeTone.info,
              ),
              PwfSisStatusBadge(
                label: 'No waqf_assets mutation',
                icon: Icons.verified_user_outlined,
                tone: PwfSisNoticeTone.success,
              ),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'قرار v38H الحاكم',
            subtitle:
                'هذه الصفحة تثبت طريقة الربط المستقبلية، ولا تنفذ الربط الآن.',
            child: const Text(
              'نسك لا ينشئ اتصال Supabase مستقلًا. عند استضافته داخل PalWakf سيستخدم SupabaseService وAccessProfile من المنصة، وكل عمليات البيانات يجب أن تمر عبر RPC wrappers آمنة وRLS، مع shape discovery قبل إنشاء schema نسك.',
            ),
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            minTileWidth: 210,
            children: [
              PwfSisMetricCard(
                label: 'Client findings',
                value: '${contract.platformClientFindings.length}',
                subtitle: 'من قراءة ملفات PalWakf',
                icon: Icons.travel_explore_outlined,
              ),
              PwfSisMetricCard(
                label: 'Adapter rules',
                value: '${contract.repositoryAdapterRules.length}',
                subtitle: 'قواعد Repository',
                icon: Icons.cable_outlined,
              ),
              PwfSisMetricCard(
                label: 'RPC contracts',
                value: '${contract.rpcContracts.length}',
                subtitle: 'عقود public/admin',
                icon: Icons.api_outlined,
              ),
              PwfSisMetricCard(
                label: 'Discovery checks',
                value: '${contract.shapeDiscoveryChecks.length}',
                subtitle: 'قبل أي SQL apply',
                icon: Icons.fact_check_outlined,
              ),
              const PwfSisMetricCard(
                label: 'Binding',
                value: 'DEFERRED',
                subtitle: 'بعد استضافة PalWakf',
                icon: Icons.lock_clock_outlined,
              ),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'نتائج اكتشاف عقد Supabase داخل PalWakf',
            subtitle:
                'هذه النتائج مستخرجة من ملفات المنصة التي تمت قراءتها سابقًا، ولا تتضمن مفاتيح أو أسرار اتصال.',
            child: PwfSisDataTable(
              columns: const [
                'المفتاح',
                'ملف المنصة',
                'ما وجدناه',
                'قرار نسك',
                'الحالة'
              ],
              rows: [
                for (final finding in contract.platformClientFindings)
                  [
                    Text(finding.key),
                    Text(finding.sourceFile),
                    Text(finding.findingAr),
                    Text(finding.nosokDecisionAr),
                    PwfSisStatusBadge(
                      label: finding.status,
                      icon: Icons.info_outline,
                      tone: finding.status.contains('required')
                          ? PwfSisNoticeTone.warning
                          : PwfSisNoticeTone.info,
                    ),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'قواعد Adapter / Repository',
            subtitle:
                'تمنع هذه القواعد إنشاء عميل مستقل أو تجاوز RPC/RLS عند التحول إلى backend حقيقي.',
            child: PwfSisDataTable(
              columns: const ['القاعدة', 'النص الحاكم', 'آلية التنفيذ'],
              rows: [
                for (final rule in contract.repositoryAdapterRules)
                  [
                    Text(rule.titleAr),
                    Text(rule.ruleAr),
                    Text(rule.implementationAr)
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'RPC / Repository Binding Design',
            subtitle:
                'هذه العقود تحدد ما ستستدعيه واجهات نسك لاحقًا بدل الجداول المباشرة.',
            child: PwfSisDataTable(
              columns: const ['RPC', 'السطح', 'الغرض', 'الأمن', 'الحالة'],
              rows: [
                for (final rpc in contract.rpcContracts)
                  [
                    Text(rpc.rpcName),
                    Text(rpc.surface),
                    Text(rpc.purposeAr),
                    Text(rpc.securityAr),
                    PwfSisStatusBadge(
                      label: rpc.statusAr,
                      icon: Icons.pending_actions_outlined,
                      tone: PwfSisNoticeTone.warning,
                    ),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Shape Discovery SQL Readiness',
            subtitle:
                'قبل إنشاء nosok schema يجب التحقق read-only من شكل مصادر PalWakf.',
            child: PwfSisDataTable(
              columns: const ['الفحص', 'الهدف', 'الغرض', 'القرار'],
              rows: [
                for (final check in contract.shapeDiscoveryChecks)
                  [
                    Text(check.checkKey),
                    Text(check.targetObject),
                    Text(check.expectedPurposeAr),
                    Text(check.decisionAr),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'تسلسل الربط الحقيقي لاحقًا',
            subtitle: 'لا تُتجاوز هذه الخطوات عند الانضمام للمنصة.',
            child: PwfSisTimeline(items: contract.runtimeBindingSequence),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'بوابات عدم التنفيذ في v38H',
            subtitle: contract.executionStatus,
            child: PwfSisTimeline(items: contract.noApplyGates),
          ),
        ],
      ),
    );
  }
}
