import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/location/location_service.dart';
import '../../../core/location/saved_location.dart';
import '../../../core/providers.dart';
import '../../../l10n/app_localizations.dart';

/// Choix du lieu : position GPS ou recherche dans la base des villes
/// (hors-ligne, en arabe, français ou anglais).
class LocationPickerScreen extends ConsumerStatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  ConsumerState<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends ConsumerState<LocationPickerScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  String _query = '';
  List<SavedLocation> _results = const [];
  bool _locating = false;
  LocationFailure? _gpsFailure;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () async {
      final results = await ref.read(locationServiceProvider).searchCities(value);
      if (!mounted) return;
      setState(() {
        _query = value;
        _results = results;
      });
    });
  }

  Future<void> _useGps() async {
    setState(() {
      _locating = true;
      _gpsFailure = null;
    });
    try {
      final location = await ref.read(locationServiceProvider).currentLocation();
      _select(location);
    } on LocationException catch (e) {
      if (mounted) setState(() => _gpsFailure = e.failure);
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  void _select(SavedLocation location) {
    ref.read(settingsProvider.notifier).update((s) => s.copyWith(location: location));
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l.locationTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _controller,
              autofocus: true,
              onChanged: _onQueryChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l.searchCityHint,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          ListTile(
            leading: _locating
                ? const SizedBox.square(
                    dimension: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(Icons.my_location, color: scheme.primary),
            title: Text(_locating ? l.locating : l.useMyLocation),
            subtitle: _gpsFailure == null
                ? null
                : Text(switch (_gpsFailure!) {
                    LocationFailure.serviceDisabled => l.locationServiceDisabled,
                    LocationFailure.permissionDenied => l.locationPermissionDenied,
                    LocationFailure.unavailable => l.locationError,
                  }, style: TextStyle(color: scheme.error)),
            onTap: _locating ? null : _useGps,
          ),
          const Divider(height: 1),
          Expanded(child: _buildResults(l, lang, scheme)),
        ],
      ),
    );
  }

  Widget _buildResults(AppLocalizations l, String lang, ColorScheme scheme) {
    if (_query.trim().length < 2) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(l.searchCityPrompt, style: TextStyle(color: scheme.onSurfaceVariant)),
      );
    }
    if (_results.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(l.noCityFound, style: TextStyle(color: scheme.onSurfaceVariant)),
      );
    }
    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, i) {
        final city = _results[i];
        return ListTile(
          leading: const Icon(Icons.location_city_outlined),
          title: Text(city.cityName(lang) ?? ''),
          subtitle: Text(city.countryName(lang) ?? city.countryCode),
          onTap: () => _select(city),
        );
      },
    );
  }
}
