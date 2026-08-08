import 'package:flutter/material.dart';

class NosokStatCard extends StatelessWidget {
  const NosokStatCard({
    super.key,
    String? title,
    String? label,
    required this.value,
    this.subtitle,
    this.width = 220,
  }) : title = title ?? label ?? '';

  final String title;
  final String value;
  final String? subtitle;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(value, style: theme.textTheme.headlineSmall),
              if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(subtitle!, style: theme.textTheme.bodySmall),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
