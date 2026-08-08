import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_application_documents_controller.dart';
import '../../../application/nosok_application_lifecycle_controller.dart';
import '../../../application/nosok_application_payments_controller.dart';
import '../../../application/nosok_applications_controller.dart';
import '../../../application/services/nosok_file_upload_service.dart';
import '../../../data/repositories/nosok_supabase_repository.dart';
import '../../../domain/models/nosok_application.dart';
import '../../../domain/models/nosok_application_companion.dart';
import '../../../domain/models/nosok_application_document.dart';
import '../../../domain/models/nosok_application_payment.dart';
import '../../../domain/models/nosok_application_review.dart';
import '../../../domain/models/nosok_application_lifecycle_transition.dart';
import '../../../domain/models/nosok_storage_upload_result.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';
import 'nosok_admin_crud_helpers.dart';

class NosokAdminApplicationDetailsPage extends ConsumerWidget {
  const NosokAdminApplicationDetailsPage(
      {super.key, required this.applicationId});

  final String applicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationAsync =
        ref.watch(nosokApplicationDetailsProvider(applicationId));
    final companionsAsync =
        ref.watch(nosokApplicationCompanionsProvider(applicationId));
    final documentsAsync =
        ref.watch(nosokApplicationDocumentsProvider(applicationId));
    final paymentsAsync =
        ref.watch(nosokApplicationPaymentsProvider(applicationId));
    final reviewsAsync =
        ref.watch(nosokApplicationReviewsProvider(applicationId));

    return NosokPageScaffold(
      title: 'تفاصيل الطلب الإدارية',
      subtitle:
          'صفحة تشغيلية كاملة لإدارة حالة الطلب، الوثائق، الدفعات، والتحقق الإداري داخل نسك تحت المنصة.',
      children: [
        applicationAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => const Text(
              'تعذر تحميل الطلب حاليًا. راجع الصلاحية أو أعد المحاولة لاحقًا.'),
          data: (application) {
            if (application == null) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('الطلب غير موجود أو لم يعد متاحًا.'),
                ),
              );
            }

            return Column(
              children: [
                _ApplicationHeaderCard(application: application),
                const SizedBox(height: 16),
                _LifecycleEnforcementSection(application: application),
                const SizedBox(height: 16),
                companionsAsync.when(
                  loading: () => const _LoadingCard(title: 'المرافقون'),
                  error: (error, stack) => _ErrorCard(
                      title: 'المرافقون',
                      message: 'تعذر تحميل البيانات حاليًا.'),
                  data: (companions) =>
                      _CompanionsSection(companions: companions),
                ),
                const SizedBox(height: 16),
                documentsAsync.when(
                  loading: () => const _LoadingCard(title: 'الوثائق'),
                  error: (error, stack) => _ErrorCard(
                      title: 'الوثائق', message: 'تعذر تحميل البيانات حاليًا.'),
                  data: (documents) => _DocumentsSection(
                    application: application,
                    documents: documents,
                  ),
                ),
                const SizedBox(height: 16),
                paymentsAsync.when(
                  loading: () => const _LoadingCard(title: 'الدفعات'),
                  error: (error, stack) => _ErrorCard(
                      title: 'الدفعات', message: 'تعذر تحميل البيانات حاليًا.'),
                  data: (payments) => _PaymentsSection(
                    application: application,
                    payments: payments,
                  ),
                ),
                const SizedBox(height: 16),
                reviewsAsync.when(
                  loading: () => const _LoadingCard(title: 'سجل المراجعات'),
                  error: (error, stack) => _ErrorCard(
                      title: 'سجل المراجعات',
                      message: 'تعذر تحميل البيانات حاليًا.'),
                  data: (reviews) => _ReviewsSection(reviews: reviews),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ApplicationHeaderCard extends StatelessWidget {
  const _ApplicationHeaderCard({required this.application});

  final NosokApplication application;

  @override
  Widget build(BuildContext context) {
    return NosokSectionCard(
      title: 'الملف الرئيسي للطلب',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(application.applicantFullName,
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoPill(label: 'رقم الطلب', value: application.applicationNo),
              _InfoPill(
                  label: 'رمز التتبع', value: application.trackingToken ?? '-'),
              _InfoPill(label: 'نوع الخدمة', value: application.serviceType),
              _InfoPill(
                  label: 'حالة الطلب', value: application.applicationStatus),
              _InfoPill(
                  label: 'الأهلية',
                  value: application.eligibilityStatus ?? '-'),
              if (application.submittedAt != null)
                _InfoPill(
                    label: 'تاريخ التقديم',
                    value: _formatDateTime(application.submittedAt!)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _MetaLine(label: 'رقم الهوية', value: application.nationalId),
              _MetaLine(label: 'الهاتف', value: application.phone ?? '-'),
              _MetaLine(label: 'الجوال', value: application.mobile ?? '-'),
              _MetaLine(label: 'البريد', value: application.email ?? '-'),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (application.documentsCount != null)
                _StatBox(
                    label: 'الوثائق',
                    value: application.documentsCount.toString()),
              if (application.paymentsCount != null)
                _StatBox(
                    label: 'الدفعات',
                    value: application.paymentsCount.toString()),
              if (application.totalPaidAmount != null)
                _StatBox(
                    label: 'إجمالي المدفوع',
                    value: application.totalPaidAmount!.toStringAsFixed(2)),
              if (application.lastPaymentStatus != null)
                _StatBox(
                    label: 'آخر حالة دفع',
                    value: application.lastPaymentStatus!),
            ],
          ),
        ],
      ),
    );
  }
}

class _LifecycleEnforcementSection extends ConsumerWidget {
  const _LifecycleEnforcementSection({required this.application});

  final NosokApplication application;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rulesAsync =
        ref.watch(nosokLifecycleRulesProvider(application.applicationStatus));
    final transitionsAsync =
        ref.watch(nosokApplicationLifecycleTransitionsProvider(application.id));

    return NosokSectionCard(
      title: 'دورة حياة الطلب المحكومة',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الحالة الحالية: ${application.applicationStatus}. لا يتم نقل الطلب إلا عبر الانتقالات المسموحة في State Machine، مع تسجيل السبب والملاحظة.',
          ),
          const SizedBox(height: 12),
          rulesAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (error, stack) =>
                const Text('تعذر تحميل انتقالات الحالة حاليًا.'),
            data: (rules) {
              final enabledRules =
                  rules.where((rule) => rule.isEnabled).toList();
              if (enabledRules.isEmpty) {
                return const Text('لا توجد انتقالات متاحة من الحالة الحالية.');
              }
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: enabledRules.map((rule) {
                  return FilledButton.tonalIcon(
                    onPressed: () => _runLifecycleTransition(
                        context, ref, application, rule),
                    icon: const Icon(Icons.sync_alt_outlined),
                    label: Text(rule.titleAr.isEmpty
                        ? rule.transitionKey
                        : rule.titleAr),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 16),
          Text('سجل الانتقالات',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          transitionsAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (error, stack) =>
                const Text('تعذر تحميل سجل الانتقالات حاليًا.'),
            data: (transitions) {
              if (transitions.isEmpty) {
                return const Text('لا توجد انتقالات مسجلة بعد.');
              }
              return Column(
                children: transitions.take(6).map((transition) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(
                        transition.isAllowed
                            ? Icons.check_circle_outline
                            : Icons.block_outlined,
                      ),
                      title: Text(
                          '${transition.fromStatus} → ${transition.toStatus}'),
                      subtitle: Text([
                        transition.transitionKey,
                        if ((transition.reasonAr ?? '').isNotEmpty)
                          transition.reasonAr!,
                        if ((transition.noteAr ?? '').isNotEmpty)
                          transition.noteAr!,
                        if ((transition.blockerReasonAr ?? '').isNotEmpty)
                          transition.blockerReasonAr!,
                      ].join(' • ')),
                      trailing: transition.createdAt == null
                          ? null
                          : Text(_formatDateTime(transition.createdAt!)),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

Future<void> _runLifecycleTransition(
  BuildContext context,
  WidgetRef ref,
  NosokApplication application,
  NosokApplicationLifecycleRule rule,
) async {
  final note = await _askForNotes(
    context,
    title: rule.requiresReason
        ? 'سبب إجراء: ${rule.titleAr}'
        : 'ملاحظة إجراء: ${rule.titleAr}',
  );
  if (note == null) return;
  await ref
      .read(nosokApplicationLifecycleControllerProvider.notifier)
      .transition(
        applicationId: application.id,
        transitionKey: rule.transitionKey,
        reasonAr: rule.requiresReason ? note : null,
        noteAr: rule.requiresReason ? null : note,
      );
  ref.invalidate(nosokApplicationDetailsProvider(application.id));
  ref.invalidate(nosokApplicationLifecycleTransitionsProvider(application.id));
  ref.invalidate(nosokApplicationsControllerProvider);
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تنفيذ انتقال دورة الحياة.')));
  }
}

class _CompanionsSection extends StatelessWidget {
  const _CompanionsSection({required this.companions});

  final List<NosokApplicationCompanion> companions;

  @override
  Widget build(BuildContext context) {
    return NosokSectionCard(
      title: 'المرافقون',
      child: companions.isEmpty
          ? const Text('لا يوجد مرافقون لهذا الطلب.')
          : Column(
              children: companions.map((item) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(item.fullName),
                    subtitle: Text([
                      item.relationType ?? 'بدون صلة',
                      item.nationalId ?? 'بدون هوية',
                      item.phone ?? 'بدون هاتف',
                    ].join(' • ')),
                  ),
                );
              }).toList(),
            ),
    );
  }
}

class _DocumentsSection extends ConsumerWidget {
  const _DocumentsSection({required this.application, required this.documents});

  final NosokApplication application;
  final List<NosokApplicationDocument> documents;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NosokSectionCard(
      title: 'وثائق الطلب',
      actions: [
        FilledButton.icon(
          onPressed: () => _openDocumentDialog(context, ref, application, null),
          icon: const Icon(Icons.add),
          label: const Text('إضافة وثيقة'),
        ),
      ],
      child: documents.isEmpty
          ? const Text('لا توجد وثائق لهذا الطلب.')
          : Column(
              children: documents.map((item) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                  item.documentTitle ?? item.documentType,
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            ),
                            _StatusBadge(label: item.reviewStatus),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _InfoPill(
                                label: 'اسم الملف',
                                value: item.originalFileName ?? '-'),
                            _InfoPill(label: 'النوع', value: item.documentType),
                            if (item.mimeType != null)
                              _InfoPill(label: 'MIME', value: item.mimeType!),
                            if (item.fileSizeBytes != null)
                              _InfoPill(
                                  label: 'الحجم',
                                  value: '${item.fileSizeBytes} بايت'),
                          ],
                        ),
                        if ((item.fileUrl ?? '').isNotEmpty) ...[
                          const SizedBox(height: 8),
                          _CopyableLine(label: 'الرابط', value: item.fileUrl!),
                        ],
                        if ((item.storagePath ?? '').isNotEmpty) ...[
                          const SizedBox(height: 4),
                          _CopyableLine(
                              label: 'المسار', value: item.storagePath!),
                        ],
                        if ((item.reviewNotes ?? '').isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text('ملاحظات المراجعة: ${item.reviewNotes}'),
                        ],
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            TextButton.icon(
                              onPressed: () => _openDocumentDialog(
                                  context, ref, application, item),
                              icon: const Icon(Icons.edit_outlined),
                              label: const Text('تعديل'),
                            ),
                            TextButton(
                              onPressed: () => _reviewDocument(
                                  context, ref, application, item, 'approved'),
                              child: const Text('اعتماد الوثيقة'),
                            ),
                            TextButton(
                              onPressed: () => _reviewDocument(
                                  context, ref, application, item, 'rejected'),
                              child: const Text('رفض الوثيقة'),
                            ),
                            TextButton.icon(
                              onPressed: () async {
                                final confirmed = await showConfirmDialog(
                                    context, 'هل تريد حذف الوثيقة؟');
                                if (!confirmed) return;
                                await ref
                                    .read(nosokRepositoryProvider)
                                    .deleteApplicationDocument(item.id);
                                ref.invalidate(
                                    nosokApplicationDocumentsProvider(
                                        application.id));
                                ref.invalidate(nosokApplicationDetailsProvider(
                                    application.id));
                              },
                              icon: const Icon(Icons.delete_outline),
                              label: const Text('حذف'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}

class _PaymentsSection extends ConsumerWidget {
  const _PaymentsSection({required this.application, required this.payments});

  final NosokApplication application;
  final List<NosokApplicationPayment> payments;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = payments.fold<double>(0, (sum, item) => sum + item.amount);

    return NosokSectionCard(
      title: 'دفعات الطلب',
      actions: [
        FilledButton.icon(
          onPressed: () => _openPaymentDialog(context, ref, application, null),
          icon: const Icon(Icons.add),
          label: const Text('إضافة دفعة'),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'إجمالي الدفعات المسجلة: ${total.toStringAsFixed(2)} ${payments.isEmpty ? 'ILS' : payments.first.currencyCode}'),
          const SizedBox(height: 12),
          if (payments.isEmpty)
            const Text('لا توجد دفعات لهذا الطلب.')
          else
            Column(
              children: payments.map((item) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                  '${item.amount.toStringAsFixed(2)} ${item.currencyCode}',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            ),
                            _StatusBadge(label: item.verificationStatus),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _InfoPill(
                                label: 'نوع الدفعة', value: item.paymentType),
                            _InfoPill(
                                label: 'حالة الدفع', value: item.paymentStatus),
                            _InfoPill(
                                label: 'مرجع الدفع',
                                value: item.paymentReference ?? '-'),
                            _InfoPill(
                                label: 'طريقة الدفع',
                                value: item.paymentMethod ?? '-'),
                          ],
                        ),
                        if ((item.receiptUrl ?? '').isNotEmpty) ...[
                          const SizedBox(height: 8),
                          _CopyableLine(
                              label: 'رابط السند', value: item.receiptUrl!),
                        ],
                        if ((item.receiptStoragePath ?? '').isNotEmpty) ...[
                          const SizedBox(height: 4),
                          _CopyableLine(
                              label: 'مسار السند',
                              value: item.receiptStoragePath!),
                        ],
                        if ((item.verificationNotes ?? '').isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text('ملاحظات التحقق: ${item.verificationNotes}'),
                        ],
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            TextButton.icon(
                              onPressed: () => _openPaymentDialog(
                                  context, ref, application, item),
                              icon: const Icon(Icons.edit_outlined),
                              label: const Text('تعديل'),
                            ),
                            TextButton(
                              onPressed: () => _verifyPayment(
                                context,
                                ref,
                                application,
                                item,
                                verificationStatus: 'under_review',
                                paymentStatus: 'pending',
                              ),
                              child: const Text('قيد المراجعة'),
                            ),
                            TextButton(
                              onPressed: () => _verifyPayment(
                                context,
                                ref,
                                application,
                                item,
                                verificationStatus: 'verified',
                                paymentStatus: 'paid',
                              ),
                              child: const Text('اعتماد الدفعة'),
                            ),
                            TextButton(
                              onPressed: () => _verifyPayment(
                                context,
                                ref,
                                application,
                                item,
                                verificationStatus: 'rejected',
                                paymentStatus: 'failed',
                              ),
                              child: const Text('رفض الدفعة'),
                            ),
                            TextButton.icon(
                              onPressed: () async {
                                final confirmed = await showConfirmDialog(
                                    context, 'هل تريد حذف الدفعة؟');
                                if (!confirmed) return;
                                await ref
                                    .read(nosokRepositoryProvider)
                                    .deleteApplicationPayment(item.id);
                                ref.invalidate(nosokApplicationPaymentsProvider(
                                    application.id));
                                ref.invalidate(nosokApplicationDetailsProvider(
                                    application.id));
                              },
                              icon: const Icon(Icons.delete_outline),
                              label: const Text('حذف'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _ReviewsSection extends StatelessWidget {
  const _ReviewsSection({required this.reviews});

  final List<NosokApplicationReview> reviews;

  @override
  Widget build(BuildContext context) {
    return NosokSectionCard(
      title: 'سجل المراجعات',
      child: reviews.isEmpty
          ? const Text('لا يوجد سجل مراجعات حتى الآن.')
          : Column(
              children: reviews.map((item) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(item.reviewAction),
                    subtitle: Text([
                      item.reviewReason ?? 'بدون ملاحظات',
                      if (item.createdAt != null)
                        _formatDateTime(item.createdAt!),
                    ].join(' • ')),
                  ),
                );
              }).toList(),
            ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return NosokSectionCard(
      title: title,
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return NosokSectionCard(
      title: title,
      child: Text(message),
    );
  }
}

Future<void> _reviewDocument(
  BuildContext context,
  WidgetRef ref,
  NosokApplication application,
  NosokApplicationDocument document,
  String reviewStatus,
) async {
  final notes = await _askForNotes(context,
      title: reviewStatus == 'approved'
          ? 'ملاحظات اعتماد الوثيقة'
          : 'سبب رفض الوثيقة');
  if (notes == null) return;
  await ref.read(nosokRepositoryProvider).saveApplicationDocument(
        document.copyWith(
          reviewStatus: reviewStatus,
          reviewNotes: notes,
          applicationId: application.id,
        ),
      );
  ref.invalidate(nosokApplicationDocumentsProvider(application.id));
  ref.invalidate(nosokApplicationReviewsProvider(application.id));
}

Future<void> _verifyPayment(
  BuildContext context,
  WidgetRef ref,
  NosokApplication application,
  NosokApplicationPayment payment, {
  required String verificationStatus,
  required String paymentStatus,
}) async {
  final prompt = verificationStatus == 'verified'
      ? 'ملاحظات اعتماد الدفعة'
      : verificationStatus == 'rejected'
          ? 'سبب رفض الدفعة'
          : 'ملاحظات المراجعة';
  final notes = await _askForNotes(context, title: prompt);
  if (notes == null) return;
  await ref.read(nosokRepositoryProvider).verifyApplicationPayment(
        paymentId: payment.id,
        applicationId: application.id,
        verificationStatus: verificationStatus,
        paymentStatus: paymentStatus,
        verificationNotes: notes,
      );
  ref.invalidate(nosokApplicationPaymentsProvider(application.id));
  ref.invalidate(nosokApplicationDetailsProvider(application.id));
  ref.invalidate(nosokApplicationReviewsProvider(application.id));
}

Future<String?> _askForNotes(BuildContext context,
    {required String title}) async {
  final controller = TextEditingController();
  final result = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        minLines: 2,
        maxLines: 4,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), hintText: 'اكتب الملاحظات هنا'),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('إلغاء')),
        FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('حفظ')),
      ],
    ),
  );
  controller.dispose();
  return result;
}

Future<void> _openDocumentDialog(
  BuildContext context,
  WidgetRef ref,
  NosokApplication application,
  NosokApplicationDocument? document,
) async {
  final result = await showDialog<NosokApplicationDocument>(
    context: context,
    builder: (context) =>
        _DocumentDialog(applicationId: application.id, document: document),
  );
  if (result == null) return;
  await ref.read(nosokRepositoryProvider).saveApplicationDocument(result);
  ref.invalidate(nosokApplicationDocumentsProvider(application.id));
  ref.invalidate(nosokApplicationDetailsProvider(application.id));
}

Future<void> _openPaymentDialog(
  BuildContext context,
  WidgetRef ref,
  NosokApplication application,
  NosokApplicationPayment? payment,
) async {
  final result = await showDialog<NosokApplicationPayment>(
    context: context,
    builder: (context) =>
        _PaymentDialog(applicationId: application.id, payment: payment),
  );
  if (result == null) return;
  await ref.read(nosokRepositoryProvider).saveApplicationPayment(result);
  ref.invalidate(nosokApplicationPaymentsProvider(application.id));
  ref.invalidate(nosokApplicationDetailsProvider(application.id));
}

class _DocumentDialog extends ConsumerStatefulWidget {
  const _DocumentDialog({required this.applicationId, this.document});

  final String applicationId;
  final NosokApplicationDocument? document;

  @override
  ConsumerState<_DocumentDialog> createState() => _DocumentDialogState();
}

class _DocumentDialogState extends ConsumerState<_DocumentDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _originalNameController;
  late final TextEditingController _fileUrlController;
  late final TextEditingController _bucketController;
  late final TextEditingController _pathController;
  late final TextEditingController _mimeController;
  late final TextEditingController _notesController;
  late final TextEditingController _reviewNotesController;
  late String _documentType;
  late String _reviewStatus;
  int? _fileSizeBytes;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    final document = widget.document ??
        NosokApplicationDocument.empty(applicationId: widget.applicationId);
    _titleController =
        TextEditingController(text: document.documentTitle ?? '');
    _originalNameController =
        TextEditingController(text: document.originalFileName ?? '');
    _fileUrlController = TextEditingController(text: document.fileUrl ?? '');
    _bucketController =
        TextEditingController(text: document.storageBucket ?? '');
    _pathController = TextEditingController(text: document.storagePath ?? '');
    _mimeController = TextEditingController(text: document.mimeType ?? '');
    _notesController = TextEditingController(text: document.notes ?? '');
    _reviewNotesController =
        TextEditingController(text: document.reviewNotes ?? '');
    _documentType = document.documentType;
    _reviewStatus = document.reviewStatus;
    _fileSizeBytes = document.fileSizeBytes;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _originalNameController.dispose();
    _fileUrlController.dispose();
    _bucketController.dispose();
    _pathController.dispose();
    _mimeController.dispose();
    _notesController.dispose();
    _reviewNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.document == null ? 'إضافة وثيقة' : 'تعديل وثيقة'),
      content: SizedBox(
        width: 720,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 300,
                  child: DropdownButtonFormField<String>(
                    initialValue: _documentType,
                    decoration: const InputDecoration(
                        labelText: 'نوع الوثيقة', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'identity', child: Text('هوية')),
                      DropdownMenuItem(
                          value: 'passport', child: Text('جواز سفر')),
                      DropdownMenuItem(
                          value: 'photo', child: Text('صورة شخصية')),
                      DropdownMenuItem(
                          value: 'payment_receipt', child: Text('سند دفع')),
                      DropdownMenuItem(
                          value: 'medical', child: Text('وثيقة طبية')),
                      DropdownMenuItem(value: 'other', child: Text('أخرى')),
                    ],
                    onChanged: (value) =>
                        setState(() => _documentType = value ?? 'identity'),
                  ),
                ),
                _dialogField(_titleController, 'عنوان الوثيقة'),
                _dialogField(_originalNameController, 'اسم الملف الأصلي'),
                _dialogField(_bucketController, 'Bucket', readOnly: true),
                _dialogField(_pathController, 'مسار التخزين', readOnly: true),
                _dialogField(_fileUrlController, 'رابط الوثيقة',
                    readOnly: true),
                _dialogField(_mimeController, 'نوع الملف MIME', readOnly: true),
                SizedBox(
                  width: 300,
                  child: DropdownButtonFormField<String>(
                    initialValue: _reviewStatus,
                    decoration: const InputDecoration(
                        labelText: 'حالة المراجعة',
                        border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(
                          value: 'pending', child: Text('بانتظار المراجعة')),
                      DropdownMenuItem(
                          value: 'approved', child: Text('معتمدة')),
                      DropdownMenuItem(
                          value: 'rejected', child: Text('مرفوضة')),
                    ],
                    onChanged: (value) =>
                        setState(() => _reviewStatus = value ?? 'pending'),
                  ),
                ),
                SizedBox(
                  width: 612,
                  child: TextFormField(
                    controller: _reviewNotesController,
                    minLines: 2,
                    maxLines: 3,
                    decoration: const InputDecoration(
                        labelText: 'ملاحظات المراجعة',
                        border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  width: 612,
                  child: TextFormField(
                    controller: _notesController,
                    minLines: 2,
                    maxLines: 3,
                    decoration: const InputDecoration(
                        labelText: 'ملاحظات عامة',
                        border: OutlineInputBorder()),
                  ),
                ),
                _UploadCard(
                  title: 'رفع الملف من الجهاز',
                  subtitle: _fileSizeBytes == null
                      ? 'لم يتم رفع ملف بعد.'
                      : 'الحجم الحالي: $_fileSizeBytes بايت',
                  uploading: _uploading,
                  onPick: _pickAndUpload,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء')),
        FilledButton(
          onPressed: () {
            if (!(_formKey.currentState?.validate() ?? false)) return;
            if (_emptyToNull(_fileUrlController.text) == null &&
                _emptyToNull(_pathController.text) == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text('ارفع ملفًا أو وفّر رابط/مسار تخزين على الأقل.')),
              );
              return;
            }
            Navigator.of(context).pop(
              NosokApplicationDocument(
                id: widget.document?.id ?? '',
                applicationId: widget.applicationId,
                documentType: _documentType,
                reviewStatus: _reviewStatus,
                documentTitle: _emptyToNull(_titleController.text),
                originalFileName: _emptyToNull(_originalNameController.text),
                fileUrl: _emptyToNull(_fileUrlController.text),
                storageBucket: _emptyToNull(_bucketController.text),
                storagePath: _emptyToNull(_pathController.text),
                mimeType: _emptyToNull(_mimeController.text),
                fileSizeBytes: _fileSizeBytes,
                reviewNotes: _emptyToNull(_reviewNotesController.text),
                notes: _emptyToNull(_notesController.text),
              ),
            );
          },
          child: const Text('حفظ'),
        ),
      ],
    );
  }

  Future<void> _pickAndUpload() async {
    setState(() => _uploading = true);
    try {
      final result =
          await ref.read(nosokFileUploadServiceProvider).pickAndUpload(
        folder: 'applications/${widget.applicationId}/documents',
        allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png', 'webp'],
      );
      if (result == null || !mounted) return;
      _applyUpload(result);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
              'تعذر رفع الملف حاليًا. تحقق من الملف وحاول مرة أخرى.')));
    } finally {
      if (mounted) {
        setState(() => _uploading = false);
      }
    }
  }

  void _applyUpload(NosokStorageUploadResult result) {
    setState(() {
      _originalNameController.text = result.originalFileName;
      _bucketController.text = result.bucket;
      _pathController.text = result.path;
      _fileUrlController.text = result.publicUrl;
      _mimeController.text = result.mimeType ?? '';
      _fileSizeBytes = result.fileSizeBytes;
      if (_titleController.text.trim().isEmpty) {
        _titleController.text = result.originalFileName;
      }
    });
  }
}

class _PaymentDialog extends ConsumerStatefulWidget {
  const _PaymentDialog({required this.applicationId, this.payment});

  final String applicationId;
  final NosokApplicationPayment? payment;

  @override
  ConsumerState<_PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends ConsumerState<_PaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _referenceController;
  late final TextEditingController _methodController;
  late final TextEditingController _providerController;
  late final TextEditingController _transactionIdController;
  late final TextEditingController _receiptUrlController;
  late final TextEditingController _receiptBucketController;
  late final TextEditingController _receiptPathController;
  late final TextEditingController _receiptFileNameController;
  late final TextEditingController _receiptMimeController;
  late final TextEditingController _notesController;
  late final TextEditingController _verificationNotesController;
  late String _paymentType;
  late String _currencyCode;
  late String _paymentStatus;
  late String _verificationStatus;
  int? _receiptFileSizeBytes;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    final payment = widget.payment ??
        NosokApplicationPayment.empty(applicationId: widget.applicationId);
    _amountController =
        TextEditingController(text: payment.amount.toStringAsFixed(2));
    _referenceController =
        TextEditingController(text: payment.paymentReference ?? '');
    _methodController =
        TextEditingController(text: payment.paymentMethod ?? '');
    _providerController =
        TextEditingController(text: payment.providerName ?? '');
    _transactionIdController =
        TextEditingController(text: payment.externalTransactionId ?? '');
    _receiptUrlController =
        TextEditingController(text: payment.receiptUrl ?? '');
    _receiptBucketController =
        TextEditingController(text: payment.receiptStorageBucket ?? '');
    _receiptPathController =
        TextEditingController(text: payment.receiptStoragePath ?? '');
    _receiptFileNameController =
        TextEditingController(text: payment.receiptOriginalFileName ?? '');
    _receiptMimeController =
        TextEditingController(text: payment.receiptMimeType ?? '');
    _notesController = TextEditingController(text: payment.notes ?? '');
    _verificationNotesController =
        TextEditingController(text: payment.verificationNotes ?? '');
    _paymentType = payment.paymentType;
    _currencyCode = payment.currencyCode;
    _paymentStatus = payment.paymentStatus;
    _verificationStatus = payment.verificationStatus;
    _receiptFileSizeBytes = payment.receiptFileSizeBytes;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    _methodController.dispose();
    _providerController.dispose();
    _transactionIdController.dispose();
    _receiptUrlController.dispose();
    _receiptBucketController.dispose();
    _receiptPathController.dispose();
    _receiptFileNameController.dispose();
    _receiptMimeController.dispose();
    _notesController.dispose();
    _verificationNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.payment == null ? 'إضافة دفعة' : 'تعديل دفعة'),
      content: SizedBox(
        width: 760,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 300,
                  child: DropdownButtonFormField<String>(
                    initialValue: _paymentType,
                    decoration: const InputDecoration(
                        labelText: 'نوع الدفعة', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(
                          value: 'registration_fee', child: Text('رسوم تسجيل')),
                      DropdownMenuItem(
                          value: 'deposit', child: Text('دفعة أولى')),
                      DropdownMenuItem(
                          value: 'full_payment', child: Text('سداد كامل')),
                      DropdownMenuItem(value: 'other', child: Text('أخرى')),
                    ],
                    onChanged: (value) => setState(
                        () => _paymentType = value ?? 'registration_fee'),
                  ),
                ),
                _dialogField(_amountController, 'المبلغ',
                    validator: requiredText,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true)),
                SizedBox(
                  width: 300,
                  child: DropdownButtonFormField<String>(
                    initialValue: _currencyCode,
                    decoration: const InputDecoration(
                        labelText: 'العملة', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'ILS', child: Text('ILS')),
                      DropdownMenuItem(value: 'JOD', child: Text('JOD')),
                      DropdownMenuItem(value: 'USD', child: Text('USD')),
                    ],
                    onChanged: (value) =>
                        setState(() => _currencyCode = value ?? 'ILS'),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: DropdownButtonFormField<String>(
                    initialValue: _paymentStatus,
                    decoration: const InputDecoration(
                        labelText: 'حالة الدفع', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(
                          value: 'pending', child: Text('بانتظار التحقق')),
                      DropdownMenuItem(value: 'paid', child: Text('مدفوع')),
                      DropdownMenuItem(value: 'failed', child: Text('فشل')),
                      DropdownMenuItem(value: 'refunded', child: Text('مسترد')),
                      DropdownMenuItem(value: 'cancelled', child: Text('ملغى')),
                    ],
                    onChanged: (value) =>
                        setState(() => _paymentStatus = value ?? 'pending'),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: DropdownButtonFormField<String>(
                    initialValue: _verificationStatus,
                    decoration: const InputDecoration(
                        labelText: 'حالة التحقق', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(
                          value: 'pending', child: Text('بانتظار التحقق')),
                      DropdownMenuItem(
                          value: 'under_review', child: Text('قيد المراجعة')),
                      DropdownMenuItem(
                          value: 'verified', child: Text('متحقق منها')),
                      DropdownMenuItem(
                          value: 'rejected', child: Text('مرفوضة')),
                      DropdownMenuItem(
                          value: 'needs_receipt', child: Text('يلزم سند')),
                    ],
                    onChanged: (value) => setState(
                        () => _verificationStatus = value ?? 'pending'),
                  ),
                ),
                _dialogField(_referenceController, 'مرجع الدفع'),
                _dialogField(_methodController, 'طريقة الدفع'),
                _dialogField(_providerController, 'مزود الدفع'),
                _dialogField(
                    _transactionIdController, 'المعرف الخارجي للمعاملة'),
                _dialogField(_receiptFileNameController, 'اسم سند الدفع',
                    readOnly: true),
                _dialogField(_receiptBucketController, 'Bucket السند',
                    readOnly: true),
                _dialogField(_receiptPathController, 'مسار سند الدفع',
                    readOnly: true),
                _dialogField(_receiptUrlController, 'رابط سند الدفع',
                    readOnly: true),
                _dialogField(_receiptMimeController, 'MIME السند',
                    readOnly: true),
                SizedBox(
                  width: 612,
                  child: TextFormField(
                    controller: _verificationNotesController,
                    minLines: 2,
                    maxLines: 3,
                    decoration: const InputDecoration(
                        labelText: 'ملاحظات التحقق',
                        border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  width: 612,
                  child: TextFormField(
                    controller: _notesController,
                    minLines: 2,
                    maxLines: 3,
                    decoration: const InputDecoration(
                        labelText: 'ملاحظات عامة',
                        border: OutlineInputBorder()),
                  ),
                ),
                _UploadCard(
                  title: 'رفع سند الدفع من الجهاز',
                  subtitle: _receiptFileSizeBytes == null
                      ? 'لم يتم رفع سند بعد.'
                      : 'الحجم الحالي: $_receiptFileSizeBytes بايت',
                  uploading: _uploading,
                  onPick: _pickAndUploadReceipt,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء')),
        FilledButton(
          onPressed: () {
            if (!(_formKey.currentState?.validate() ?? false)) return;
            final amount = double.tryParse(_amountController.text.trim());
            if (amount == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('أدخل مبلغًا صحيحًا.')));
              return;
            }
            Navigator.of(context).pop(
              NosokApplicationPayment(
                id: widget.payment?.id ?? '',
                applicationId: widget.applicationId,
                paymentType: _paymentType,
                amount: amount,
                currencyCode: _currencyCode,
                paymentStatus: _paymentStatus,
                verificationStatus: _verificationStatus,
                paymentReference: _emptyToNull(_referenceController.text),
                paymentMethod: _emptyToNull(_methodController.text),
                providerName: _emptyToNull(_providerController.text),
                externalTransactionId:
                    _emptyToNull(_transactionIdController.text),
                receiptUrl: _emptyToNull(_receiptUrlController.text),
                receiptStorageBucket:
                    _emptyToNull(_receiptBucketController.text),
                receiptStoragePath: _emptyToNull(_receiptPathController.text),
                receiptOriginalFileName:
                    _emptyToNull(_receiptFileNameController.text),
                receiptMimeType: _emptyToNull(_receiptMimeController.text),
                receiptFileSizeBytes: _receiptFileSizeBytes,
                verificationNotes:
                    _emptyToNull(_verificationNotesController.text),
                notes: _emptyToNull(_notesController.text),
                paidAt: _paymentStatus == 'paid'
                    ? DateTime.now()
                    : widget.payment?.paidAt,
                verifiedAt: _verificationStatus == 'verified'
                    ? DateTime.now()
                    : widget.payment?.verifiedAt,
              ),
            );
          },
          child: const Text('حفظ'),
        ),
      ],
    );
  }

  Future<void> _pickAndUploadReceipt() async {
    setState(() => _uploading = true);
    try {
      final result =
          await ref.read(nosokFileUploadServiceProvider).pickAndUpload(
        folder: 'applications/${widget.applicationId}/payments',
        allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png', 'webp'],
      );
      if (result == null || !mounted) return;
      setState(() {
        _receiptFileNameController.text = result.originalFileName;
        _receiptBucketController.text = result.bucket;
        _receiptPathController.text = result.path;
        _receiptUrlController.text = result.publicUrl;
        _receiptMimeController.text = result.mimeType ?? '';
        _receiptFileSizeBytes = result.fileSizeBytes;
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
              'تعذر رفع سند الدفع حاليًا. تحقق من الملف وحاول مرة أخرى.')));
    } finally {
      if (mounted) {
        setState(() => _uploading = false);
      }
    }
  }
}

class _UploadCard extends StatelessWidget {
  const _UploadCard({
    required this.title,
    required this.subtitle,
    required this.uploading,
    required this.onPick,
  });

  final String title;
  final String subtitle;
  final bool uploading;
  final Future<void> Function() onPick;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 680,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Icon(Icons.upload_file_outlined),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(subtitle),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: uploading ? null : onPick,
                icon: uploading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.attach_file),
                label: Text(uploading ? 'جارٍ الرفع...' : 'اختيار ورفع'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black12),
      ),
      child: Text('$label: $value'),
    );
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(value),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.black.withValues(alpha: 0.04),
      ),
      child: Text(label),
    );
  }
}

class _CopyableLine extends StatelessWidget {
  const _CopyableLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: SelectableText('$label: $value')),
        IconButton(
          tooltip: 'نسخ',
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: value));
            if (context.mounted) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('تم النسخ.')));
            }
          },
          icon: const Icon(Icons.copy_outlined),
        ),
      ],
    );
  }
}

Widget _dialogField(
  TextEditingController controller,
  String label, {
  bool readOnly = false,
  String? Function(String?)? validator,
  TextInputType? keyboardType,
}) {
  return SizedBox(
    width: 300,
    child: TextFormField(
      controller: controller,
      readOnly: readOnly,
      validator: validator,
      keyboardType: keyboardType,
      decoration:
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
    ),
  );
}

String? _emptyToNull(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

String _formatDateTime(DateTime value) {
  return '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')} ${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
}
