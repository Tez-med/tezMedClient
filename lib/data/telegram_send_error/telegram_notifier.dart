import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class TelegramNotifier {
  final String? botToken = "7260267480:AAE3NZUfHJGGxSnFmOopvq06KB5app-mf_c";
  final String chatId = '-1002499582797';

  Future<void> sendMessage(String message) async {
    if (botToken == null || botToken!.isEmpty) {
      debugPrint('Telegram bot token mavjud emas yoki bo\'sh.');
      return;
    }

    final String url = 'https://api.telegram.org/bot$botToken/sendMessage';
    final Map<String, dynamic> data = {
      'chat_id': chatId,
      'text': message,
      'parse_mode': 'HTML',
    };

    try {
      await Dio().post(url, data: data);
    } on DioException catch (dioError) {
      debugPrint(
          'Telegramga xabar yuborishda DioException yuz berdi: ${dioError.message}');
    } catch (error) {
      debugPrint('Telegramga xabar yuborishda xatolik yuz berdi: $error');
    }
  }

  Future<void> sendError(String errorMessage) async {
    final String formattedErrorMessage = errorMessage;
    await sendMessage(formattedErrorMessage);
  }
}
