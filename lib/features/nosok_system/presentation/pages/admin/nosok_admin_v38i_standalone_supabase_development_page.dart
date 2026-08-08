import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v38i_standalone_supabase_development_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV38IStandaloneSupabaseDevelopmentPage extends ConsumerWidget {
  const NosokAdminV38IStandaloneSupabaseDevelopmentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contract =
        ref.watch(nosokV38IStandaloneSupabaseDevelopmentContractProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title: 'Nosok v38I — Standalone Real Supabase Development Binding',
            description:
                'دفعة تطوير تربط نسك بقاعدة Supabase حقيقية مؤقتًا كبيئة تطوير مستقلة، مع بقاء بيانات نسك داخل schema nosok، وقراءة المراجع السيادية من core فقط عبر wrappers آمنة. public ليس مصدرًا سياديًا للمحافظات أو LGUs.',
            badges: [
              'v38I',
              'standalone-real-db-development',
              'core-is-source-of-truth',
              'public-wrappers-only',
              'no-production-approval',
            ],
            actions: [
              PwfSisStatusBadge(
                label: 'schema pack ready',
                icon: Icons.storage_outlined,
                tone: PwfSisNoticeTone.warning,
              ),
              PwfSisStatusBadge(
                label: 'core read-only references',
                icon: Icons.account_tree_outlined,
                tone: PwfSisNoticeTone.info,
              ),
              PwfSisStatusBadge(
                label: 'no waqf_assets mutation',
                icon: Icons.verified_user_outlined,
                tone: PwfSisNoticeTone.success,
              ),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'الحكم الحاكم بعد v38I',
            subtitle: contract.executionStatus,
            child: const Text(
              'يسمح لنسك بالعمل Standalone مع Supabase حقيقي للتطوير فقط، بشرط أن تكون schema nosok هي مالك بيانات نسك، وأن تكون core هي المصدر السيادي للمحافظات وLGUs والوحدات، وأن تبقى public مجرد سطح RPC/view آمن. لا إنتاج ولا cross-schema mutation.',
            ),
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            minTileWidth: 210,
            children: [
              PwfSisMetricCard(
                label: 'Runtime modes',
                value: '${contract.runtimeModes.length}',
                subtitle: 'preview / standalone / hosted',
                icon: Icons.toggle_on_outlined,
              ),
              PwfSisMetricCard(
                label: 'Core refs',
                value: '${contract.coreReferenceObjects.length}',
                subtitle: 'governorates/LGUs/org units',
                icon: Icons.hub_outlined,
              ),
              PwfSisMetricCard(
                label: 'Schema objects',
                value: '${contract.schemaObjects.length}',
                subtitle: 'nosok owned objects',
                icon: Icons.schema_outlined,
              ),
              PwfSisMetricCard(
                label: 'RPC wrappers',
                value: '${contract.rpcWrappers.length}',
                subtitle: 'public/admin surfaces',
                icon: Icons.api_outlined,
              ),
              const PwfSisMetricCard(
                label: 'Production',
                value: 'NOT APPROVED',
                subtitle: 'development only',
                icon: Icons.lock_clock_outlined,
              ),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'أوضاع التشغيل',
            subtitle:
                'الواجهات يجب أن تتعامل مع NosokRepository فقط، بينما يتغير Adapter حسب الوضع.',
            child: PwfSisDataTable(
              columns: const ['الوضع', 'الوصف', 'الحالة'],
              rows: [
                for (final mode in contract.runtimeModes)
                  [
                    Text(mode.titleAr),
                    Text(mode.descriptionAr),
                    PwfSisStatusBadge(
                      label: mode.statusAr,
                      icon: Icons.info_outline,
                      tone: mode.statusAr == 'prepared'
                          ? PwfSisNoticeTone.warning
                          : PwfSisNoticeTone.info,
                    ),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'مصادر core السيادية',
            subtitle:
                'LGU / governorates / org_units / unit profiles لا تؤخذ من public كمصدر سيادي.',
            child: PwfSisDataTable(
              columns: const [
                'المفتاح',
                'المصدر',
                'عائلة الكائن',
                'استخدام نسك',
                'قاعدة الوصول'
              ],
              rows: [
                for (final source in contract.coreReferenceObjects)
                  [
                    Text(source.key),
                    Text(source.sourceSchema),
                    Text(source.expectedObjectFamily),
                    Text(source.nosokUsageAr),
                    Text(source.accessRuleAr),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Nosok Schema Creation Pack',
            subtitle:
                'هذه الكائنات مملوكة لنسك. لا يتم إنشاء FK إلى core قبل shape discovery.',
            child: PwfSisDataTable(
              columns: const [
                'الكائن',
                'النوع',
                'الغرض',
                'قاعدة الربط',
                'الحالة'
              ],
              rows: [
                for (final object in contract.schemaObjects)
                  [
                    Text(object.objectName),
                    Text(object.objectType),
                    Text(object.purposeAr),
                    Text(object.crossSchemaRuleAr),
                    PwfSisStatusBadge(
                      label: object.statusAr,
                      icon: Icons.pending_actions_outlined,
                      tone: PwfSisNoticeTone.warning,
                    ),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Public RPC Wrappers',
            subtitle: 'public هو سطح آمن فقط، وليس مالكًا للبيانات السيادية.',
            child: PwfSisDataTable(
              columns: const ['RPC', 'السطح', 'الغرض', 'الأمن', 'الحالة'],
              rows: [
                for (final rpc in contract.rpcWrappers)
                  [
                    Text(rpc.rpcName),
                    Text(rpc.surface),
                    Text(rpc.purposeAr),
                    Text(rpc.securityAr),
                    PwfSisStatusBadge(
                      label: rpc.statusAr,
                      icon: Icons.api_outlined,
                      tone: rpc.statusAr.contains('ready')
                          ? PwfSisNoticeTone.warning
                          : PwfSisNoticeTone.info,
                    ),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Repository Adapter Design',
            subtitle: 'الربط الحقيقي لا يغير صفحات الواجهة؛ يتغير Adapter فقط.',
            child: PwfSisDataTable(
              columns: const ['Adapter', 'الوضع', 'مصدر Supabase', 'القرار'],
              rows: [
                for (final adapter in contract.repositoryAdapters)
                  [
                    Text(adapter.titleAr),
                    Text(adapter.modeAr),
                    Text(adapter.supabaseSourceAr),
                    Text(adapter.decisionAr),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Homepage Sections Runtime Admin',
            subtitle:
                'تحويل إدارة أقسام الصفحة الرئيسية إلى runtime admin في بيئة التطوير الحقيقية.',
            child: PwfSisDataTable(
              columns: const ['القدرة', 'Workflow', 'الحماية'],
              rows: [
                for (final capability
                    in contract.homepageRuntimeAdminCapabilities)
                  [
                    Text(capability.titleAr),
                    Text(capability.workflowAr),
                    Text(capability.guardAr),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'بوابات Shape Discovery',
            subtitle: 'تشغّل قبل أي FK أو mapping نهائي مع core.',
            child: PwfSisTimeline(items: contract.shapeDiscoveryGates),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'قواعد السلامة الإنتاجية',
            subtitle: 'هذه القواعد تمنع تحول بيئة التطوير إلى إنتاج غير معتمد.',
            child: PwfSisTimeline(items: contract.productionSafetyRules),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'تسلسل التطبيق في بيئة التطوير',
            subtitle: 'التسلسل الموصى به بعد استلام نتائج discovery.',
            child: PwfSisTimeline(items: contract.developmentApplySequence),
          ),
        ],
      ),
    );
  }
}
