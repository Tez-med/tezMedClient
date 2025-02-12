import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tez_med_client/data/notification/model/notification_message.dart';

abstract class NotificationRepository {
  Future<void> initializeNotifications();
  Future<String?> getFcmToken();
  Future<void> showNotification(RemoteMessage message);
  Stream<NotificationMessage> get notificationStream;
  Future<List<NotificationMessage>> getNotificationHistory();
  Future<List<NotificationMessage>> getUnreadNotifications();
  Future<void> markNotificationAsRead(String notificationId);
  Future<void> markAllNotificationsAsRead();
  Future<void> saveBackgroundNotification(RemoteMessage message);
}
