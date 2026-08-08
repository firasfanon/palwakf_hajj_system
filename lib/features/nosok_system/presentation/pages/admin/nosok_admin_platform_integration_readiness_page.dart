import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../system_routes.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';

class NosokAdminPlatformIntegrationReadinessPage extends StatelessWidget {
  const NosokAdminPlatformIntegrationReadinessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return NosokPageScaffold(
      title: 'حزمة جاهزية الدمج مع المنصة',
      subtitle:
          'تجميع عقود الدمج المطلوبة قبل نقل نسك من preview host إلى PalWakf: routes، registry، RBAC، billing، notifications، units، health، وPWF-SIS.',
      actions: [
        FilledButton.icon(
          onPressed: () =>
              context.go(NosokSystemRoutes.adminProductionUatClosure),
          icon: const Icon(Icons.fact_check_outlined),
          label: const Text('بوابة UAT'),
        ),
        OutlinedButton.icon(
          onPressed: () => context.go(NosokSystemRoutes.adminUsersRoles),
          icon: const Icon(Icons.admin_panel_settings_outlined),
          label: const Text('الأدوار'),
        ),
      ],
      children: [
        NosokSectionCard(
          title: 'عقود الدمج المطلوبة',
          subtitle:
              'هذه البنود يجب أن تُطبّق داخل ريبو PalWakf الكامل، لا داخل preview host فقط.',
          child: const Column(
            children: [
              _IntegrationRow(
                  area: 'Routing',
                  contract:
                      '/switch/nosok و /systems/nosok و /admin/systems/nosok',
                  status: 'جاهز كمقترح دمج'),
              _IntegrationRow(
                  area: 'RBAC',
                  contract:
                      'permission keys + role templates + AccessProfile override',
                  status: 'ينتظر تسجيل المنصة'),
              _IntegrationRow(
                  area: 'Units',
                  contract:
                      'core.org_units مصدر الوحدات، nosok.unit_service_scopes سطح خدمة فقط',
                  status: 'جاهز للتطبيق'),
              _IntegrationRow(
                  area: 'Billing',
                  contract:
                      'billing_system هو محرك الدفع، ونسك يستهلك bridge فقط',
                  status: 'جاهز لعقد تكامل'),
              _IntegrationRow(
                  area: 'Notifications',
                  contract: 'notification provider adapters عبر منصة PalWakf',
                  status: 'جاهز للاختبار'),
              _IntegrationRow(
                  area: 'Public privacy',
                  contract:
                      'tracking_token فقط للمتابعة العامة دون بيانات حساسة',
                  status: 'مغلق تشغيليًا'),
              _IntegrationRow(
                  area: 'Visual system',
                  contract: 'PWF-SIS + RTL + Anti-overload UX',
                  status: 'جاهز للمراجعة البصرية'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        NosokSectionCard(
          title: 'تسلسل الإدماج العملي',
          subtitle:
              'لا يُنقل نسك للإنتاج مباشرة من preview؛ يتم تطبيقه عبر overlay مضبوط داخل المنصة.',
          child: Column(
            children: [
              _StepTile(
                  step: '1',
                  title: 'تطبيق SQL حتى v20',
                  note: 'تشغيل ملفات sql/00 إلى sql/18 حسب ترتيب الدفعات.'),
              _StepTile(
                  step: '2',
                  title: 'نسخ feature إلى lib/features/nosok_system',
                  note: 'دون نسخ preview main.dart إلى المنصة.'),
              _StepTile(
                  step: '3',
                  title: 'تطبيق platform_merge_patch انتقائيًا',
                  note:
                      'routes/registry/sidebar/RBAC فقط داخل ملفات المنصة الحقيقية.'),
              _StepTile(
                  step: '4',
                  title: 'Provider override',
                  note:
                      'ربط nosokAccessProfileProvider بـ AccessProfile الحقيقي من PalWakf.'),
              _StepTile(
                  step: '5',
                  title: 'UAT evidence',
                  note:
                      'رفع أدلة Browser/Role/SQL/Privacy/Billing قبل production decision.'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        NosokSectionCard(
          title: 'حكم v20',
          subtitle:
              'الدفعة تغلق حزمة الجاهزية لكنها لا تعلن production-approved دون أدلة تشغيل حقيقية من بيئة المنصة.',
          child: const Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _Badge(label: 'platform-ready package'),
              _Badge(label: 'production-not-approved'),
              _Badge(label: 'merge-under-platform'),
              _Badge(label: 'no-waqf-assets-mutation'),
            ],
          ),
        ),
      ],
    );
  }
}

class _IntegrationRow extends StatelessWidget {
  const _IntegrationRow(
      {required this.area, required this.contract, required this.status});
  final String area;
  final String contract;
  final String status;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.integration_instructions_outlined),
      title: Text(area),
      subtitle: Text(contract),
      trailing: Text(status),
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile(
      {required this.step, required this.title, required this.note});
  final String step;
  final String title;
  final String note;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text(step)),
      title: Text(title),
      subtitle: Text(note),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(label),
      ),
    );
  }
}
