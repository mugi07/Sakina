import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/settings/app_settings.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/adhan_schedule.dart';
import '../domain/prayer_calculator.dart';
import '../presentation/prayer_labels.dart';

final adhanNotificationsProvider = Provider<AdhanNotifications>(
  (ref) => AdhanNotifications(FlutterLocalNotificationsPlugin()),
);

/// Notifications locales à l'heure des prières (aucun serveur).
///
/// Les notifications des prochains jours sont reprogrammées à chaque
/// ouverture de l'app et à chaque changement de lieu ou de réglage.
class AdhanNotifications {
  AdhanNotifications(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;
  Future<void>? _init;

  static const _channelId = 'adhan_v1';

  /// Notifications gérées sur Android et iOS uniquement (pas en test ni sur
  /// ordinateur, où le plugin n'est pas disponible).
  static bool get _supported => Platform.isAndroid || Platform.isIOS;

  Future<void> _ensureInitialized() => _init ??= _plugin
      .initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          // Permission demandée plus tard, avec une explication (bienvenue, réglages).
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
      )
      .then((_) {});

  AndroidFlutterLocalNotificationsPlugin? get _android =>
      _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  /// Demande l'autorisation d'afficher des notifications (et, sur Android,
  /// de les déclencher à la minute exacte).
  Future<bool> requestPermission() async {
    if (!_supported) return false;
    await _ensureInitialized();
    if (Platform.isAndroid) {
      final granted = await _android?.requestNotificationsPermission() ?? false;
      if (granted && !(await _android?.canScheduleExactNotifications() ?? true)) {
        await _android?.requestExactAlarmsPermission();
      }
      return granted;
    }
    if (Platform.isIOS) {
      return await _plugin
              .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(alert: true, sound: true) ??
          false;
    }
    return false;
  }

  /// Autorisation actuelle (null si la plateforme ne permet pas de le savoir).
  Future<bool?> hasPermission() async {
    if (!_supported) return null;
    await _ensureInitialized();
    if (Platform.isAndroid) return _android?.areNotificationsEnabled();
    if (Platform.isIOS) {
      final ios = _plugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      return (await ios?.checkPermissions())?.isEnabled;
    }
    return null;
  }

  /// Android : false si les alarmes exactes ne sont pas autorisées (les
  /// notifications peuvent alors arriver avec jusqu'à une heure de retard).
  Future<bool?> canScheduleExact() async {
    if (!Platform.isAndroid) return null;
    await _ensureInitialized();
    return _android?.canScheduleExactNotifications();
  }

  /// Ouvre l'écran système « Alarmes et rappels » (Android 12 et plus).
  Future<void> requestExactAlarms() async {
    if (!Platform.isAndroid) return;
    await _ensureInitialized();
    await _android?.requestExactAlarmsPermission();
  }

  /// Remplace toutes les notifications programmées. Renvoie leur nombre.
  Future<int> reschedule({
    required PrayerCalculator? calculator,
    required AppSettings settings,
    required AppLocalizations l,
    required String locale,
  }) async {
    if (!_supported) return 0;
    await _ensureInitialized();
    await _plugin.cancelAllPendingNotifications();
    if (calculator == null || !settings.adhanEnabled) return 0;

    final schedule = buildAdhanSchedule(
      calculator: calculator,
      now: DateTime.now(),
      muted: {for (final name in settings.adhanMuted) ?Salah.values.asNameMap()[name]},
      reminderMinutes: settings.adhanReminderMinutes,
      maxCount: Platform.isIOS ? 60 : 120,
    );

    final exact = Platform.isAndroid && (await _android?.canScheduleExactNotifications() ?? false);
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        l.adhanChannelName,
        channelDescription: l.adhanChannelDescription,
        importance: Importance.max,
        priority: Priority.high,
        category: AndroidNotificationCategory.reminder,
      ),
      iOS: const DarwinNotificationDetails(presentAlert: true, presentSound: true),
    );

    for (final n in schedule) {
      final name = l.salahName(n.salah);
      await _plugin.zonedSchedule(
        id: n.id,
        scheduledDate: n.fireAt,
        notificationDetails: details,
        androidScheduleMode: exact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        title: n.isReminder
            ? l.reminderTitle(name, settings.adhanReminderMinutes)
            : l.adhanTitle(name, formatTime(n.prayerTime, locale)),
        body: n.isReminder ? l.reminderBody : l.adhanBody(name),
      );
    }
    return schedule.length;
  }
}
