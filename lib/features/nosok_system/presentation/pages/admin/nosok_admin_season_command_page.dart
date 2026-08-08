import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/nosok_season_command_controller.dart';
import '../../../domain/models/nosok_season_command_gate.dart';
import '../../../system_routes.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';
import '../../widgets/nosok_stat_card.dart';

class NosokAdminSeasonCommandPage extends ConsumerWidget {
  const NosokAdminSeasonCommandPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gatesValue = ref.watch(nosokSeasonCommandGatesProvider);
    final decisionValue = ref.watch(nosokSeasonOpenGateDecisionProvider);

    return NosokPageScaffold(
      title: 'قيادة الموسم',
      subtitle:
          'سطح قيادة موسمي يفرض بوابة تشغيل قبل فتح التسجيل: الموسم، البرنامج، الشركات، الخصوصية، الأدوار، وجسر الدفع.',
      actions: [
        FilledButton.icon(
            onPressed: () => context.go(NosokSystemRoutes.adminSeasons),
            icon: const Icon(Icons.event_available_outlined),
            label: const Text('إدارة المواسم')),
        OutlinedButton.icon(
            onPressed: () => context.go(NosokSystemRoutes.adminPrograms),
            icon: const Icon(Icons.route_outlined),
            label: const Text('البرامج')),
        OutlinedButton.icon(
            onPressed: () => context.go(NosokSystemRoutes.adminCompanies),
            icon: const Icon(Icons.business_outlined),
            label: const Text('الشركات')),
        OutlinedButton.icon(
          onPressed: () {
            ref.invalidate(nosokSeasonCommandGatesProvider);
            ref.invalidate(nosokSeasonOpenGateDecisionProvider);
          },
          icon: const Icon(Icons.refresh_outlined),
          label: const Text('تحديث'),
        ),
      ],
      children: [
        decisionValue.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, stackTrace) => NosokSectionCard(
            title: 'تعذر تقييم بوابة الموسم',
            subtitle: 'تعذر تحميل البيانات حاليًا.',
            child: const Text('تأكد من تطبيق SQL v17 أو مستودع المعاينة.'),
          ),
          data: (decision) => _OpenGateDecisionCard(decision: decision),
        ),
        const SizedBox(height: 16),
        gatesValue.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, stackTrace) => NosokSectionCard(
            title: 'تعذر تحميل Checklist الموسم',
            subtitle: 'تعذر تحميل البيانات حاليًا.',
            child: OutlinedButton.icon(
              onPressed: () => ref.invalidate(nosokSeasonCommandGatesProvider),
              icon: const Icon(Icons.refresh_outlined),
              label: const Text('إعادة المحاولة'),
            ),
          ),
          data: (gates) => _SeasonGates(gates: gates),
        ),
        const SizedBox(height: 16),
        NosokSectionCard(
          title: 'قرارات الموسم',
          subtitle:
              'فتح التسجيل لا يُنفذ من زر شكلي؛ القرار محكوم بنتيجة البوابة أعلاه وبصلاحيات PalWakf.',
          child: const Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _DecisionCard(
                  icon: Icons.lock_open_outlined,
                  title: 'فتح التسجيل',
                  body: 'ممنوع إذا بقي blocker في بوابة الموسم.'),
              _DecisionCard(
                  icon: Icons.pause_circle_outline,
                  title: 'تعليق التسجيل',
                  body: 'عند وجود خلل في الدفع أو التتبع أو الصلاحيات.'),
              _DecisionCard(
                  icon: Icons.verified_outlined,
                  title: 'اعتماد النتائج',
                  body: 'يتطلب فصل صلاحيات الاعتماد عن المراجعة.'),
              _DecisionCard(
                  icon: Icons.archive_outlined,
                  title: 'إغلاق الموسم',
                  body: 'بعد اكتمال التقارير والتسويات والشكاوى.'),
            ],
          ),
        ),
      ],
    );
  }
}

class _OpenGateDecisionCard extends StatelessWidget {
  const _OpenGateDecisionCard({required this.decision});

  final NosokSeasonOpenGateDecision decision;

  @override
  Widget build(BuildContext context) {
    return NosokSectionCard(
      title: decision.canOpen
          ? 'بوابة الموسم تسمح بالفتح'
          : 'بوابة الموسم تمنع الفتح',
      subtitle: decision.noteAr,
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          NosokStatCard(
              label: 'قرار الفتح',
              value: decision.canOpen ? 'مسموح' : 'ممنوع',
              subtitle: 'قرار تشغيل لا يعتمد على النصوص الثابتة'),
          NosokStatCard(
              label: 'Blockers',
              value: decision.blockerCount.toString(),
              subtitle: 'يجب أن تساوي صفرًا قبل الفتح'),
          SizedBox(
            width: 320,
            child: Card.outlined(
              child: ListTile(
                leading: Icon(decision.canOpen
                    ? Icons.verified_outlined
                    : Icons.gpp_bad_outlined),
                title: const Text('تنفيذ فتح الموسم'),
                subtitle: Text(decision.canOpen
                    ? 'يمكن توجيه المستخدم لإدارة المواسم.'
                    : 'أغلق الـ blockers أولًا.'),
                trailing: const Icon(Icons.chevron_left),
                onTap: () => context.go(NosokSystemRoutes.adminSeasons),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SeasonGates extends StatelessWidget {
  const _SeasonGates({required this.gates});

  final List<NosokSeasonCommandGate> gates;

  @override
  Widget build(BuildContext context) {
    final passed = gates.where((item) => item.passed).length;
    final blockers = gates.where((item) => item.isBlocking).length;

    return NosokSectionCard(
      title: 'Checklist تشغيل الموسم المربوط بالبيانات',
      subtitle:
          'تُقرأ من RPC v17 وتحول checklist من نص إرشادي إلى Gate تشغيلية قابلة للفحص.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              NosokStatCard(
                  label: 'فحوص مجتازة', value: '$passed/${gates.length}'),
              NosokStatCard(label: 'Blockers', value: blockers.toString()),
            ],
          ),
          const SizedBox(height: 12),
          for (final gate in gates) _GateRow(gate: gate),
        ],
      ),
    );
  }
}

class _GateRow extends StatelessWidget {
  const _GateRow({required this.gate});
  final NosokSeasonCommandGate gate;

  @override
  Widget build(BuildContext context) {
    final icon = gate.passed
        ? Icons.task_alt_outlined
        : gate.isBlocking
            ? Icons.block_outlined
            : Icons.pending_actions_outlined;
    final label = gate.passed
        ? 'Passed'
        : gate.isBlocking
            ? 'Blocker'
            : gate.status;
    return Card.outlined(
      child: ListTile(
        leading: Icon(icon),
        title: Text(gate.titleAr),
        subtitle: Text([gate.descriptionAr, gate.evidenceNote]
            .whereType<String>()
            .where((item) => item.trim().isNotEmpty)
            .join(' — ')),
        trailing: Wrap(
          spacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _PlainBadge(label: gate.gateType),
            _PlainBadge(label: label),
            if ((gate.routePath ?? '').trim().isNotEmpty)
              const Icon(Icons.open_in_new_outlined),
          ],
        ),
        onTap: (gate.routePath ?? '').trim().isEmpty
            ? null
            : () => context.go(gate.routePath!),
      ),
    );
  }
}

class _PlainBadge extends StatelessWidget {
  const _PlainBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(label, style: Theme.of(context).textTheme.labelSmall),
      ),
    );
  }
}

class _DecisionCard extends StatelessWidget {
  const _DecisionCard(
      {required this.icon, required this.title, required this.body});
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
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
