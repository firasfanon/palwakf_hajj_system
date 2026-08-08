import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../system_routes.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';

class NosokAdminSqlUatIntakePage extends StatefulWidget {
  const NosokAdminSqlUatIntakePage({super.key});

  @override
  State<NosokAdminSqlUatIntakePage> createState() =>
      _NosokAdminSqlUatIntakePageState();
}

class _NosokAdminSqlUatIntakePageState
    extends State<NosokAdminSqlUatIntakePage> {
  final _formKey = GlobalKey<FormState>();
  final _sqlUatSummaryController = TextEditingController();
  final _evidenceUrlController = TextEditingController();
  String _selectedStatus = 'pending';

  @override
  void dispose() {
    _sqlUatSummaryController.dispose();
    _evidenceUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checks = _checksForStatus(_selectedStatus);
    return NosokPageScaffold(
      title: 'استيعاب نتائج SQL UAT',
      subtitle:
          'تسجيل نتيجة تشغيل عقود SQL الخاصة بنسك داخل Supabase قبل قرار الدمج النهائي أو اعتماد الإنتاج.',
      actions: [
        FilledButton.icon(
          onPressed: () =>
              context.go(NosokSystemRoutes.adminProductionUatClosure),
          icon: const Icon(Icons.fact_check_outlined),
          label: const Text('إغلاق UAT'),
        ),
      ],
      children: [
        NosokSectionCard(
          title: 'استمارة الاستيعاب',
          subtitle:
              'هذه واجهة preview. عند الدمج الفعلي تحفظ عبر RPC v21 داخل nosok.sql_uat_result_intake.',
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _selectedStatus,
                  decoration: const InputDecoration(labelText: 'حالة SQL UAT'),
                  items: const [
                    DropdownMenuItem(
                        value: 'pending', child: Text('قيد الانتظار')),
                    DropdownMenuItem(value: 'passed', child: Text('ناجح')),
                    DropdownMenuItem(value: 'blocked', child: Text('معيق')),
                    DropdownMenuItem(value: 'partial', child: Text('جزئي')),
                  ],
                  onChanged: (value) =>
                      setState(() => _selectedStatus = value ?? 'pending'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _sqlUatSummaryController,
                  minLines: 4,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    labelText: 'ملخص نتيجة SQL UAT',
                    hintText:
                        'مثال: rpc_nosok_v21_runtime_contract_uat_v1 passed؛ registry/permissions/sections ready...',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _evidenceUrlController,
                  decoration: const InputDecoration(
                      labelText: 'رابط الدليل أو اسم ملف اللقطة'),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'تم تسجيل نتيجة UAT في واجهة المعاينة. الحفظ النهائي يتم عبر SQL/RPC v21.')),
                    );
                  },
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('تسجيل النتيجة'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        NosokSectionCard(
          title: 'فحوص v21 المطلوبة',
          subtitle: 'تتغير القراءة التشغيلية حسب حالة الاستيعاب الحالية.',
          child: Column(
            children: [
              for (final check in checks) _UatCheckTile(check: check),
            ],
          ),
        ),
        const SizedBox(height: 16),
        NosokSectionCard(
          title: 'أوامر SQL المقترحة',
          subtitle:
              'تُشغل داخل Supabase SQL Editor بعد تطبيق ملفات sql/00..19.',
          child: const SelectableText(
            'select * from public.rpc_nosok_v21_runtime_contract_uat_v1();\n'
            'select * from public.rpc_nosok_v21_platform_merge_readiness_v1();\n'
            'select * from public.rpc_nosok_v21_rbac_override_contract_v1();\n'
            'select * from public.rpc_nosok_v21_sql_uat_result_intake_v1();',
          ),
        ),
      ],
    );
  }

  List<_UatCheck> _checksForStatus(String status) {
    final passed = status == 'passed';
    return [
      _UatCheck('schema_and_tables', 'nosok schema والجداول التشغيلية',
          passed ? 'passed' : 'pending'),
      _UatCheck('registry_contract', 'Dynamic Registry + system sections',
          passed ? 'passed' : 'pending'),
      _UatCheck(
          'rbac_contract',
          'permissions + role templates + provider override',
          passed ? 'passed' : 'pending'),
      _UatCheck('public_privacy', 'التتبع العام بلا بيانات حساسة',
          passed ? 'passed' : 'pending'),
      _UatCheck('billing_bridge', 'Billing bridge لا يخزن أسرار دفع',
          passed ? 'passed' : 'pending'),
    ];
  }
}

class _UatCheck {
  const _UatCheck(this.key, this.title, this.status);
  final String key;
  final String title;
  final String status;
}

class _UatCheckTile extends StatelessWidget {
  const _UatCheckTile({required this.check});
  final _UatCheck check;

  @override
  Widget build(BuildContext context) {
    final passed = check.status == 'passed';
    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(passed
            ? Icons.check_circle_outline
            : Icons.pending_actions_outlined),
        title: Text(check.title),
        subtitle: Text(check.key),
        trailing: Chip(label: Text(check.status)),
      ),
    );
  }
}
