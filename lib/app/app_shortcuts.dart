import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:quick_actions/quick_actions.dart';

import '../l10n/app_localizations.dart';

const _qibla = 'qibla';

/// Raccourcis de l'icône de l'app (appui long sur l'icône, Android et iOS) :
/// « Trouver la Qibla » ouvre directement la boussole.
class AppShortcuts {
  AppShortcuts({required this.onQibla});

  final VoidCallback onQibla;
  final _actions = const QuickActions();
  bool _initialized = false;

  /// Installe les raccourcis dans la langue de l'app (à rappeler quand la
  /// langue change). Au premier appel, traite aussi le raccourci qui a
  /// éventuellement lancé l'app.
  Future<void> update(AppLocalizations l) async {
    if (!Platform.isAndroid && !Platform.isIOS) return;
    try {
      if (!_initialized) {
        _initialized = true;
        await _actions.initialize((type) {
          if (type == _qibla) onQibla();
        });
      }
      await _actions.setShortcutItems([
        // Icône : res/drawable/ic_shortcut_qibla.xml (Android),
        // Assets.xcassets/ic_shortcut_qibla (iOS).
        ShortcutItem(type: _qibla, localizedTitle: l.findQibla, icon: 'ic_shortcut_qibla'),
      ]);
    } on PlatformException catch (e) {
      debugPrint('Raccourcis de l\'icône indisponibles : $e');
    }
  }
}
