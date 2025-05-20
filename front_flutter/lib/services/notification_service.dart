import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart' show Color;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> initialize() async {
    try {
      tz.initializeTimeZones();

      await AwesomeNotifications().initialize(null, [
        NotificationChannel(
          channelGroupKey: 'habit_reminders_group',
          channelKey: 'habit_reminders',
          channelName: 'Lembretes de Hábitos',
          channelDescription: 'Notificações para lembrar sobre hábitos',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: const Color(0xFF9D50DD),
          importance: NotificationImportance.High,
          channelShowBadge: true,
          onlyAlertOnce: false,
          playSound: true,
          criticalAlerts: true,
        ),
      ], debug: true);

      await _requestPermissions();
      await _setupNotificationListeners();
    } catch (e) {
      print('Erro ao inicializar notificações: $e');
      rethrow;
    }
  }

  Future<void> _requestPermissions() async {
    await AwesomeNotifications().isNotificationAllowed().then((
      isAllowed,
    ) async {
      if (!isAllowed) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  Future<void> _setupNotificationListeners() async {
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  /// Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    print('Notificação criada: ${receivedNotification.title}');
  }

  /// Use this method to detect every time that a new notification is displayed
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    print('Notificação exibida: ${receivedNotification.title}');
  }

  /// Use this method to detect if the user dismissed a notification
  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    print('Notificação descartada: ${receivedAction.title}');
  }

  /// Use this method to detect when the user taps on a notification or action button
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    print('Ação recebida: ${receivedAction.title}');
  }

  Future<bool> scheduleHabitReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    List<int> weekDays = const [],
  }) async {
    try {
      bool success = await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'habit_reminders',
          title: title,
          body: body,
          notificationLayout: NotificationLayout.Default,
          wakeUpScreen: true,
          category: NotificationCategory.Reminder,
          criticalAlert: true,
        ),
        schedule: NotificationCalendar(
          hour: scheduledTime.hour,
          minute: scheduledTime.minute,
          second: 0,
          millisecond: 0,
          repeats: true,
          preciseAlarm: true,
          allowWhileIdle: true,
          weekday: weekDays.isNotEmpty ? weekDays.first : null,
        ),
      );

      if (weekDays.isNotEmpty && weekDays.length > 1) {
        // Cria notificações adicionais para outros dias da semana
        for (int i = 1; i < weekDays.length; i++) {
          await AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: id + i,
              channelKey: 'habit_reminders',
              title: title,
              body: body,
              notificationLayout: NotificationLayout.Default,
              wakeUpScreen: true,
              category: NotificationCategory.Reminder,
              criticalAlert: true,
            ),
            schedule: NotificationCalendar(
              hour: scheduledTime.hour,
              minute: scheduledTime.minute,
              second: 0,
              millisecond: 0,
              repeats: true,
              preciseAlarm: true,
              allowWhileIdle: true,
              weekday: weekDays[i],
            ),
          );
        }
      }

      return success;
    } catch (e) {
      print('Erro ao agendar notificação: $e');
      return false;
    }
  }

  Future<void> cancelHabitReminder(int id) async {
    try {
      await AwesomeNotifications().cancel(id);
      // Cancela também as notificações adicionais para dias da semana
      for (int i = 1; i < 7; i++) {
        await AwesomeNotifications().cancel(id + i);
      }
    } catch (e) {
      print('Erro ao cancelar notificação: $e');
      rethrow;
    }
  }

  Future<void> cancelAllReminders() async {
    try {
      await AwesomeNotifications().cancelAll();
    } catch (e) {
      print('Erro ao cancelar todas as notificações: $e');
      rethrow;
    }
  }

  Future<List<NotificationModel>> getPendingReminders() async {
    try {
      final List<NotificationModel> pendingNotifications =
          await AwesomeNotifications().listScheduledNotifications();
      return pendingNotifications;
    } catch (e) {
      print('Erro ao listar notificações pendentes: $e');
      return [];
    }
  }
}
