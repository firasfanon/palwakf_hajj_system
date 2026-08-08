import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_applications_controller.dart';
import '../../../application/nosok_programs_controller.dart';
import '../../../application/nosok_seasons_controller.dart';
import '../../../application/services/nosok_file_upload_service.dart';
import '../../../domain/models/nosok_application.dart';
import '../../../domain/models/nosok_application_companion.dart';
import '../../../domain/models/nosok_application_document.dart';
import '../../../domain/models/nosok_application_draft.dart';
import '../../../domain/models/nosok_application_payment.dart';
import '../../../domain/models/nosok_storage_upload_result.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';

class NosokApplyPage extends ConsumerStatefulWidget {
  const NosokApplyPage({super.key});

  @override
  ConsumerState<NosokApplyPage> createState() => _NosokApplyPageState();
}

class _NosokApplyPageState extends ConsumerState<NosokApplyPage> {
  final List<GlobalKey<FormState>> _formKeys =
      List<GlobalKey<FormState>>.generate(
    6,
    (_) => GlobalKey<FormState>(),
  );

  final _fullNameController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  int _currentStep = 0;
  String _serviceType = 'hajj';
  String? _seasonId;
  String? _programId;
  String? _gender;
  String? _maritalStatus;
  DateTime? _birthDate;
  bool _acceptDeclaration = false;
  final List<NosokApplicationCompanion> _companions =
      <NosokApplicationCompanion>[];
  final List<NosokApplicationDocument> _documents =
      <NosokApplicationDocument>[];
  final List<NosokApplicationPayment> _payments = <NosokApplicationPayment>[];

  @override
  void dispose() {
    _fullNameController.dispose();
    _nationalIdController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final seasonsAsync = ref.watch(nosokPublicSeasonsProvider);
    final programsAsync = ref.watch(
      nosokPublicProgramsProvider(
        NosokPublicProgramsFilter(
          seasonId: _seasonId,
          serviceType: _serviceType,
        ),
      ),
    );
    final submitState = ref.watch(nosokApplicationSubmissionControllerProvider);
    final isSubmitting = submitState.isLoading;

    return NosokPageScaffold(
      title: 'تقديم طلب جديد',
      subtitle:
          'ابدأ طلب الحج أو العمرة بخطوات واضحة: بياناتك، المرافقون، الوثائق، ثم مراجعة قبل الإرسال. احتفظ برمز التتبع بعد الإرسال لمتابعة الحالة.',
      children: [
        NosokSectionCard(
          title: 'قبل أن تبدأ',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                  '• يظهر نموذج التقديم عندما يكون الموسم مفتوحًا حسب إعلان الوزارة.'),
              SizedBox(height: 6),
              Text('• جهّز الوثائق المطلوبة قبل البدء لتقليل النواقص.'),
              SizedBox(height: 6),
              Text(
                  '• بعد الإرسال سيظهر رقم الطلب ورمز التتبع. احتفظ بهما للمتابعة.'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        seasonsAsync.when(
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
                  'تعذر تحميل المواسم المفتوحة حاليًا. أعد المحاولة أو تواصل مع الدعم الفني إذا استمرت المشكلة.'),
            ),
          ),
          data: (seasons) {
            if (seasons.isEmpty) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('لا يوجد موسم مفتوح حاليًا للتقديم.'),
                ),
              );
            }

            if (_seasonId == null ||
                !seasons.any((item) => item.id == _seasonId)) {
              _seasonId = seasons.first.id;
            }

            return _buildApplicationWizard(
              context: context,
              seasons: seasons.cast<dynamic>(),
              programsAsync: programsAsync,
              isSubmitting: isSubmitting,
            );
          },
        ),
      ],
    );
  }

  static const List<String> _stepTitles = [
    'الخدمة والموسم',
    'بيانات مقدم الطلب',
    'المرافقون',
    'الوثائق',
    'الدفعات',
    'المراجعة والإرسال',
  ];

  static const List<String> _stepDescriptions = [
    'اختر نوع الخدمة والموسم والبرنامج المتاح.',
    'أدخل بياناتك كما تظهر في الوثائق الرسمية.',
    'أضف المرافقين عند الحاجة حسب سياسة الموسم.',
    'أرفق الوثائق المطلوبة أو جهّزها للاستكمال.',
    'أضف سندات الدفع عند توفرها حسب تعليمات الوزارة.',
    'راجع الملخص وأقر بصحة البيانات قبل الإرسال.',
  ];

  static const List<IconData> _stepIcons = [
    Icons.flag_outlined,
    Icons.badge_outlined,
    Icons.group_add_outlined,
    Icons.upload_file_outlined,
    Icons.receipt_long_outlined,
    Icons.verified_user_outlined,
  ];

  Widget _buildApplicationWizard({
    required BuildContext context,
    required List<dynamic> seasons,
    required AsyncValue<dynamic> programsAsync,
    required bool isSubmitting,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isLastStep = _currentStep == _stepTitles.length - 1;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: .75)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          color: scheme.surface,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0A3B5A).withValues(alpha: .06),
              blurRadius: 28,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CitizenProgressBar(
              currentStep: _currentStep,
              labels: _stepTitles,
              icons: _stepIcons,
              onStepSelected: (index) => setState(() => _currentStep = index),
            ),
            const SizedBox(height: 20),
            _StepHeader(
              icon: _stepIcons[_currentStep],
              title: _stepTitles[_currentStep],
              description: _stepDescriptions[_currentStep],
            ),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: KeyedSubtree(
                key: ValueKey<int>(_currentStep),
                child: _buildCurrentStepContent(seasons, programsAsync),
              ),
            ),
            const SizedBox(height: 20),
            _WizardControls(
              isLastStep: isLastStep,
              isSubmitting: isSubmitting,
              canGoBack: _currentStep > 0,
              onBack: () => setState(() => _currentStep -= 1),
              onNext: _handleNextOrSubmit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent(
      List<dynamic> seasons, AsyncValue<dynamic> programsAsync) {
    return switch (_currentStep) {
      0 => _buildServiceSeasonStep(seasons, programsAsync),
      1 => _buildApplicantStep(),
      2 => _buildCompanionsStep(),
      3 => _buildDocumentsStep(),
      4 => _buildPaymentsStep(),
      _ => _buildReviewStep(),
    };
  }

  Widget _buildServiceSeasonStep(
      List<dynamic> seasons, AsyncValue<dynamic> programsAsync) {
    return Form(
      key: _formKeys[0],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _FormHintStrip(
            icon: Icons.info_outline,
            title: 'اختيار الخدمة حسب إعلان الموسم',
            message:
                'تظهر البرامج المتاحة حسب الموسم ونوع الخدمة. لا تبدأ بإدخال البيانات قبل اختيار الخدمة والموسم.',
          ),
          const SizedBox(height: 16),
          _ResponsiveFields(
            children: [
              SizedBox(
                width: 320,
                child: DropdownButtonFormField<String>(
                  initialValue: _serviceType,
                  decoration: _premiumInputDecoration('نوع الخدمة',
                      icon: Icons.flag_outlined),
                  items: const [
                    DropdownMenuItem(value: 'hajj', child: Text('حج')),
                    DropdownMenuItem(value: 'umrah', child: Text('عمرة')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _serviceType = value ?? 'hajj';
                      _programId = null;
                    });
                  },
                ),
              ),
              SizedBox(
                width: 320,
                child: DropdownButtonFormField<String>(
                  initialValue: _seasonId,
                  decoration: _premiumInputDecoration('الموسم',
                      icon: Icons.event_available_outlined),
                  items: seasons
                      .map<DropdownMenuItem<String>>(
                        (season) => DropdownMenuItem<String>(
                          value: season.id as String,
                          child: Text(season.titleAr as String),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _seasonId = value;
                      _programId = null;
                    });
                  },
                ),
              ),
              SizedBox(
                width: 320,
                child: programsAsync.when(
                  loading: () => const LinearProgressIndicator(minHeight: 46),
                  error: (error, stack) => const Text(
                      'تعذر تحميل البرامج المتاحة حاليًا. أعد المحاولة لاحقًا.'),
                  data: (programs) {
                    final list = (programs as List).cast<dynamic>();
                    if (list.isEmpty) {
                      return const Text(
                          'لا يوجد برنامج متاح للموسم ونوع الخدمة الحاليين.');
                    }
                    _programId ??= list.first.id as String;
                    return DropdownButtonFormField<String>(
                      initialValue: list.any((item) => item.id == _programId)
                          ? _programId
                          : list.first.id as String,
                      decoration: _premiumInputDecoration('البرنامج',
                          icon: Icons.route_outlined),
                      items: list
                          .map<DropdownMenuItem<String>>(
                            (program) => DropdownMenuItem<String>(
                              value: program.id as String,
                              child: Text(program.titleAr as String),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() => _programId = value),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildApplicantStep() {
    return Form(
      key: _formKeys[1],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _FormHintStrip(
            icon: Icons.location_on_outlined,
            title: 'العنوان المعتمد مهم',
            message:
                'يعتمد مسار قرعة الحج لاحقًا على العنوان المثبت في البطاقة الشخصية وربطه بالتجمع/LGU المعتمد.',
          ),
          const SizedBox(height: 16),
          _ResponsiveFields(
            children: [
              _formField(_fullNameController, 'الاسم الرباعي',
                  validator: _requiredText, icon: Icons.person_outline),
              _formField(_nationalIdController, 'رقم الهوية',
                  validator: _requiredText,
                  keyboardType: TextInputType.number,
                  icon: Icons.credit_card_outlined),
              _birthDateField(context),
              SizedBox(
                width: 320,
                child: DropdownButtonFormField<String>(
                  initialValue: _gender,
                  decoration:
                      _premiumInputDecoration('الجنس', icon: Icons.wc_outlined),
                  items: const [
                    DropdownMenuItem(value: 'male', child: Text('ذكر')),
                    DropdownMenuItem(value: 'female', child: Text('أنثى')),
                  ],
                  onChanged: (value) => setState(() => _gender = value),
                ),
              ),
              _formField(_phoneController, 'الهاتف',
                  keyboardType: TextInputType.phone,
                  icon: Icons.phone_outlined),
              _formField(_mobileController, 'الجوال',
                  validator: _requiredText,
                  keyboardType: TextInputType.phone,
                  icon: Icons.smartphone_outlined),
              _formField(_emailController, 'البريد الإلكتروني',
                  keyboardType: TextInputType.emailAddress,
                  icon: Icons.email_outlined),
              SizedBox(
                width: 320,
                child: DropdownButtonFormField<String>(
                  initialValue: _maritalStatus,
                  decoration: _premiumInputDecoration('الحالة الاجتماعية',
                      icon: Icons.family_restroom_outlined),
                  items: const [
                    DropdownMenuItem(
                        value: 'single', child: Text('أعزب/عزباء')),
                    DropdownMenuItem(value: 'married', child: Text('متزوج/ة')),
                    DropdownMenuItem(value: 'widowed', child: Text('أرمل/ة')),
                  ],
                  onChanged: (value) => setState(() => _maritalStatus = value),
                ),
              ),
              _wideTextField(_addressController, 'العنوان حسب البطاقة الشخصية',
                  icon: Icons.home_work_outlined, minLines: 2, maxLines: 3),
              _wideTextField(_notesController, 'ملاحظات إضافية',
                  icon: Icons.notes_outlined, minLines: 2, maxLines: 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompanionsStep() {
    return Form(
      key: _formKeys[2],
      child: _CollectionSection<NosokApplicationCompanion>(
        title: 'المرافقون المضافون',
        emptyText:
            'لم تتم إضافة مرافقين بعد. يمكنك المتابعة دون مرافقين إذا كانت سياسة الموسم تسمح بذلك.',
        items: _companions,
        itemBuilder: (item) => ListTile(
          leading:
              const CircleAvatar(child: Icon(Icons.person_add_alt_1_outlined)),
          title: Text(item.fullName),
          subtitle: Text([
            item.relationType ?? 'بدون صلة',
            item.nationalId ?? 'بدون هوية'
          ].join(' • ')),
        ),
        onAdd: () async {
          final result = await showDialog<NosokApplicationCompanion>(
            context: context,
            builder: (context) => const _CompanionDialog(),
          );
          if (result != null) {
            setState(() => _companions.add(result));
          }
        },
        onEdit: (index) async {
          final result = await showDialog<NosokApplicationCompanion>(
            context: context,
            builder: (context) =>
                _CompanionDialog(companion: _companions[index]),
          );
          if (result != null) {
            setState(() => _companions[index] = result);
          }
        },
        onDelete: (index) => setState(() => _companions.removeAt(index)),
      ),
    );
  }

  Widget _buildDocumentsStep() {
    return Form(
      key: _formKeys[3],
      child: _CollectionSection<NosokApplicationDocument>(
        title: 'الوثائق',
        emptyText:
            'لم تتم إضافة وثائق بعد. أضف الوثائق المتوفرة، ويمكن استكمال النواقص لاحقًا حسب تعليمات الوزارة.',
        items: _documents,
        itemBuilder: (item) => ListTile(
          leading: const CircleAvatar(child: Icon(Icons.description_outlined)),
          title: Text(item.documentTitle ?? item.documentType),
          subtitle: Text([
            item.originalFileName ?? 'بدون اسم ملف',
            item.storagePath ?? item.fileUrl ?? 'بدون مسار/رابط',
          ].join(' • ')),
        ),
        onAdd: () async {
          final result = await showDialog<NosokApplicationDocument>(
            context: context,
            builder: (context) => const _DocumentDialog(),
          );
          if (result != null) {
            setState(() => _documents.add(result));
          }
        },
        onEdit: (index) async {
          final result = await showDialog<NosokApplicationDocument>(
            context: context,
            builder: (context) => _DocumentDialog(document: _documents[index]),
          );
          if (result != null) {
            setState(() => _documents[index] = result);
          }
        },
        onDelete: (index) => setState(() => _documents.removeAt(index)),
      ),
    );
  }

  Widget _buildPaymentsStep() {
    return Form(
      key: _formKeys[4],
      child: _CollectionSection<NosokApplicationPayment>(
        title: 'الدفعات',
        emptyText:
            'لا توجد دفعات مضافة. أضف سندًا فقط إذا كان مطلوبًا في إعلان الموسم.',
        items: _payments,
        itemBuilder: (item) => ListTile(
          leading: const CircleAvatar(child: Icon(Icons.receipt_long_outlined)),
          title: Text('${item.amount.toStringAsFixed(2)} ${item.currencyCode}'),
          subtitle: Text([
            item.paymentType,
            item.paymentStatus,
            item.paymentReference ?? 'بدون مرجع',
          ].join(' • ')),
        ),
        onAdd: () async {
          final result = await showDialog<NosokApplicationPayment>(
            context: context,
            builder: (context) => const _PaymentDialog(),
          );
          if (result != null) {
            setState(() => _payments.add(result));
          }
        },
        onEdit: (index) async {
          final result = await showDialog<NosokApplicationPayment>(
            context: context,
            builder: (context) => _PaymentDialog(payment: _payments[index]),
          );
          if (result != null) {
            setState(() => _payments[index] = result);
          }
        },
        onDelete: (index) => setState(() => _payments.removeAt(index)),
      ),
    );
  }

  Widget _buildReviewStep() {
    return Form(
      key: _formKeys[5],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFD),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFDCE3EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _summaryLine(
                    'نوع الخدمة', _serviceType == 'hajj' ? 'حج' : 'عمرة'),
                _summaryLine('المرافقون', _companions.length.toString()),
                _summaryLine('الوثائق', _documents.length.toString()),
                _summaryLine('الدفعات', _payments.length.toString()),
              ],
            ),
          ),
          const SizedBox(height: 10),
          CheckboxListTile(
            value: _acceptDeclaration,
            onChanged: (value) =>
                setState(() => _acceptDeclaration = value ?? false),
            contentPadding: EdgeInsets.zero,
            title: const Text(
                'أقر بصحة البيانات والمرفقات المدخلة وأتحمل مسؤوليتها.'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleNextOrSubmit() async {
    final isLastStep = _currentStep == _stepTitles.length - 1;
    if (isLastStep) {
      await _submit();
      return;
    }
    final valid = _formKeys[_currentStep].currentState?.validate() ?? true;
    if (!valid) return;
    if (_currentStep == 0 && (_seasonId == null || _programId == null)) {
      _showMessage('اختر الموسم والبرنامج قبل المتابعة.');
      return;
    }
    setState(() => _currentStep += 1);
  }

  Future<void> _submit() async {
    final valid = _formKeys[5].currentState?.validate() ?? true;
    if (!valid) return;
    if (!_acceptDeclaration) {
      _showMessage('يجب الإقرار بصحة البيانات قبل الإرسال.');
      return;
    }
    if (_seasonId == null || _programId == null) {
      _showMessage('اختر الموسم والبرنامج قبل الإرسال.');
      return;
    }

    final draft = NosokApplicationDraft(
      seasonId: _seasonId!,
      programId: _programId!,
      serviceType: _serviceType,
      applicantFullName: _fullNameController.text.trim(),
      nationalId: _nationalIdController.text.trim(),
      birthDate: _birthDate,
      gender: _gender,
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      mobile: _mobileController.text.trim().isEmpty
          ? null
          : _mobileController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      addressText: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      maritalStatus: _maritalStatus,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      companions: _companions,
      documents: _documents,
      payments: _payments,
    );

    try {
      final application = await ref
          .read(nosokApplicationSubmissionControllerProvider.notifier)
          .submit(draft);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('تم تقديم الطلب بنجاح'),
          content: _SuccessDialogBody(application: application),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إغلاق'),
            ),
          ],
        ),
      );
      _resetForm();
    } catch (error) {
      if (mounted) {
        _showMessage(
            'تعذر إرسال الطلب حاليًا. أعد المحاولة أو تواصل مع الدعم الفني إذا استمرت المشكلة.');
      }
    }
  }

  void _resetForm() {
    setState(() {
      _currentStep = 0;
      _programId = null;
      _gender = null;
      _maritalStatus = null;
      _birthDate = null;
      _acceptDeclaration = false;
      _companions.clear();
      _documents.clear();
      _payments.clear();
    });
    _fullNameController.clear();
    _nationalIdController.clear();
    _birthDateController.clear();
    _phoneController.clear();
    _mobileController.clear();
    _emailController.clear();
    _addressController.clear();
    _notesController.clear();
  }

  Widget _birthDateField(BuildContext context) {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: _birthDateController,
        readOnly: true,
        decoration: _premiumInputDecoration(
          'تاريخ الميلاد',
          icon: Icons.calendar_today_outlined,
          helperText: 'اختر التاريخ من التقويم.',
        ),
        onTap: () async {
          final now = DateTime.now();
          final picked = await showDatePicker(
            context: context,
            initialDate: DateTime(now.year - 30),
            firstDate: DateTime(1900),
            lastDate: now,
          );
          if (picked == null) return;
          setState(() {
            _birthDate = picked;
            _birthDateController.text = _formatDate(picked);
          });
        },
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _CitizenProgressBar extends StatelessWidget {
  const _CitizenProgressBar({
    required this.currentStep,
    required this.labels,
    required this.icons,
    required this.onStepSelected,
  });

  final int currentStep;
  final List<String> labels;
  final List<IconData> icons;
  final ValueChanged<int> onStepSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 760;
        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var index = 0; index < labels.length; index++)
                _ProgressTile(
                  index: index,
                  currentStep: currentStep,
                  label: labels[index],
                  icon: icons[index],
                  onTap: () => onStepSelected(index),
                  compact: true,
                ),
            ],
          );
        }
        return Row(
          children: [
            for (var index = 0; index < labels.length; index++) ...[
              Expanded(
                child: _ProgressTile(
                  index: index,
                  currentStep: currentStep,
                  label: labels[index],
                  icon: icons[index],
                  onTap: () => onStepSelected(index),
                ),
              ),
              if (index != labels.length - 1)
                Container(
                  width: 34,
                  height: 2,
                  color: index < currentStep
                      ? const Color(0xFFB68B40)
                      : const Color(0xFFDCE3EB),
                ),
            ],
          ],
        );
      },
    );
  }
}

class _ProgressTile extends StatelessWidget {
  const _ProgressTile({
    required this.index,
    required this.currentStep,
    required this.label,
    required this.icon,
    required this.onTap,
    this.compact = false,
  });

  final int index;
  final int currentStep;
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final active = index == currentStep;
    final complete = index < currentStep;
    final color =
        active || complete ? const Color(0xFF0A3B5A) : const Color(0xFF486581);
    final background = active
        ? const Color(0xFFE8F0FE)
        : complete
            ? const Color(0xFFF9F3E7)
            : const Color(0xFFF8FAFD);
    final border = active
        ? const Color(0xFF0A3B5A)
        : complete
            ? const Color(0xFFB68B40)
            : const Color(0xFFDCE3EB);

    return Padding(
      padding: compact ? const EdgeInsets.only(bottom: 8) : EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border),
          ),
          child: Row(
            mainAxisAlignment:
                compact ? MainAxisAlignment.start : MainAxisAlignment.center,
            mainAxisSize: compact ? MainAxisSize.max : MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 17,
                backgroundColor:
                    active ? const Color(0xFF0A3B5A) : const Color(0xFFFFFFFF),
                foregroundColor: active ? Colors.white : color,
                child: complete
                    ? const Icon(Icons.check, size: 17)
                    : active
                        ? Icon(icon, size: 17)
                        : Text('${index + 1}'),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  textAlign: compact ? TextAlign.start : TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: color,
                        fontWeight: active ? FontWeight.w900 : FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader(
      {required this.icon, required this.title, required this.description});

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A3B5A), Color(0xFF0F4C7A)],
          begin: AlignmentDirectional.centerStart,
          end: AlignmentDirectional.centerEnd,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withValues(alpha: .16),
            foregroundColor: Colors.white,
            child: Icon(icon),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: .88),
                        height: 1.55)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WizardControls extends StatelessWidget {
  const _WizardControls({
    required this.isLastStep,
    required this.isSubmitting,
    required this.canGoBack,
    required this.onBack,
    required this.onNext,
  });

  final bool isLastStep;
  final bool isSubmitting;
  final bool canGoBack;
  final VoidCallback onBack;
  final Future<void> Function() onNext;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 640;
        final nextButton = FilledButton.icon(
          onPressed: isSubmitting ? null : onNext,
          icon: Icon(isLastStep ? Icons.send_outlined : Icons.arrow_back),
          label: Text(isLastStep ? 'إرسال الطلب' : 'التالي'),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF0A3B5A),
            foregroundColor: Colors.white,
            minimumSize: Size(compact ? double.infinity : 150, 48),
          ),
        );
        final backButton = OutlinedButton.icon(
          onPressed: isSubmitting || !canGoBack ? null : onBack,
          icon: const Icon(Icons.arrow_forward),
          label: const Text('السابق'),
          style: OutlinedButton.styleFrom(
            minimumSize: Size(compact ? double.infinity : 130, 48),
          ),
        );
        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [nextButton, const SizedBox(height: 8), backButton],
          );
        }
        return Row(
          children: [
            const Spacer(),
            backButton,
            const SizedBox(width: 10),
            nextButton,
          ],
        );
      },
    );
  }
}

class _FormHintStrip extends StatelessWidget {
  const _FormHintStrip(
      {required this.icon, required this.title, required this.message});

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F3E7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD7B56D)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF5D4215)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: theme.textTheme.titleSmall?.copyWith(
                        color: const Color(0xFF5D4215),
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF5D4215), height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessDialogBody extends StatelessWidget {
  const _SuccessDialogBody({required this.application});

  final NosokApplication application;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('رقم الطلب: ${application.applicationNo}'),
        const SizedBox(height: 8),
        Text('رمز التتبع: ${application.trackingToken ?? '-'}'),
        const SizedBox(height: 8),
        const Text('احتفظ برمز التتبع لاستخدامه لاحقًا في صفحة متابعة الطلب.'),
      ],
    );
  }
}

class _CollectionSection<T> extends StatelessWidget {
  const _CollectionSection({
    required this.title,
    required this.emptyText,
    required this.items,
    required this.itemBuilder,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  final String title;
  final String emptyText;
  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final VoidCallback onAdd;
  final Future<void> Function(int index) onEdit;
  final void Function(int index) onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('إضافة'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (items.isEmpty)
          Text(emptyText)
        else
          Column(
            children: List.generate(items.length, (index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    itemBuilder(items[index]),
                    ButtonBar(
                      children: [
                        TextButton.icon(
                          onPressed: () => onEdit(index),
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('تعديل'),
                        ),
                        TextButton.icon(
                          onPressed: () => onDelete(index),
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('حذف'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
      ],
    );
  }
}

class _CompanionDialog extends StatefulWidget {
  const _CompanionDialog({this.companion});

  final NosokApplicationCompanion? companion;

  @override
  State<_CompanionDialog> createState() => _CompanionDialogState();
}

class _CompanionDialogState extends State<_CompanionDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _nationalIdController;
  late final TextEditingController _relationController;
  late final TextEditingController _phoneController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final companion = widget.companion;
    _nameController = TextEditingController(text: companion?.fullName ?? '');
    _nationalIdController =
        TextEditingController(text: companion?.nationalId ?? '');
    _relationController =
        TextEditingController(text: companion?.relationType ?? '');
    _phoneController = TextEditingController(text: companion?.phone ?? '');
    _notesController = TextEditingController(text: companion?.notes ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nationalIdController.dispose();
    _relationController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.companion == null ? 'إضافة مرافق' : 'تعديل مرافق'),
      content: SizedBox(
        width: 620,
        child: Form(
          key: _formKey,
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _formField(_nameController, 'الاسم', validator: _requiredText),
              _formField(_nationalIdController, 'رقم الهوية'),
              _formField(_relationController, 'صلة القرابة'),
              _formField(_phoneController, 'الهاتف',
                  keyboardType: TextInputType.phone),
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
              NosokApplicationCompanion(
                id: widget.companion?.id,
                fullName: _nameController.text.trim(),
                nationalId: _emptyToNull(_nationalIdController.text),
                relationType: _emptyToNull(_relationController.text),
                phone: _emptyToNull(_phoneController.text),
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

class _DocumentDialog extends StatefulWidget {
  const _DocumentDialog({this.document});

  final NosokApplicationDocument? document;

  @override
  State<_DocumentDialog> createState() => _DocumentDialogState();
}

class _DocumentDialogState extends State<_DocumentDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _originalNameController;
  late final TextEditingController _fileUrlController;
  late final TextEditingController _bucketController;
  late final TextEditingController _pathController;
  late final TextEditingController _mimeController;
  late final TextEditingController _notesController;
  late String _documentType;
  int? _fileSizeBytes;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    final document = widget.document ?? NosokApplicationDocument.empty();
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
    _documentType = document.documentType;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.document == null ? 'إضافة وثيقة' : 'تعديل وثيقة'),
      content: SizedBox(
        width: 640,
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
                _formField(_titleController, 'عنوان الوثيقة'),
                _formField(_originalNameController, 'اسم الملف الأصلي'),
                _readOnlyField(_bucketController, 'اسم bucket'),
                _readOnlyField(_pathController, 'مسار التخزين'),
                _readOnlyField(_fileUrlController, 'رابط الوثيقة'),
                _readOnlyField(_mimeController, 'نوع الملف MIME'),
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
                _UploadHintCard(
                  title: 'رفع الوثيقة من الجهاز',
                  subtitle: _fileSizeBytes == null
                      ? 'لم يتم رفع ملف بعد.'
                      : 'الحجم الحالي: $_fileSizeBytes بايت',
                  uploading: _uploading,
                  onPressed: _pickAndUpload,
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
                applicationId: widget.document?.applicationId ?? '',
                documentType: _documentType,
                reviewStatus: widget.document?.reviewStatus ?? 'pending',
                documentTitle: _emptyToNull(_titleController.text),
                originalFileName: _emptyToNull(_originalNameController.text),
                fileUrl: _emptyToNull(_fileUrlController.text),
                storageBucket: _emptyToNull(_bucketController.text),
                storagePath: _emptyToNull(_pathController.text),
                mimeType: _emptyToNull(_mimeController.text),
                fileSizeBytes: _fileSizeBytes,
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
      final service = ProviderScope.containerOf(context)
          .read(nosokFileUploadServiceProvider);
      final result = await service.pickAndUpload(
        folder: 'applications/drafts/documents',
        allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png', 'webp'],
      );
      if (result == null || !mounted) return;
      _applyUpload(result);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
              'تعذر رفع الوثيقة حاليًا. تحقق من الملف وحاول مرة أخرى.')));
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

class _PaymentDialog extends StatefulWidget {
  const _PaymentDialog({this.payment});

  final NosokApplicationPayment? payment;

  @override
  State<_PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<_PaymentDialog> {
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
  late String _paymentType;
  late String _currencyCode;
  late String _paymentStatus;
  late String _verificationStatus;
  int? _receiptFileSizeBytes;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    final payment = widget.payment ?? NosokApplicationPayment.empty();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.payment == null ? 'إضافة دفعة' : 'تعديل دفعة'),
      content: SizedBox(
        width: 700,
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
                _formField(_amountController, 'المبلغ',
                    validator: _requiredText,
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
                _formField(_referenceController, 'مرجع الدفع'),
                _formField(_methodController, 'طريقة الدفع'),
                _formField(_providerController, 'مزود الدفع'),
                _formField(_transactionIdController, 'المعرف الخارجي للمعاملة'),
                _readOnlyField(_receiptFileNameController, 'اسم سند الدفع'),
                _readOnlyField(_receiptBucketController, 'Bucket السند'),
                _readOnlyField(_receiptPathController, 'مسار سند الدفع'),
                _readOnlyField(_receiptUrlController, 'رابط سند الدفع'),
                _readOnlyField(_receiptMimeController, 'MIME السند'),
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
                _UploadHintCard(
                  title: 'رفع سند الدفع من الجهاز',
                  subtitle: _receiptFileSizeBytes == null
                      ? 'لم يتم رفع سند بعد.'
                      : 'الحجم الحالي: $_receiptFileSizeBytes بايت',
                  uploading: _uploading,
                  onPressed: _pickAndUploadReceipt,
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
                const SnackBar(content: Text('أدخل مبلغًا صحيحًا.')),
              );
              return;
            }
            Navigator.of(context).pop(
              NosokApplicationPayment(
                id: widget.payment?.id ?? '',
                applicationId: widget.payment?.applicationId ?? '',
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
                notes: _emptyToNull(_notesController.text),
                paidAt: _paymentStatus == 'paid' ? DateTime.now() : null,
                verifiedAt:
                    _verificationStatus == 'verified' ? DateTime.now() : null,
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
      final service = ProviderScope.containerOf(context)
          .read(nosokFileUploadServiceProvider);
      final result = await service.pickAndUpload(
        folder: 'applications/drafts/payments',
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

class _UploadHintCard extends StatelessWidget {
  const _UploadHintCard({
    required this.title,
    required this.subtitle,
    required this.uploading,
    required this.onPressed,
  });

  final String title;
  final String subtitle;
  final bool uploading;
  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 612,
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
              FilledButton.icon(
                onPressed: uploading ? null : onPressed,
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

Widget _readOnlyField(TextEditingController controller, String label) {
  return SizedBox(
    width: 320,
    child: TextFormField(
      controller: controller,
      readOnly: true,
      decoration: _premiumInputDecoration(label, icon: Icons.lock_outline),
    ),
  );
}

class _ResponsiveFields extends StatelessWidget {
  const _ResponsiveFields({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: children,
        );
      },
    );
  }
}

Widget _formField(
  TextEditingController controller,
  String label, {
  String? Function(String?)? validator,
  TextInputType? keyboardType,
  IconData? icon,
}) {
  return SizedBox(
    width: 320,
    child: TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration: _premiumInputDecoration(label, icon: icon),
    ),
  );
}

Widget _wideTextField(
  TextEditingController controller,
  String label, {
  IconData? icon,
  int minLines = 1,
  int maxLines = 1,
}) {
  return SizedBox(
    width: 654,
    child: TextFormField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      decoration: _premiumInputDecoration(label, icon: icon),
    ),
  );
}

InputDecoration _premiumInputDecoration(
  String label, {
  IconData? icon,
  String? helperText,
}) {
  return InputDecoration(
    labelText: label,
    helperText: helperText,
    filled: true,
    fillColor: const Color(0xFFFFFFFF),
    prefixIcon:
        icon == null ? null : Icon(icon, color: const Color(0xFF0A3B5A)),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Color(0xFFDCE3EB)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Color(0xFFDCE3EB)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Color(0xFF0A3B5A), width: 1.4),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Color(0xFFB22222)),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  );
}

Widget _summaryLine(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        SizedBox(width: 110, child: Text('$label:')),
        Expanded(child: Text(value)),
      ],
    ),
  );
}

String? _requiredText(String? value) {
  if ((value ?? '').trim().isEmpty) {
    return 'هذا الحقل مطلوب';
  }
  return null;
}

String _formatDate(DateTime value) {
  return '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}

String? _emptyToNull(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
