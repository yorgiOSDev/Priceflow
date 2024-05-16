class TValidator {
  static String? validateEmail(String value) {
    if (value == null && value.isEmpty) {
      return 'Email is required.';
    }

    //Regular expression for email verification
    final emailRegExp = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address.';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    //Check for minimum password length
    if (value.length < 8) {
      return 'Password must beat at least 8 characters long.';
    }

    //Check for upperCase letters
    if (value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter.';
    }

    //Check for numbers
    if (value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number.';
    }

    //Check for special characters
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character.';
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required.';
    }

    //Regular expression for phone number validation assuming a 10 digit USA Phone Number format
    final phoneRegExp = RegExp(r'^\d{10}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number format (10 digits required).';
    }

    return null;
  }

  //Add more custom validators as needed
}
