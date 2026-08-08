import 'package:flutter/material.dart';

enum PwfSisNoticeTone { info, success, warning, error, neutral }

class _PwfSisNosokPalette {
  const _PwfSisNosokPalette._();

  static const sovereignBlue = Color(0xFF0A3B5A);
  static const sovereignBlueMid = Color(0xFF0F4C7A);
  static const gold = Color(0xFFB68B40);
  static const goldSoft = Color(0xFFF9F3E7);
  static const goldBorder = Color(0xFFD7B56D);
  static const goldText = Color(0xFF5D4215);
  static const greenSoft = Color(0xFFE8F5EE);
  static const greenBorder = Color(0xFF8BC5A5);
  static const greenText = Color(0xFF1F5F3B);
  static const royalRed = Color(0xFFB22222);
  static const royalRedBorder = Color(0xFFB22222);
}

Color _pwfSisToneBackground(ColorScheme scheme, PwfSisNoticeTone tone) {
  return switch (tone) {
    PwfSisNoticeTone.success => _PwfSisNosokPalette.greenSoft,
    PwfSisNoticeTone.warning => _PwfSisNosokPalette.goldSoft,
    PwfSisNoticeTone.error => scheme.surface,
    PwfSisNoticeTone.info => scheme.primaryContainer,
    PwfSisNoticeTone.neutral => scheme.surface,
  };
}

Color _pwfSisToneForeground(ColorScheme scheme, PwfSisNoticeTone tone) {
  return switch (tone) {
    PwfSisNoticeTone.success => _PwfSisNosokPalette.greenText,
    PwfSisNoticeTone.warning => _PwfSisNosokPalette.goldText,
    PwfSisNoticeTone.error => _PwfSisNosokPalette.royalRed,
    PwfSisNoticeTone.info => scheme.onPrimaryContainer,
    PwfSisNoticeTone.neutral => scheme.onSurface,
  };
}

Color _pwfSisToneBorder(ColorScheme scheme, PwfSisNoticeTone tone) {
  return switch (tone) {
    PwfSisNoticeTone.success => _PwfSisNosokPalette.greenBorder,
    PwfSisNoticeTone.warning => _PwfSisNosokPalette.goldBorder,
    PwfSisNoticeTone.error => _PwfSisNosokPalette.royalRedBorder,
    PwfSisNoticeTone.info => scheme.primary.withValues(alpha: .22),
    PwfSisNoticeTone.neutral => scheme.outlineVariant,
  };
}

class PwfSisPublicServiceShell extends StatelessWidget {
  const PwfSisPublicServiceShell({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PwfSisServiceHero extends StatelessWidget {
  const PwfSisServiceHero({
    super.key,
    required this.title,
    required this.description,
    this.badges = const [],
    this.primaryAction,
    this.secondaryAction,
    this.tertiaryAction,
  });

  final String title;
  final String description;
  final List<String> badges;
  final Widget? primaryAction;
  final Widget? secondaryAction;
  final Widget? tertiaryAction;

  @override
  Widget build(BuildContext context) {
    return PwfSisPremiumPublicHero(
      title: title,
      description: description,
      badges: badges,
      icon: Icons.travel_explore_outlined,
      primaryAction: primaryAction,
      secondaryAction: secondaryAction,
      tertiaryAction: tertiaryAction,
    );
  }
}

class PwfSisServiceCard extends StatelessWidget {
  const PwfSisServiceCard(
      {super.key,
      required this.icon,
      required this.title,
      required this.description,
      this.actionLabel,
      this.onPressed,
      this.disabled = false});
  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onPressed;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: disabled ? null : onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CircleAvatar(
                backgroundColor: const Color(0xFFE8F0FE),
                foregroundColor: const Color(0xFF0A3B5A),
                child: Icon(icon)),
            const SizedBox(height: 12),
            Text(title,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(description,
                style: theme.textTheme.bodyMedium,
                maxLines: 4,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 10),
            if (disabled)
              PwfSisStatusBadge(
                  label: 'قيد التجهيز', icon: Icons.lock_clock_outlined)
            else
              Text(actionLabel ?? 'فتح',
                  style: const TextStyle(
                      color: Color(0xFF0A3B5A), fontWeight: FontWeight.w800)),
          ]),
        ),
      ),
    );
  }
}

class PwfSisRequirementsPanel extends StatelessWidget {
  const PwfSisRequirementsPanel({super.key, required this.items});
  final List<String> items;
  @override
  Widget build(BuildContext context) {
    return PwfSisPanel(
      title: 'المتطلبات الأساسية',
      subtitle:
          'ملخص مبسط. تظهر المتطلبات النهائية داخل نموذج الطلب حسب نوع الخدمة والموسم.',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final item in items)
            PwfSisStatusBadge(label: item, icon: Icons.check_circle_outline)
        ],
      ),
    );
  }
}

class PwfSisPublicWorkflowStepper extends StatelessWidget {
  const PwfSisPublicWorkflowStepper({super.key, required this.steps});
  final List<String> steps;
  @override
  Widget build(BuildContext context) {
    return PwfSisPanel(
      title: 'رحلة الخدمة',
      subtitle:
          'تم تبسيط الرحلة حتى لا تتحول الصفحة إلى نموذج طويل أو جدول إداري.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 720;
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (var i = 0; i < steps.length; i++)
                SizedBox(
                  width: compact
                      ? constraints.maxWidth
                      : (constraints.maxWidth - 30) / 4,
                  child: _WorkflowStep(index: i + 1, title: steps[i]),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _WorkflowStep extends StatelessWidget {
  const _WorkflowStep({required this.index, required this.title});
  final int index;
  final String title;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          border: Border.all(color: scheme.outlineVariant),
          borderRadius: BorderRadius.circular(16),
          color: scheme.surface),
      child: Row(children: [
        CircleAvatar(radius: 15, child: Text('$index')),
        const SizedBox(width: 8),
        Expanded(child: Text(title))
      ]),
    );
  }
}

class PwfSisTrackingCard extends StatefulWidget {
  const PwfSisTrackingCard({super.key, this.onTrack});
  final void Function(String value)? onTrack;
  @override
  State<PwfSisTrackingCard> createState() => _PwfSisTrackingCardState();
}

class _PwfSisTrackingCardState extends State<PwfSisTrackingCard> {
  final _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PwfSisPanel(
      title: 'متابعة الطلب',
      subtitle:
          'استخدم رقم الطلب أو رمز التتبع. لا تظهر بيانات حساسة في الواجهة العامة.',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 360,
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'رقم الطلب / رمز التتبع',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.confirmation_number_outlined,
                    color: Color(0xFF0A3B5A)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18))),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                  borderSide: BorderSide(color: Color(0xFFDCE3EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                  borderSide: BorderSide(color: Color(0xFF0A3B5A), width: 1.4),
                ),
              ),
            ),
          ),
          FilledButton.icon(
            onPressed: () => widget.onTrack?.call(_controller.text.trim()),
            icon: const Icon(Icons.search),
            label: const Text('متابعة'),
            style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF0A3B5A),
                minimumSize: const Size(132, 50)),
          ),
        ],
      ),
    );
  }
}

class PwfSisTransactionLookupPanel extends StatelessWidget {
  const PwfSisTransactionLookupPanel({
    super.key,
    required this.title,
    required this.subtitle,
    required this.primaryLabel,
    this.icon = Icons.manage_search_outlined,
    this.fields = const ['رقم الطلب / رمز التتبع', 'رقم الهوية / رمز التحقق'],
  });

  final String title;
  final String subtitle;
  final String primaryLabel;
  final IconData icon;
  final List<String> fields;

  @override
  Widget build(BuildContext context) {
    return PwfSisPanel(
      title: title,
      subtitle: subtitle,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 700;
          final fieldWidgets = [
            for (final field in fields)
              SizedBox(
                width: compact ? constraints.maxWidth : 300,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: field,
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.confirmation_number_outlined,
                        color: Color(0xFF0A3B5A)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: Color(0xFFDCE3EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(
                          color: Color(0xFF0A3B5A), width: 1.4),
                    ),
                  ),
                ),
              ),
          ];
          final button = FilledButton.icon(
            onPressed: () {},
            icon: Icon(icon),
            label: Text(primaryLabel),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0A3B5A),
              foregroundColor: Colors.white,
              minimumSize: Size(compact ? double.infinity : 150, 50),
            ),
          );
          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...fieldWidgets.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10), child: item)),
                button,
              ],
            );
          }
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [...fieldWidgets, button],
          );
        },
      ),
    );
  }
}

class PwfSisFAQAccordion extends StatelessWidget {
  const PwfSisFAQAccordion({super.key, required this.items});
  final List<(String, String)> items;
  @override
  Widget build(BuildContext context) {
    return PwfSisPanel(
      title: 'أسئلة شائعة',
      subtitle: 'مختصرات قابلة للتوسيع بدل قائمة طويلة.',
      child: Column(children: [
        for (final item in items)
          ExpansionTile(title: Text(item.$1), children: [
            Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                    alignment: Alignment.centerRight, child: Text(item.$2)))
          ])
      ]),
    );
  }
}

class PwfSisPublicHelpCard extends StatelessWidget {
  const PwfSisPublicHelpCard({super.key});
  @override
  Widget build(BuildContext context) {
    return PwfSisPanel(
      title: 'المساعدة العامة',
      subtitle:
          'مساعد نسك العام يعرض إرشادًا غير حساس، مع إبراز تطبيق مناسكنا كقناة إرشادية مساندة عند اعتماد الربط النهائي، بينما تبقى قرارات الطلب داخل قنوات المتابعة الرسمية.',
      child: Wrap(spacing: 10, runSpacing: 10, children: const [
        PwfSisStatusBadge(
            label: 'دليل استخدام', icon: Icons.menu_book_outlined),
        PwfSisStatusBadge(label: 'دعم فني', icon: Icons.support_agent_outlined),
        PwfSisStatusBadge(
            label: 'تطبيق مناسكنا', icon: Icons.phone_iphone_outlined),
        PwfSisStatusBadge(
            label: 'سياسة خصوصية', icon: Icons.privacy_tip_outlined),
      ]),
    );
  }
}

class PwfSisSystemHero extends StatelessWidget {
  const PwfSisSystemHero(
      {super.key,
      required this.title,
      required this.description,
      this.badges = const [],
      this.actions = const []});
  final String title;
  final String description;
  final List<String> badges;
  final List<Widget> actions;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: scheme.outlineVariant)),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 14,
        spacing: 18,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Wrap(spacing: 8, runSpacing: 8, children: [
                for (final badge in badges)
                  PwfSisStatusBadge(
                      label: badge, icon: Icons.admin_panel_settings_outlined)
              ]),
              const SizedBox(height: 10),
              Text(title,
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(description,
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.55)),
            ]),
          ),
          Wrap(spacing: 8, runSpacing: 8, children: actions),
        ],
      ),
    );
  }
}

class PwfSisMetricCard extends StatelessWidget {
  const PwfSisMetricCard(
      {super.key,
      required this.label,
      required this.value,
      this.subtitle,
      this.icon = Icons.insights_outlined});
  final String label;
  final String value;
  final String? subtitle;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(children: [
          CircleAvatar(
              backgroundColor: scheme.secondaryContainer,
              foregroundColor: scheme.onSecondaryContainer,
              child: Icon(icon)),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(label, style: theme.textTheme.bodyMedium),
                Text(value,
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800)),
                if (subtitle != null)
                  Text(subtitle!, style: theme.textTheme.bodySmall)
              ])),
        ]),
      ),
    );
  }
}

class PwfSisStatusBadge extends StatelessWidget {
  const PwfSisStatusBadge(
      {super.key,
      required this.label,
      this.icon,
      this.tone = PwfSisNoticeTone.neutral});
  final String label;
  final IconData? icon;
  final PwfSisNoticeTone tone;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = _pwfSisToneBackground(scheme, tone);
    final foreground = _pwfSisToneForeground(scheme, tone);
    final borderColor = _pwfSisToneBorder(scheme, tone);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: borderColor)),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: foreground, fontWeight: FontWeight.w700),
        child: IconTheme.merge(
          data: IconThemeData(color: foreground),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            if (icon != null) ...[
              Icon(icon, size: 16),
              const SizedBox(width: 6)
            ],
            Text(label)
          ]),
        ),
      ),
    );
  }
}

class PwfSisNotice extends StatelessWidget {
  const PwfSisNotice(
      {super.key,
      required this.title,
      required this.message,
      this.tone = PwfSisNoticeTone.info});
  final String title;
  final String message;
  final PwfSisNoticeTone tone;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final background = _pwfSisToneBackground(scheme, tone);
    final foreground = _pwfSisToneForeground(scheme, tone);
    final border = _pwfSisToneBorder(scheme, tone);
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: border),
      ),
      child: Container(
        color: background,
        padding: const EdgeInsets.all(14),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(
            switch (tone) {
              PwfSisNoticeTone.error => Icons.error_outline,
              PwfSisNoticeTone.warning => Icons.warning_amber_outlined,
              PwfSisNoticeTone.success => Icons.check_circle_outline,
              _ => Icons.info_outline,
            },
            color: foreground,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DefaultTextStyle.merge(
              style: TextStyle(color: foreground),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: theme.textTheme.titleMedium?.copyWith(
                          color: foreground, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(message,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: foreground, height: 1.55)),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class PwfSisRuntimeState extends StatelessWidget {
  const PwfSisRuntimeState(
      {super.key, required this.label, required this.value, this.ok = true});
  final String label;
  final String value;
  final bool ok;
  @override
  Widget build(BuildContext context) => PwfSisStatusBadge(
      label: '$label: $value',
      icon: ok ? Icons.check_circle_outline : Icons.error_outline,
      tone: ok ? PwfSisNoticeTone.success : PwfSisNoticeTone.warning);
}

class PwfSisAdaptiveWorkspace extends StatelessWidget {
  const PwfSisAdaptiveWorkspace(
      {super.key, required this.children, this.minTileWidth = 280});
  final List<Widget> children;
  final double minTileWidth;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final columns = (constraints.maxWidth / minTileWidth).floor().clamp(1, 4);
      final width = (constraints.maxWidth - (columns - 1) * 12) / columns;
      return Wrap(spacing: 12, runSpacing: 12, children: [
        for (final child in children) SizedBox(width: width, child: child)
      ]);
    });
  }
}

class PwfSisDataTable extends StatelessWidget {
  const PwfSisDataTable(
      {super.key, required this.columns, required this.rows, this.cardBuilder});
  final List<String> columns;
  final List<List<Widget>> rows;
  final Widget Function(List<Widget> row)? cardBuilder;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 720) {
        return Column(children: [
          for (final row in rows)
            Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: cardBuilder?.call(row) ??
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: row)))
        ]);
      }
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            for (final column in columns) DataColumn(label: Text(column))
          ],
          rows: [
            for (final row in rows)
              DataRow(cells: [for (final cell in row) DataCell(cell)])
          ],
        ),
      );
    });
  }
}

class PwfSisReviewQueue extends StatelessWidget {
  const PwfSisReviewQueue({super.key, required this.items});
  final List<(String, String, String)> items;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      for (final item in items)
        ListTile(
            leading: const Icon(Icons.assignment_outlined),
            title: Text(item.$1),
            subtitle: Text(item.$2),
            trailing: PwfSisStatusBadge(label: item.$3))
    ]);
  }
}

class PwfSisDecisionPanel extends StatelessWidget {
  const PwfSisDecisionPanel({super.key, required this.actions});
  final List<Widget> actions;
  @override
  Widget build(BuildContext context) => PwfSisPanel(
      title: 'لوحة القرار',
      subtitle: 'الإجراءات تظهر حسب الصلاحية وحالة الطلب.',
      child: Wrap(spacing: 8, runSpacing: 8, children: actions));
}

class PwfSisTimeline extends StatelessWidget {
  const PwfSisTimeline({super.key, required this.items});
  final List<String> items;
  @override
  Widget build(BuildContext context) => Column(children: [
        for (var i = 0; i < items.length; i++)
          ListTile(
              leading: CircleAvatar(child: Text('${i + 1}')),
              title: Text(items[i]))
      ]);
}

class PwfSisDocumentPreview extends StatelessWidget {
  const PwfSisDocumentPreview(
      {super.key, required this.title, required this.status});
  final String title;
  final String status;
  @override
  Widget build(BuildContext context) => ListTile(
      leading: const Icon(Icons.description_outlined),
      title: Text(title),
      subtitle: Text('الحالة: $status'),
      trailing: const Icon(Icons.visibility_outlined));
}

class PwfSisMessageThread extends StatelessWidget {
  const PwfSisMessageThread({super.key, required this.messages});
  final List<String> messages;
  @override
  Widget build(BuildContext context) => Column(children: [
        for (final message in messages)
          Align(
              alignment: Alignment.centerRight,
              child: Card(
                  child: Padding(
                      padding: const EdgeInsets.all(12), child: Text(message))))
      ]);
}

class PwfSisAuditPanel extends StatelessWidget {
  const PwfSisAuditPanel({super.key});
  @override
  Widget build(BuildContext context) => const PwfSisNotice(
      title: 'Audit محكوم',
      message:
          'يظهر سجل التدقيق فقط لمن يملك صلاحية Superuser أو صلاحية audit معتمدة من المنصة.',
      tone: PwfSisNoticeTone.neutral);
}

class PwfSisPanel extends StatelessWidget {
  const PwfSisPanel(
      {super.key,
      required this.title,
      required this.child,
      this.subtitle,
      this.actions = const []});
  final String title;
  final String? subtitle;
  final Widget child;
  final List<Widget> actions;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 8,
              spacing: 12,
              children: [
                ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              style: theme.textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w700)),
                          if (subtitle != null) ...[
                            const SizedBox(height: 6),
                            Text(subtitle!)
                          ]
                        ])),
                if (actions.isNotEmpty)
                  Wrap(spacing: 8, runSpacing: 8, children: actions),
              ]),
          const SizedBox(height: 14),
          child,
        ]),
      ),
    );
  }
}

class PwfSisPremiumPublicHero extends StatelessWidget {
  const PwfSisPremiumPublicHero({
    super.key,
    required this.title,
    required this.description,
    this.highlight,
    this.badges = const [],
    this.statusItems = const [],
    this.primaryAction,
    this.secondaryAction,
    this.tertiaryAction,
    this.icon = Icons.travel_explore_outlined,
  });

  final String title;
  final String description;
  final String? highlight;
  final List<String> badges;
  final List<(IconData, String, PwfSisNoticeTone)> statusItems;
  final Widget? primaryAction;
  final Widget? secondaryAction;
  final Widget? tertiaryAction;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: const [
            _PwfSisNosokPalette.sovereignBlue,
            _PwfSisNosokPalette.sovereignBlueMid,
            Color(0xFFE8F0FE),
          ],
        ),
        border: Border.all(color: scheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: .18),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Stack(
        children: [
          PositionedDirectional(
            top: -80,
            end: -40,
            child: _PwfSisDecorativeOrb(
                size: 190,
                color: _PwfSisNosokPalette.gold.withValues(alpha: .22)),
          ),
          PositionedDirectional(
            bottom: -90,
            start: -30,
            child: _PwfSisDecorativeOrb(
                size: 220, color: scheme.surface.withValues(alpha: .22)),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 820;
              final content = Padding(
                padding: EdgeInsets.all(compact ? 18 : 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (badges.isNotEmpty) ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final badge in badges)
                            PwfSisStatusBadge(
                                label: badge,
                                icon: Icons.verified_outlined,
                                tone: PwfSisNoticeTone.info),
                        ],
                      ),
                      const SizedBox(height: 14),
                    ],
                    RichText(
                      text: TextSpan(
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          height: 1.06,
                          color: scheme.onPrimary,
                        ),
                        children: [
                          TextSpan(text: title),
                          if ((highlight ?? '').isNotEmpty)
                            TextSpan(
                              text: ' $highlight',
                              style: const TextStyle(
                                  color: _PwfSisNosokPalette.gold),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      description,
                      style: theme.textTheme.titleMedium?.copyWith(
                        height: 1.45,
                        color: scheme.onPrimary.withValues(alpha: .92),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        if (primaryAction != null) primaryAction!,
                        if (secondaryAction != null) secondaryAction!,
                        if (tertiaryAction != null) tertiaryAction!,
                      ],
                    ),
                    if (statusItems.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _PwfSisHeroStatusStrip(items: statusItems),
                    ],
                  ],
                ),
              );
              final visual = Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  compact ? 22 : 0,
                  0,
                  compact ? 18 : 24,
                  compact ? 18 : 24,
                ),
                child: _PwfSisHeroIconCard(icon: icon),
              );
              if (compact) {
                return content;
              }
              return Row(
                children: [
                  Expanded(flex: 7, child: content),
                  Expanded(flex: 3, child: visual),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PwfSisDecorativeOrb extends StatelessWidget {
  const _PwfSisDecorativeOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _PwfSisHeroStatusStrip extends StatelessWidget {
  const _PwfSisHeroStatusStrip({required this.items});

  final List<(IconData, String, PwfSisNoticeTone)> items;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: .90),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final item in items)
            PwfSisStatusBadge(label: item.$2, icon: item.$1, tone: item.$3),
        ],
      ),
    );
  }
}

class _PwfSisHeroIconCard extends StatelessWidget {
  const _PwfSisHeroIconCard({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: AlignmentDirectional.center,
            child:
                Icon(icon, size: 72, color: _PwfSisNosokPalette.sovereignBlue),
          ),
          const SizedBox(height: 18),
          Text('خدمة رقمية وطنية',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(
            'تجربة خدمية مختصرة للمواطن مع فصل كامل عن أدوات الموظفين والحوكمة الداخلية.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: scheme.onSurfaceVariant, height: 1.6),
          ),
        ],
      ),
    );
  }
}

class PwfSisPremiumServiceCard extends StatelessWidget {
  const PwfSisPremiumServiceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onPressed,
    this.priority = false,
    this.tone = PwfSisNoticeTone.neutral,
  });

  final IconData icon;
  final String title;
  final String description;
  final String actionLabel;
  final VoidCallback onPressed;
  final bool priority;
  final PwfSisNoticeTone tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final bg = _pwfSisToneBackground(scheme, tone);
    final fg = _pwfSisToneForeground(scheme, tone);
    final border = _pwfSisToneBorder(scheme, tone);
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: priority ? 2 : 0,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          constraints: BoxConstraints(minHeight: priority ? 178 : 154),
          padding: const EdgeInsets.all(16),
          decoration:
              BoxDecoration(color: bg, border: Border.all(color: border)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: scheme.surface.withValues(alpha: .85),
                foregroundColor: fg,
                child: Icon(icon),
              ),
              const SizedBox(height: 12),
              Text(title,
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w900, color: fg)),
              const SizedBox(height: 8),
              Text(description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.55, color: fg.withValues(alpha: .86))),
              const SizedBox(height: 12),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(actionLabel,
                    style: TextStyle(color: fg, fontWeight: FontWeight.w900)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PwfSisTrustTransparencyBox extends StatelessWidget {
  const PwfSisTrustTransparencyBox({super.key, required this.body});

  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _PwfSisNosokPalette.goldSoft,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: _PwfSisNosokPalette.goldBorder),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        final compact = constraints.maxWidth < 720;
        final icon = CircleAvatar(
          radius: 28,
          backgroundColor: scheme.surface,
          foregroundColor: scheme.primary,
          child: const Icon(Icons.balance_outlined),
        );
        final copy = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('شفافية وعدالة',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(body, style: theme.textTheme.bodyLarge?.copyWith(height: 1.7)),
          ],
        );
        if (compact) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [icon, const SizedBox(height: 12), copy]);
        }
        return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [icon, const SizedBox(width: 14), Expanded(child: copy)]);
      }),
    );
  }
}
