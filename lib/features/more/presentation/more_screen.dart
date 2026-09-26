import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    Widget entry(IconData icon, String title, String location) => ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.go(location),
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
          ListTile(
            leading: const Icon(Icons.radio_button_checked),
            title: Text(l.tasbih),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/more/tasbih'),
          ),
          entry(Icons.star_outline, l.asmaUlHusna, '/more/names'),
          entry(Icons.calendar_month_outlined, l.hijriCalendar, '/more/calendar'),
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
