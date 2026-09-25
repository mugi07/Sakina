import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers.dart';
import '../../../../l10n/app_localizations.dart';

/// « 📍 Casablanca, Maroc ▾ » — ouvre le choix du lieu.
class LocationHeader extends ConsumerWidget {
  const LocationHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final location = ref.watch(settingsProvider.select((s) => s.location));
    final lang = Localizations.localeOf(context).languageCode;
    final label = location == null
        ? l.chooseLocation
        : [
            location.cityName(lang) ?? l.myPosition,
            ?location.countryName(lang),
          ].join(lang == 'ar' ? '، ' : ', ');

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: TextButton.icon(
        onPressed: () => context.push('/location'),
        icon: Icon(location?.fromGps ?? false ? Icons.my_location : Icons.location_on_outlined),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
