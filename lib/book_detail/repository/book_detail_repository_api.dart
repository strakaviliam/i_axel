import 'package:flutter/foundation.dart';
import 'package:iaxel/app/api.dart';
import 'package:iaxel/app/app_result.dart';

import '../model/book_model.dart';
import 'book_detail_repository.dart';

class BookDetailRepositoryApi extends BookDetailRepository {

  Api _bookApi = Api('/books/{isbn13}', method: HTTPMethod.get);

  BookDetailRepositoryApi({Api? bookApi}) {
    _bookApi = bookApi ?? _bookApi;
  }

  @override
  Future<BookModel> loadBook(String isbn13) async {
    final Result result = await _bookApi.call(
      parameters: <String, dynamic>{
        '{isbn13}': isbn13,
      },
    );

    if (result.status == Status.fail) {
      throw result.errorResult();
    }
    return compute<Map<String, dynamic>, BookModel>(_parseBooks, result.data as Map<String, dynamic>);
  }

}

Future<BookModel> _parseBooks(Map<String, dynamic> data) async {
  return BookModel.fromMap(data);
}
