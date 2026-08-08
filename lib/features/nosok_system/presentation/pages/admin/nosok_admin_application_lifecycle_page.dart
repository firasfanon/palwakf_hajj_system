import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/nosok_application_lifecycle_controller.dart';
import '../../../domain/models/nosok_application_lifecycle_transition.dart';
import '../../../system_routes.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';
import '../../widgets/nosok_stat_card.dart';

class NosokAdminApplicationLifecyclePage extends ConsumerWidget {
  const NosokAdminApplicationLifecyclePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rulesAsync = ref.watch(nosokLifecycleRulesProvider(null));
    final transitionsAsync =
        ref.watch(nosokApplicationLifecycleTransitionsProvider(null));

    return NosokPageScaffold(
      title: 'State Machine الطلبات',
      subtitle:
          'إدارة دورة حياة الطلب كمسار حالات واضح بدل تحديثات عشوائية: submitted → under_review → needs_completion/accepted/rejected → closed.',
      actions: [
        FilledButton.icon(
          onPressed: () => context.go(NosokSystemRoutes.adminApplications),
          icon: const Icon(Icons.assignment_outlined),
          label: const Text('الطلبات'),
        ),
        OutlinedButton.icon(
          onPressed: () {
            ref.invalidate(nosokLifecycleRulesProvider(null));
            ref.invalidate(nosokApplicationLifecycleTransitionsProvider(null));
          },
          icon: const Icon(Icons.refresh_outlined),
          label: const Text('تحديث'),
        ),
      ],
      children: [
        rulesAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, stackTrace) => NosokSectionCard(
            title: 'تعذر تحميل قواعد الانتقال',
            subtitle: 'تعذر تحميل البيانات حاليًا.',
            child:
                const Text('تأكد من تطبيق SQL v18 أو استخدم مستودع المعاينة.'),
          ),
          data: (rules) => _LifecycleRulesSection(rules: rules),
        ),
        const SizedBox(height: 16),
        transitionsAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, stackTrace) => NosokSectionCard(
            title: 'تعذر تحميل سجل الانتقالات',
            subtitle: 'تعذر تحميل البيانات حاليًا.',
            child: const Text('سجل الانتقالات اختياري لكنه مطلوب للإنتاج.'),
          ),
          data: (transitions) =>
              _LifecycleTransitionsSection(transitions: transitions),
        ),
      ],
    );
  }
}

class _LifecycleRulesSection extends StatelessWidget {
  const _LifecycleRulesSection({required this.rules});

  final List<NosokApplicationLifecycleRule> rules;

  @override
  Widget build(BuildContext context) {
    final enabled = rules.where((item) => item.isEnabled).length;
    return NosokSectionCard(
      title: 'قواعد الانتقال المسموحة',
      subtitle: 'هذه القواعد يجب أن تقابلها صلاحيات RBAC وRPC/RLS في المنصة.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              NosokStatCard(
                  label: 'إجمالي القواعد', value: rules.length.toString()),
              NosokStatCard(
                  label: 'القواعد المفعلة', value: enabled.toString()),
            ],
          ),
          const SizedBox(height: 12),
          for (final rule in rules)
            Card.outlined(
              child: ListTile(
                leading: Icon(rule.isEnabled
                    ? Icons.alt_route_outlined
                    : Icons.block_outlined),
                title: Text(rule.titleAr),
                subtitle: Text(
                    '${rule.fromStatus} ← ${rule.toStatus}\n${rule.descriptionAr ?? ''}'),
                trailing: _Badge(
                    label: rule.requiredPermission ?? 'permission-pending'),
              ),
            ),
        ],
      ),
    );
  }
}

class _LifecycleTransitionsSection extends StatelessWidget {
  const _LifecycleTransitionsSection({required this.transitions});

  final List<NosokApplicationLifecycleTransition> transitions;

  @override
  Widget build(BuildContext context) {
    return NosokSectionCard(
      title: 'سجل الانتقالات الأخير',
      subtitle:
          'Audit trail تشغيلي يوضح من أي حالة إلى أي حالة، مع السبب والملاحظة.',
      child: transitions.isEmpty
          ? const Text('لا توجد انتقالات مسجلة بعد.')
          : Column(
              children: [
                for (final transition in transitions.take(25))
                  Card.outlined(
                    child: ListTile(
                      leading: Icon(transition.isAllowed
                          ? Icons.task_alt_outlined
                          : Icons.block_outlined),
                      title: Text(
                          '${transition.applicationNo} — ${transition.transitionKey}'),
                      subtitle: Text(
                          '${transition.fromStatus} ← ${transition.toStatus}\n${transition.reasonAr ?? transition.noteAr ?? '-'}'),
                      trailing: _Badge(
                          label: transition.isAllowed ? 'allowed' : 'blocked'),
                    ),
                  ),
              ],
            ),
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(label, style: Theme.of(context).textTheme.labelSmall),
      ),
    );
  }
}
