import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/calendar/hijri_date.dart';
import '../../../core/providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../prayer_times/application/prayer_providers.dart';
import '../../prayer_times/presentation/widgets/location_header.dart';
import '../../prayer_times/presentation/widgets/next_prayer_card.dart';
import '../../quran/application/quran_providers.dart';
import '../../quran/presentation/quran_index_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final settings = ref.watch(settingsProvider);
    final calculator = ref.watch(prayerCalculatorProvider);
    final now = ref.watch(clockProvider).value ?? DateTime.now();
    final today = calculator?.localToday(now) ?? DateTime(now.year, now.month, now.day);
    final hijri = HijriDate.fromGregorian(today, adjustmentDays: settings.hijriAdjustment);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            Text(
              l.homeGreeting,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700, color: scheme.primary),
            ),
            const SizedBox(height: 4),
            Text(
              hijri.format(locale),
              style: TextStyle(fontSize: 16, color: scheme.tertiary, fontWeight: FontWeight.w600),
            ),
            Text(
              DateFormat.yMMMMEEEEd(locale).format(today),
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 4),
            if (settings.location != null) const LocationHeader(),
            const SizedBox(height: 8),
            const NextPrayerCard(),
            if (settings.lastReadPage != null) ...[
              const SizedBox(height: 16),
              _ContinueReadingCard(page: settings.lastReadPage!),
            ],
          ],
        ),
      ),
    );
  }
}

class _ContinueReadingCard extends ConsumerWidget {
  const _ContinueReadingCard({required this.page});

  final int page;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final rows = ref.watch(pageAyahsProvider((page: page, edition: null))).value;
    final surah = rows == null ? null : ref.watch(surahByIdProvider).value?[rows.first.a.surah];
    if (surah == null) return const SizedBox.shrink();

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: NumberBadge(number: surah.id),
        title: Text(l.continueReading),
        subtitle: Text(l.continueReadingPage(page, isArabic ? surah.nameAr : surah.nameTranslit)),
        trailing: const Icon(Icons.menu_book_outlined),
        onTap: () => openMushafPage(context, page),
      ),
    );
  }
}
