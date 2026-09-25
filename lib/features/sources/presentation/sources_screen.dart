import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/widgets/coming_soon.dart';
import '../../../l10n/app_localizations.dart';

typedef _Source = ({String title, String author, String license, String url});

/// Sources du contenu (lues dans content.sqlite), polices, et avis de
/// copyright Tanzil que la licence impose d'afficher.
final _sourcesProvider = FutureProvider<({List<_Source> sources, String tanzilNotice})>((
  ref,
) async {
  final db = ref.watch(contentDatabaseProvider);
  final raw = await db.metaValue(key: 'sources').getSingle();
  final notice = await db.metaValue(key: 'tanzil_notice').getSingle();
  final list = (jsonDecode(raw) as List<dynamic>).cast<Map<String, dynamic>>();
  return (
    sources: [
      for (final s in list)
        (
          title: s['title'] as String,
          author: s['author'] as String,
          license: s['license'] as String,
          url: s['url'] as String,
        ),
    ],
    tanzilNotice: notice,
  );
});

const _fonts = <_Source>[
  (
    title: 'IBM Plex Sans Arabic',
    author: 'IBM',
    license: 'SIL Open Font License 1.1',
    url: 'https://github.com/IBM/plex',
  ),
  (
    title: 'Amiri Quran',
    author: 'Khaled Hosny — Amiri Project',
    license: 'SIL Open Font License 1.1',
    url: 'https://github.com/aliftype/amiri',
  ),
];

class SourcesScreen extends ConsumerWidget {
  const SourcesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final data = ref.watch(_sourcesProvider);
    final scheme = Theme.of(context).colorScheme;

    Widget sourceTile(_Source s) => ListTile(
      title: Text(s.title),
      subtitle: Text('${s.author}\n${s.license}\n${s.url}'),
      isThreeLine: true,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l.sourcesTitle)),
      body: data.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => LoadErrorView(onRetry: () => ref.invalidate(_sourcesProvider)),
        data: (d) => ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            Padding(padding: const EdgeInsets.all(20), child: Text(l.sourcesIntro)),
            ...d.sources.map(sourceTile),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
              child: Text(
                l.fontsTitle,
                style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w700),
              ),
            ),
            ..._fonts.map(sourceTile),
            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: Text(l.softwareLicenses),
              onTap: () => showLicensePage(context: context, applicationName: l.appTitle),
            ),
            ExpansionTile(
              title: Text(l.tanzilNoticeTitle),
              childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              children: [
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: SelectableText(
                    d.tanzilNotice,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(Icons.lock_outline, color: scheme.primary),
                  const SizedBox(width: 12),
                  Expanded(child: Text(l.privacyNote)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
