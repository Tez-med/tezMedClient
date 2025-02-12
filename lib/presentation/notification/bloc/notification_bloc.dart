import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tez_med_client/injection.dart';

import '../../../data/notification/model/notification_message.dart';
import '../../../domain/notification/repositories/notification_repository.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;

  NotificationBloc(this.repository) : super(NotificationInitial()) {
    on<InitializeNotifications>(_onInitializeNotifications);
    on<NotificationReceived>(_onNotificationReceived);
    on<FetchNotificationHistory>(_onFetchNotificationHistory);
    on<MarkNotificationAsRead>(_onMarkNotificationAsRead);

    repository.notificationStream.listen((message) async {
      final prefs = getIt<SharedPreferences>();

      if (!prefs.containsKey('notification_time')) {
        await prefs.setString("notification_time", DateTime.now().toString());
      }
      add(NotificationReceived(message));
    });
  }

  List<NotificationMessage> _sortNotifications(
      List<NotificationMessage> notifications) {
    return List<NotificationMessage>.from(notifications)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  Future<void> _onMarkNotificationAsRead(
    MarkNotificationAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    final currentState = state;
    if (currentState is NotificationsLoaded) {
      try {
        await repository.markNotificationAsRead(event.notificationId);
        final updatedNotifications =
            currentState.notifications.map((notification) {
          if (notification.id == event.notificationId) {
            return notification.copyWith(isRead: true);
          }
          return notification;
        }).toList();

        emit(NotificationsLoaded(_sortNotifications(updatedNotifications)));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    }
  }

  Future<void> _onInitializeNotifications(
    InitializeNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(NotificationLoading());
      await repository.initializeNotifications();
      final notifications = await repository.getNotificationHistory();
      emit(NotificationsLoaded(_sortNotifications(notifications)));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onNotificationReceived(
    NotificationReceived event,
    Emitter<NotificationState> emit,
  ) async {
    final currentState = state;
    if (currentState is NotificationsLoaded) {
      final updatedNotifications = [
        event.message,
        ...currentState.notifications
      ];
      emit(NotificationsLoaded(_sortNotifications(updatedNotifications)));
    }
  }

  Future<void> _onFetchNotificationHistory(
    FetchNotificationHistory event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(NotificationLoading());
      final notifications = await repository.getNotificationHistory();
      emit(NotificationsLoaded(_sortNotifications(notifications)));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}
