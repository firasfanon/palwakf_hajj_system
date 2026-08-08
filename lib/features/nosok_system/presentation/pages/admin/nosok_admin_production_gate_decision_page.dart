import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../system_routes.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';

class NosokAdminProductionGateDecisionPage extends StatelessWidget {
  const NosokAdminProductionGateDecisionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final gates = _gates;
    final ready = gates.every((gate) => gate.status == 'passed');
    return NosokPageScaffold(
      title: 'قرار بوابة الإنتاج لنظام نسك',
      subtitle:
          'قرار حاكم لا يعتمد على وجود الصفحات فقط، بل على الدمج داخل PalWakf، أدلة Browser/Role UAT، SQL UAT، خصوصية التتبع، وجاهزية جسور الدفع والإشعارات.',
      actions: [
        FilledButton.icon(
          onPressed: () =>
              context.go(NosokSystemRoutes.adminBrowserRoleEvidence),
          icon: const Icon(Icons.verified_outlined),
          label: const Text('أدلة المتصفح والأدوار'),
        ),
        OutlinedButton.icon(
          onPressed: () => context.go(NosokSystemRoutes.adminRemainingWork),
          icon: const Icon(Icons.playlist_add_check_outlined),
          label: const Text('المتبقي'),
        ),
      ],
      children: [
        NosokSectionCard(
          title: ready
              ? 'الحكم: قابل للترقية'
              : 'الحكم الحالي: غير معتمد إنتاجيًا',
          subtitle: ready
              ? 'كل البوابات مغلقة في سجل الأدلة. يبقى قرار صاحب الصلاحية داخل المنصة.'
              : 'الدفعة توسّع التشغيل وتغلق حزمة القرار، لكنها لا تمنح production approval تلقائيًا قبل الأدلة الواقعية.',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _DecisionBadge(
                  label: ready
                      ? 'production-candidate'
                      : 'production-not-approved'),
              const _DecisionBadge(label: 'semi-independent-under-platform'),
              const _DecisionBadge(label: 'rbac-owned-by-palwakf'),
              const _DecisionBadge(label: 'no-waqf-assets-mutation'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        NosokSectionCard(
          title: 'بوابات القرار',
          subtitle: 'كل بند يجب أن يكون passed بدليل واضح قبل اعتماد الإنتاج.',
          child: Column(
              children: [for (final gate in gates) _GateTile(gate: gate)]),
        ),
        const SizedBox(height: 16),
        const NosokSectionCard(
          title: 'قرار v22',
          subtitle: 'قرار محافظ وفق العقد الحاكم.',
          child: SelectableText(
            'decision: PRODUCTION_NOT_APPROVED\n'
            'reason: full PalWakf repo execution + SQL UAT evidence + browser/role evidence still required.\n'
            'allowed_next_state: controlled-staging / integration-ready-after-application-on-full-repo\n'
            'forbidden_claims: لا يجوز إعلان الإنتاجية بناءً على preview host فقط.',
          ),
        ),
      ],
    );
  }

  static const _gates = [
    _Gate('flutter_preview', 'Flutter Preview', 'passed',
        'آخر سجل أثبت analyzer clean وChrome startup.'),
    _Gate('full_repo_apply', 'تطبيق داخل ريبو PalWakf الكامل', 'pending',
        'يلزم نسخ feature وتفعيل route groups وprovider override داخل الريبو الكامل.'),
    _Gate('sql_uat', 'SQL UAT داخل Supabase', 'pending',
        'تشغيل كل RPCs من 00 إلى v22 وحفظ نتيجة الاستيعاب.'),
    _Gate('browser_role_uat', 'Browser/Role UAT', 'pending',
        'superuser/restricted/unit officer/public tracking.'),
    _Gate('privacy_gate', 'خصوصية التتبع العام', 'pending',
        'إثبات عدم عرض الاسم/الهوية/الهاتف في public status.'),
    _Gate('billing_notification_bridge', 'جسور الدفع والإشعارات', 'pending',
        'إثبات adapters/bridge بلا أسرار أو بيانات دفع حساسة داخل نسك.'),
  ];
}

class _Gate {
  const _Gate(this.key, this.title, this.status, this.note);
  final String key;
  final String title;
  final String status;
  final String note;
}

class _GateTile extends StatelessWidget {
  const _GateTile({required this.gate});
  final _Gate gate;

  @override
  Widget build(BuildContext context) {
    final passed = gate.status == 'passed';
    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(
            passed ? Icons.check_circle_outline : Icons.lock_clock_outlined),
        title: Text(gate.title),
        subtitle: Text('${gate.key}\n${gate.note}'),
        isThreeLine: true,
        trailing: Chip(label: Text(gate.status)),
      ),
    );
  }
}

class _DecisionBadge extends StatelessWidget {
  const _DecisionBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(Icons.verified_outlined, size: 18),
      label: Text(label),
    );
  }
}
