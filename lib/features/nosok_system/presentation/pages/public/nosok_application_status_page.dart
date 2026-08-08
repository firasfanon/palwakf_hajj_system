import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/nosok_applications_controller.dart';
import '../../../system_routes.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';

class NosokApplicationStatusPage extends ConsumerStatefulWidget {
  const NosokApplicationStatusPage({super.key});

  @override
  ConsumerState<NosokApplicationStatusPage> createState() =>
      _NosokApplicationStatusPageState();
}

class _NosokApplicationStatusPageState
    extends ConsumerState<NosokApplicationStatusPage> {
  final TextEditingController _trackingTokenController =
      TextEditingController();
  String? _submittedToken;

  @override
  void dispose() {
    _trackingTokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lookupAsync = _submittedToken == null || _submittedToken!.isEmpty
        ? null
        : ref.watch(nosokApplicationTrackingLookupProvider(_submittedToken!));

    return NosokPageScaffold(
      title: 'متابعة طلبك',
      subtitle:
          'أدخل رقم الطلب أو رمز التتبع الذي حصلت عليه بعد التقديم لعرض الحالة العامة والنواقص دون كشف بيانات حساسة.',
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: const BorderSide(color: Color(0xFFDCE3EB)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xFFE8F0FE),
                      foregroundColor: Color(0xFF0A3B5A),
                      child: Icon(Icons.manage_search_outlined),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'تحقق آمن من حالة طلبك',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 640;
                    final field = TextField(
                      controller: _trackingTokenController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        labelText: 'رقم الطلب / رمز التتبع',
                        hintText: 'مثال: NSK-TRK-1A2B3C4D5E6F',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.confirmation_number_outlined,
                            color: Color(0xFF0A3B5A)),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(18))),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          borderSide: BorderSide(color: Color(0xFFDCE3EB)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          borderSide:
                              BorderSide(color: Color(0xFF0A3B5A), width: 1.4),
                        ),
                      ),
                      onSubmitted: (_) => _search(),
                    );
                    final actions = [
                      FilledButton.icon(
                        onPressed: _search,
                        icon: const Icon(Icons.search),
                        label: const Text('متابعة الحالة'),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF0A3B5A),
                          minimumSize:
                              Size(compact ? double.infinity : 150, 50),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          _trackingTokenController.clear();
                          setState(() => _submittedToken = null);
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('مسح'),
                        style: OutlinedButton.styleFrom(
                            minimumSize:
                                Size(compact ? double.infinity : 110, 50)),
                      ),
                    ];
                    if (compact) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          field,
                          const SizedBox(height: 10),
                          ...actions.map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: item))
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: field),
                        const SizedBox(width: 10),
                        ...actions.map((item) => Padding(
                            padding: const EdgeInsetsDirectional.only(start: 8),
                            child: item)),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),
                const Text(
                    'يعرض هذا المسار الحالة العامة للطلب والنواقص المطلوبة دون إظهار بيانات داخلية أو ملاحظات موظفين.'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (lookupAsync == null)
          const NosokSectionCard(
            title: 'إرشاد',
            child: Text(
                'بعد تقديم الطلب سيظهر لك رقم الطلب ورمز التتبع. احتفظ بهما ثم أدخلهما هنا لمتابعة الحالة.'),
          )
        else
          lookupAsync.when(
            loading: () => const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
            error: (error, stack) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: const Text(
                    'تعذر التحقق من الطلب حاليًا. تحقق من الرمز أو أعد المحاولة لاحقًا.'),
              ),
            ),
            data: (application) {
              if (application == null) {
                return const NosokSectionCard(
                  title: 'لا توجد نتيجة',
                  child: Text(
                      'لم يتم العثور على طلب مطابق لرمز التتبع المدخل. تحقق من الرمز ثم أعد المحاولة.'),
                );
              }
              return NosokSectionCard(
                title: 'نتيجة التتبع',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StatusLine(
                        label: 'رقم الطلب', value: application.applicationNo),
                    _StatusLine(
                        label: 'رمز التتبع',
                        value: application.trackingToken ?? '-'),
                    const Text(
                        'لا تعرض صفحة التتبع العام الاسم أو رقم الهوية أو بيانات الاتصال أو روابط الوثائق/الإيصالات.'),
                    const SizedBox(height: 8),
                    _StatusLine(
                        label: 'نوع الخدمة',
                        value:
                            application.serviceType == 'hajj' ? 'حج' : 'عمرة'),
                    _StatusLine(
                        label: 'حالة الطلب',
                        value: _labelForStatus(application.applicationStatus)),
                    _StatusLine(
                        label: 'حالة الأهلية',
                        value: _labelForEligibility(
                            application.eligibilityStatus)),
                    _StatusLine(
                        label: 'الموسم',
                        value: application.seasonTitleAr ?? '-'),
                    _StatusLine(
                        label: 'البرنامج',
                        value: application.programTitleAr ?? '-'),
                    _StatusLine(
                        label: 'الوثائق المسجلة',
                        value: (application.documentsCount ?? 0).toString()),
                    _StatusLine(
                        label: 'الدفعات المسجلة',
                        value: (application.paymentsCount ?? 0).toString()),
                    _StatusLine(
                        label: 'إجمالي المدفوع',
                        value: application.totalPaidAmount == null
                            ? '-'
                            : application.totalPaidAmount!.toStringAsFixed(2)),
                    _StatusLine(
                        label: 'آخر حالة دفع',
                        value: _labelForPayment(application.lastPaymentStatus)),
                    _StatusLine(
                        label: 'تاريخ التقديم',
                        value: _formatDateTime(application.submittedAt)),
                    _StatusLine(
                        label: 'آخر مراجعة',
                        value: _formatDateTime(application.reviewedAt)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilledButton.icon(
                          onPressed: () =>
                              context.go(NosokSystemRoutes.citizenFollowup),
                          icon: const Icon(Icons.playlist_add_check_outlined),
                          label: const Text('إرسال إجراء متابعة'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  void _search() {
    final normalized = _trackingTokenController.text.trim().toUpperCase();
    if (normalized.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أدخل tracking token أولًا.')),
      );
      return;
    }
    setState(() => _submittedToken = normalized);
  }

  String _labelForStatus(String value) {
    switch (value) {
      case 'draft':
        return 'مسودة';
      case 'submitted':
        return 'مقدم';
      case 'under_review':
        return 'قيد المراجعة';
      case 'accepted':
        return 'مقبول';
      case 'rejected':
        return 'مرفوض';
      case 'waitlist':
        return 'احتياط';
      case 'closed':
        return 'مغلق';
      default:
        return value.isEmpty ? '-' : value;
    }
  }

  String _labelForEligibility(String? value) {
    switch (value) {
      case 'pending':
        return 'بانتظار الفحص';
      case 'eligible':
        return 'مستوفٍ';
      case 'ineligible':
        return 'غير مستوفٍ';
      case 'needs_review':
        return 'بحاجة مراجعة';
      case null:
      case '':
        return '-';
      default:
        return value;
    }
  }

  String _labelForPayment(String? value) {
    switch (value) {
      case 'pending':
        return 'بانتظار التحقق';
      case 'paid':
        return 'مدفوع';
      case 'failed':
        return 'فشل';
      case 'refunded':
        return 'مسترد';
      case 'cancelled':
        return 'ملغى';
      case null:
      case '':
        return '-';
      default:
        return value;
    }
  }

  String _formatDateTime(DateTime? value) {
    if (value == null) return '-';
    final y = value.year.toString().padLeft(4, '0');
    final m = value.month.toString().padLeft(2, '0');
    final d = value.day.toString().padLeft(2, '0');
    final hh = value.hour.toString().padLeft(2, '0');
    final mm = value.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $hh:$mm';
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Expanded(child: Text(value.isEmpty ? '-' : value)),
        ],
      ),
    );
  }
}
