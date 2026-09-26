import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/quran_providers.dart';
import '../../application/recitation.dart';
import '../../domain/reciters.dart';

/// Lance la récitation d'un verset jusqu'à la fin de sa sourate.
Future<void> playFromAyah(
  WidgetRef ref,
  BuildContext context, {
  required int surah,
  required int number,
}) async {
  final lang = Localizations.localeOf(context).languageCode;
  final ayahs = await ref
      .read(contentDatabaseProvider)
      .surahAyahsFrom(surah: surah, fromNumber: number)
      .get();
  final surahs = await ref.read(surahByIdProvider.future);
  await ref
      .read(recitationProvider.notifier)
      .play(
        [for (final a in ayahs) (id: a.id, surah: a.surah, number: a.number, page: a.page)],
        titleOf: (s, n) {
          final name = surahs[s];
          final label = name == null ? '$s' : (lang == 'ar' ? name.nameAr : name.nameTranslit);
          return '$label $s:$n';
        },
      );
}

/// Barre de lecture en bas du lecteur : récitateur, précédent, lecture,
/// suivant, répétition du verset, arrêt.
class RecitationBar extends ConsumerWidget {
  const RecitationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final state = ref.watch(recitationProvider);
    final controller = ref.read(recitationProvider.notifier);
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surfaceContainerHigh,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state.error)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    l.audioNeedsInternet,
                    style: TextStyle(color: scheme.error, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => pickReciter(context, ref),
                      icon: const Icon(Icons.record_voice_over_outlined, size: 18),
                      label: Text(state.reciter.displayName(lang), overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  IconButton(
                    tooltip: l.previous,
                    onPressed: controller.previous,
                    icon: const Icon(Icons.skip_previous),
                  ),
                  IconButton.filled(
                    tooltip: state.playing ? l.pause : l.listen,
                    onPressed: controller.togglePlay,
                    icon: Icon(state.playing ? Icons.pause : Icons.play_arrow),
                  ),
                  IconButton(
                    tooltip: l.next,
                    onPressed: controller.next,
                    icon: const Icon(Icons.skip_next),
                  ),
                  IconButton(
                    tooltip: l.repeatVerse,
                    isSelected: state.repeatOne,
                    onPressed: controller.toggleRepeat,
                    icon: const Icon(Icons.repeat_one),
                    selectedIcon: Icon(Icons.repeat_one_on, color: scheme.primary),
                  ),
                  IconButton(
                    tooltip: l.stop,
                    onPressed: controller.stop,
                    icon: const Icon(Icons.stop),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Choix du récitateur (appliqué à la prochaine lecture).
Future<void> pickReciter(BuildContext context, WidgetRef ref) async {
  final l = AppLocalizations.of(context);
  final lang = Localizations.localeOf(context).languageCode;
  final current = ref.read(recitationProvider).reciter;
  final picked = await showDialog<Reciter>(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(l.reciter),
      children: [
        RadioGroup<Reciter>(
          groupValue: current,
          onChanged: (r) => Navigator.of(context).pop(r),
          child: Column(
            children: [
              for (final r in Reciter.values)
                RadioListTile<Reciter>(
                  value: r,
                  title: Text(r.displayName(lang)),
                  subtitle: lang == 'ar' ? null : Text(r.nameAr, textDirection: TextDirection.rtl),
                ),
            ],
          ),
        ),
      ],
    ),
  );
  if (picked != null) await ref.read(recitationProvider.notifier).setReciter(picked);
}
