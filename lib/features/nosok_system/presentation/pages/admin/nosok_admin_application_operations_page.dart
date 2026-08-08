import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/nosok_followup_inbox_controller.dart';
import '../../../application/nosok_notification_dispatch_controller.dart';
import '../../../application/nosok_unit_queue_controller.dart';
import '../../../application/nosok_workbench_controller.dart';
import '../../../system_routes.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';
import '../../widgets/nosok_stat_card.dart';

class NosokAdminApplicationOperationsPage extends ConsumerWidget {
  const NosokAdminApplicationOperationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buckets =
        ref.watch(nosokWorkflowBucketsProvider).valueOrNull ?? const [];
    final queue =
        ref.watch(nosokUnitApplicationQueueProvider).valueOrNull ?? const [];
    final followups =
        ref.watch(nosokFollowupInboxProvider).valueOrNull ?? const [];
    final dispatches =
        ref.watch(nosokNotificationDispatchesProvider).valueOrNull ?? const [];
    final blockers =
        buckets.fold<int>(0, (sum, item) => sum + item.blockerCount);
    final warnings =
        buckets.fold<int>(0, (sum, item) => sum + item.warningCount);
    final queueOpen = queue.length;
    final pendingFollowups =
        followups.where((item) => item.status != 'closed').length;
    final pendingNotifications = dispatches
        .where((item) => item.status == 'queued' || item.status == 'pending')
        .length;

    return NosokPageScaffold(
      title: 'مركز عمليات الطلبات',
      subtitle:
          'سطح تشغيلي عميق يجمع دورة حياة الطلب، طوابير الوحدات، متابعة المواطن، الإشعارات، والـ SLA في صفحة واحدة.',
      actions: [
        FilledButton.icon(
          onPressed: () => context.go(NosokSystemRoutes.adminApplications),
          icon: const Icon(Icons.assignment_outlined),
          label: const Text('قائمة الطلبات'),
        ),
        OutlinedButton.icon(
          onPressed: () =>
              context.go(NosokSystemRoutes.adminApplicationLifecycle),
          icon: const Icon(Icons.alt_route_outlined),
          label: const Text('دورة الحياة'),
        ),
      ],
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            NosokStatCard(
                label: 'طلبات في الطوابير',
                value: queueOpen.toString(),
                subtitle: 'Unit-scoped queues'),
            NosokStatCard(
                label: 'متابعات مفتوحة',
                value: pendingFollowups.toString(),
                subtitle: 'Citizen follow-up inbox'),
            NosokStatCard(
                label: 'إشعارات قيد الإرسال',
                value: pendingNotifications.toString(),
                subtitle: 'Notification bridge'),
            NosokStatCard(
                label: 'Blockers / Warnings',
                value: '$blockers / $warnings',
                subtitle: 'Workbench risk'),
          ],
        ),
        const SizedBox(height: 16),
        NosokSectionCard(
          title: 'خريطة العمل اليومية',
          subtitle:
              'ترتيب عملي للموظف: فرز، تدقيق، استكمال، قرار، إشعار، ثم إغلاق.',
          child: LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth < 800 ? 1 : 2;
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: columns,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: columns == 1 ? 4 : 1.9,
                children: const [
                  _OperationCard(
                      title: 'فرز الطلبات حسب الوحدة',
                      route: NosokSystemRoutes.adminUnitQueues,
                      icon: Icons.account_tree_outlined,
                      note: 'توجيه العمل للمديرية/الوحدة المختصة.'),
                  _OperationCard(
                      title: 'تطبيق State Machine',
                      route: NosokSystemRoutes.adminApplicationLifecycle,
                      icon: Icons.alt_route_outlined,
                      note: 'منع الانتقالات غير المحكومة.'),
                  _OperationCard(
                      title: 'صندوق متابعة المواطن',
                      route: NosokSystemRoutes.adminFollowupInbox,
                      icon: Icons.mark_email_unread_outlined,
                      note: 'استقبال طلبات الاستكمال والاعتراض.'),
                  _OperationCard(
                      title: 'جسر الإشعارات',
                      route: NosokSystemRoutes.adminNotificationDispatch,
                      icon: Icons.send_outlined,
                      note: 'تجهيز رسائل منصة لا محرك مستقل.'),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        NosokSectionCard(
          title: 'سياسة التعميق التشغيلي',
          subtitle:
              'لا يتم قبول قرار حالة إلا من Lifecycle، ولا تُغلق متابعة مواطن بلا ملاحظة، ولا تُرسل إشعارات إلا عبر Bridge قابل للتدقيق.',
          child: const Column(
            children: [
              _PolicyRow(
                  label: 'State machine enforced',
                  detail:
                      'التحكم بالحالة يتم عبر قواعد انتقال لا عبر تعديل حر.'),
              _PolicyRow(
                  label: 'Follow-up evidence',
                  detail:
                      'كل طلب متابعة مواطن يبقى في صندوق متابعة حتى الإغلاق.'),
              _PolicyRow(
                  label: 'Unit queues',
                  detail:
                      'الوحدة ترى نطاقها التشغيلي وفق AccessProfile/RBAC عند الدمج.'),
              _PolicyRow(
                  label: 'Notification audit',
                  detail:
                      'الإرسال يعبر طابورًا قابلًا للتدقيق قبل مزودات المنصة.'),
            ],
          ),
        ),
      ],
    );
  }
}

class _OperationCard extends StatelessWidget {
  const _OperationCard(
      {required this.title,
      required this.route,
      required this.icon,
      required this.note});
  final String title;
  final String route;
  final IconData icon;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: InkWell(
        onTap: () => context.go(route),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 30),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 6),
                    Text(note)
                  ])),
              const Icon(Icons.chevron_left),
            ],
          ),
        ),
      ),
    );
  }
}

class _PolicyRow extends StatelessWidget {
  const _PolicyRow({required this.label, required this.detail});
  final String label;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.check_circle_outline),
      title: Text(label),
      subtitle: Text(detail),
    );
  }
}
