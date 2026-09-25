import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/settings/app_settings.dart';
import '../../../l10n/app_localizations.dart';
import '../../prayer_times/domain/method_defaults.dart';
import '../../prayer_times/domain/prayer_calculator.dart';
import '../../prayer_times/presentation/prayer_labels.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final settings = ref.watch(settingsProvider);
    final controller = ref.read(settingsProvider.notifier);
    final location = settings.location;
    final resolved = location == null ? null : PrayerConfig.resolve(settings, location);

    String languageName(AppLanguage lang) => switch (lang) {
      AppLanguage.system => l.system,
      AppLanguage.ar => 'العربية',
      AppLanguage.fr => 'Français',
      AppLanguage.en => 'English',
    };
    String themeName(ThemeMode mode) => switch (mode) {
      ThemeMode.system => l.system,
      ThemeMode.light => l.themeLight,
      ThemeMode.dark => l.themeDark,
    };
    String translationName(QuranTranslation t) => switch (t) {
      QuranTranslation.auto => l.translationAuto,
      QuranTranslation.none => l.translationNone,
      QuranTranslation.frHamidullah => 'Français — Muhammad Hamidullah',
      QuranTranslation.enSahih => 'English — Saheeh International',
    };
    String hijriAdjustmentLabel(int days) => days == 0
        ? l.hijriAdjustmentValue(0)
        : '${days > 0 ? '+' : '−'}${l.hijriAdjustmentValue(days.abs())}';

    final autoMethodLabel = resolved == null
        ? l.automatic
        : l.autoMethod(l.methodName(defaultMethodForCountry(location!.countryCode)));
    final autoMadhabLabel = resolved == null
        ? l.automatic
        : l.autoMethod(l.madhabName(defaultMadhabForCountry(location!.countryCode)));

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: ListView(
        children: [
          _SectionTitle(l.sectionGeneral),
          _ChoiceTile<AppLanguage>(
            icon: Icons.language,
            title: l.language,
            value: settings.language,
            options: AppLanguage.values,
            labelOf: languageName,
            onChanged: (v) => controller.update((s) => s.copyWith(language: v)),
          ),
          _ChoiceTile<ThemeMode>(
            icon: Icons.brightness_6_outlined,
            title: l.theme,
            value: settings.themeMode,
            options: ThemeMode.values,
            labelOf: themeName,
            onChanged: (v) => controller.update((s) => s.copyWith(themeMode: v)),
          ),
          _SectionTitle(l.sectionPrayer),
          _ChoiceTile<CalculationMethod?>(
            icon: Icons.calculate_outlined,
            title: l.calculationMethod,
            value: settings.calculationMethod,
            options: [null, ...selectableMethods],
            labelOf: (m) => m == null ? autoMethodLabel : l.methodName(m),
            subtitleOf: (m) => l.methodAngles(
              m ?? resolved?.method ?? CalculationMethod.muslimWorldLeague,
              locale,
            ),
            onChanged: (v) => controller.update((s) => s.copyWith(calculationMethod: v)),
          ),
          _ChoiceTile<Madhab?>(
            icon: Icons.wb_sunny_outlined,
            title: l.asrMethod,
            value: settings.madhab,
            options: const [null, Madhab.shafi, Madhab.hanafi],
            labelOf: (m) => m == null ? autoMadhabLabel : l.madhabName(m),
            onChanged: (v) => controller.update((s) => s.copyWith(madhab: v)),
          ),
          _ChoiceTile<HighLatitudeRule?>(
            icon: Icons.public,
            title: l.highLatitudeRule,
            value: settings.highLatitudeRule,
            options: [null, ...HighLatitudeRule.values],
            labelOf: (r) => r == null
                ? (resolved == null
                      ? l.automatic
                      : l.autoMethod(l.highLatitudeRuleName(resolved.highLatitudeRule)))
                : l.highLatitudeRuleName(r),
            onChanged: (v) => controller.update((s) => s.copyWith(highLatitudeRule: v)),
          ),
          _ChoiceTile<int>(
            icon: Icons.nightlight_outlined,
            title: l.hijriAdjustment,
            value: settings.hijriAdjustment,
            options: const [-2, -1, 0, 1, 2],
            labelOf: hijriAdjustmentLabel,
            onChanged: (v) => controller.update((s) => s.copyWith(hijriAdjustment: v)),
          ),
          _SectionTitle(l.sectionQuran),
          _ChoiceTile<QuranTranslation>(
            icon: Icons.translate,
            title: l.translation,
            value: settings.quranTranslation,
            options: QuranTranslation.values,
            labelOf: translationName,
            onChanged: (v) => controller.update((s) => s.copyWith(quranTranslation: v)),
          ),
          ListTile(
            leading: const Icon(Icons.format_size),
            title: Text(l.arabicFontSize),
            subtitle: Slider(
              value: settings.arabicFontScale,
              min: 0.8,
              max: 1.8,
              divisions: 10,
              label: '${(settings.arabicFontScale * 100).round()} %',
              onChanged: (v) => controller.update((s) => s.copyWith(arabicFontScale: v)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(20, 24, 20, 4),
    child: Text(
      text,
      style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700),
    ),
  );
}

/// Ligne de réglage qui ouvre une liste de choix exclusifs.
class _ChoiceTile<T> extends StatelessWidget {
  const _ChoiceTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.options,
    required this.labelOf,
    required this.onChanged,
    this.subtitleOf,
  });

  final IconData icon;
  final String title;
  final T value;
  final List<T> options;
  final String Function(T) labelOf;
  final String Function(T)? subtitleOf;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon),
    title: Text(title),
    subtitle: Text(labelOf(value)),
    onTap: () => _pick(context),
  );

  Future<void> _pick(BuildContext context) async {
    final l = AppLocalizations.of(context);
    // Enveloppe la valeur pour distinguer « null choisi » de « annulé ».
    final picked = await showDialog<({T value})>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        content: SizedBox(
          width: double.maxFinite,
          child: RadioGroup<int>(
            groupValue: options.indexOf(value),
            onChanged: (i) => Navigator.of(context).pop((value: options[i!])),
            child: ListView(
              shrinkWrap: true,
              children: [
                for (var i = 0; i < options.length; i++)
                  RadioListTile<int>(
                    value: i,
                    title: Text(labelOf(options[i])),
                    subtitle: subtitleOf == null ? null : Text(subtitleOf!(options[i])),
                  ),
              ],
            ),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l.cancel))],
      ),
    );
    if (picked != null) onChanged(picked.value);
  }
}
