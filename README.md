# Sakinah – سكينة

Application musulmane gratuite, sans publicité et 100 % hors-ligne (Android et iOS) :
Coran, horaires de prière, Qibla, adhkar, hadiths… en arabe, français et anglais.

Plan complet du produit : [docs/PLAN.md](docs/PLAN.md).

## Fonctionnalités

- **Coran** : mushaf de Médine (604 pages) lu en défilement vertical continu, chaque langue sur
  ses propres pages (arabe, français, anglais), index sourates / juz / hizb, recherche, signets,
  tafsir Al-Muyassar,
  récitation audio verset par verset (8 récitateurs, arrière-plan, écoute hors-ligne après la
  première lecture).
- **Prière** : horaires calculés sur le téléphone (méthode selon le pays), notifications à l'heure
  de chaque prière et rappel avant, tableau mensuel, date hégirienne.
- **Qibla** : boussole en direct, corrigée de la déclinaison magnétique (WMM-2025).
- **Adhkar** : Hisn al-Muslim complet (132 chapitres), compteurs de répétitions, rappels matin et
  soir ; **Tasbih**.
- **Hadiths** : an-Nawawi, Qudsi, Bukhari, Muslim, Muwatta Malik, en arabe, français et anglais,
  avec recherche.
- **Khatma** : lire tout le Coran en 7 à 60 jours, objectif de pages du jour, avance / retard,
  rappel quotidien.
- **Les 99 noms d'Allah** et **calendrier hégirien** (Umm al-Qura, correction ±2 jours,
  événements : Ramadan, Aïd, 'Arafa, Achoura, jours blancs…).
- **Widget Android** « Horaires de prière » : prochaine prière et horaires du jour, mis à jour à
  chaque heure de prière sans ouvrir l'app.
- **Accueil** : prochaine prière, verset et hadith du jour, adhkar, khatma, reprise de lecture.
- Hors-ligne, sans compte, sans publicité, sans collecte de données. Seule l'audio de récitation
  est téléchargée à la première écoute d'un verset.

## Démarrer

```bash
flutter pub get
flutter run
```

La base de contenu `assets/db/content.sqlite` est déjà construite et versionnée, il n'y a rien
à télécharger pour lancer l'app.

## Vérifier

```bash
flutter analyze
flutter test
```

Les tests couvrent :
- les horaires de prière, comparés aux valeurs de référence d'Adhan, et le planning des notifications ;
- la Qibla et la déclinaison magnétique (valeurs de test officielles NOAA WMM2025) ;
- la normalisation de l'arabe et la recherche (Coran, hadiths) ;
- l'intégrité du Coran : SHA-256 du texte identique à Tanzil, 6 236 versets, juz, pages et sajdas ;
- la mise en page du mushaf (taille qui fait tenir la page), les index, les signets ;
- l'intégrité des recueils de hadiths et des adhkar, le tasbih, la file de récitation ;
- des tests d'interface de l'app complète, en français, anglais et arabe (RTL).

## Contenu : `tool/content_pipeline/`

`content.sqlite` est construit par un script reproductible :

```bash
dart run tool/content_pipeline/build_content_db.dart
```

Le script :
- télécharge les sources (Tanzil, GeoNames), environ 215 Mo mis en cache dans `tool/content_pipeline/.cache/` ;
- vérifie leurs sommes SHA-256 contre `sources.lock.json` ;
- construit la base et génère `docs/SOURCES.md`.

Si une source a changé, le script s'arrête. Vérifiez le changement, puis relancez avec `--update-lock`.

Le schéma de la base est défini une seule fois, dans `lib/core/database/content_schema.drift`.
Drift en génère le code Dart, et le pipeline l'exécute tel quel. Après toute modification :

```bash
dart run tool/content_pipeline/build_content_db.dart
dart run build_runner build
```

**Le texte du Coran n'est jamais modifié.** Il est stocké verbatim (licence Tanzil). Seule une
colonne normalisée est ajoutée pour la recherche.

## Structure

```
lib/
  app/          routeur (5 onglets), thème, MaterialApp
  core/         base de contenu, réglages, localisation, calendrier hégirien, texte
  features/     home, quran, prayer_times, qibla, adhkar, hadith, tasbih, asma_husna, calendar,
                khatma, widgets, location, settings, sources, more
  l10n/         traductions de l'interface (app_fr.arb = modèle, app_ar.arb, app_en.arb)
tool/content_pipeline/   construction de content.sqlite
test/                    tests unitaires, de contenu et d'interface
```

## iOS (Codemagic)

`codemagic.yaml` : `ios-testflight` (signé, envoyé sur TestFlight) et `ios-build-only` (compilation
sans signature). La clé du certificat se trouve dans le groupe Codemagic `sakina_env`
(`CERTIFICATE_PRIVATE_KEY`), jamais dans ce dépôt. Les fichiers `ios/Runner/*.lproj/InfoPlist.strings`
(message d'autorisation de localisation en FR, AR, EN) doivent être ajoutés au projet dans Xcode.

## Widget d'écran d'accueil

- **Android** : `PrayerTimesWidgetProvider.kt` + `res/layout/prayer_times_widget.xml`. L'app
  enregistre les horaires des 7 prochains jours (`lib/features/widgets/prayer_widget.dart`) et
  programme une mise à jour à chaque heure de prière ; le widget choisit lui-même la prochaine
  prière. Ajout depuis l'app : Plus → « Ajouter le widget à l'écran d'accueil ».
- **iOS** : un widget iOS demande une extension WidgetKit (cible Xcode en Swift + App Group
  partagé avec l'app), qu'on ne peut créer que dans Xcode sur un Mac. Les données sont déjà prêtes
  (clé `prayer_widget`, JSON) : il suffira d'ajouter la cible, de régler l'App Group
  (`HomeWidget.setAppGroupId`) et d'écrire la vue SwiftUI.
