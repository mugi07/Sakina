import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/hadith_database.dart';
import '../../../../core/providers.dart';
import '../../../../core/settings/app_settings.dart';
import '../../../../core/share.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/hadith_providers.dart';

/// Langue effective des hadiths : réglage, sinon langue de l'app.
AppLanguage effectiveHadithLanguage(WidgetRef ref, BuildContext context) {
  final chosen = ref.watch(settingsProvider.select((s) => s.hadithLanguage));
  if (chosen != AppLanguage.system) return chosen;
  return switch (Localizations.localeOf(context).languageCode) {
    'ar' => AppLanguage.ar,
    'fr' => AppLanguage.fr,
    _ => AppLanguage.en,
  };
}

/// Choix de la langue des hadiths : une seule langue affichée à la fois.
class HadithLanguageBar extends ConsumerWidget {
  const HadithLanguageBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = effectiveHadithLanguage(ref, context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: SegmentedButton<AppLanguage>(
        showSelectedIcon: false,
        segments: const [
          ButtonSegment(value: AppLanguage.ar, label: Text('العربية')),
          ButtonSegment(value: AppLanguage.fr, label: Text('Français')),
          ButtonSegment(value: AppLanguage.en, label: Text('English')),
        ],
        selected: {language},
        onSelectionChanged: (s) => ref
            .read(settingsProvider.notifier)
            .update((settings) => settings.copyWith(hadithLanguage: s.first)),
      ),
    );
  }
}

/// Un hadith dans une seule langue, avec son numéro et son degré.
class HadithCard extends ConsumerWidget {
  const HadithCard({required this.hadith, this.bookName, super.key});

  final Hadith hadith;

  /// Nom du recueil (affiché dans les résultats de recherche).
  final String? bookName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final language = effectiveHadithLanguage(ref, context);
    final scheme = Theme.of(context).colorScheme;
    final text = switch (language) {
      AppLanguage.ar => hadith.textAr,
      AppLanguage.fr => hadith.textFr,
      _ => hadith.textEn,
    };
    final isArabic = language == AppLanguage.ar;
    final number = hadithNumberLabel(hadith.number);
    final title = [?bookName, l.hadithNumber(number)].join(' · ');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onLongPress: text == null
            ? null
            : () async {
                await Clipboard.setData(ClipboardData(text: '$text\n\n— $title'));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.copied)));
                }
              },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w700),
                    ),
                  ),
                  if (text != null)
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      tooltip: l.share,
                      icon: const Icon(Icons.share_outlined, size: 18),
                      onPressed: () => shareText('$text\n\n— $title'),
                    ),
                  if (text != null)
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      tooltip: l.copy,
                      icon: const Icon(Icons.copy_outlined, size: 18),
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: '$text\n\n— $title'));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(l.copied)));
                        }
                      },
                    ),
                ],
              ),
              const SizedBox(height: 6),
              if (text == null)
                Text(
                  l.translationMissing,
                  style: TextStyle(fontStyle: FontStyle.italic, color: scheme.onSurfaceVariant),
                )
              else
                Text(
                  text,
                  textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                  style: TextStyle(fontSize: isArabic ? 18 : 15.5, height: isArabic ? 1.9 : 1.55),
                ),
              if (hadith.grades != null) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final g in hadith.grades!.split('; '))
                      Chip(
                        visualDensity: VisualDensity.compact,
                        label: Text(g, style: const TextStyle(fontSize: 11.5)),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
