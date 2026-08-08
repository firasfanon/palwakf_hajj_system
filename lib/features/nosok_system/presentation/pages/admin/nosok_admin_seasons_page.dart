import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_seasons_controller.dart';
import '../../../domain/models/nosok_season.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';
import 'nosok_admin_crud_helpers.dart';

class NosokAdminSeasonsPage extends ConsumerWidget {
  const NosokAdminSeasonsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seasonsAsync = ref.watch(nosokSeasonsControllerProvider);

    return NosokPageScaffold(
      title: 'إدارة المواسم',
      subtitle:
          'CRUD فعلي للمواسم تحت المنصة مع التحكم بفتح/إغلاق التسجيل والظهور العام.',
      actions: [
        FilledButton.icon(
          onPressed: () => _openSeasonDialog(context, ref),
          icon: const Icon(Icons.add),
          label: const Text('إضافة موسم'),
        ),
      ],
      children: [
        NosokSectionCard(
          title: 'المواسم الحالية',
          child: seasonsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => const Text('تعذر تحميل المواسم حاليًا.'),
            data: (seasons) {
              if (seasons.isEmpty) {
                return const Text('لا توجد مواسم حتى الآن.');
              }
              return Column(
                children: seasons
                    .map(
                      (season) => Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(season.titleAr),
                          subtitle: Text(
                            '${season.seasonCode} • ${_labelForServiceType(season.serviceType)} • ${_labelForSeasonStatus(season.status)}',
                          ),
                          trailing: Wrap(
                            spacing: 4,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () => _openSeasonDialog(context, ref,
                                    season: season),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => confirmCrudDelete(
                                    context,
                                    () => ref
                                        .read(nosokSeasonsControllerProvider
                                            .notifier)
                                        .deleteSeason(season.id)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}

Future<void> _openSeasonDialog(
  BuildContext context,
  WidgetRef ref, {
  NosokSeason? season,
}) async {
  final result = await showDialog<NosokSeason>(
    context: context,
    builder: (context) => _SeasonDialog(season: season),
  );
  if (result == null) return;
  try {
    await ref.read(nosokSeasonsControllerProvider.notifier).saveSeason(result);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(season == null ? 'تم إنشاء الموسم.' : 'تم تحديث الموسم.')),
      );
    }
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: const Text(
                'تعذر حفظ الموسم حاليًا. راجع البيانات والصلاحية ثم حاول مجددًا.')),
      );
    }
  }
}

Future<void> confirmCrudDelete(
    BuildContext context, Future<void> Function() onDelete) async {
  final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('تأكيد الحذف'),
          content: const Text('سيتم حذف السجل المحدد. هل تريد المتابعة؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('حذف'),
            ),
          ],
        ),
      ) ??
      false;
  if (!confirmed) return;
  await onDelete();
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حذف السجل.')),
    );
  }
}

class _SeasonDialog extends StatefulWidget {
  const _SeasonDialog({this.season});

  final NosokSeason? season;

  @override
  State<_SeasonDialog> createState() => _SeasonDialogState();
}

class _SeasonDialogState extends State<_SeasonDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;
  late final TextEditingController _titleArController;
  late final TextEditingController _titleEnController;
  late final TextEditingController _hijriYearController;
  late final TextEditingController _gregorianYearController;
  late final TextEditingController _notesController;
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;
  late String _serviceType;
  late String _status;
  late bool _isVisible;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    final season = widget.season ?? NosokSeason.empty();
    _codeController = TextEditingController(text: season.seasonCode);
    _titleArController = TextEditingController(text: season.titleAr);
    _titleEnController = TextEditingController(text: season.titleEn ?? '');
    _hijriYearController =
        TextEditingController(text: season.hijriYear?.toString() ?? '');
    _gregorianYearController =
        TextEditingController(text: season.gregorianYear?.toString() ?? '');
    _notesController = TextEditingController(text: season.notes ?? '');
    _serviceType = season.serviceType;
    _status = season.status;
    _isVisible = season.isPubliclyVisible;
    _startDate = season.registrationStartAt;
    _endDate = season.registrationEndAt;
    _startDateController = TextEditingController(
        text: season.registrationStartAt == null
            ? ''
            : formatDateYmd(season.registrationStartAt!));
    _endDateController = TextEditingController(
        text: season.registrationEndAt == null
            ? ''
            : formatDateYmd(season.registrationEndAt!));
  }

  @override
  void dispose() {
    _codeController.dispose();
    _titleArController.dispose();
    _titleEnController.dispose();
    _hijriYearController.dispose();
    _gregorianYearController.dispose();
    _notesController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.season == null ? 'إضافة موسم' : 'تعديل موسم'),
      content: SizedBox(
        width: 640,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _dialogField(_codeController, 'رمز الموسم',
                    validator: requiredText),
                _dialogField(_titleArController, 'العنوان بالعربية',
                    validator: requiredText),
                _dialogField(_titleEnController, 'العنوان بالإنجليزية'),
                _dialogField(_hijriYearController, 'السنة الهجرية',
                    keyboardType: TextInputType.number),
                _dialogField(_gregorianYearController, 'السنة الميلادية',
                    keyboardType: TextInputType.number),
                SizedBox(
                  width: 300,
                  child: DropdownButtonFormField<String>(
                    initialValue: _serviceType,
                    decoration: const InputDecoration(
                        labelText: 'نوع الخدمة', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'hajj', child: Text('حج')),
                      DropdownMenuItem(value: 'umrah', child: Text('عمرة')),
                      DropdownMenuItem(value: 'mixed', child: Text('مختلط')),
                    ],
                    onChanged: (value) =>
                        setState(() => _serviceType = value ?? 'hajj'),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: DropdownButtonFormField<String>(
                    initialValue: _status,
                    decoration: const InputDecoration(
                        labelText: 'الحالة', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'draft', child: Text('مسودة')),
                      DropdownMenuItem(value: 'open', child: Text('مفتوح')),
                      DropdownMenuItem(value: 'closed', child: Text('مغلق')),
                      DropdownMenuItem(value: 'archived', child: Text('مؤرشف')),
                    ],
                    onChanged: (value) =>
                        setState(() => _status = value ?? 'draft'),
                  ),
                ),
                _dateField('بداية التسجيل', _startDateController,
                    () => _pickDate(isStart: true)),
                _dateField('نهاية التسجيل', _endDateController,
                    () => _pickDate(isStart: false)),
                SizedBox(
                  width: 612,
                  child: TextFormField(
                    controller: _notesController,
                    minLines: 2,
                    maxLines: 4,
                    decoration: const InputDecoration(
                        labelText: 'ملاحظات', border: OutlineInputBorder()),
                  ),
                ),
                SwitchListTile(
                  value: _isVisible,
                  onChanged: (value) => setState(() => _isVisible = value),
                  title: const Text('مرئي للجمهور'),
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
              NosokSeason(
                id: widget.season?.id ?? '',
                seasonCode: _codeController.text.trim(),
                titleAr: _titleArController.text.trim(),
                titleEn: _titleEnController.text.trim().isEmpty
                    ? null
                    : _titleEnController.text.trim(),
                serviceType: _serviceType,
                hijriYear: int.tryParse(_hijriYearController.text.trim()),
                gregorianYear:
                    int.tryParse(_gregorianYearController.text.trim()),
                registrationStartAt: _startDate,
                registrationEndAt: _endDate,
                status: _status,
                notes: _notesController.text.trim().isEmpty
                    ? null
                    : _notesController.text.trim(),
                isPubliclyVisible: _isVisible,
              ),
            );
          },
          child: const Text('حفظ'),
        ),
      ],
    );
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? _startDate : _endDate) ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
        _startDateController.text = formatDateYmd(picked);
      } else {
        _endDate = picked;
        _endDateController.text = formatDateYmd(picked);
      }
    });
  }
}

Widget _dialogField(
  TextEditingController controller,
  String label, {
  String? Function(String?)? validator,
  TextInputType? keyboardType,
}) {
  return SizedBox(
    width: 300,
    child: TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration:
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
    ),
  );
}

Widget _dateField(
    String label, TextEditingController controller, VoidCallback onTap) {
  return SizedBox(
    width: 300,
    child: TextFormField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today_outlined),
      ),
    ),
  );
}

String _labelForSeasonStatus(String status) {
  switch (status) {
    case 'open':
      return 'مفتوح';
    case 'closed':
      return 'مغلق';
    case 'archived':
      return 'مؤرشف';
    default:
      return 'مسودة';
  }
}

String _labelForServiceType(String value) {
  switch (value) {
    case 'umrah':
      return 'عمرة';
    case 'mixed':
      return 'مختلط';
    default:
      return 'حج';
  }
}
