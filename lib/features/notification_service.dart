// notification_service.dart

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  Future<void> initializeNotifications() async {
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
          channelGroupKey: "basic_channel_group",
          ledColor: Colors.yellow,
          defaultColor: Colors.deepPurple,
          channelKey: 'MCI_KEY',
          channelName: 'MediConsultChannel',
          channelDescription: 'MediConsult Notifications',
          importance: NotificationImportance.High,
          enableLights: true,
          enableVibration: true,
          playSound: true),
    ], channelGroups: [
      NotificationChannelGroup(
          channelGroupKey: "basic_channel_group",
          channelGroupName: "Basic group"),
    ]);
  }

  Future<void> requestNotificationPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  Future<void> createNotification(
      String? channelId, String? title, String? body) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: channelId ?? 'MCI_KEY',
        displayOnBackground: true,
        displayOnForeground: false,
        backgroundColor: Colors.white,
        color: Colors.yellow,
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
        autoDismissible: false,
      ),
      actionButtons: [
        NotificationActionButton(
            key: "Yes",
            label: "Yes",
            color: const Color.fromARGB(255, 0, 255, 8)),
        NotificationActionButton(
          key: "No",
          label: "No",
          color: Colors.red,
        ),
      ],
    );
  }
}
