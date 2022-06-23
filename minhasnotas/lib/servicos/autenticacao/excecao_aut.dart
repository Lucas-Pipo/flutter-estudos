// exceções de login
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// exceções de registro
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// exceções genéricas

class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
