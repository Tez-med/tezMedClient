import 'package:hive_flutter/hive_flutter.dart';

import '../../data/notification/model/notification_message.dart';

Future<void> initHive() async {
  Hive.initFlutter();
  Hive.registerAdapter(NotificationMessageAdapter());
}
