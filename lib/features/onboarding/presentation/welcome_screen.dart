import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/providers.dart';
import '../../../core/settings/app_settings.dart';
import '../../../l10n/app_localizations.dart';
import '../../prayer_times/application/adhan_notifications.dart';

/// Premier lancement, en trois étapes : langue, ville, notifications.
class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  final _pages = PageController();
  int _step = 0;
  bool? _notificationsGranted;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _next() {
    setState(() => _step++);
    _pages.animateToPage(_step, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void _finish() {
    ref.read(settingsProvider.notifier).update((s) => s.copyWith(onboardingDone: true));
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
    final lang = Localizations.localeOf(context).languageCode;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < 3; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: i == _step ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i <= _step ? scheme.primary : scheme.outlineVariant,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pages,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _Step(
                    icon: null,
                    title: 'سكينة',
                    titleStyle: TextStyle(
                      fontFamily: quranFontFamily,
                      fontSize: 56,
                      color: scheme.primary,
                    ),
                    subtitle: l.welcomeTagline,
                    body: Column(
                      children: [
                        Text(l.welcomeLanguage, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 12),
                        for (final (value, label) in const [
                          (AppLanguage.ar, 'العربية'),
                          (AppLanguage.fr, 'Français'),
                          (AppLanguage.en, 'English'),
                        ])
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: SizedBox(
                              width: 240,
                              child: value.name == lang
                                  ? FilledButton(
                                      onPressed: () => _setLanguage(value),
                                      child: Text(label),
                                    )
                                  : OutlinedButton(
                                      onPressed: () => _setLanguage(value),
                                      child: Text(label),
                                    ),
                            ),
                          ),
                      ],
                    ),
                    actions: [FilledButton(onPressed: _next, child: Text(l.continueLabel))],
                  ),
                  _Step(
                    icon: Icons.location_on_outlined,
                    title: l.welcomeLocationTitle,
                    subtitle: l.welcomeLocationBody,
                    body: settings.location == null
                        ? FilledButton.tonalIcon(
                            onPressed: () => context.push('/location'),
                            icon: const Icon(Icons.search),
                            label: Text(l.chooseLocation),
                          )
                        : Card(
                            child: ListTile(
                              leading: Icon(Icons.check_circle, color: scheme.primary),
                              title: Text(settings.location!.cityName(lang) ?? l.myPosition),
                              subtitle: Text(settings.location!.countryName(lang) ?? ''),
                              trailing: TextButton(
                                onPressed: () => context.push('/location'),
                                child: Text(l.changeLocation),
                              ),
                            ),
                          ),
                    actions: [
                      if (settings.location == null)
                        TextButton(onPressed: _next, child: Text(l.later)),
                      FilledButton(
                        onPressed: settings.location == null ? null : _next,
                        child: Text(l.continueLabel),
                      ),
                    ],
                  ),
                  _Step(
                    icon: Icons.notifications_active_outlined,
                    title: l.welcomeNotifTitle,
                    subtitle: l.welcomeNotifBody,
                    body: _notificationsGranted == true
                        ? Chip(
                            avatar: Icon(Icons.check, color: scheme.primary),
                            label: Text(l.notificationsAllowed),
                          )
                        : FilledButton.tonalIcon(
                            onPressed: () async {
                              final granted = await ref
                                  .read(adhanNotificationsProvider)
                                  .requestPermission();
                              if (mounted) setState(() => _notificationsGranted = granted);
                            },
                            icon: const Icon(Icons.notifications_outlined),
                            label: Text(l.allow),
                          ),
                    actions: [FilledButton(onPressed: _finish, child: Text(l.start))],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setLanguage(AppLanguage language) =>
      ref.read(settingsProvider.notifier).update((s) => s.copyWith(language: language));
}

class _Step extends StatelessWidget {
  const _Step({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.actions,
    this.titleStyle,
  });

  final IconData? icon;
  final String title;
  final TextStyle? titleStyle;
  final String subtitle;
  final Widget body;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  if (icon != null) Icon(icon, size: 64, color: scheme.tertiary),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: titleStyle ?? Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 15),
                  ),
                  const SizedBox(height: 32),
                  body,
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              for (final a in actions)
                Padding(padding: const EdgeInsetsDirectional.only(start: 8), child: a),
            ],
          ),
        ],
      ),
    );
  }
}
