import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/widgets/coming_soon.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/location/presentation/location_picker_screen.dart';
import '../features/more/presentation/more_screen.dart';
import '../features/prayer_times/presentation/prayer_times_screen.dart';
import '../features/quran/presentation/surah_list_screen.dart';
import '../features/quran/presentation/surah_reader_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/sources/presentation/sources_screen.dart';
import '../l10n/app_localizations.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Cinq onglets (Accueil, Coran, Prière, Adhkar, Plus), chacun avec sa
/// propre pile de navigation ; le choix du lieu s'ouvre en plein écran.
GoRouter buildRouter() => GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
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
              builder: (_, _) => const SurahListScreen(),
              routes: [
                GoRoute(
                  path: 'surah/:id',
                  builder: (_, state) =>
                      SurahReaderScreen(surahId: int.parse(state.pathParameters['id']!)),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/prayer', builder: (_, _) => const PrayerTimesScreen())],
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
