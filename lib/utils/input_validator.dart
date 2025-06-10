class InputValidator {
  static bool isValidId(String id) {
    final regex = RegExp(r'^[a-z]{1,6}$');
    return regex.hasMatch(id);
  }

  static bool isValidPassword(String password) {
    final regex = RegExp(r'^[a-zA-Z_]{1,15}$');
    return regex.hasMatch(password);
  }
}