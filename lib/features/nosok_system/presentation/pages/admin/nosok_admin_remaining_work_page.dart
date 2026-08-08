import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../system_routes.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';

class NosokAdminRemainingWorkPage extends StatelessWidget {
  const NosokAdminRemainingWorkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return NosokPageScaffold(
      title: 'المتبقي قبل اعتماد نسك',
      subtitle:
          'سجل واضح بما بقي بعد v22. هذا السطح يمنع الخلط بين preview جاهز وproduction-approved داخل PalWakf.',
      actions: [
        FilledButton.icon(
          onPressed: () => context.go(NosokSystemRoutes.adminRealPlatformMerge),
          icon: const Icon(Icons.merge_outlined),
          label: const Text('حزمة الدمج'),
        ),
        OutlinedButton.icon(
          onPressed: () =>
              context.go(NosokSystemRoutes.adminProductionGateDecision),
          icon: const Icon(Icons.gavel_outlined),
          label: const Text('بوابة الإنتاج'),
        ),
      ],
      children: [
        NosokSectionCard(
          title: 'المتبقي الحرج P0',
          subtitle: 'لا إنتاج قبل إغلاق هذه البنود.',
          child: Column(
              children: [for (final item in _p0) _RemainingTile(item: item)]),
        ),
        const SizedBox(height: 16),
        NosokSectionCard(
          title: 'المتبقي التشغيلي P1',
          subtitle: 'يفضل إغلاقه قبل controlled rollout أو pilot رسمي.',
          child: Column(
              children: [for (final item in _p1) _RemainingTile(item: item)]),
        ),
        const SizedBox(height: 16),
        NosokSectionCard(
          title: 'المتبقي التحسيني P2',
          subtitle: 'لا يمنع staging، لكنه مهم للنضج المؤسسي.',
          child: Column(
              children: [for (final item in _p2) _RemainingTile(item: item)]),
        ),
      ],
    );
  }

  static const _p0 = [
    _Remaining('full_repo_apply', 'تطبيق الحزمة داخل ريبو PalWakf الكامل',
        'لم يُرفع الريبو الكامل داخل هذه الجلسة؛ لذلك لا يمكن الادعاء أن الدمج طُبق فعليًا داخل المنصة.'),
    _Remaining('sql_uat_evidence', 'تشغيل SQL UAT داخل Supabase',
        'تشغيل rpc_nosok_v22_runtime_contract_uat_v1 وكل RPCs السابقة وحفظ النتيجة.'),
    _Remaining('rbac_provider_override', 'ربط AccessProfile الحقيقي',
        'override من platform accessProfileProvider إلى nosokAccessProfileProvider داخل PalWakf.'),
    _Remaining('browser_role_evidence', 'Browser/Role UAT',
        'superuser، مستخدم محدود، موظف وحدة، public tracking، ومراجعة console.'),
  ];

  static const _p1 = [
    _Remaining('billing_adapter_evidence', 'إثبات جسر الدفع',
        'ربط billing_system الحقيقي أو mock رسمي مع idempotency وعدم حفظ أسرار دفع داخل نسك.'),
    _Remaining('notification_bridge_evidence', 'إثبات جسر الإشعارات',
        'اختبار in_app/SMS/email adapters من خلال خدمة إشعارات المنصة.'),
    _Remaining('unit_scope_real_data', 'ربط الوحدات الحقيقية',
        'قراءة core.org_units ونطاقات الوحدة من AccessProfile وليس demo فقط.'),
    _Remaining('storage_bucket_policies', 'سياسات Storage',
        'تأكيد bucket/policies لملفات الطلبات وسندات الدفعات.'),
  ];

  static const _p2 = [
    _Remaining('analytics', 'تحليلات وتقارير موسمية أعمق',
        'لوحات قبول/رفض/دفعات/وثائق حسب الوحدة والموسم.'),
    _Remaining('content_editorial', 'تحرير محتوى نسك',
        'Workflow نشر للإعلانات والأسئلة والشروط الموسمية.'),
    _Remaining('accessibility', 'فحص WCAG/RTL/Density',
        'اختبار لوحة التحكم على شاشات صغيرة وكثافة بيانات عالية.'),
  ];
}

class _Remaining {
  const _Remaining(this.key, this.title, this.note);
  final String key;
  final String title;
  final String note;
}

class _RemainingTile extends StatelessWidget {
  const _RemainingTile({required this.item});
  final _Remaining item;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.pending_actions_outlined),
        title: Text(item.title),
        subtitle: Text('${item.key}\n${item.note}'),
        isThreeLine: true,
      ),
    );
  }
}
