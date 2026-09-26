import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    Widget soon(IconData icon, String title) => ListTile(
      enabled: false,
      leading: Icon(icon),
      title: Text(title),
      trailing: Chip(label: Text(l.comingSoon), visualDensity: VisualDensity.compact),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l.moreTitle)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.auto_stories_outlined),
            title: Text(l.hadith),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/more/hadith'),
          ),
          soon(Icons.radio_button_checked, l.tasbih),
          soon(Icons.star_outline, l.asmaUlHusna),
          soon(Icons.calendar_month_outlined, l.hijriCalendar),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(l.settingsTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/more/settings'),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l.sourcesTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/more/sources'),
          ),
        ],
      ),
    );
  }
}
