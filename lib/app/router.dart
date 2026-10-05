import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/providers.dart';
import '../features/adhkar/presentation/adhkar_screens.dart';
import '../features/asma_husna/presentation/asma_husna_screen.dart';
import '../features/calendar/presentation/hijri_calendar_screen.dart';
import '../features/dedication/presentation/dedication.dart';
import '../features/hadith/presentation/hadith_screens.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/khatma/presentation/khatma_screen.dart';
import '../features/location/presentation/location_picker_screen.dart';
import '../features/more/presentation/more_screen.dart';
import '../features/onboarding/presentation/welcome_screen.dart';
import '../features/prayer_times/presentation/monthly_timetable_screen.dart';
import '../features/prayer_times/presentation/prayer_times_screen.dart';
import '../features/qibla/presentation/qibla_compass_screen.dart';
import '../features/quran/domain/page_layout.dart';
import '../features/quran/presentation/mushaf_screen.dart';
import '../features/quran/presentation/quran_index_screen.dart';
import '../features/quran/presentation/quran_search_screens.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/sources/presentation/sources_screen.dart';
import '../features/tasbih/presentation/tasbih_screen.dart';
import '../l10n/app_localizations.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Cinq onglets (Accueil, Coran, Prière, Adhkar, Plus), chacun avec sa
/// propre pile de navigation ; le choix du lieu s'ouvre en plein écran.
/// Au premier lancement, l'écran de bienvenue passe avant tout le reste.
GoRouter buildRouter(WidgetRef ref) => GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  redirect: (context, state) {
    final settings = ref.read(settingsProvider);
    final needsWelcome = !settings.onboardingDone && settings.location == null;
    final path = state.matchedLocation;
    if (needsWelcome && path != '/welcome' && path != '/location') return '/welcome';
    return null;
  },
  routes: [
    GoRoute(path: '/welcome', builder: (_, _) => const WelcomeScreen()),
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => _TabScaffold(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [GoRoute(path: '/home', builder: (_, _) => const HomeScreen())],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/quran',
              builder: (_, _) => const QuranIndexScreen(),
              routes: [
                GoRoute(path: 'search', builder: (_, _) => const QuranSearchScreen()),
                GoRoute(path: 'khatma', builder: (_, _) => const KhatmaScreen()),
                // Lecteur en plein écran (sans la barre d'onglets).
                GoRoute(
                  path: 'page/:page',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (_, state) => MushafScreen(
                    initialPage: (int.tryParse(state.pathParameters['page']!) ?? 1).clamp(
                      1,
                      mushafPageCount,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/prayer',
              builder: (_, _) => const PrayerTimesScreen(),
              routes: [GoRoute(path: 'month', builder: (_, _) => const MonthlyTimetableScreen())],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/adhkar',
              builder: (_, _) => const AdhkarHomeScreen(),
              routes: [
                GoRoute(path: 'tasbih', builder: (_, _) => const TasbihScreen()),
                GoRoute(
                  path: ':category',
                  builder: (_, state) => AdhkarCategoryScreen(
                    categoryId: int.tryParse(state.pathParameters['category']!) ?? 27,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/more',
              builder: (_, _) => const MoreScreen(),
              routes: [
                GoRoute(path: 'settings', builder: (_, _) => const SettingsScreen()),
                GoRoute(path: 'sources', builder: (_, _) => const SourcesScreen()),
                GoRoute(path: 'tasbih', builder: (_, _) => const TasbihScreen()),
                GoRoute(path: 'names', builder: (_, _) => const AsmaHusnaScreen()),
                GoRoute(path: 'calendar', builder: (_, _) => const HijriCalendarScreen()),
                GoRoute(path: 'dedication', builder: (_, _) => const DedicationScreen()),
                GoRoute(
                  path: 'hadith',
                  builder: (_, _) => const HadithBooksScreen(),
                  routes: [
                    GoRoute(path: 'search', builder: (_, _) => const HadithSearchScreen()),
                    GoRoute(
                      path: ':book',
                      builder: (_, state) =>
                          HadithBookScreen(bookId: state.pathParameters['book']!),
                      routes: [
                        GoRoute(
                          path: ':section',
                          builder: (_, state) => HadithListScreen(
                            bookId: state.pathParameters['book']!,
                            section: int.tryParse(state.pathParameters['section']!) ?? 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    // Boussole Qibla en plein écran, ouverte depuis l'accueil, l'onglet
    // Prière, l'onglet Plus ou le raccourci de l'icône de l'app.
    GoRoute(
      path: '/qibla',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, _) => const QiblaCompassScreen(),
    ),
    GoRoute(
      path: '/location',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (_, _) =>
          const MaterialPage(fullscreenDialog: true, child: LocationPickerScreen()),
    ),
  ],
);

class _TabScaffold extends StatelessWidget {
  const _TabScaffold({required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    // Retour depuis la racine d'un autre onglet : revenir à l'Accueil au lieu
    // de quitter l'app (on ne quitte que depuis l'Accueil).
    return PopScope(
      canPop: shell.currentIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) shell.goBranch(0);
      },
      child: Scaffold(
        body: shell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: shell.currentIndex,
          onDestinationSelected: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: l.navHome,
            ),
            NavigationDestination(
              icon: const Icon(Icons.menu_book_outlined),
              selectedIcon: const Icon(Icons.menu_book),
              label: l.navQuran,
            ),
            NavigationDestination(
              icon: const Icon(Icons.access_time),
              selectedIcon: const Icon(Icons.access_time_filled),
              label: l.navPrayer,
            ),
            NavigationDestination(
              icon: const Icon(Icons.self_improvement_outlined),
              selectedIcon: const Icon(Icons.self_improvement),
              label: l.navAdhkar,
            ),
            NavigationDestination(
              icon: const Icon(Icons.grid_view_outlined),
              selectedIcon: const Icon(Icons.grid_view),
              label: l.navMore,
            ),
          ],
        ),
      ),
    );
  }
}
