import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../system_routes.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokCompanyPortalPage extends StatelessWidget {
  const NosokCompanyPortalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PwfSisPublicServiceShell(
      children: [
        PwfSisServiceHero(
          title: 'بوابة الشركات المؤهلة',
          description:
              'مساحة شريك تشغيلية للشركات المؤهلة لإدارة الحملات، القوائم، النواقص، والمراسلات عند اكتمال الربط داخل منصة PalWakf.',
          badges: const [
            'Partner Workspace',
            'ليس لوحة موظف',
            'RBAC مطلوب',
            'قيد الربط'
          ],
          primaryAction: FilledButton.icon(
            onPressed: () => context.go(NosokSystemRoutes.companies),
            icon: const Icon(Icons.business_outlined),
            label: const Text('عرض الشركات المؤهلة'),
          ),
          secondaryAction: OutlinedButton.icon(
            onPressed: () => context.go(NosokSystemRoutes.contact),
            icon: const Icon(Icons.contact_support_outlined),
            label: const Text('طلب مساعدة'),
          ),
        ),
        const SizedBox(height: 16),
        const PwfSisNotice(
          title: 'بوابة شريك لا بوابة إدارة',
          message:
              'ممثل الشركة لا يرى لوحة الموظف أو Audit الداخلي. تظهر له فقط الحملات والقوائم والنواقص والمراسلات المرتبطة بنطاق شركته بعد تفعيل RBAC الحقيقي.',
          tone: PwfSisNoticeTone.info,
        ),
        const SizedBox(height: 16),
        const PwfSisPanel(
          title: 'Partner Operations Snapshot',
          subtitle:
              'تصميم تشغيلي منخفض الازدحام: مؤشرات مختصرة ثم قوائم تفصيلية لاحقًا حسب الصلاحية.',
          child: PwfSisAdaptiveWorkspace(
            minTileWidth: 220,
            children: [
              PwfSisMetricCard(
                  label: 'حملات نشطة',
                  value: '—',
                  subtitle: 'تظهر بعد الربط',
                  icon: Icons.campaign_outlined),
              PwfSisMetricCard(
                  label: 'أفراد ضمن القوائم',
                  value: '—',
                  subtitle: 'محجوبة حتى RBAC',
                  icon: Icons.groups_outlined),
              PwfSisMetricCard(
                  label: 'نواقص مفتوحة',
                  value: '—',
                  subtitle: 'حسب نطاق الشركة',
                  icon: Icons.assignment_late_outlined),
              PwfSisMetricCard(
                  label: 'رسائل واردة',
                  value: '—',
                  subtitle: 'planned bridge',
                  icon: Icons.mail_outline),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const PwfSisPanel(
          title: 'مساحة العمل المتوقعة للشركة',
          subtitle:
              'هذه واجهة جاهزية بصرية وتشغيلية، ولا تدعي وجود Backend غير مفعّل.',
          child: PwfSisAdaptiveWorkspace(
            minTileWidth: 240,
            children: [
              PwfSisServiceCard(
                  icon: Icons.campaign_outlined,
                  title: 'حملاتي',
                  description: 'عرض الحملات والسعة والحالة ونطاق الموسم.',
                  disabled: true),
              PwfSisServiceCard(
                  icon: Icons.groups_outlined,
                  title: 'قوائم الحجاج والمعتمرين',
                  description: 'قوائم مرتبطة بالشركة فقط عند اعتماد الربط.',
                  disabled: true),
              PwfSisServiceCard(
                  icon: Icons.assignment_outlined,
                  title: 'النواقص',
                  description: 'مرفقات وبيانات تحتاج استكمال ضمن نطاق الشركة.',
                  disabled: true),
              PwfSisServiceCard(
                  icon: Icons.mail_outline,
                  title: 'المراسلات',
                  description: 'تنبيهات وتعليمات ومراسلات مرتبطة بالحملات.',
                  disabled: true),
              PwfSisServiceCard(
                  icon: Icons.description_outlined,
                  title: 'الوثائق',
                  description:
                      'مراجعة حالة الوثائق دون إظهار بيانات خارج النطاق.',
                  disabled: true),
              PwfSisServiceCard(
                  icon: Icons.query_stats_outlined,
                  title: 'ملخص تشغيلي',
                  description: 'مؤشرات السعة والجاهزية والمخاطر التشغيلية.',
                  disabled: true),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const PwfSisPanel(
          title: 'حالات التكامل',
          subtitle: 'تظهر هذه الحالات لضمان عدم تقديم واجهة وهمية للمستخدم.',
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              PwfSisRuntimeState(
                  label: 'Company RBAC', value: 'pending', ok: false),
              PwfSisRuntimeState(
                  label: 'Campaign binding', value: 'planned', ok: false),
              PwfSisRuntimeState(
                  label: 'Messages bridge', value: 'planned', ok: false),
              PwfSisRuntimeState(
                  label: 'Documents bridge', value: 'planned', ok: false),
            ],
          ),
        ),
      ],
    );
  }
}
