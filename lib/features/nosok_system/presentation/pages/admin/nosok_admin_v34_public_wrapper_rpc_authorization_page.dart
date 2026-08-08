import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v34_wrapper_authorization_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV34PublicWrapperRpcAuthorizationPage extends ConsumerWidget {
  const NosokAdminV34PublicWrapperRpcAuthorizationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV34WrapperAuthorizationPackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
        title: 'تعذر تحميل v34',
        message: 'تعذر تحميل بوابة v34.',
        tone: PwfSisNoticeTone.error,
      ),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'Nosok v34 — Public Wrapper/RPC Staging Apply Authorization',
            description:
                'تفويض تطبيق views/RPC wrappers العامة على staging فقط دون public base tables.',
            badges: const ['v34', 'public wrappers', 'staging only'],
            actions: [
              PwfSisStatusBadge(
                  label: data.gateDecision.decision,
                  tone: PwfSisNoticeTone.warning),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            children: [
              PwfSisMetricCard(
                  label: 'accepted',
                  value: '${data.acceptedCount}',
                  icon: Icons.check_circle_outline),
              PwfSisMetricCard(
                  label: 'prepared',
                  value: '${data.preparedCount}',
                  icon: Icons.construction_outlined),
              PwfSisMetricCard(
                  label: 'wrappers',
                  value: '${data.wrapperCount}',
                  icon: Icons.api_outlined),
              PwfSisMetricCard(
                  label: 'pending UAT',
                  value: '${data.pendingEvidenceCount}',
                  icon: Icons.pending_actions_outlined),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisNotice(
            title: 'قرار v34',
            message: data.gateDecision.summaryAr,
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Authorization Gate',
            subtitle:
                'يميز بين التطوير المسموح، التنفيذ المحروس، وما يبقى محظورًا.',
            child: PwfSisDataTable(
              columns: const [
                'المفتاح',
                'العنوان',
                'الحالة',
                'الدليل',
                'القرار'
              ],
              rows: [
                for (final item in data.authorizationItems)
                  [
                    Text(item.key),
                    Text(item.titleAr),
                    PwfSisStatusBadge(
                      label: item.status,
                      tone: item.accepted
                          ? PwfSisNoticeTone.success
                          : item.blocked
                              ? PwfSisNoticeTone.error
                              : PwfSisNoticeTone.warning,
                    ),
                    Text(item.evidenceAr),
                    Text(item.decisionAr),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Public Wrapper/RPC Surfaces',
            subtitle: 'public كطبقة RPC/view فقط، وليس owner schema.',
            child: PwfSisDataTable(
              columns: const [
                'المفتاح',
                'السطح',
                'النوع',
                'الدور',
                'حدود البيانات',
                'الحالة'
              ],
              rows: [
                for (final item in data.wrapperRpcSurfaces)
                  [
                    Text(item.key),
                    Text(item.objectName),
                    Text(item.surfaceType),
                    Text(item.allowedRoleAr),
                    Text(item.dataBoundaryAr),
                    PwfSisStatusBadge(
                        label: item.applyStatus,
                        tone: item.applied
                            ? PwfSisNoticeTone.success
                            : PwfSisNoticeTone.warning),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Browser/Role Negative UAT',
            subtitle:
                'هذه الأدلة مطلوبة بعد wrapper apply وقبل repository binding.',
            child: PwfSisDataTable(
              columns: const [
                'المفتاح',
                'الممثل',
                'المسار',
                'المتوقع',
                'الحالة'
              ],
              rows: [
                for (final item in data.browserRoleEvidenceCases)
                  [
                    Text(item.key),
                    Text(item.actorAr),
                    Text(item.routeAr),
                    Text(item.expectedAr),
                    PwfSisStatusBadge(
                        label: item.status,
                        tone: item.accepted
                            ? PwfSisNoticeTone.success
                            : item.blocked
                                ? PwfSisNoticeTone.error
                                : PwfSisNoticeTone.warning),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Repository Binding Gate',
            subtitle: 'لا يوجد direct Flutter table write إلى nosok.*.',
            child: PwfSisDataTable(
              columns: const ['mode', 'مسموح الآن', 'الحدود', 'الدليل التالي'],
              rows: [
                for (final item in data.repositoryBindingDecisions)
                  [
                    Text(item.mode),
                    PwfSisStatusBadge(
                        label: item.allowedNow ? 'allowed' : 'blocked',
                        tone: item.allowedNow
                            ? PwfSisNoticeTone.success
                            : PwfSisNoticeTone.error),
                    Text(item.boundaryAr),
                    Text(item.nextEvidenceAr),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            children: [
              PwfSisPanel(
                  title: 'المسموح التالي',
                  child: Text(data.gateDecision.allowedNextStepAr)),
              PwfSisPanel(
                  title: 'المحظور', child: Text(data.gateDecision.blockedAr)),
            ],
          ),
        ],
      ),
    );
  }
}
