/// Validators for input fields
class Validators {
  /// Validate email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email не может быть пустым';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Введите корректный email';
    }

    return null;
  }

  /// Validate password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пароль не может быть пустым';
    }

    if (value.length < 6) {
      return 'Пароль должен быть минимум 6 символов';
    }

    return null;
  }

  /// Validate strong password
  static String? validateStrongPassword(String? value) {
    final passwordValidation = validatePassword(value);
    if (passwordValidation != null) {
      return passwordValidation;
    }

    if (!value!.contains(RegExp(r'[A-Z]'))) {
      return 'Пароль должен содержать хотя бы одну заглавную букву';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Пароль должен содержать хотя бы одну цифру';
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Пароль должен содержать хотя бы один специальный символ';
    }

    return null;
  }

  /// Validate name
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Имя не может быть пустым';
    }

    if (value.length < 2) {
      return 'Имя должно быть минимум 2 символа';
    }

    if (value.length > 50) {
      return 'Имя не должно быть длиннее 50 символов';
    }

    return null;
  }

  /// Validate URL
  static String? validateURL(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL optional
    }

    try {
      Uri.parse(value);
      if (!value.startsWith('http://') && !value.startsWith('https://')) {
        return 'URL должен начинаться с http:// или https://';
      }
      return null;
    } catch (e) {
      return 'Некорректный URL';
    }
  }

  /// Validate passwords match
  static String? validatePasswordsMatch(
    String? password,
    String? confirmPassword,
  ) {
    if (password != confirmPassword) {
      return 'Пароли не совпадают';
    }
    return null;
  }

  /// Check if email is valid (simple check)
  static bool isValidEmail(String email) {
    return validateEmail(email) == null;
  }

  /// Check if password is valid
  static bool isValidPassword(String password) {
    return validatePassword(password) == null;
  }

  /// Check if name is valid
  static bool isValidName(String name) {
    return validateName(name) == null;
  }
}
