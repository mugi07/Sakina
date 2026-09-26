import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/text/search_normalizer.dart';
import '../../../l10n/app_localizations.dart';
import '../../quran/presentation/quran_index_screen.dart';
import '../domain/asma_husna.dart';

String _meaning(DivineName n, String languageCode) => languageCode == 'fr' ? n.fr : n.en;

/// Les 99 noms d'Allah : nom en arabe, translittération, sens.
class AsmaHusnaScreen extends StatefulWidget {
  const AsmaHusnaScreen({super.key});

  @override
  State<AsmaHusnaScreen> createState() => _AsmaHusnaScreenState();
}

class _AsmaHusnaScreenState extends State<AsmaHusnaScreen> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final scheme = Theme.of(context).colorScheme;
    final query = normalizeForSearch(_filter);
    final names = [
      for (final (i, n) in asmaUlHusna.indexed)
        if (query.isEmpty ||
            normalizeForSearch('${n.arabic} ${n.transliteration} ${n.fr} ${n.en}').contains(query))
          (number: i + 1, name: n),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l.asmaUlHusna)),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: TextField(
                onChanged: (v) => setState(() => _filter = v),
                decoration: InputDecoration(
                  hintText: l.asmaSearchHint,
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Text(
                l.asmaReviewNote,
                style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                mainAxisExtent: 170,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: names.length,
              itemBuilder: (context, i) {
                final (:number, :name) = names[i];
                return Card(
                  margin: EdgeInsets.zero,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => _showName(context, number, name),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$number',
                            style: TextStyle(
                              fontSize: 12,
                              color: scheme.tertiary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              name.arabic,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontFamily: quranFontFamily,
                                fontSize: 30,
                                color: scheme.primary,
                                height: 1.6,
                              ),
                            ),
                          ),
                          Text(
                            name.transliteration,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                          if (lang != 'ar')
                            Text(
                              _meaning(name, lang),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showName(BuildContext context, int number, DivineName name) {
    final lang = Localizations.localeOf(context).languageCode;
    final scheme = Theme.of(context).colorScheme;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NumberBadge(number: number),
            const SizedBox(height: 8),
            Text(
              name.arabic,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: quranFontFamily, fontSize: 48, color: scheme.primary),
            ),
            Text(
              name.transliteration,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            if (lang != 'ar') ...[
              const SizedBox(height: 8),
              Text(
                _meaning(name, lang),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: scheme.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
