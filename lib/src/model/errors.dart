class DeepLError extends Error {
  String message;
  Error? error;

  DeepLError({required this.message, this.error});

  @override
  String toString() => 'DeepLError[message: $message, error: $error]';
}

class AuthorizationError extends DeepLError {
  AuthorizationError({required String message}) : super(message: message);
}

class QuotaExceededError extends DeepLError {
  QuotaExceededError({required String message}) : super(message: message);
}

class TooManyRequestsError extends DeepLError {
  TooManyRequestsError({required String message}) : super(message: message);
}

class ConnectionError extends DeepLError {
  bool shouldRetry;

  ConnectionError(
      {required String message, this.shouldRetry = false, Error? error})
      : super(message: message, error: error);
}

class GlossaryNotFoundError extends DeepLError {
  GlossaryNotFoundError({required String message}) : super(message: message);
}

class DocumentNotReadyError extends DeepLError {
  DocumentNotReadyError({required String message}) : super(message: message);
}
