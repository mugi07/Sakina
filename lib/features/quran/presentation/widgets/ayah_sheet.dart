import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/database/content_database.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/quran_providers.dart';
import '../../domain/quran_text.dart';

/// Fiche d'un verset : le texte arabe, puis chaque traduction dans sa
/// propre section (les langues ne sont jamais mélangées).
Future<void> showAyahSheet(BuildContext context, Ayah ayah) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => DraggableScrollableSheet(
    expand: false,
    initialChildSize: 0.55,
    maxChildSize: 0.9,
    builder: (context, controller) => _AyahSheet(ayah: ayah, controller: controller),
  ),
);

class _AyahSheet extends ConsumerWidget {
  const _AyahSheet({required this.ayah, required this.controller});

  final Ayah ayah;
  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final isArabicUi = Localizations.localeOf(context).languageCode == 'ar';
    final surah = ref.watch(surahByIdProvider).value?[ayah.surah];
    final translations = ref.watch(ayahTranslationsProvider(ayah.id)).value ?? const [];
    final scheme = Theme.of(context).colorScheme;
    final arabic = ayahDisplayText(surah: ayah.surah, number: ayah.number, text: ayah.textUthmani);
    final reference = l.ayahReference(
      surah == null ? '${ayah.surah}' : (isArabicUi ? surah.nameAr : surah.nameTranslit),
      ayah.number,
    );

    return ListView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '$reference · ${ayah.surah}:${ayah.number}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            IconButton(
              tooltip: l.copy,
              icon: const Icon(Icons.copy_outlined),
              onPressed: () async {
                final text = [
                  arabic,
                  for (final t in translations) t.content,
                  '— $reference (${ayah.surah}:${ayah.number})',
                ].join('\n\n');
                await Clipboard.setData(ClipboardData(text: text));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.copied)));
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '$arabic\u00A0${ayahEndMark(ayah.number)}',
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontFamily: quranFontFamily, fontSize: 26, height: 2),
        ),
        for (final t in translations) ...[
          const Divider(height: 28),
          Text(
            '${t.e.name} — ${t.e.language.toUpperCase()}',
            style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w700, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(t.content, style: const TextStyle(fontSize: 16, height: 1.5)),
          ),
        ],
      ],
    );
  }
}
