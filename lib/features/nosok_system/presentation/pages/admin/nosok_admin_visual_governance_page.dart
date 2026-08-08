import 'package:flutter/material.dart';

import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';

class NosokAdminVisualGovernancePage extends StatelessWidget {
  const NosokAdminVisualGovernancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return NosokPageScaffold(
      title: 'حوكمة الواجهة البصرية',
      subtitle:
          'ضبط التزام نسك بـ PWF-SIS: هوية المنصة، مكونات مشتركة، تقليل الأوفرلود، تجاوب، RTL، وعدم اختراع شكل منفصل.',
      children: const [
        NosokSectionCard(
          title: 'قواعد الواجهة المعتمدة',
          subtitle:
              'هذه الصفحة ليست محرر Theme؛ بل سجل التزام تشغيلي حتى يظل النظام شبه مستقل بصريًا دون الانفصال عن PalWakf.',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _VisualRule(
                  icon: Icons.format_paint_outlined,
                  title: 'هوية موروثة',
                  body:
                      'الألوان والخطوط الأساسية من المنصة، مع body خاص بنسك.'),
              _VisualRule(
                  icon: Icons.view_quilt_outlined,
                  title: 'مكونات موحدة',
                  body:
                      'Cards, Buttons, Section headers, Empty states ضمن نظام موحد.'),
              _VisualRule(
                  icon: Icons.compress_outlined,
                  title: 'Anti-overload UX',
                  body:
                      'تقسيم المعلومات إلى مراحل، تبويبات، بطاقات، وdensity مناسب.'),
              _VisualRule(
                  icon: Icons.phone_android_outlined,
                  title: 'Responsive',
                  body:
                      'صفحات عامة وإدارية قابلة للاستخدام على الشاشات المختلفة.'),
              _VisualRule(
                  icon: Icons.language_outlined,
                  title: 'RTL/i18n',
                  body: 'العربية RTL افتراضيًا مع قابلية التوسعة للإنجليزية.'),
              _VisualRule(
                  icon: Icons.accessibility_new_outlined,
                  title: 'Accessibility',
                  body:
                      'تباين كافٍ، أزرار واضحة، وعدم استخدام ألوان فاتحة على خلفيات فاتحة.'),
            ],
          ),
        ),
        SizedBox(height: 16),
        NosokSectionCard(
          title: 'حالات الواجهة التشغيلية',
          subtitle:
              'يجب أن تتوفر في كل صفحة إنتاجية، خصوصًا الصفحات المعتمدة على RPC.',
          child: Column(
            children: [
              _StateTile(
                  title: 'Loading', body: 'رسالة انتظار واضحة بدل فراغ مفاجئ.'),
              _StateTile(
                  title: 'Empty',
                  body:
                      'إرشاد المستخدم إلى الإجراء التالي عند عدم وجود بيانات.'),
              _StateTile(
                  title: 'Error',
                  body: 'عرض سبب عام آمن مع زر إعادة المحاولة.'),
              _StateTile(
                  title: 'Unauthorized',
                  body: 'حجب آمن دون تسريب محتوى غير مصرح.'),
              _StateTile(
                  title: 'Maintenance',
                  body: 'توجيه مستخدم النظام عند إيقاف موسمي أو صيانة.'),
            ],
          ),
        ),
      ],
    );
  }
}

class _VisualRule extends StatelessWidget {
  const _VisualRule(
      {required this.icon, required this.title, required this.body});
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      child: Card.outlined(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon),
            const SizedBox(height: 10),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(body)
          ]),
        ),
      ),
    );
  }
}

class _StateTile extends StatelessWidget {
  const _StateTile({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
        child: ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: Text(title),
            subtitle: Text(body)));
  }
}
