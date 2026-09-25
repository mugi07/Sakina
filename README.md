# Sakina – سكينة

Application musulmane gratuite, sans publicité et 100 % hors-ligne (Android et iOS) :
Coran, horaires de prière, Qibla, adhkar, hadiths… en arabe, français et anglais.

Plan complet du produit : [docs/PLAN.md](docs/PLAN.md).

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
- les horaires de prière, comparés aux valeurs de référence d'Adhan ;
- la Qibla ;
- la normalisation de l'arabe ;
- l'intégrité du Coran : SHA-256 du texte identique à Tanzil, 6 236 versets, juz, pages et sajdas ;
- un test d'interface de l'app complète, en français et en arabe (RTL).

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
  features/     home, quran, prayer_times, qibla, location, settings, sources, more
  l10n/         traductions de l'interface (app_fr.arb = modèle, app_ar.arb, app_en.arb)
tool/content_pipeline/   construction de content.sqlite
test/                    tests unitaires, de contenu et d'interface
```

## iOS (Codemagic)

`codemagic.yaml` : `ios-testflight` (signé, envoyé sur TestFlight) et `ios-build-only` (compilation
sans signature). La clé du certificat se trouve dans le groupe Codemagic `sakina_env`
(`CERTIFICATE_PRIVATE_KEY`), jamais dans ce dépôt. Les fichiers `ios/Runner/*.lproj/InfoPlist.strings`
(message d'autorisation de localisation en FR, AR, EN) doivent être ajoutés au projet dans Xcode.
