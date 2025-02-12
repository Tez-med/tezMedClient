 // Phone number formatting utility
  String formatPhoneNumber(String phoneNumber) {
    // Remove any non-digit characters and '+998' prefix
    String cleaned = phoneNumber.replaceAll(RegExp(r'\D'), '');
    if (cleaned.startsWith('998')) {
      cleaned = cleaned.substring(3);
    }

    // Format remaining digits as "XX XXX XX XX"
    if (cleaned.length >= 9) {
      return '${cleaned.substring(0, 2)} '
          '${cleaned.substring(2, 5)} '
          '${cleaned.substring(5, 7)} '
          '${cleaned.substring(7, 9)}';
    }

    return cleaned; 
  }