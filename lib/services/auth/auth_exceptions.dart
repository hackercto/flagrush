// login

class UserNotFoundAuthException implements Exception {
  final String message = 'User not found';
}

class InvalidPasswordAuthException implements Exception {
  final String message = 'Invalid password';
}

// register

class WeakPasswordAuthException implements Exception {
  final String message = 'Weak password';
}

class EmailAlreadyInUseAuthException implements Exception {
  final String message = 'Email already in use';
}

class InvalidEmailAuthException implements Exception {
  final String message = 'Invalid email';
}

// generic

class GenericAuthException implements Exception {
  final String message = 'An error occurred';
}

class UserNotLoggedInAuthException implements Exception {
  final String message = 'User not logged in';
}