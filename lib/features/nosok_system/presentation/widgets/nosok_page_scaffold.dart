import 'package:flutter/material.dart';

class NosokPageScaffold extends StatelessWidget {
  const NosokPageScaffold({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    required this.children,
  });

  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0xFF0A3B5A),
                          Color(0xFF0F4C7A),
                          Color(0xFFE8F0FE),
                        ],
                      ),
                      border: Border.all(color: const Color(0xFFDCE3EB)),
                      boxShadow: [
                        BoxShadow(
                          color: scheme.shadow.withValues(alpha: .12),
                          blurRadius: 26,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 18,
                        runSpacing: 14,
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 760),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style:
                                      theme.textTheme.headlineMedium?.copyWith(
                                    color: scheme.onPrimary,
                                    fontWeight: FontWeight.w900,
                                    height: 1.15,
                                  ),
                                ),
                                if ((subtitle ?? '').trim().isNotEmpty) ...[
                                  const SizedBox(height: 10),
                                  Text(
                                    subtitle!,
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      color: scheme.onPrimary
                                          .withValues(alpha: .90),
                                      height: 1.55,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if ((actions ?? const <Widget>[]).isNotEmpty)
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: actions!,
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...children,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
