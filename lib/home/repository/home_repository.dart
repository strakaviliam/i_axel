import '../model/home_response.dart';

abstract class HomeRepository {
  Future<HomeResponse> newBooks();
  Future<HomeResponse> searchBooks(int page, String query, String key);
}
