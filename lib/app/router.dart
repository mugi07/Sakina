import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/providers.dart';
import '../core/widgets/coming_soon.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/location/presentation/location_picker_screen.dart';
import '../features/more/presentation/more_screen.dart';
import '../features/onboarding/presentation/welcome_screen.dart';
import '../features/prayer_times/presentation/monthly_timetable_screen.dart';
import '../features/prayer_times/presentation/prayer_times_screen.dart';
import '../features/qibla/presentation/qibla_compass_screen.dart';
import '../features/quran/domain/page_layout.dart';
import '../features/quran/presentation/mushaf_screen.dart';
import '../features/quran/presentation/quran_index_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/sources/presentation/sources_screen.dart';
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
              routes: [
                GoRoute(path: 'month', builder: (_, _) => const MonthlyTimetableScreen()),
                GoRoute(path: 'qibla', builder: (_, _) => const QiblaCompassScreen()),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/adhkar',
              builder: (context, _) => ComingSoonScreen(
                title: AppLocalizations.of(context).navAdhkar,
                icon: Icons.self_improvement,
              ),
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
              ],
            ),
          ],
        ),
      ],
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
    return Scaffold(
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
    );
  }
}
