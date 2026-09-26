import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/database/content_database.dart';
import '../../../../core/providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../khatma/application/khatma_controller.dart';
import '../../../khatma/domain/khatma_plan.dart';
import '../../../prayer_times/application/prayer_providers.dart';
import '../../../prayer_times/domain/prayer_calculator.dart';
import '../../../quran/application/quran_providers.dart';
import '../../../quran/domain/quran_text.dart';
import '../../../quran/presentation/quran_index_screen.dart';

/// Versets connus qui ont un sens complet seuls (références uniquement :
/// le texte vient de la base Tanzil).
const dailyVerses = [
  (2, 152),
  (2, 153),
  (2, 186),
  (2, 201),
  (2, 255),
  (2, 286),
  (3, 8),
  (3, 139),
  (3, 159),
  (3, 173),
  (3, 185),
  (3, 200),
  (6, 162),
  (7, 23),
  (7, 56),
  (9, 51),
  (10, 62),
  (11, 6),
  (12, 87),
  (13, 11),
  (13, 28),
  (14, 7),
  (16, 18),
  (16, 97),
  (17, 24),
  (18, 10),
  (18, 46),
  (20, 114),
  (21, 87),
  (23, 118),
  (25, 63),
  (25, 74),
  (29, 45),
  (29, 69),
  (33, 41),
  (33, 56),
  (39, 53),
  (40, 60),
  (49, 10),
  (49, 13),
  (50, 16),
  (51, 56),
  (55, 13),
  (57, 4),
  (59, 22),
  (64, 11),
  (65, 3),
  (67, 2),
  (93, 5),
  (94, 5),
  (94, 6),
  (112, 1),
];

/// Référence du verset du jour : la même toute la journée, différente
/// d'un jour à l'autre.
(int, int) verseOfTheDayReference(DateTime day) {
  final dayNumber = DateTime.utc(day.year, day.month, day.day).millisecondsSinceEpoch ~/ 86400000;
  return dailyVerses[dayNumber % dailyVerses.length];
}

final _verseProvider =
    FutureProvider.family<AyahByReferenceResult?, ({DateTime day, String edition})>((
      ref,
      arg,
    ) async {
      final (surah, number) = verseOfTheDayReference(arg.day);
      return ref
          .watch(contentDatabaseProvider)
          .ayahByReference(surah: surah, number: number, edition: arg.edition)
          .getSingleOrNull();
    });

class VerseOfTheDayCard extends ConsumerWidget {
  const VerseOfTheDayCard({required this.day, super.key});

  final DateTime day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final edition = switch (lang) {
      'fr' => 'fr.hamidullah',
      'en' => 'en.sahih',
      _ => '',
    };
    final verse = ref.watch(_verseProvider((day: day, edition: edition))).value;
    final surah = verse == null ? null : ref.watch(surahByIdProvider).value?[verse.a.surah];
    if (verse == null || surah == null) return const SizedBox.shrink();
    final a = verse.a;
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => openMushafPage(context, a.page),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome_outlined, color: scheme.tertiary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    l.verseOfTheDay,
                    style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${ayahDisplayText(surah: a.surah, number: a.number, text: a.textUthmani)}'
                ' ${ayahEndMark(a.number)}',
                textDirection: TextDirection.rtl,
                style: const TextStyle(fontFamily: quranFontFamily, fontSize: 21, height: 1.9),
              ),
              if (verse.translation != null) ...[
                const SizedBox(height: 6),
                Text(
                  verse.translation!,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(color: scheme.onSurfaceVariant, height: 1.5),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                '${lang == 'ar' ? 'سورة ${surah.nameAr}' : surah.nameTranslit} ${a.surah}:${a.number}',
                style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Raccourci vers les adhkar du matin (jusqu'au Asr) ou du soir (après le Asr).
class AdhkarShortcutCard extends ConsumerWidget {
  const AdhkarShortcutCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final now = ref.watch(clockProvider).value ?? DateTime.now();
    final calculator = ref.watch(prayerCalculatorProvider);
    final bool evening;
    if (calculator == null) {
      evening = now.hour >= 15 || now.hour < 3;
    } else {
      final day = calculator.forDay(calculator.localToday(now));
      evening = now.isAfter(day[Salah.asr]) || now.isBefore(day[Salah.fajr]);
    }
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Icon(
          evening ? Icons.nights_stay_outlined : Icons.wb_sunny_outlined,
          color: scheme.tertiary,
        ),
        title: Text(
          evening ? l.eveningAdhkar : l.morningAdhkar,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.chevron_right),
        // Chapitre « matin et soir » de Hisn al-Muslim.
        onTap: () => context.go('/adhkar/27'),
      ),
    );
  }
}

/// Khatma en cours : jour, pages restantes aujourd'hui (rien s'il n'y en a pas).
class KhatmaHomeCard extends ConsumerWidget {
  const KhatmaHomeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(khatmaProvider);
    if (plan == null || plan.isCompleted) return const SizedBox.shrink();
    final l = AppLocalizations.of(context);
    final today = DateTime.now();
    final scheme = Theme.of(context).colorScheme;
    final behind = plan.status(today) == KhatmaStatus.behind;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: SizedBox.square(
            dimension: 40,
            child: CircularProgressIndicator(
              value: plan.progress,
              strokeWidth: 5,
              backgroundColor: scheme.primary.withValues(alpha: 0.12),
            ),
          ),
          title: Text(
            '${l.khatmaTitle} · ${l.khatmaDayOf(plan.dayNumber(today), plan.days)}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            behind
                ? l.khatmaBehind(plan.pagesBehind(today))
                : l.khatmaRemainingToday(plan.remainingToday(today)),
            style: TextStyle(color: behind ? scheme.error : null),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go('/quran/khatma'),
        ),
      ),
    );
  }
}
