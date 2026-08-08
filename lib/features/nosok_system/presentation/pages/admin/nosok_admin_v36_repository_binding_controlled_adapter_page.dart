import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v36_binding_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV36RepositoryBindingControlledAdapterPage
    extends ConsumerWidget {
  const NosokAdminV36RepositoryBindingControlledAdapterPage({super.key});

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
            title: 'Nosok v36 — Repository Binding Controlled Adapter Pack',
            description:
                'تجهيز Adapter محكوم يقرأ/يكتب عبر public RPC wrappers فقط، دون direct nosok.* access ودون service_role داخل Flutter.',
            badges: [
              'controlled adapter',
              'no service_role',
              'public wrappers only'
            ],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'قواعد الربط حسب السطح',
            subtitle:
                'الربط العام يتم تدريجيًا ولا يشمل Admin queues أو review قبل Admin RPC مستقل.',
            child: PwfSisDataTable(
              columns: const [
                'area',
                'current source',
                'controlled target',
                'allowed now',
                'gate'
              ],
              rows: [
                for (final item in data.repositoryBindingRules)
                  [
                    Text(item.area),
                    Text(item.currentSource),
                    Text(item.controlledTarget),
                    PwfSisStatusBadge(
                      label: item.allowedNow ? 'candidate' : 'blocked',
                      tone: item.allowedNow
                          ? PwfSisNoticeTone.warning
                          : PwfSisNoticeTone.error,
                    ),
                    Text(item.requiredGateAr),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Adapter Method Contracts',
            subtitle:
                'تمت إضافة nosok_public_wrapper_rpc_adapter.dart كحزمة ربط محكومة لا تُفعل global provider بعد.',
            child: PwfSisDataTable(
              columns: const [
                'method',
                'wrapper',
                'direction',
                'privacy boundary',
                'binding decision'
              ],
              rows: [
                for (final item in data.adapterMethods)
                  [
                    Text(item.methodName),
                    Text(item.wrapperSurface),
                    Text(item.dataDirection),
                    Text(item.privacyBoundaryAr),
                    Text(item.bindingDecisionAr),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'لا يوجد switch إنتاجي',
            message:
                'لم يتم تغيير nosokRepositoryProvider العام. تم تجهيز adapter controlled فقط حتى إغلاق Browser/Role/Scope UAT.',
            tone: PwfSisNoticeTone.info,
          ),
        ],
      ),
    );
  }
}
