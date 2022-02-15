
import 'api.dart';

enum Status{
  success, fail
}

class Result {

  final Status status;
  final dynamic data;
  final String? error;
  final Map<String, String>? errors;
  final String key;

  const Result({
    required this.status,
    required this.key,
    this.data,
    this.error,
    this.errors
  });

  ErrorResult errorResult() {
    return ErrorResult(
      error: error ?? Api.ERROR_GENERAL,
      errors: errors,
      key: key,
    );
  }
}

class ErrorResult implements Exception {
  final String error;
  final String key;
  final Map<String, String>? errors;

  ErrorResult({
    required this.error,
    required this.key,
    this.errors,
  });
}
