import 'dart:io';
import 'dart:ui' show Color;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../core/settings/app_settings.dart';
import '../../../l10n/app_localizations.dart';
import '../../khatma/domain/khatma_plan.dart';
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
  static const _testId = 999000001;

  /// Couleur d'accent des notifications Android (émeraude de l'app).
  static const _accent = Color(0xFF0E6B55);

  /// Notifications gérées sur Android et iOS uniquement (pas en test ni sur
  /// ordinateur, où le plugin n'est pas disponible).
  static bool get _supported => Platform.isAndroid || Platform.isIOS;

  Future<void> _ensureInitialized() => _init ??= _plugin
      .initialize(
        settings: const InitializationSettings(
          // Silhouette blanche (res/drawable-*/ic_stat_sakinah.png) : Android
          // n'affiche que la transparence des icônes de la barre d'état.
          android: AndroidInitializationSettings('ic_stat_sakinah'),
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
    KhatmaPlan? khatma,
    tz.Location? localZone,
  }) async {
    if (!_supported) return 0;
    await _ensureInitialized();
    await _plugin.cancelAllPendingNotifications();

    final now = DateTime.now();
    final khatmaTimes = khatma == null || localZone == null
        ? const <tz.TZDateTime>[]
        : khatmaReminderTimes(khatma, localZone, now);
    final schedule = calculator == null || (!settings.adhanEnabled && !settings.adhkarReminders)
        ? const <ScheduledAdhan>[]
        : buildAdhanSchedule(
            calculator: calculator,
            now: now,
            muted: {for (final name in settings.adhanMuted) ?Salah.values.asNameMap()[name]},
            reminderMinutes: settings.adhanReminderMinutes,
            prayers: settings.adhanEnabled,
            adhkarReminders: settings.adhkarReminders,
            // Limite iOS (64) partagée avec les rappels de khatma.
            maxCount: (Platform.isIOS ? 60 : 120) - khatmaTimes.length,
          );
    if (schedule.isEmpty && khatmaTimes.isEmpty) return 0;

    final exact = Platform.isAndroid && (await _android?.canScheduleExactNotifications() ?? false);
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        l.adhanChannelName,
        channelDescription: l.adhanChannelDescription,
        importance: Importance.max,
        priority: Priority.high,
        category: AndroidNotificationCategory.reminder,
        color: _accent,
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
        title: switch (n.kind) {
          AdhanKind.prayer => l.adhanTitle(name, formatTime(n.prayerTime, locale)),
          AdhanKind.reminder => l.reminderTitle(name, settings.adhanReminderMinutes),
          AdhanKind.morningAdhkar => l.morningAdhkar,
          AdhanKind.eveningAdhkar => l.eveningAdhkar,
        },
        body: switch (n.kind) {
          AdhanKind.prayer => l.adhanBody(name),
          AdhanKind.reminder => l.reminderBody,
          AdhanKind.morningAdhkar => l.adhkarReminderBodyMorning,
          AdhanKind.eveningAdhkar => l.adhkarReminderBodyEvening,
        },
      );
    }
    for (final t in khatmaTimes) {
      await _plugin.zonedSchedule(
        // Identifiants à part : 2AAMMJJ00.
        id: 200000000 + ((t.year % 100) * 10000 + t.month * 100 + t.day) * 10,
        scheduledDate: t,
        notificationDetails: details,
        androidScheduleMode: exact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        title: l.khatmaTitle,
        body: l.khatmaReminderBody(khatma!.pagesPerDay),
      );
    }
    return schedule.length + khatmaTimes.length;
  }

  /// Notification de test, sur le même canal que l'adhan. Programmée
  /// [testDelay] plus tard quand c'est possible à la seconde près (le temps
  /// de verrouiller le téléphone), sinon affichée tout de suite. Renvoie le
  /// délai utilisé, ou null sans autorisation.
  Future<Duration?> sendTest(AppLocalizations l) async {
    if (!_supported) return null;
    await _ensureInitialized();
    if (!(await hasPermission() ?? true) && !await requestPermission()) return null;
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        l.adhanChannelName,
        channelDescription: l.adhanChannelDescription,
        importance: Importance.max,
        priority: Priority.high,
        category: AndroidNotificationCategory.reminder,
        color: _accent,
      ),
      iOS: const DarwinNotificationDetails(presentAlert: true, presentSound: true),
    );
    final exact = Platform.isIOS || (await _android?.canScheduleExactNotifications() ?? false);
    if (!exact) {
      await _plugin.show(
        id: _testId,
        title: l.testNotificationTitle,
        body: l.testNotificationBody,
        notificationDetails: details,
      );
      return Duration.zero;
    }
    await _plugin.zonedSchedule(
      id: _testId,
      scheduledDate: tz.TZDateTime.now(tz.UTC).add(testDelay),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      title: l.testNotificationTitle,
      body: l.testNotificationBody,
    );
    return testDelay;
  }

  static const testDelay = Duration(seconds: 10);
}
