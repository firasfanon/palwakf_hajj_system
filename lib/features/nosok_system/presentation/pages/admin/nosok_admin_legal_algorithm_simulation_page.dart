import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v38f_prejoin_operational_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminLegalAlgorithmSimulationPage extends ConsumerWidget {
  const NosokAdminLegalAlgorithmSimulationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contract = ref.watch(nosokV38FPrejoinOperationalContractProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title: 'محاكاة خوارزمية الحج القانونية — preview',
            description:
                'صفحة تحضيرية تعرض سيناريوهات قانونية يجب أن تتحول لاحقًا إلى RPC مدقق. لا يتم تنفيذ قرعة فعلية من واجهة Flutter، ولا يتم حفظ نتائج أو تعديل حصص.',
            badges: [
              'legal-simulation',
              'regulation-15-2025',
              'no-draw-execution',
              'audit-required'
            ],
            actions: [
              PwfSisStatusBadge(
                  label: 'Simulation only',
                  icon: Icons.science_outlined,
                  tone: PwfSisNoticeTone.warning),
              PwfSisStatusBadge(
                  label: 'RPC required later',
                  icon: Icons.api_outlined,
                  tone: PwfSisNoticeTone.neutral),
            ],
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'قاعدة حاكمة',
            message:
                'هذه الصفحة لا تختار فائزين ولا تنتج نتائج. الغرض منها تثبيت فروع الخوارزمية قانونيًا قبل تحويلها إلى nosok.rpc_lottery_algorithm_simulate_v1 وnosok.rpc_lottery_draw_execute_v1 بعد استضافة نسك داخل PalWakf.',
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'سيناريوهات المحاكاة القانونية',
            subtitle:
                'كل سيناريو يجب أن يملك branch واضحًا وحدث audit عند التنفيذ الحقيقي.',
            child: PwfSisDataTable(
              columns: const [
                'السيناريو',
                'المدخلات',
                'النتيجة المتوقعة',
                'أثر التدقيق'
              ],
              rows: [
                for (final scenario in contract.legalSimulationScenarios)
                  [
                    Text(scenario.titleAr),
                    Text(scenario.inputAr),
                    Text(scenario.expectedAr),
                    Text(scenario.auditAr)
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'عقود البيانات المطلوبة لاحقًا',
            subtitle:
                'لا تطبق هذه الكائنات الآن؛ هي جزء من Schema/RPC pack بعد الاستضافة.',
            child: PwfSisDataTable(
              columns: const ['الكائن', 'النوع', 'المالك', 'الحالة'],
              rows: [
                for (final object in contract.schemaContracts)
                  [
                    Text(object.objectName),
                    Text(object.objectType),
                    Text(object.ownerAr),
                    PwfSisStatusBadge(
                        label: object.statusAr,
                        icon: Icons.lock_clock_outlined,
                        tone: PwfSisNoticeTone.warning)
                  ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
