import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/gen/assets.gen.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import 'package:tez_med_client/presentation/notification/bloc/notification_bloc.dart';

import '../../../data/notification/model/notification_message.dart';

@RoutePage()
class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColor.primaryColor),
          onPressed: () => context.router.maybePop(),
        ),
        title: Text(
          S.of(context).notification,
        ),
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColor.primaryColor),
              ),
            );
          } else if (state is NotificationsLoaded) {
            if (state.notifications.isEmpty) {
              return const _EmptyNotification();
            }

            return _buildNotificationList(context, state.notifications);
          } else if (state is NotificationError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: AppTextstyle.nunitoBold
                        .copyWith(color: Colors.red[300]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return const SizedBox.expand();
        },
      ),
    );
  }

  Widget _buildNotificationList(
      BuildContext context, List<NotificationMessage> notifications) {
    // Get the local userId from Hive box
    final localUserId = LocalStorageService().getString(StorageKeys.userId);

    final filteredNotifications = notifications
        .where((notification) => notification.userId == localUserId)
        .toList();

    if (filteredNotifications.isEmpty) {
      return const _EmptyNotification();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredNotifications.length,
      itemBuilder: (context, index) {
        final notification = filteredNotifications[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _NotificationItem(
            notification: notification,
            onTap: () {
              context
                  .read<NotificationBloc>()
                  .add(MarkNotificationAsRead(notification.id));
            },
          ),
        );
      },
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final NotificationMessage notification;
  final VoidCallback onTap;

  const _NotificationItem({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: notification.isRead
            ? Colors.white
            : AppColor.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNotificationIcon(),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title ?? 'No title',
                        style: AppTextstyle.nunitoBold.copyWith(
                          fontSize: 18,
                          color: AppColor.primaryColor,
                        ),
                      ),
                      Text(
                        notification.body ?? 'No body',
                        style: AppTextstyle.nunitoMedium.copyWith(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatDate(notification.timestamp),
                        style: AppTextstyle.nunitoMedium.copyWith(
                          fontSize: 13,
                          color: AppColor.greyColor500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!notification.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.primaryColor,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColor.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.notifications,
        color: AppColor.primaryColor,
        size: 24,
      ),
    );
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('MMMM d, y HH:mm').format(dateTime);
  }
}

class _EmptyNotification extends StatelessWidget {
  const _EmptyNotification();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.icons.notificationEmpty.svg(),
          const SizedBox(height: 15),
          Text(
            S.of(context).no_notification,
            textAlign: TextAlign.center,
            style: AppTextstyle.nunitoBold.copyWith(fontSize: 20),
          ),
          Text(
            S.of(context).no_notification_subtitle,
            textAlign: TextAlign.center,
            style: AppTextstyle.nunitoMedium
                .copyWith(fontSize: 18, color: AppColor.greyTextColor),
          ),
        ],
      ),
    );
  }
}
