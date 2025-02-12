import 'package:intl/intl.dart';

DateTime parseToDateTime(String dateString) {
  // Har xil vaqt formatlarini sinab ko'rish uchun ro'yxat
  List<String> formats = [
    "yyyy/MM/dd HH:mm:ss",
    "yyyy-MM-dd HH:mm",
    "dd-MM-yyyy HH:mm:ss",
    "MM/dd/yyyy HH:mm:ss",
    "yyyy-MM-dd",
    "dd/MM/yyyy",
    "MM-dd-yyyy",
    "dd MMM yyyy",
    "MMM dd, yyyy",
    "yyyy/MM/dd",
    "dd.MM.yyyy",
    "yyyyMMdd",
  ];

  // Har bir formatni tahlil qilib ko'rish
  for (String format in formats) {
    try {
      // Sana formatini o'qish
      DateTime parsedDate = DateFormat(format).parse(dateString);
      return parsedDate;
    } catch (e) {
      // Xatolik yuzaga kelganda davom etish
      continue;
    }
  }

  // Agar barcha formatlar bilan xatolik bo'lsa, standard parserni sinash
  DateTime? fallbackDate = DateTime.tryParse(dateString);
  if (fallbackDate != null) {
    return fallbackDate;
  }

  // Agar sanani o'qish muvaffaqiyatsiz bo'lsa, hozirgi sanani qaytarish
  return DateTime.now();
}
