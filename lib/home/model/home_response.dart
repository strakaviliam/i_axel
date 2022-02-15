import 'book_model.dart';

class HomeResponse {
  final String key;
  final List<BookModel> books;
  final int total;

  HomeResponse(this.key, this.books, this.total);
}
