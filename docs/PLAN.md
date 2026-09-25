# Plan complet : application musulmane (Coran, Qibla, Horaires, Adhkar, Hadith…)

## Contexte

Vous voulez créer une application musulmane complète pour Android et iOS : Coran, direction de la Qibla, horaires de prière avec adhan, adhkar, hadiths, et d'autres outils du quotidien. Le dossier `C:\Androids ios\Muslim idea` est vide, donc on part de zéro.

Vos choix :
- **Technologie : Flutter.** Déjà installé sur votre PC (Flutter 3.47 / Dart 3.13, SDK Android présent, git présent).
- **Langues : arabe, français et anglais**, avec l'interface en droite-à-gauche (RTL) complète pour l'arabe.
- **Modèle : 100 % gratuit, sans publicité** (sadaqa jariya).
- **Données : 100 % hors-ligne, sans compte ni serveur.** Tout se calcule et se stocke sur le téléphone.

Nom de travail proposé : **« Sakina – سكينة »**. Vous pourrez le changer.

But : une app **fiable** (texte du Coran vérifié, horaires justes, sources citées), **rapide**, **belle** et **respectueuse de la vie privée**. Aucune donnée ne quitte le téléphone.

---

## 1. Fonctionnalités, par version

### V1.0 : MVP (≈ 4 mois pour un développeur seul)

| Module | Contenu |
|---|---|
| **Accueil** | Prochaine prière avec compte à rebours, date hégirienne et grégorienne, verset du jour, hadith du jour, raccourci « Adhkar du matin/soir » selon l'heure, « Continuer la lecture » |
| **Horaires de prière** | Calcul local (paquet `adhan`), méthode choisie automatiquement selon le pays (voir §4), madhab pour l'Asr, ajustement ±min par prière, règle pour les hautes latitudes, tableau mensuel |
| **Adhan / notifications** | Notification à chaque prière avec son d'adhan au choix, rappel X min avant, activation prière par prière, mode silencieux |
| **Qibla** | Boussole avec correction de la déclinaison magnétique, angle en degrés, distance jusqu'à la Kaaba, aide au calibrage (mouvement en 8), vibration quand l'appareil est aligné |
| **Coran** | Liste des sourates, juz et hizb (60 hizb avec quarts et huitièmes, important au Maghreb). Lecteur arabe avec traduction FR ou EN. Tafsir Al-Muyassar (arabe). Recherche arabe (sans tashkīl) et dans les traductions. Signets, dernière lecture, taille de police |
| **Récitation audio** | 4 à 5 récitateurs (Mishary Alafasy, Al-Husary, Abdul Basit, Al-Minshawi, Saad Al-Ghamdi…). Lecture verset par verset avec surlignage. Répétition d'un verset ou d'une plage. Lecture en arrière-plan avec contrôles sur l'écran de verrouillage. Téléchargement par sourate pour écouter hors-ligne |
| **Adhkar** | Hisn al-Muslim par catégories : matin, soir, après la prière, sommeil, réveil, voyage, etc. Compteur par dhikr. Traduction, translittération, source et mérite affichés. Rappels matin/soir |
| **Hadith** | Les 40 hadiths de Nawawi, Riyad as-Salihin, Sahih al-Bukhari, Sahih Muslim (AR + FR + EN selon la disponibilité). Degré d'authenticité affiché, recherche, favoris |
| **Tasbih** | Compteur avec retour haptique, objectifs (33/99/100/libre), historique du jour |
| **Partage** | Partager un verset, un hadith ou un dhikr en texte ou en image (jolie carte) |
| **Réglages** | Langue, thème (clair / sombre / sépia), police arabe, taille du texte, lieu (GPS ou ville choisie hors-ligne), méthode de calcul |
| **Sources et licences** | Écran obligatoire qui cite chaque source de contenu (Tanzil, KFGQPC, etc.) |

### V1.1 (+ 6 à 8 semaines)

- **Mode Mushaf** page par page (604 pages, mise en page de Médine) avec **tajwīd en couleurs**.
- Traduction **mot à mot**.
- **Widgets** sur l'écran d'accueil : horaires de prière, verset du jour.
- **Calendrier hégirien** et événements islamiques (Ramadan, Aïd, Achoura, 'Arafa, jours blancs), avec correction ±1 ou 2 jours selon le pays.
- **Les 99 noms d'Allah** (Asma' al-Husna), avec sens et audio.
- **Planificateur de khatma** (finir le Coran en X jours, rappel quotidien) et statistiques de lecture.
- **Mode Ramadan** : suhoor et iftar, dou'a de rupture du jeûne, suivi du jeûne.
- **Rappel du vendredi** : sourate Al-Kahf et salawat.
- **Sauvegarde / restauration par fichier** : export et import JSON des favoris et de la progression. C'est ce qui remplace le compte pour changer de téléphone.

### V2.0 (+ 3 mois)

- **Riwaya Warsh 'an Nafi'**, très importante au Maghreb, en plus de Hafs.
- **Mode mémorisation (hifz)** : boucle sur une plage de versets, masquage progressif du texte, auto-évaluation, révisions espacées.
- **Autres recueils de hadith** : Muwatta' Malik (important au Maghreb), Abu Dawud, Tirmidhi, Nasa'i, Ibn Majah, Hadith Qudsi.
- **Autres tafsirs** : Ibn Kathir, As-Sa'di.
- **Suivi des prières** : prières faites, prières à rattraper (qada'), statistiques.
- **Guides illustrés** : ablutions (wudu'), prière, prière du mort, Hajj et 'Omra.
- **Recueil de dou'as** (coraniques et prophétiques), roqya.
- **Calculateur de zakat** : l'utilisateur saisit lui-même le prix de l'or et de l'argent, puisque l'app est hors-ligne.
- **Qibla solaire** : alerte les 27-28 mai et 15-16 juillet, quand le soleil est à la verticale de la Kaaba.
- **Montres** : Wear OS et Apple Watch (horaires, compteur tasbih).

---

## 2. Navigation et écrans

Barre du bas avec 5 onglets, inversée automatiquement en arabe :

```
[ Accueil ]  [ Coran ]  [ Prière ]  [ Adhkar ]  [ Plus ]
                           │                       │
                  Horaires + Qibla      Hadith, Tasbih, 99 Noms,
                  + tableau mensuel     Calendrier, Zakat, Réglages,
                                        Sources et licences
```

**Parcours du premier lancement (onboarding)**, 4 écrans :
1. Choix de la langue.
2. Lieu : GPS, ou recherche d'une ville hors-ligne.
3. Méthode de calcul proposée automatiquement, modifiable.
4. Autorisation des notifications, puis choix de l'adhan.

**Maquette de l'écran d'accueil :**
```
┌──────────────────────────────┐
│ ٤ ربيع الآخر ١٤٤٨ · 26 sept. │
│ Casablanca  ▾                │
│ ┌──────────────────────────┐ │
│ │  Asr  dans 01:23:45      │ │
│ │  Fajr Dhuhr ●Asr Magh Isha│ │
│ └──────────────────────────┘ │
│ ☀ Adhkar du soir   [Ouvrir] │
│ 📖 Continuer : Al-Baqara 255 │
│ ✦ Verset du jour   [Partager]│
│ ✦ Hadith du jour   [Partager]│
└──────────────────────────────┘
```

**Design :**
- Couleurs : vert émeraude profond et or doux, fond crème en mode clair, fond presque noir en mode sombre pour lire la nuit. Motifs géométriques islamiques très discrets.
- Polices : **KFGQPC Uthmanic Hafs** pour le Coran, **Noto Naskh Arabic** ou **Amiri** pour l'arabe de l'interface, **Inter** pour le français et l'anglais.
- Accessibilité : lecteur d'écran, grandes polices, contrastes vérifiés.

---

## 3. Architecture technique

### Stack

| Besoin | Paquet |
|---|---|
| État / injection de dépendances | `flutter_riverpod` + `riverpod_annotation` / `riverpod_generator` |
| Navigation | `go_router` |
| Base de données | `drift` + `sqlite3_flutter_libs` (SQLite avec FTS5 pour la recherche) |
| Préférences | `shared_preferences` |
| Traductions (i18n) | `flutter_localizations` + `intl` + fichiers ARB (`gen-l10n`) |
| Horaires de prière | `adhan` (portage Dart d'Adhan / Batoul Apps) |
| Localisation / capteurs | `geolocator`, `flutter_compass`, `permission_handler` |
| Notifications | `flutter_local_notifications`, `timezone`, `flutter_timezone`, `workmanager` (reprogrammation en tâche de fond), `android_alarm_manager_plus` (adhan complet sur Android) |
| Audio | `just_audio` + `audio_service` (arrière-plan, écran de verrouillage) |
| Téléchargements | `background_downloader` |
| Calendrier hégirien | `hijri` (Umm al-Qura) + décalage manuel |
| Widgets d'accueil | `home_widget` (V1.1) |
| Divers | `share_plus`, `screenshot` (cartes image), `wakelock_plus`, `path_provider`, `flutter_svg` |

### Structure du projet (feature-first, Clean Architecture légère)

```
sakina/
├─ lib/
│  ├─ main.dart
│  ├─ app/            router.dart, theme/, app.dart
│  ├─ core/           database/, arabic/ (normalisation), location/,
│  │                  notifications/, audio/, widgets/ communs, utils/
│  └─ features/
│     ├─ onboarding/  ├─ home/       ├─ prayer_times/  ├─ qibla/
│     ├─ quran/       ├─ hadith/     ├─ adhkar/        ├─ tasbih/
│     ├─ calendar/    ├─ asma_husna/ └─ settings/
│     (chaque feature : data/ · domain/ · presentation/)
├─ assets/  db/content.sqlite · fonts/ · audio/adhan/ · images/
├─ l10n/    app_ar.arb · app_fr.arb · app_en.arb
├─ tools/content_pipeline/   scripts qui construisent content.sqlite
├─ test/  ·  integration_test/
└─ docs/  SOURCES.md (licences) · privacy-policy.md
```

### Deux bases de données séparées

1. **`content.sqlite`** : en lecture seule, fournie dans l'app et copiée au premier lancement. Elle contient :
   - `surahs`, `ayahs` (texte uthmani, texte normalisé pour la recherche, juz, hizb, rub', page, sajda)
   - `translations`, `tafsirs`
   - `hadith_books`, `hadith_chapters`, `hadiths` (ar, fr, en, degré, référence)
   - `adhkar_categories`, `adhkar` (ar, translittération, fr, en, nombre de répétitions, source, mérite)
   - `asma_husna`
   - `cities` (nom ar/fr/en, pays, lat, lng, fuseau horaire)
   - Tables virtuelles **FTS5** pour la recherche
2. **`user.sqlite`** : données de l'utilisateur, en lecture-écriture, avec migrations Drift. Elle contient `bookmarks`, `notes`, `reading_progress`, `khatma_plans`, `tasbih_sessions`, `dhikr_daily_progress`, `prayer_log`.

Mettre à jour le contenu ne touche donc jamais les données de l'utilisateur.

### Pipeline de contenu (`tools/content_pipeline/`)

Des scripts Dart en ligne de commande, reproductibles :
1. Télécharger les sources brutes.
2. Vérifier leurs sommes de contrôle.
3. Normaliser et construire `content.sqlite`.
4. Générer `SOURCES.md`.

**Le texte du Coran n'est jamais modifié.** On ajoute seulement une colonne normalisée pour la recherche.

### Normalisation de l'arabe pour la recherche (`core/arabic/normalizer.dart`)

- Supprimer le tashkīl (U+064B–U+0652), l'alif suscrit (U+0670), les signes coraniques (U+06D6–U+06ED) et le tatwīl.
- Ramener أ إ آ ٱ à ا, ى à ي, et optionnellement ة à ه.

### Contenus lourds = paquets optionnels

« Hors-ligne » signifie : pas de compte, pas de serveur à nous. Pour garder l'app légère (objectif < 60 Mo) :
- **Fourni dans l'app dès l'installation :** texte du Coran, 2 traductions, tafsir Al-Muyassar, Nawawi, Riyad as-Salihin, Hisn al-Muslim, villes, 2 sons d'adhan.
- **Téléchargé à la demande, une seule fois, puis 100 % hors-ligne :** audio des récitateurs (EveryAyah / mp3quran), polices du Mushaf page par page, gros recueils de hadith, autres tafsirs. Ces paquets sont hébergés gratuitement sur GitHub Releases.

---

## 4. Points techniques critiques

### Horaires de prière : méthode par défaut selon le pays (modifiable)

| Pays | Méthode | Asr |
|---|---|---|
| Maroc | Fajr 19° / Isha 17° (Habous) + ajustements en minutes | Standard |
| Algérie | 18° / 17° | Standard |
| Tunisie | 18° / 18° | Standard |
| France | UOIF 12°, ou 15° / 18° selon la mosquée (proposer le choix) | Standard |
| Arabie saoudite | Umm al-Qura | Standard |
| Égypte | Égyptienne | Standard |
| Turquie | Diyanet | Hanafi |
| USA / Canada | ISNA | Standard |
| Pakistan / Inde | Karachi | Hanafi |
| Pays du Golfe | Dubai / Qatar / Kuwait | Standard |
| Autres | Ligue islamique mondiale (MWL) | Standard |

- **Hautes latitudes** (Europe du Nord) : règle au choix, « septième de la nuit », « milieu de la nuit » ou « angle ».
- **Validation** : tests automatiques qui comparent aux calendriers officiels (Habous, Umm al-Qura, grande mosquée de Paris) à ±1 minute près.

### Notifications d'adhan : les pièges

**Android :**
- Permission `POST_NOTIFICATIONS` (Android 13+).
- `SCHEDULE_EXACT_ALARM`, à demander avec une explication. Ne pas utiliser `USE_EXACT_ALARM`, que Google Play réserve aux applis de réveil.
- Proposer de désactiver l'optimisation de batterie.
- Créer **un canal de notification par son d'adhan**, car on ne peut plus changer le son d'un canal après sa création.
- L'adhan complet se joue via une alarme et un service de premier plan.

**iOS :**
- **Maximum 64 notifications programmées** à la fois. On programme donc une fenêtre glissante d'environ 10 jours, renouvelée à chaque ouverture de l'app et en tâche de fond (`BGAppRefreshTask`).
- **Le son d'une notification est limité à 30 secondes.** Il faut une version courte de l'adhan au format `.caf` ; l'adhan complet ne se joue que si l'app est ouverte.
- Reprogrammer aussi en cas de changement de fuseau horaire, de lieu ou de méthode.

### Qibla

- Direction calculée par la formule de l'azimut sur un grand cercle vers la Kaaba (21.4225, 39.8262).
- La boussole donne le **nord magnétique**. Il faut la corriger avec la **déclinaison** calculée hors-ligne par le modèle WMM, sinon l'erreur peut atteindre plusieurs degrés.
- Si la précision du capteur est faible, afficher l'écran de calibrage et un avertissement : s'éloigner des objets métalliques et des aimants (coques magnétiques).
- Si l'appareil n'a pas de magnétomètre, afficher seulement l'angle par rapport au nord.
- Valeurs de contrôle pour les tests : Paris ≈ 119°, New York ≈ 58°.

### Coran : rendu du texte

- **V1.0 :** texte uthmani de Tanzil ou KFGQPC, affiché avec la police KFGQPC Uthmanic Hafs en mode liste (le texte se réorganise selon la taille de l'écran).
- **V1.1 :** mode Mushaf identique au papier, grâce aux polices QPC par page et à la base de mise en page de QUL (qul.tarteel.ai). Les versions tajwīd utilisent des polices colorées.
- **Audio synchronisé :** fichiers d'EveryAyah, un par verset. Le surlignage et la répétition sont alors simples, sans avoir à calculer des horodatages.

---

## 5. Sources de contenu (licences à confirmer une par une avant publication)

| Contenu | Source proposée | Remarque |
|---|---|---|
| Texte du Coran | Tanzil.net (uthmani) ou KFGQPC | Attribution obligatoire, texte non modifié |
| Mise en page Mushaf, polices, mot à mot | QUL – Quranic Universal Library (Tarteel) | Vérifier la licence de chaque ressource |
| Traduction française | Muhammad Hamidullah (via Tanzil) | Usage non commercial : compatible avec une app gratuite |
| Traduction anglaise | Saheeh International (via Tanzil) | Idem |
| Tafsir | Al-Muyassar (KFGQPC) ; Ibn Kathir (arabe, domaine public) | |
| Audio | EveryAyah.com (par verset), mp3quran.net (sourates) | |
| Hadith | `fawazahmed0/hadith-api` sur GitHub (Unlicense, AR/EN/FR selon les recueils, avec degrés) | Recouper avec sunnah.com |
| Adhkar | Hisn al-Muslim (Sa'id al-Qahtani) | Vérifier les droits des traductions FR/EN |
| Villes | GeoNames `cities15000` (CC-BY 4.0), avec noms AR et FR | |
| Sons d'adhan | Enregistrements libres de droits ou autorisés | Ne pas prendre n'importe quel MP3 trouvé en ligne |
| Polices | KFGQPC (libre), Amiri, Noto Naskh Arabic, Inter (licence OFL) | |

**Relecture religieuse :** faire relire par une personne qualifiée (imam, étudiant en science religieuse) les traductions des adhkar, les degrés des hadiths et les méthodes de calcul par défaut, avant la publication.

---

## 6. Feuille de route détaillée (V1.0)

| Semaines | Étape | Livrables |
|---|---|---|
| 1–2 | **Fondations** | Projet Flutter, structure des dossiers, thème clair/sombre, i18n AR/FR/EN avec RTL, `go_router`, Riverpod, Drift, pipeline de contenu (v0 : Coran + villes), CI GitHub Actions (analyse + tests) |
| 3–5 | **Prière et Qibla** | Onboarding, localisation GPS et ville hors-ligne, calcul des horaires, réglages de méthode, tableau mensuel, notifications Android et iOS, écran Qibla, tests comparés aux calendriers officiels |
| 6–10 | **Coran** | Listes sourate / juz / hizb, lecteur, traductions, tafsir, recherche FTS, signets, dernière lecture, audio (lecture, téléchargement, arrière-plan, surlignage, répétition) |
| 11–13 | **Adhkar, Hadith, Tasbih** | Hisn al-Muslim avec compteurs et rappels, 4 recueils de hadith avec recherche et favoris, tasbih, partage en image |
| 14–16 | **Accueil et finitions** | Tableau de bord, verset et hadith du jour, écran « Sources et licences », accessibilité, performances, tests sur de vrais appareils, bêta fermée |
| 17 | **Publication** | Fiches des stores en 3 langues, captures d'écran, politique de confidentialité, soumission |

---

## 7. Publication sur les stores

- **Google Play :** 25 $ une seule fois. Les nouveaux comptes personnels doivent faire un **test fermé avec au moins 12 testeurs pendant 14 jours** avant la mise en production. Il faut aussi remplir le formulaire « Sécurité des données » : localisation utilisée uniquement sur l'appareil, aucune donnée collectée.
- **Apple App Store :** 99 $ par an. **Vous êtes sur Windows : compiler pour iOS demande un Mac.** Solutions : Codemagic, qui compile sur des Mac dans le cloud avec une offre gratuite, ou un Mac mini, éventuellement d'occasion.
- **Politique de confidentialité :** obligatoire même sans collecte de données. Page gratuite sur GitHub Pages.
- **Bouton « Soutenir le projet » :** sur iOS, un pourboire au développeur doit passer par l'achat intégré d'Apple. Sinon, mettre le lien de don uniquement sur le site web. Vérifier les règles avant d'en ajouter un.
- **Référencement (ASO) :** mots-clés « Coran, horaires de prière, adhan, qibla, adhkar, hadith, القرآن, أذكار, مواقيت الصلاة ».

---

## 8. Vérification et tests

- **Tests unitaires :**
  - horaires de prière (Casablanca, Alger, Paris, La Mecque, Londres en été, Oslo pour les hautes latitudes) comparés aux calendriers officiels, à ±1 min près ;
  - angle de la Qibla (Paris ≈ 119°, New York ≈ 58°) ;
  - normalisation de l'arabe ;
  - conversion hégirienne ;
  - programmation des notifications (fenêtre de 64 sur iOS).
- **Test du contenu :**
  - 6 236 versets et 114 sourates ;
  - somme de contrôle du texte du Coran identique à la source ;
  - chaque hadith a sa référence ;
  - chaque dhikr a son nombre de répétitions.
- **Tests d'interface :** tests de widgets et captures de référence (golden tests) en LTR et en RTL, en mode clair et sombre.
- **Tests d'intégration** (`integration_test/`) : onboarding de bout en bout, puis lecture d'une sourate, puis ajout d'un favori.
- **Manuel, sur de vrais appareils** (boussole et notifications impossibles à tester sur émulateur) :
  - un Android récent et un Android ancien (Android 8) ;
  - un iPhone, via Codemagic ou TestFlight ;
  - vérifier que l'adhan sonne quand l'app est fermée ou le téléphone redémarré, et en mode Doze.
- **Commandes :** `flutter analyze`, `flutter test`, `flutter test integration_test`, `flutter run` sur l'émulateur.

---

## 9. Ce que je ferai dès que vous validez ce plan (Phase 0, semaines 1-2)

1. `git init` et `flutter create sakina` (org à choisir, par ex. `com.votrenom.sakina`) dans `C:\Androids ios\Muslim idea\`.
2. Ajouter les dépendances de base (Riverpod, go_router, Drift, intl, adhan, geolocator…) et configurer `analysis_options.yaml` en mode strict.
3. Créer la structure `app/`, `core/` et `features/`, le thème (couleurs, polices), les fichiers ARB AR/FR/EN et la bascule RTL.
4. Écrire `tools/content_pipeline/`, qui télécharge Tanzil et GeoNames, construit `content.sqlite` et génère `SOURCES.md`.
5. Écrire le normaliseur arabe et les premiers tests (calcul des horaires, azimut de la Qibla).
6. Livrer une première app qui démarre, avec la barre de navigation en 5 onglets et l'écran des horaires de prière fonctionnel, puis vérifier avec `flutter analyze`, `flutter test` et `flutter run`.

Ensuite, on avance étape par étape selon la feuille de route du §6.
