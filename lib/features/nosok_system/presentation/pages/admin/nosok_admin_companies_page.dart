import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_companies_controller.dart';
import '../../../application/nosok_company_qualifications_controller.dart';
import '../../../application/nosok_seasons_controller.dart';
import '../../../data/repositories/nosok_supabase_repository.dart';
import '../../../domain/models/nosok_company.dart';
import '../../../domain/models/nosok_company_season_qualification.dart';
import '../../../domain/models/nosok_season.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';
import 'nosok_admin_crud_helpers.dart';

class NosokAdminCompaniesPage extends ConsumerStatefulWidget {
  const NosokAdminCompaniesPage({super.key});

  @override
  ConsumerState<NosokAdminCompaniesPage> createState() =>
      _NosokAdminCompaniesPageState();
}

class _NosokAdminCompaniesPageState
    extends ConsumerState<NosokAdminCompaniesPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final companiesAsync = ref.watch(nosokCompaniesControllerProvider);

    return NosokPageScaffold(
      title: 'إدارة الشركات المؤهلة',
      subtitle:
          'CRUD فعلي للشركات مع تأهيل موسمي مستقل لكل شركة داخل نسك تحت المنصة.',
      actions: [
        SizedBox(
          width: 260,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'بحث في الشركات',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                onPressed: () {
                  _searchController.clear();
                  ref
                      .read(nosokCompaniesControllerProvider.notifier)
                      .refreshList(query: '');
                },
                icon: const Icon(Icons.clear),
              ),
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (value) => ref
                .read(nosokCompaniesControllerProvider.notifier)
                .refreshList(query: value),
          ),
        ),
        FilledButton.icon(
          onPressed: () => _openCompanyDialog(context, ref),
          icon: const Icon(Icons.add),
          label: const Text('إضافة شركة'),
        ),
      ],
      children: [
        NosokSectionCard(
          title: 'الشركات الحالية',
          child: companiesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) =>
                const Text('تعذر تحميل الشركات حاليًا. أعد المحاولة لاحقًا.'),
            data: (companies) {
              if (companies.isEmpty) {
                return const Text('لا توجد شركات حتى الآن.');
              }
              return Column(
                children: companies.map((company) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(company.companyNameAr),
                      subtitle: Text(
                        [
                          company.licenseNo ?? 'بدون رخصة',
                          company.mobile ?? company.phone ?? 'بدون هاتف',
                          company.status,
                        ].join(' • '),
                      ),
                      trailing: Wrap(
                        spacing: 4,
                        children: [
                          IconButton(
                            tooltip: 'التأهيلات الموسمية',
                            icon: const Icon(Icons.event_available_outlined),
                            onPressed: () =>
                                _openQualificationsSheet(context, ref, company),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => _openCompanyDialog(context, ref,
                                company: company),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => confirmCrudDelete(
                              context,
                              () => ref
                                  .read(
                                      nosokCompaniesControllerProvider.notifier)
                                  .deleteCompany(company.id),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}

Future<void> _openCompanyDialog(
  BuildContext context,
  WidgetRef ref, {
  NosokCompany? company,
}) async {
  final result = await showDialog<NosokCompany>(
    context: context,
    builder: (context) => _CompanyDialog(company: company),
  );
  if (result == null) return;
  try {
    await ref
        .read(nosokCompaniesControllerProvider.notifier)
        .saveCompany(result);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                company == null ? 'تم إنشاء الشركة.' : 'تم تحديث الشركة.')),
      );
    }
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: const Text(
                'تعذر حفظ الشركة حاليًا. راجع البيانات والصلاحية ثم حاول مجددًا.')),
      );
    }
  }
}

Future<void> _openQualificationsSheet(
  BuildContext context,
  WidgetRef ref,
  NosokCompany company,
) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return ProviderScope(
        parent: ProviderScope.containerOf(context),
        child: _CompanyQualificationsSheet(company: company),
      );
    },
  );
}

class _CompanyQualificationsSheet extends ConsumerWidget {
  const _CompanyQualificationsSheet({required this.company});

  final NosokCompany company;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seasonsAsync = ref.watch(nosokSeasonsControllerProvider);
    final qualificationsAsync = ref.watch(
      nosokCompanyQualificationsProvider(
        NosokCompanyQualificationFilter(companyId: company.id),
      ),
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('تأهيلات ${company.companyNameAr}',
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                  FilledButton.icon(
                    onPressed: seasonsAsync.hasValue
                        ? () => _openQualificationDialog(context, ref, company,
                            seasonsAsync.value ?? const <NosokSeason>[], null)
                        : null,
                    icon: const Icon(Icons.add),
                    label: const Text('إضافة تأهيل'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 420,
                child: qualificationsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) =>
                      const Text('تعذر تحميل التأهيلات حاليًا.'),
                  data: (items) {
                    if (items.isEmpty) {
                      return const Center(
                          child: Text(
                              'لا توجد تأهيلات موسمية لهذه الشركة حتى الآن.'));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Card(
                          child: ListTile(
                            title: Text(item.seasonTitleAr ?? item.seasonId),
                            subtitle: Text([
                              item.qualificationStatus,
                              item.isPubliclyVisible ? 'منشور' : 'غير منشور',
                              _formatRange(item.startsAt, item.endsAt),
                            ].join(' • ')),
                            trailing: Wrap(
                              spacing: 4,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined),
                                  onPressed: seasonsAsync.hasValue
                                      ? () => _openQualificationDialog(
                                          context,
                                          ref,
                                          company,
                                          seasonsAsync.value ??
                                              const <NosokSeason>[],
                                          item)
                                      : null,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () async {
                                    final confirmed = await showConfirmDialog(
                                        context,
                                        'هل تريد حذف التأهيل الموسمي؟');
                                    if (!confirmed) return;
                                    await ref
                                        .read(nosokRepositoryProvider)
                                        .deleteCompanyQualification(item.id);
                                    ref.invalidate(
                                        nosokCompanyQualificationsProvider(
                                            NosokCompanyQualificationFilter(
                                                companyId: company.id)));
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _openQualificationDialog(
  BuildContext context,
  WidgetRef ref,
  NosokCompany company,
  List<NosokSeason> seasons,
  NosokCompanySeasonQualification? qualification,
) async {
  final result = await showDialog<NosokCompanySeasonQualification>(
    context: context,
    builder: (context) => _QualificationDialog(
      company: company,
      seasons: seasons,
      qualification: qualification,
    ),
  );
  if (result == null) return;
  await ref.read(nosokRepositoryProvider).saveCompanyQualification(result);
  ref.invalidate(nosokCompanyQualificationsProvider(
      NosokCompanyQualificationFilter(companyId: company.id)));
}

class _CompanyDialog extends StatefulWidget {
  const _CompanyDialog({this.company});

  final NosokCompany? company;

  @override
  State<_CompanyDialog> createState() => _CompanyDialogState();
}

class _CompanyDialogState extends State<_CompanyDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameArController;
  late final TextEditingController _nameEnController;
  late final TextEditingController _licenseController;
  late final TextEditingController _phoneController;
  late final TextEditingController _mobileController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _notesController;
  late String _status;
  late bool _isVisible;

  @override
  void initState() {
    super.initState();
    final company = widget.company ?? NosokCompany.empty();
    _nameArController = TextEditingController(text: company.companyNameAr);
    _nameEnController =
        TextEditingController(text: company.companyNameEn ?? '');
    _licenseController = TextEditingController(text: company.licenseNo ?? '');
    _phoneController = TextEditingController(text: company.phone ?? '');
    _mobileController = TextEditingController(text: company.mobile ?? '');
    _emailController = TextEditingController(text: company.email ?? '');
    _addressController = TextEditingController(text: company.addressText ?? '');
    _notesController = TextEditingController(text: company.notes ?? '');
    _status = company.status;
    _isVisible = company.isPubliclyVisible;
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _licenseController.dispose();
    _phoneController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Widget _companyField(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return SizedBox(
      width: 300,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.company == null ? 'إضافة شركة' : 'تعديل شركة'),
      content: SizedBox(
        width: 640,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _companyField(_nameArController, 'اسم الشركة بالعربية',
                    validator: requiredText),
                _companyField(_nameEnController, 'اسم الشركة بالإنجليزية'),
                _companyField(_licenseController, 'رقم الرخصة'),
                _companyField(_phoneController, 'الهاتف',
                    keyboardType: TextInputType.phone),
                _companyField(_mobileController, 'الجوال',
                    keyboardType: TextInputType.phone),
                _companyField(_emailController, 'البريد الإلكتروني',
                    keyboardType: TextInputType.emailAddress),
                SizedBox(
                  width: 300,
                  child: DropdownButtonFormField<String>(
                    initialValue: _status,
                    decoration: const InputDecoration(
                        labelText: 'الحالة', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'draft', child: Text('مسودة')),
                      DropdownMenuItem(
                          value: 'qualified', child: Text('مؤهلة')),
                      DropdownMenuItem(
                          value: 'suspended', child: Text('موقوفة')),
                      DropdownMenuItem(
                          value: 'inactive', child: Text('غير نشطة')),
                    ],
                    onChanged: (value) =>
                        setState(() => _status = value ?? 'draft'),
                  ),
                ),
                SizedBox(
                  width: 612,
                  child: TextFormField(
                    controller: _addressController,
                    minLines: 2,
                    maxLines: 3,
                    decoration: const InputDecoration(
                        labelText: 'العنوان', border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  width: 612,
                  child: TextFormField(
                    controller: _notesController,
                    minLines: 2,
                    maxLines: 3,
                    decoration: const InputDecoration(
                        labelText: 'ملاحظات', border: OutlineInputBorder()),
                  ),
                ),
                SwitchListTile(
                  value: _isVisible,
                  onChanged: (value) => setState(() => _isVisible = value),
                  title: const Text('منشورة للجمهور'),
                  contentPadding: EdgeInsets.zero,
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
            Navigator.of(context).pop(
              NosokCompany(
                id: widget.company?.id ?? '',
                companyNameAr: _nameArController.text.trim(),
                companyNameEn: _emptyToNull(_nameEnController.text),
                licenseNo: _emptyToNull(_licenseController.text),
                phone: _emptyToNull(_phoneController.text),
                mobile: _emptyToNull(_mobileController.text),
                email: _emptyToNull(_emailController.text),
                addressText: _emptyToNull(_addressController.text),
                status: _status,
                isPubliclyVisible: _isVisible,
                notes: _emptyToNull(_notesController.text),
              ),
            );
          },
          child: const Text('حفظ'),
        ),
      ],
    );
  }
}

class _QualificationDialog extends StatefulWidget {
  const _QualificationDialog({
    required this.company,
    required this.seasons,
    this.qualification,
  });

  final NosokCompany company;
  final List<NosokSeason> seasons;
  final NosokCompanySeasonQualification? qualification;

  @override
  State<_QualificationDialog> createState() => _QualificationDialogState();
}

class _QualificationDialogState extends State<_QualificationDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _notesController;
  late String _seasonId;
  late String _status;
  late bool _isVisible;

  @override
  void initState() {
    super.initState();
    final item = widget.qualification ??
        NosokCompanySeasonQualification.empty(companyId: widget.company.id);
    _notesController =
        TextEditingController(text: item.qualificationNotes ?? '');
    _seasonId =
        item.seasonId.isNotEmpty ? item.seasonId : widget.seasons.first.id;
    _status = item.qualificationStatus;
    _isVisible = item.isPubliclyVisible;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.qualification == null
          ? 'إضافة تأهيل موسمي'
          : 'تعديل تأهيل موسمي'),
      content: SizedBox(
        width: 640,
        child: Form(
          key: _formKey,
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 300,
                child: DropdownButtonFormField<String>(
                  initialValue: _seasonId,
                  decoration: const InputDecoration(
                      labelText: 'الموسم', border: OutlineInputBorder()),
                  items: widget.seasons
                      .map((season) => DropdownMenuItem(
                          value: season.id, child: Text(season.titleAr)))
                      .toList(),
                  onChanged: (value) => setState(
                      () => _seasonId = value ?? widget.seasons.first.id),
                ),
              ),
              SizedBox(
                width: 300,
                child: DropdownButtonFormField<String>(
                  initialValue: _status,
                  decoration: const InputDecoration(
                      labelText: 'حالة التأهيل', border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'draft', child: Text('مسودة')),
                    DropdownMenuItem(value: 'qualified', child: Text('مؤهلة')),
                    DropdownMenuItem(value: 'suspended', child: Text('موقوفة')),
                    DropdownMenuItem(value: 'withdrawn', child: Text('مسحوبة')),
                  ],
                  onChanged: (value) =>
                      setState(() => _status = value ?? 'draft'),
                ),
              ),
              SizedBox(
                width: 612,
                child: TextFormField(
                  controller: _notesController,
                  minLines: 2,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      labelText: 'ملاحظات التأهيل',
                      border: OutlineInputBorder()),
                ),
              ),
              SwitchListTile(
                value: _isVisible,
                onChanged: (value) => setState(() => _isVisible = value),
                title: const Text('منشور للجمهور عند الفلترة بالموسم'),
                contentPadding: EdgeInsets.zero,
              ),
            ],
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
            Navigator.of(context).pop(
              NosokCompanySeasonQualification(
                id: widget.qualification?.id ?? '',
                companyId: widget.company.id,
                seasonId: _seasonId,
                qualificationStatus: _status,
                isPubliclyVisible: _isVisible,
                qualificationNotes: _emptyToNull(_notesController.text),
              ),
            );
          },
          child: const Text('حفظ'),
        ),
      ],
    );
  }
}

String _formatRange(DateTime? start, DateTime? end) {
  final s = start == null
      ? '-'
      : '${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}';
  final e = end == null
      ? '-'
      : '${end.year}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}';
  return '$s → $e';
}

String? _emptyToNull(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
