import 'package:shared_preferences/shared_preferences.dart';

class AppCache {

  static const String _languageKey = 'kLanguageKey';

  String _language = 'en';
  final List<String> _languages = ['en', 'sk'];
  String _apiEndpoint = '';

  String get language => _language;
  List<String> get languages => _languages;
  String get apiEndpoint => _apiEndpoint;

  Future<void> setup({
    String? language,
    String? apiEndpoint,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    _apiEndpoint = apiEndpoint ?? _apiEndpoint;

    //set user language
    if (language != null) {
      _language = language;
      storage.setString(_languageKey, _language);
    }
  }

  Future<void> init() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    _language = storage.getString(_languageKey) ?? _language;
  }
}
