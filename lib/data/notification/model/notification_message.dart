import 'package:hive/hive.dart';

part 'notification_message.g.dart';

@HiveType(typeId: 5)
class NotificationMessage extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? title;

  @HiveField(2)
  final String? body;

  @HiveField(3)
  final Map<String, dynamic>? data;

  @HiveField(4)
  final DateTime timestamp;

  @HiveField(5)
  bool isRead;

  @HiveField(6)
  final String userId;

  NotificationMessage({
    required this.id,
    required this.userId,
    this.title,
    this.body,
    this.data,
    required this.timestamp,
    required this.isRead,
  });

  // JSONdan yaratish va JSONga o'zgartirish metodlari

  // copyWith metodini moslashtirish
  NotificationMessage copyWith({
    String? id,
    String? title,
    String? body,
    Map<String, dynamic>? data,
    DateTime? timestamp,
    bool? isRead,
    String? userId,
  }) {
    return NotificationMessage(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}
