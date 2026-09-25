import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/database/content_database.dart';
import '../../../core/widgets/coming_soon.dart';
import '../../../l10n/app_localizations.dart';
import '../application/quran_providers.dart';

class SurahListScreen extends ConsumerWidget {
  const SurahListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final surahs = ref.watch(surahListProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.quranTitle)),
      body: surahs.when(
        data: (list) => ListView.separated(
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: list.length,
          separatorBuilder: (_, _) => const Divider(height: 1, indent: 76),
          itemBuilder: (context, i) => SurahTile(surah: list[i]),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => LoadErrorView(onRetry: () => ref.invalidate(surahListProvider)),
      ),
    );
  }
}

class SurahTile extends StatelessWidget {
  const SurahTile({required this.surah, super.key});

  final Surah surah;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final scheme = Theme.of(context).colorScheme;
    final type = surah.revelationType == 'meccan' ? l.meccan : l.medinan;

    return ListTile(
      onTap: () => context.go('/quran/surah/${surah.id}'),
      leading: SurahNumberBadge(number: surah.id),
      title: Text(
        isArabic ? 'سورة ${surah.nameAr}' : surah.nameTranslit,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text('$type · ${l.ayahCount(surah.ayahCount)}'),
      trailing: isArabic
          ? null
          : Text(
              surah.nameAr,
              textDirection: TextDirection.rtl,
              style: TextStyle(fontFamily: quranFontFamily, fontSize: 22, color: scheme.primary),
            ),
    );
  }
}

/// Numéro de sourate dans un losange (deux carrés superposés, motif
/// d'étoile à huit branches).
class SurahNumberBadge extends StatelessWidget {
  const SurahNumberBadge({required this.number, super.key});

  final int number;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final border = Border.all(color: scheme.tertiary, width: 1.5);
    return SizedBox.square(
      dimension: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(width: 30, height: 30, decoration: BoxDecoration(border: border)),
          Transform.rotate(
            angle: 0.785398, // 45°
            child: Container(width: 30, height: 30, decoration: BoxDecoration(border: border)),
          ),
          Text('$number', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
