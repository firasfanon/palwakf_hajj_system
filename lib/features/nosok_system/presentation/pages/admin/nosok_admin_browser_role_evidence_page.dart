import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../system_routes.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';

class NosokAdminBrowserRoleEvidencePage extends StatefulWidget {
  const NosokAdminBrowserRoleEvidencePage({super.key});

  @override
  State<NosokAdminBrowserRoleEvidencePage> createState() =>
      _NosokAdminBrowserRoleEvidencePageState();
}

class _NosokAdminBrowserRoleEvidencePageState
    extends State<NosokAdminBrowserRoleEvidencePage> {
  final _surfaceController =
      TextEditingController(text: '/admin/systems/nosok');
  final _actorController = TextEditingController(text: 'superuser');
  final _evidenceController = TextEditingController();
  String _result = 'pending';

  @override
  void dispose() {
    _surfaceController.dispose();
    _actorController.dispose();
    _evidenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final matrix = _matrix(_result);
    return NosokPageScaffold(
      title: 'استيعاب أدلة Browser / Role UAT',
      subtitle:
          'سطح إداري لتجميع أدلة المتصفح والأدوار بعد تطبيق حزمة الدمج الحقيقية داخل PalWakf، مع فصل واضح بين preview host وproduction gate.',
      actions: [
        FilledButton.icon(
          onPressed: () =>
              context.go(NosokSystemRoutes.adminProductionGateDecision),
          icon: const Icon(Icons.gavel_outlined),
          label: const Text('قرار بوابة الإنتاج'),
        ),
        OutlinedButton.icon(
          onPressed: () => context.go(NosokSystemRoutes.adminSqlUatIntake),
          icon: const Icon(Icons.storage_outlined),
          label: const Text('SQL UAT'),
        ),
      ],
      children: [
        NosokSectionCard(
          title: 'تسجيل دليل تشغيل',
          subtitle:
              'الحفظ النهائي يتم عبر RPC v22 داخل Supabase بعد الدمج. هذه الواجهة تعمل أيضًا كـ preview آمن.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: 320,
                    child: TextField(
                      controller: _surfaceController,
                      decoration:
                          const InputDecoration(labelText: 'المسار / السطح'),
                    ),
                  ),
                  SizedBox(
                    width: 260,
                    child: TextField(
                      controller: _actorController,
                      decoration:
                          const InputDecoration(labelText: 'الدور أو المستخدم'),
                    ),
                  ),
                  SizedBox(
                    width: 220,
                    child: DropdownButtonFormField<String>(
                      initialValue: _result,
                      decoration: const InputDecoration(labelText: 'النتيجة'),
                      items: const [
                        DropdownMenuItem(
                            value: 'pending', child: Text('قيد الانتظار')),
                        DropdownMenuItem(value: 'passed', child: Text('ناجح')),
                        DropdownMenuItem(value: 'failed', child: Text('فشل')),
                        DropdownMenuItem(value: 'blocked', child: Text('معيق')),
                      ],
                      onChanged: (value) =>
                          setState(() => _result = value ?? 'pending'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _evidenceController,
                minLines: 3,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'الدليل / الملاحظة',
                  hintText:
                      'مثال: superuser opened /admin/systems/nosok; bthusr1 forbidden; browser console clean...',
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'تم تسجيل دليل UAT داخل المعاينة. طبّق RPC v22 لحفظه في Supabase.')),
                  );
                },
                icon: const Icon(Icons.save_outlined),
                label: const Text('تسجيل الدليل'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        NosokSectionCard(
          title: 'مصفوفة الأدلة المطلوبة قبل قرار الإنتاج',
          subtitle:
              'لا تكفي نتيجة analyzer/chrome startup وحدها. يجب وجود أدلة أدوار ومتصفح ومسارات حرجة.',
          child: Column(
              children: [for (final item in matrix) _EvidenceTile(item: item)]),
        ),
        const SizedBox(height: 16),
        const NosokSectionCard(
          title: 'الحد الأدنى المقبول للأدلة',
          subtitle:
              'المطلوب قبل الانتقال من staging-ready إلى production-approved.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PolicyLine('superuser يفتح لوحة نسك وكل أسطح الإدارة الحرجة.'),
              _PolicyLine(
                  'مستخدم بلا صلاحيات لا يرى السايدبار الإداري ولا يصل يدويًا للمسارات المحمية.'),
              _PolicyLine(
                  'موظف وحدة يرى طوابير وحدته فقط بعد ربط AccessProfile الحقيقي.'),
              _PolicyLine(
                  'صفحات public tracking/follow-up لا تكشف الاسم أو رقم الهوية أو الهاتف.'),
              _PolicyLine(
                  'Console review بلا أخطاء Runtime في المسارات العامة والإدارية.'),
            ],
          ),
        ),
      ],
    );
  }

  List<_EvidenceItem> _matrix(String result) {
    final status = result == 'passed' ? 'passed' : 'pending';
    return [
      _EvidenceItem(
          'superuser_admin',
          'superuser / منصة',
          '/admin/systems/nosok',
          status,
          'يفتح لوحة النظام والسايدبار كاملًا.'),
      _EvidenceItem(
          'restricted_user',
          'restricted employee',
          '/admin/systems/nosok',
          'pending',
          'يُمنع أو يرى فقط ما تسمح به صلاحياته.'),
      _EvidenceItem(
          'unit_officer',
          'nosokUnitOfficer',
          '/admin/systems/nosok/unit-queues',
          'pending',
          'يرى طوابير الوحدة المصرح بها فقط.'),
      _EvidenceItem(
          'public_tracking',
          'public citizen',
          '/systems/nosok/application-status',
          status,
          'يعرض الحالة بلا بيانات حساسة.'),
      _EvidenceItem('followup', 'public citizen', '/systems/nosok/follow-up',
          status, 'ينشئ طلب متابعة عبر tracking token فقط.'),
      _EvidenceItem('console', 'browser console', 'critical routes', 'pending',
          'لا توجد أخطاء Flutter runtime أو JS console blockers.'),
    ];
  }
}

class _EvidenceItem {
  const _EvidenceItem(
      this.key, this.actor, this.surface, this.status, this.note);
  final String key;
  final String actor;
  final String surface;
  final String status;
  final String note;
}

class _EvidenceTile extends StatelessWidget {
  const _EvidenceTile({required this.item});
  final _EvidenceItem item;

  @override
  Widget build(BuildContext context) {
    final passed = item.status == 'passed';
    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(passed
            ? Icons.check_circle_outline
            : Icons.pending_actions_outlined),
        title: Text('${item.actor} — ${item.surface}'),
        subtitle: Text('${item.key}\n${item.note}'),
        isThreeLine: true,
        trailing: Chip(label: Text(item.status)),
      ),
    );
  }
}

class _PolicyLine extends StatelessWidget {
  const _PolicyLine(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
