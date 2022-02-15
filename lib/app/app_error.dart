
class AppError {
  final String error;
  final String key;
  final Map<String, String>? errors;

  AppError(this.error, {this.key = '', this.errors});
}
