import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/database/content_database.dart';
import '../../../core/providers.dart';
import '../../../core/text/search_normalizer.dart';
import '../../../core/widgets/coming_soon.dart';
import '../../../l10n/app_localizations.dart';
import '../../quran/presentation/quran_index_screen.dart';

final adhkarCategoriesProvider = FutureProvider<List<AdhkarCategory>>(
  (ref) => ref.watch(contentDatabaseProvider).allAdhkarCategories().get(),
);

final adhkarOfCategoryProvider = FutureProvider.family<List<AdhkarData>, int>(
  (ref, category) => ref.watch(contentDatabaseProvider).adhkarOfCategory(category: category).get(),
);

/// Chapitres mis en avant : matin et soir, sommeil, réveil, après la prière.
const _essentialIds = [27, 28, 1, 25];

/// Titre d'un chapitre : arabe en arabe, sinon anglais (français à venir).
String categoryTitle(AdhkarCategory c, String languageCode) => switch (languageCode) {
  'ar' => c.titleAr,
  'fr' => c.titleFr ?? c.titleEn,
  _ => c.titleEn,
};

/// Onglet « Adhkar » : tasbih, chapitres essentiels, puis tous les
/// chapitres de Hisn al-Muslim avec une recherche.
class AdhkarHomeScreen extends ConsumerStatefulWidget {
  const AdhkarHomeScreen({super.key});

  @override
  ConsumerState<AdhkarHomeScreen> createState() => _AdhkarHomeScreenState();
}

class _AdhkarHomeScreenState extends ConsumerState<AdhkarHomeScreen> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final scheme = Theme.of(context).colorScheme;
    final categories = ref.watch(adhkarCategoriesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.navAdhkar)),
      body: categories.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => LoadErrorView(onRetry: () => ref.invalidate(adhkarCategoriesProvider)),
        data: (list) {
          final byId = {for (final c in list) c.id: c};
          final query = normalizeForSearch(_filter);
          final filtered = query.isEmpty
              ? list
              : list
                    .where(
                      (c) =>
                          normalizeForSearch('${c.titleAr} ${c.titleEn} ${c.titleFr ?? ''}')
                              .contains(query),
                    )
                    .toList();
          return ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Card(
                  child: ListTile(
                    leading: Icon(Icons.radio_button_checked, color: scheme.primary),
                    title: Text(l.tasbih, style: const TextStyle(fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.go('/adhkar/tasbih'),
                  ),
                ),
              ),
              _SectionTitle(l.adhkarEssentials),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.7,
                  children: [
                    for (final id in _essentialIds)
                      if (byId[id] case final c?)
                        Card(
                          margin: const EdgeInsets.all(4),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => context.go('/adhkar/${c.id}'),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    c.titleAr,
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: scheme.primary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                  if (lang != 'ar')
                                    Text(
                                      categoryTitle(c, lang),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        color: scheme.onSurfaceVariant,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                  ],
                ),
              ),
              _SectionTitle(l.adhkarAllChapters),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextField(
                  onChanged: (v) => setState(() => _filter = v),
                  decoration: InputDecoration(
                    hintText: l.adhkarSearchHint,
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
              for (final c in filtered)
                ListTile(
                  leading: NumberBadge(number: c.position + 1),
                  title: Text(
                    lang == 'ar' ? c.titleAr : categoryTitle(c, lang),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: lang == 'ar'
                      ? null
                      : Text(c.titleAr, textDirection: TextDirection.rtl, maxLines: 1),
                  trailing: Text(
                    '${c.itemCount}',
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                  onTap: () => context.go('/adhkar/${c.id}'),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 8),
    child: Text(
      text,
      style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700),
    ),
  );
}

/// Un chapitre : chaque invocation avec son compteur de répétitions.
class AdhkarCategoryScreen extends ConsumerStatefulWidget {
  const AdhkarCategoryScreen({required this.categoryId, super.key});

  final int categoryId;

  @override
  ConsumerState<AdhkarCategoryScreen> createState() => _AdhkarCategoryScreenState();
}

class _AdhkarCategoryScreenState extends ConsumerState<AdhkarCategoryScreen> {
  /// Répétitions faites, par invocation (le temps de la visite).
  final _done = <int, int>{};

  void _count(AdhkarData d) {
    final current = _done[d.id] ?? 0;
    if (current >= d.repeatCount) return;
    setState(() => _done[d.id] = current + 1);
    if (current + 1 == d.repeatCount) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.selectionClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final category = ref
        .watch(adhkarCategoriesProvider)
        .value
        ?.where((c) => c.id == widget.categoryId)
        .firstOrNull;
    final items = ref.watch(adhkarOfCategoryProvider(widget.categoryId));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          category == null ? '' : (lang == 'ar' ? category.titleAr : categoryTitle(category, lang)),
        ),
        actions: [
          IconButton(
            tooltip: l.restart,
            icon: const Icon(Icons.restart_alt),
            onPressed: () => setState(_done.clear),
          ),
        ],
      ),
      body: items.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => LoadErrorView(
          onRetry: () => ref.invalidate(adhkarOfCategoryProvider(widget.categoryId)),
        ),
        data: (list) => ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
              child: Text(
                l.adhkarTapHint,
                style: TextStyle(
                  fontSize: 12.5,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            for (final d in list)
              _DhikrCard(dhikr: d, done: _done[d.id] ?? 0, onTap: () => _count(d)),
          ],
        ),
      ),
    );
  }
}

class _DhikrCard extends StatelessWidget {
  const _DhikrCard({required this.dhikr, required this.done, required this.onTap});

  final AdhkarData dhikr;
  final int done;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final scheme = Theme.of(context).colorScheme;
    final finished = done >= dhikr.repeatCount;
    final translation = switch (lang) {
      'ar' => null,
      'fr' => dhikr.textFr ?? dhikr.textEn,
      _ => dhikr.textEn,
    };
    final pendingFrench = lang == 'fr' && dhikr.textFr == null && dhikr.textEn != null;

    return Opacity(
      opacity: finished ? 0.55 : 1,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          onLongPress: () async {
            await Clipboard.setData(ClipboardData(text: dhikr.textAr));
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.copied)));
            }
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  dhikr.textAr,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(fontFamily: quranFontFamily, fontSize: 22, height: 1.9),
                ),
                if (lang != 'ar' && dhikr.transliteration != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    dhikr.transliteration!,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: scheme.primary,
                      height: 1.45,
                    ),
                  ),
                ],
                if (translation != null) ...[
                  const SizedBox(height: 8),
                  if (pendingFrench)
                    Text(
                      l.translationEnglishPending,
                      style: TextStyle(fontSize: 11.5, color: scheme.onSurfaceVariant),
                    ),
                  Text(
                    translation,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(height: 1.5, color: scheme.onSurfaceVariant),
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  children: [
                    Chip(
                      visualDensity: VisualDensity.compact,
                      avatar: Icon(
                        finished ? Icons.check_circle : Icons.repeat,
                        size: 18,
                        color: finished ? scheme.primary : scheme.tertiary,
                      ),
                      label: Text(
                        finished
                            ? l.adhkarDone
                            : '${l.adhkarProgress(done, dhikr.repeatCount)} · ${l.repeatTimes(dhikr.repeatCount)}',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
