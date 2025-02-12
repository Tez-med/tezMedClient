part of 'notification_bloc.dart';

abstract class NotificationEvent {}

class InitializeNotifications extends NotificationEvent {}

class NotificationReceived extends NotificationEvent {
  final NotificationMessage message;
  NotificationReceived(this.message);
}

class MarkNotificationAsRead extends NotificationEvent {
  final String notificationId;

  MarkNotificationAsRead(this.notificationId);
}

class FetchNotificationHistory extends NotificationEvent {}
