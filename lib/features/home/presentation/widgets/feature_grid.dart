import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../qibla/presentation/qibla_card.dart';
import 'feature_icons.dart';

/// Grille d'icônes de l'accueil : toutes les rubriques en un coup d'œil.
class FeatureGrid extends StatelessWidget {
  const FeatureGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final items = <(HomeFeature, String, VoidCallback)>[
      (HomeFeature.quran, l.navQuran, () => context.go('/quran')),
      (HomeFeature.prayerTimes, l.prayerTimesTitle, () => context.go('/prayer')),
      (HomeFeature.qibla, l.qibla, () => openQiblaCompass(context)),
      (HomeFeature.adhkar, l.navAdhkar, () => context.go('/adhkar')),
      (HomeFeature.tasbih, l.tasbih, () => context.go('/more/tasbih')),
      (HomeFeature.hadith, l.hadith, () => context.go('/more/hadith')),
      (HomeFeature.names, l.asmaUlHusna, () => context.go('/more/names')),
      (HomeFeature.calendar, l.hijriCalendar, () => context.go('/more/calendar')),
      (HomeFeature.khatma, l.khatmaTitle, () => context.go('/quran/khatma')),
    ];
    // Hauteur d'une case : icône + deux lignes de texte (à la taille choisie
    // par l'utilisateur dans les réglages du téléphone).
    final extent = 92 + MediaQuery.textScalerOf(context).scale(13) * 2.6;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: extent,
          ),
          itemBuilder: (context, i) {
            final (feature, label, onTap) = items[i];
            return _FeatureTile(feature: feature, label: label, onTap: onTap);
          },
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({required this.feature, required this.label, required this.onTap});

  final HomeFeature feature;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 12, 4, 6),
          child: Column(
            children: [
              FeatureIcon(feature, size: 62),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, height: 1.25),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
