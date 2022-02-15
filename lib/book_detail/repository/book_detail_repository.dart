import '../model/book_model.dart';

abstract class BookDetailRepository {
  Future<BookModel> loadBook(String isbn13);
}
