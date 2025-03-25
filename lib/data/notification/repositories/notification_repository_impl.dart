import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:chuck_interceptor/chuck.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tez_med_client/config/environment.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/routes/app_routes.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/data/notification/model/notification_message.dart';
import 'package:tez_med_client/domain/notification/repositories/notification_repository.dart';
import 'package:tez_med_client/injection.dart';

enum NotificationPermissionStatus {
  granted,
  provisional,
  denied,
  notDetermined
}

class NotificationRepositoryImpl implements NotificationRepository {
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin;
  final FirebaseMessaging _firebaseMessaging;
  late final Box<NotificationMessage> _notificationsBox;

  static const String channelId1 = 'high_importance_channel';
  static const String channelName1 = 'High Importance Notifications';
  static const String channelDescription1 =
      'Channel for important notifications';
  static const String channelId2 = 'low_importance_channel';
  static const String channelName2 = 'Low Importance Notifications';
  static const String channelDescription2 =
      'Channel for less critical notifications';

  NotificationRepositoryImpl({
    FlutterLocalNotificationsPlugin? localNotificationsPlugin,
    FirebaseMessaging? firebaseMessaging,
  })  : _localNotificationsPlugin =
            localNotificationsPlugin ?? FlutterLocalNotificationsPlugin(),
        _firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance;

  @override
  Future<void> saveBackgroundNotification(RemoteMessage message) async {
    try {
      if (!Hive.isBoxOpen('notifications')) {
        _notificationsBox =
            await Hive.openBox<NotificationMessage>('notifications');
      }
      final notificationsBox =
          await Hive.openBox<NotificationMessage>('notifications');

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(StorageKeys.userId);

      if (userId != null) {
        final notificationMessage = NotificationMessage(
          id: message.messageId ?? UniqueKey().toString(),
          title: message.notification?.title ?? 'Notification',
          body: message.notification?.body ?? '',
          data: message.data,
          isRead: false,
          userId: userId,
          timestamp: DateTime.now(),
        );

        // Save the notification
        await notificationsBox.put(notificationMessage.id, notificationMessage);

        // Clean up old notifications
        await _cleanupOldNotifications();
      }
    } catch (e) {
      debugPrint('Error saving background notification: $e');
    }
  }

  @override
  Future<void> initializeNotifications() async {
    _notificationsBox =
        await Hive.openBox<NotificationMessage>('notifications');
    NotificationPermissionStatus permissionStatus =
        await _requestNotificationPermissions();
    switch (permissionStatus) {
      case NotificationPermissionStatus.granted:
        await _configureNotifications();
        break;
      case NotificationPermissionStatus.provisional:
        await _configureNotifications(isProvisional: true);
        break;
      case NotificationPermissionStatus.denied:
        break;
      case NotificationPermissionStatus.notDetermined:
        break;
    }
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen(
      _handleNotification,
    );
    final message = await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      _handleNotification(message);
    }

    await _cleanupOldNotifications();
  }

  Future<NotificationPermissionStatus> _requestNotificationPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      return await _requestIOSPermissions();
    } else if (Platform.isAndroid) {
      return await _requestAndroidPermissions();
    }
    return NotificationPermissionStatus.notDetermined;
  }

  Future<NotificationPermissionStatus> _requestIOSPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: true,
      carPlay: true,
      criticalAlert: true,
      provisional: false,
    );

    switch (settings.authorizationStatus) {
      case AuthorizationStatus.authorized:
        return NotificationPermissionStatus.granted;
      case AuthorizationStatus.provisional:
        return NotificationPermissionStatus.provisional;
      case AuthorizationStatus.denied:
        return NotificationPermissionStatus.denied;
      default:
        return NotificationPermissionStatus.notDetermined;
    }
  }

  Future<NotificationPermissionStatus> _requestAndroidPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _localNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation == null) {
      return NotificationPermissionStatus.notDetermined;
    }

    bool? hasPermission =
        await androidImplementation.requestNotificationsPermission();
    return hasPermission == true
        ? NotificationPermissionStatus.granted
        : NotificationPermissionStatus.denied;
  }

  Future<void> _configureNotifications({bool isProvisional = false}) async {
    // iOS settings
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _initializeAndroidChannel();

    await _initializeLocalNotifications();
  }

  Future<void> _initializeAndroidChannel() async {
    final AndroidNotificationChannel channel1 = AndroidNotificationChannel(
      channelId1,
      channelName1,
      description: channelDescription1,
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'), // Custom ovoz
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
      enableLights: true,
    );

    final AndroidNotificationChannel channel2 = AndroidNotificationChannel(
      channelId2,
      channelName2,
      description: channelDescription2,
      importance: Importance.max,
      playSound: true,
      sound:
          RawResourceAndroidNotificationSound('notification2'), // Custom ovoz
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
      enableLights: true,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    final androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      // Create both channels
      await androidImplementation.createNotificationChannel(channel1);
      await androidImplementation.createNotificationChannel(channel2);
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        defaultPresentSound: true,
        defaultPresentAlert: true,
        defaultPresentBadge: true,
        defaultPresentBanner: true,
      ),
    );

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
  }

  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    final String? payload = response.payload;
    if (payload != null) {
      _navigateToScreen(payload);
    }
  }

  void _handleNotification(RemoteMessage message) {
    final String? screenName = message.data['screen'];
    if (screenName != null) {
      _navigateToScreen(screenName);
    }
  }

  void _navigateToScreen(String screenName) async {
    final chuck = getIt<Chuck>();

    // final prefs = await SharedPreferences.getInstance();
    // if (screenName == 'new') {
    //   if (!prefs.containsKey(StorageKeys.notificationTime)) {
    //     LocalStorageService()
    //         .setString(StorageKeys.notificationTime, DateTime.now().toString());
    //   }

    //   AppRouter.instance.pushAndPopUntil(
    //     MainRoutes(),
    //     predicate: (route) => false,
    //   );
    // } else if (EnvironmentConfig.instance.isDev) {
    //   chuck.showInspector();
    // } else {
    if (EnvironmentConfig.instance.isDev) {
      if (Platform.isAndroid) {
        chuck.showInspector();
      }
    } else {
      AppRouter.instance.pushNamed('/$screenName');
    }
  }

  @override
  Future<String?> getFcmToken() async {
    return _firebaseMessaging.getToken();
  }

  @override
  Future<void> showNotification(RemoteMessage message) async {
    final RemoteNotification? notification = message.notification;

    if (notification != null) {
      final isNewNotification = message.data['screen'] == 'new';
      final channelID = isNewNotification ? channelId1 : channelId2;
      final channelNamE = isNewNotification ? channelName1 : channelName2;
      final channelDescription =
          isNewNotification ? channelDescription1 : channelDescription2;
      final importance = Importance.max;
      final priority = Priority.max;
      final vibrationPattern = Int64List.fromList([0, 1000, 500, 1000]);
      // final sound = isNewNotification
      //     ? RawResourceAndroidNotificationSound('notification')
      //     : RawResourceAndroidNotificationSound('notification2');

      await _localNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelID,
            channelNamE,
            channelDescription: channelDescription,
            importance: importance,
            priority: priority,
            playSound: true,
            autoCancel: true,
            colorized: true,
            color: AppColor.primaryColor,
            enableLights: true,
            ledColor: Color(0xFF00FF00),
            ledOnMs: 1000,
            ledOffMs: 500,
            enableVibration: true,
            vibrationPattern: vibrationPattern,
            icon: "@mipmap/ic_launcher",
            channelShowBadge: true,
            fullScreenIntent: false,
            largeIcon: DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
            category: AndroidNotificationCategory.message,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            sound: 'notification.wav',
            interruptionLevel: InterruptionLevel.active,
          ),
        ),
        payload: message.data['screen'],
      );
    }
  }

  @override
  Stream<NotificationMessage> get notificationStream {
    return FirebaseMessaging.onMessage.map((RemoteMessage firebaseMessage) {
      final notificationMessage = NotificationMessage(
        id: firebaseMessage.messageId ?? DateTime.now().toString(),
        title: firebaseMessage.notification?.title,
        body: firebaseMessage.notification?.body,
        data: firebaseMessage.data,
        isRead: false,
        userId: LocalStorageService().getString(StorageKeys.userId),
        timestamp: DateTime.now(),
      );
      _notificationsBox.put(notificationMessage.id, notificationMessage);
      return notificationMessage;
    });
  }

  @override
  Future<List<NotificationMessage>> getNotificationHistory() async {
    return _notificationsBox.values.toList();
  }

  @override
  Future<List<NotificationMessage>> getUnreadNotifications() async {
    return _notificationsBox.values
        .where((notification) => !notification.isRead)
        .toList();
  }

  @override
  Future<void> markAllNotificationsAsRead() async {
    for (var notification in _notificationsBox.values) {
      notification.isRead = true;
      await _notificationsBox.put(notification.id, notification);
    }
  }

  @override
  Future<void> markNotificationAsRead(String notificationId) async {
    final notification = _notificationsBox.get(notificationId);
    if (notification != null) {
      notification.isRead = true;
      await _notificationsBox.put(notificationId, notification);
    }
  }

  Future<void> _cleanupOldNotifications() async {
    final now = DateTime.now();
    final keysToDelete = _notificationsBox.values
        .where((notification) =>
            now.difference(notification.timestamp).inDays >= 1)
        .map((notification) => notification.id)
        .toList();

    await _notificationsBox.deleteAll(keysToDelete);
  }
}
