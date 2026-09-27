import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../hadith/presentation/widgets/hadith_of_the_day_card.dart';
import '../../prayer_times/application/prayer_providers.dart';
import '../../quran/application/quran_providers.dart';
import '../../quran/presentation/quran_index_screen.dart';
import 'widgets/daily_cards.dart';
import 'widgets/feature_grid.dart';
import 'widgets/home_header.dart';

/// Accueil : ciel du moment avec la prochaine prière, grille d'icônes de
/// toutes les rubriques, puis rappels et lectures du jour.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scroll = ScrollController();

  /// Vrai dès que le ciel commence à passer sous la barre d'état.
  final _scrolled = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() => _scrolled.value = _scroll.offset > 4);
  }

  @override
  void dispose() {
    _scroll.dispose();
    _scrolled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final calculator = ref.watch(prayerCalculatorProvider);
    final now = ref.watch(clockProvider).value ?? DateTime.now();
    final today = calculator?.localToday(now) ?? DateTime(now.year, now.month, now.day);
    final period = skyPeriod(calculator?.forDay(today), now);

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        // Icônes claires de la barre d'état, sur le ciel.
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: [
            ListView(
              controller: _scroll,
              padding: EdgeInsets.zero,
              children: [
                HomeHeader(period: period),
                // La grille chevauche le bas du ciel.
                Transform.translate(
                  offset: const Offset(0, -24),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: FeatureGrid(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const AdhkarShortcutCard(),
                      if (settings.lastReadPage != null) ...[
                        const SizedBox(height: 12),
                        _ContinueReadingCard(page: settings.lastReadPage!),
                      ],
                      const KhatmaHomeCard(),
                      const SizedBox(height: 16),
                      VerseOfTheDayCard(day: today),
                      const SizedBox(height: 16),
                      HadithOfTheDayCard(day: today),
                    ],
                  ),
                ),
              ],
            ),
            // Quand on fait défiler, bande de la couleur du ciel sous la barre
            // d'état, pour que l'heure et la batterie restent lisibles.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.paddingOf(context).top,
              child: ValueListenableBuilder(
                valueListenable: _scrolled,
                builder: (context, scrolled, child) => AnimatedOpacity(
                  opacity: scrolled ? 1 : 0,
                  duration: const Duration(milliseconds: 150),
                  child: child,
                ),
                child: ColoredBox(color: skyColors[period]!.first),
              ),
            ),
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
