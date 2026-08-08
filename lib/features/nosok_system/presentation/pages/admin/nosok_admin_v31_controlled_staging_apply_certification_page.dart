import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v31_apply_certification_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV31ControlledStagingApplyCertificationPage
    extends ConsumerWidget {
  const NosokAdminV31ControlledStagingApplyCertificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV31ApplyCertificationPackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
          title: 'تعذر تحميل شهادة apply',
          message: 'تعذر تحميل شهادة تطبيق DDL.',
          tone: PwfSisNoticeTone.error),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title:
                'Nosok v31 — Controlled Staging DDL Apply Result Certification',
            description:
                'شهادة نتيجة apply بعد تشغيل operator SQL على staging. الحالة الحالية: التفويض مسجل كنية، لكن لا يوجد SQL output يثبت إنشاء nosok schema أو جداولها.',
            badges: const [
              'apply certification',
              'staging only',
              'not production'
            ],
            actions: [
              PwfSisStatusBadge(
                  label: '${data.certifiedApplyCount} certified',
                  tone: PwfSisNoticeTone.warning)
            ],
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'لا تعتمد apply دون SQL output',
            message:
                'هذه الصفحة لا تدعي أن CREATE SCHEMA أو CREATE TABLE حدث. يجب إرسال نتيجة تشغيل guarded SQL ثم post-apply read-only UAT.',
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Controlled Staging Apply Certification Matrix',
            subtitle: 'النتائج المطلوبة لإغلاق تطبيق schema نسك على staging.',
            child: PwfSisDataTable(
              columns: const [
                'البند',
                'المتوقع',
                'المرصود',
                'الحالة',
                'الدليل المطلوب'
              ],
              rows: [
                for (final item in data.applyCertification)
                  [
                    Text(item.labelAr),
                    Text(item.expectedAr),
                    Text(item.observedAr),
                    PwfSisStatusBadge(
                        label: item.status,
                        tone: item.accepted
                            ? PwfSisNoticeTone.success
                            : item.blocked
                                ? PwfSisNoticeTone.error
                                : PwfSisNoticeTone.warning),
                    Text(item.requiredEvidenceAr),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          const PwfSisPanel(
            title: 'Operator Evidence Required',
            subtitle: 'المدخلات المطلوبة بعد التشغيل.',
            child: Text(
                'owner_authorization_id، staging database confirmation، backup reference، full SQL output، post-apply census، RLS status، no public base table proof، rollback readiness.'),
          ),
        ],
      ),
    );
  }
}
