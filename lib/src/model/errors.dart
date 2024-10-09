class DeepLError extends Error {
  String message;
  Error? error;

  DeepLError({required this.message, this.error});

  @override
  String toString() => 'DeepLError[message: $message, error: $error]';
}

class AuthorizationError extends DeepLError {
  AuthorizationError({required super.message});
}

class QuotaExceededError extends DeepLError {
  QuotaExceededError({required super.message});
}

class TooManyRequestsError extends DeepLError {
  TooManyRequestsError({required super.message});
}

class ConnectionError extends DeepLError {
  bool shouldRetry;

  ConnectionError(
      {required super.message, this.shouldRetry = false, super.error});
}

class GlossaryNotFoundError extends DeepLError {
  GlossaryNotFoundError({required super.message});
}

class DocumentNotReadyError extends DeepLError {
  DocumentNotReadyError({required super.message});
}
