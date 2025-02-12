class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  ValidationResult({required this.isValid, this.errorMessage});

  static ValidationResult success() => ValidationResult(isValid: true);
  static ValidationResult failure(String message) => 
    ValidationResult(isValid: false, errorMessage: message);
}