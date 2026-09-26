import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/settings/app_settings.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/hadith_providers.dart';
import '../hadith_screens.dart';
import 'hadith_card.dart';

/// Carte d'accueil : un hadith d'an-Nawawi ou qudsi, différent chaque jour.
class HadithOfTheDayCard extends ConsumerWidget {
  const HadithOfTheDayCard({required this.day, super.key});

  final DateTime day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final hadith = ref.watch(hadithOfTheDayProvider(day)).value;
    final books = ref.watch(hadithBooksProvider).value;
    if (hadith == null || books == null) return const SizedBox.shrink();

    final language = effectiveHadithLanguage(ref, context);
    final lang = Localizations.localeOf(context).languageCode;
    final text =
        switch (language) {
          AppLanguage.ar => hadith.textAr,
          AppLanguage.fr => hadith.textFr,
          _ => hadith.textEn,
        } ??
        hadith.textAr ??
        '';
    final book = books.where((b) => b.id == hadith.book).firstOrNull;
    final scheme = Theme.of(context).colorScheme;
    final isArabic = language == AppLanguage.ar || text == hadith.textAr;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.go('/more/hadith/${hadith.book}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_stories_outlined, color: scheme.tertiary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    l.hadithOfTheDay,
                    style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                text,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                style: TextStyle(height: isArabic ? 1.8 : 1.5, fontSize: isArabic ? 16.5 : 14.5),
              ),
              const SizedBox(height: 8),
              Text(
                '${book == null ? '' : bookName(book, lang)} · '
                '${l.hadithNumber(hadithNumberLabel(hadith.number))}',
                style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
