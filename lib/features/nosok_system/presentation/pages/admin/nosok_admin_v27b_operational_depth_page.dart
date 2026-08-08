import 'package:flutter/material.dart';

import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV27BOperationalDepthPage extends StatelessWidget {
  const NosokAdminV27BOperationalDepthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          PwfSisSystemHero(
            title: 'Nosok v27B — تعميق التشغيل الفعلي',
            description:
                'حزمة دمج كبيرة تعمّق التشغيل اليومي لنسك بعد فصل بوابة الجمهور ومساحة الشريك ولوحة الموظف: طلبات، مراجعة، حملات، مجموعات، وثائق، مراسلات، وتقارير دون اعتماد إنتاج.',
            badges: [
              'v27B',
              'operational-depth',
              'PWF-SIS',
              'no-production-approval'
            ],
          ),
          SizedBox(height: 12),
          PwfSisPanel(
            title: 'مصفوفة المساحات التشغيلية',
            subtitle:
                'الفصل واضح: المواطن رحلة خدمة، الشركة مساحة شريك، الموظف مساحة تشغيل، والإدارة نطاق حوكمة محدود.',
            child: PwfSisAdaptiveWorkspace(
              minTileWidth: 260,
              children: [
                PwfSisServiceCard(
                    icon: Icons.person_outline,
                    title: 'المواطن',
                    description:
                        'تقديم، متابعة، استكمال نواقص، شكاوى وتواصل فقط. لا يرى جداول الموظفين أو Audit.'),
                PwfSisServiceCard(
                    icon: Icons.business_center_outlined,
                    title: 'الشركة',
                    description:
                        'حملات وقوائم ونواقص ورسائل ضمن نطاق الشركة فقط بعد RBAC. لا ترى لوحة الموظف.'),
                PwfSisServiceCard(
                    icon: Icons.assignment_ind_outlined,
                    title: 'الموظف',
                    description:
                        'طلبات مسندة، مراجعة نواقص، قرارات تشغيلية، مراسلات ومتابعة ضمن صلاحياته.'),
                PwfSisServiceCard(
                    icon: Icons.admin_panel_settings_outlined,
                    title: 'الإدارة',
                    description:
                        'تقارير وإعدادات وصلاحيات وحوكمة موسمية عند توفر صلاحيات الإدارة فقط.'),
              ],
            ),
          ),
          SizedBox(height: 12),
          PwfSisPanel(
            title: 'سير العمل التشغيلي الموحد',
            subtitle:
                'يستخدمه الموظف داخليًا وتترجم حالاته للمواطن بلغة مبسطة.',
            child: PwfSisTimeline(
              items: [
                'submitted — تم إرسال الطلب من الجمهور',
                'received — استلام أولي داخل وحدة نسك',
                'under_review — مراجعة بيانات ومرفقات',
                'needs_completion — طلب استكمال نواقص من المواطن أو الشركة',
                'approved — اعتماد أولي/نهائي حسب الموسم',
                'assigned_to_campaign — ربط بحملة أو شركة مؤهلة',
                'in_followup — متابعة وثائق ورسائل وسفر',
                'completed/closed — إغلاق الخدمة أو الموسم',
              ],
            ),
          ),
          SizedBox(height: 12),
          PwfSisPanel(
            title: 'بوابات UAT المطلوبة بعد الدمج الكامل',
            subtitle:
                'هذه الدفعة لا تعلن الإنتاج. المطلوب أدلة تشغيل محلية وسحابية قبل أي اعتماد.',
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                PwfSisRuntimeState(
                    label: 'flutter analyze',
                    value: 'local retest required',
                    ok: false),
                PwfSisRuntimeState(
                    label: 'Chrome startup',
                    value: 'local retest required',
                    ok: false),
                PwfSisRuntimeState(
                    label: 'SQL UAT', value: 'pending', ok: false),
                PwfSisRuntimeState(
                    label: 'Role UAT', value: 'pending', ok: false),
                PwfSisRuntimeState(
                    label: 'Responsive UAT', value: 'pending', ok: false),
                PwfSisRuntimeState(
                    label: 'Browser console', value: 'pending', ok: false),
                PwfSisRuntimeState(
                    label: 'waqf_assets mutation', value: 'none', ok: true),
              ],
            ),
          ),
          SizedBox(height: 12),
          PwfSisNotice(
            title: 'قرار الإنتاج',
            message:
                'الإنتاج غير معتمد. هذه دفعة staging كبيرة لتثبيت واجهات ومسارات التشغيل وتوثيق الجاهزية، وليست موافقة Production Gate.',
            tone: PwfSisNoticeTone.warning,
          ),
        ],
      ),
    );
  }
}
