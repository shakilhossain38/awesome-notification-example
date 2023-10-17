import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:untitled/main.dart';
import 'package:untitled/second_page.dart';

class NotificationService {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'high_importance_channel_group',
          channelKey: 'high_importance_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel',
          ledColor: Colors.white,
          defaultColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'high_importance_channel_group',
          channelGroupName: 'Group 1',
        ),
      ],
      debug: true,
    );
  }

  static Future<void> createNotification({
    final ActionType actionType = ActionType.Default,
  }) async {
    final rng = Random(DateTime.now().millisecondsSinceEpoch);
    final randomNumber = rng.nextInt(114) + 1;
    final secondRandomNumber = rng.nextInt(115) + 1;
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: -1,
        actionType: actionType,
        channelKey: 'high_importance_channel',
        title: "Your Today's number",
        body: 'One: $randomNumber, Two: $secondRandomNumber',
        payload: {
          'first': '$randomNumber',
          'second': '$secondRandomNumber',
        },
      ),
      schedule: NotificationInterval(
        interval: 10,
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        preciseAlarm: true,
      ),
    );
  }

  @pragma('vm:entry-point')
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedAction,
  ) async {
    _updateNotification();
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    BotToast.showText(
        text: 'Hello i am actioned at ${receivedAction.actionDate}',
        duration: const Duration(seconds: 3));
    MyApp.navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => const SecondPage(),
      ),
    );
    _updateNotification();
  }

  static Future<void> listenNotification() async {
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,

      ///onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,

      ///onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  static void _updateNotification() {}

  Future<void> cancelScheduledNotifications() async {
    await AwesomeNotifications().cancelAllSchedules();
  }
}
