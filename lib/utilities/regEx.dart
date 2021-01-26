class Validator {
  static bool isValidEmail(String input) {
    RegExp emailReg =
        RegExp(r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{3,3})$');

    return emailReg.hasMatch(input);
  }

  static bool isValidName(String input) {
    RegExp emailReg = RegExp(r'^[a-zA-Z]{1,25}$');

    return emailReg.hasMatch(input);
  }
}
