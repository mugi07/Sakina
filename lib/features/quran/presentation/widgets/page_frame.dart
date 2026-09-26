import 'package:flutter/material.dart';

/// Cadre commun aux pages (arabe et traductions) : en-tête, contenu, numéro.
class PageFrame extends StatelessWidget {
  const PageFrame({required this.header, required this.footer, required this.child, super.key});

  final Widget header;
  final String footer;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 8),
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: scheme.tertiary.withValues(alpha: 0.7), width: 1.5),
      ),
      child: Column(
        children: [
          header,
          Divider(height: 8, color: scheme.tertiary.withValues(alpha: 0.4)),
          Expanded(child: child),
          const SizedBox(height: 4),
          Text(footer, style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13)),
        ],
      ),
    );
  }
}

/// En-tête de page : nom de la sourate d'un côté, juz et hizb de l'autre.
class PageHeaderRow extends StatelessWidget {
  const PageHeaderRow({required this.start, required this.end, super.key});

  final String start;
  final String end;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontSize: 12.5, color: Theme.of(context).colorScheme.onSurfaceVariant);
    return Row(
      children: [
        Expanded(
          child: Text(start, style: style, overflow: TextOverflow.ellipsis),
        ),
        Text(end, style: style),
      ],
    );
  }
}
