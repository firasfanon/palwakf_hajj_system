import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../system_routes.dart';
import '../../widgets/nosok_section_card.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokServiceGuidePage extends StatelessWidget {
  const NosokServiceGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _GuideHero(
            onApply: () => context.go(NosokSystemRoutes.apply),
            onStatus: () => context.go(NosokSystemRoutes.applicationStatus),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _GuideMetric(
                  title: 'مراحل الطلب',
                  value: '5',
                  icon: Icons.timeline_outlined),
              _GuideMetric(
                  title: 'قنوات متابعة',
                  value: '3',
                  icon: Icons.support_agent_outlined),
              _GuideMetric(
                  title: 'تتبع آمن',
                  value: 'رمز',
                  icon: Icons.privacy_tip_outlined),
              _GuideMetric(
                  title: 'شركات مؤهلة',
                  value: 'موسمية',
                  icon: Icons.business_center_outlined),
            ],
          ),
          const SizedBox(height: 16),
          NosokSectionCard(
            title: 'اختر ما تريد إنجازه',
            subtitle:
                'واجهة خدمة مركزة للمستفيد بدل عرض إداري طويل. كل بطاقة تقود إلى إجراء واضح.',
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _ActionCard(
                  icon: Icons.app_registration_rounded,
                  title: 'تقديم طلب جديد',
                  description:
                      'ابدأ نموذج التقديم متعدد الخطوات مع الوثائق والدفعات.',
                  button: 'ابدأ الآن',
                  onTap: () => context.go(NosokSystemRoutes.apply),
                ),
                _ActionCard(
                  icon: Icons.track_changes_outlined,
                  title: 'متابعة الطلب',
                  description:
                      'استخدم رمز التتبع العام لمعرفة الحالة دون كشف البيانات الحساسة.',
                  button: 'متابعة',
                  onTap: () => context.go(NosokSystemRoutes.applicationStatus),
                ),
                _ActionCard(
                  icon: Icons.business_outlined,
                  title: 'الشركات المؤهلة',
                  description:
                      'استعرض الشركات المعتمدة للموسم وفق النشر العام.',
                  button: 'استعراض',
                  onTap: () => context.go(NosokSystemRoutes.companies),
                ),
                _ActionCard(
                  icon: Icons.report_problem_outlined,
                  title: 'تقديم شكوى',
                  description:
                      'قدّم شكوى أو ملاحظة مرتبطة بالخدمة أو الشركة أو الطلب.',
                  button: 'فتح الخدمة',
                  onTap: () => context.go(NosokSystemRoutes.complaints),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          NosokSectionCard(
            title: 'ما الذي يجب تحضيره قبل التقديم؟',
            subtitle:
                'قائمة عملية للمستفيد قبل البدء. التفاصيل النهائية تضبطها الوزارة لكل موسم.',
            child: LayoutBuilder(
              builder: (context, constraints) {
                final narrow = constraints.maxWidth < 720;
                final items = <Widget>[
                  const _RequirementTile(
                      icon: Icons.badge_outlined,
                      title: 'بيانات الهوية',
                      body: 'الاسم، رقم الهوية، معلومات التواصل، والعنوان.'),
                  const _RequirementTile(
                      icon: Icons.family_restroom_outlined,
                      title: 'بيانات المرافقين',
                      body: 'صلة القرابة والبيانات الأساسية عند وجود مرافقين.'),
                  const _RequirementTile(
                      icon: Icons.attach_file_outlined,
                      title: 'الوثائق',
                      body: 'مرفقات داعمة قابلة للمراجعة والاعتماد أو الرفض.'),
                  const _RequirementTile(
                      icon: Icons.payments_outlined,
                      title: 'إثباتات الدفع',
                      body: 'سندات أو إشعارات دفع لحين اكتمال الربط المركزي.'),
                ];
                if (narrow) {
                  return Column(
                      children: items
                          .map((w) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: w))
                          .toList());
                }
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3.4,
                  children: items,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          NosokSectionCard(
            title: 'سياسة الخصوصية المختصرة',
            subtitle:
                'التتبع العام مصمم لعرض أقل قدر من المعلومات اللازمة فقط.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'يعرض التتبع العام حالة الطلب ورقم الطلب ورمز التتبع فقط، ولا يعرض الاسم أو الهوية أو الهاتف أو البريد.',
                    style: theme.textTheme.bodyLarge),
                const SizedBox(height: 8),
                const _InlinePolicy(
                    icon: Icons.lock_outline,
                    text:
                        'صلاحيات الموظفين تأتي من AccessProfile وRBAC الخاص بالمنصة.'),
                const _InlinePolicy(
                    icon: Icons.account_tree_outlined,
                    text:
                        'صفحات الوحدات تقرأ من core.org_units ولا تنشئ مصدر وحدات بديل.'),
                const _InlinePolicy(
                    icon: Icons.fact_check_outlined,
                    text:
                        'أي اعتماد إنتاجي يحتاج أدلة UAT وConsole وSQL قبل القرار.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GuideHero extends StatelessWidget {
  const _GuideHero({required this.onApply, required this.onStatus});
  final VoidCallback onApply;
  final VoidCallback onStatus;

  @override
  Widget build(BuildContext context) {
    return PwfSisPremiumPublicHero(
      title: 'دليل خدمات نسك',
      highlight: 'للمواطن',
      description:
          'ابدأ الخدمة المناسبة، تابع طلبك، واعرف ما الذي تحتاجه قبل التقديم بلغة مختصرة وواضحة.',
      badges: const ['دليل خدمة', 'تجربة مواطن', 'متابعة آمنة'],
      icon: Icons.menu_book_outlined,
      primaryAction: FilledButton.icon(
        onPressed: onApply,
        icon: const Icon(Icons.app_registration_rounded),
        label: const Text('تقديم طلب'),
      ),
      secondaryAction: OutlinedButton.icon(
        onPressed: onStatus,
        icon: const Icon(Icons.track_changes_outlined),
        label: const Text('متابعة طلب'),
      ),
    );
  }
}

class _GuideMetric extends StatelessWidget {
  const _GuideMetric(
      {required this.title, required this.value, required this.icon});
  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 12),
              Expanded(child: Text(title)),
              Text(value, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard(
      {required this.icon,
      required this.title,
      required this.description,
      required this.button,
      required this.onTap});
  final IconData icon;
  final String title;
  final String description;
  final String button;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      child: Card.outlined(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32),
              const SizedBox(height: 12),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(description),
              const SizedBox(height: 12),
              Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: FilledButton.tonal(
                      onPressed: onTap, child: Text(button))),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequirementTile extends StatelessWidget {
  const _RequirementTile(
      {required this.icon, required this.title, required this.body});
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(body),
      ),
    );
  }
}

class _InlinePolicy extends StatelessWidget {
  const _InlinePolicy({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
