import 'package:flutter/foundation.dart';
import 'package:iaxel/app/api.dart';
import 'package:iaxel/app/app_result.dart';

import '../model/book_model.dart';
import '../model/home_response.dart';
import 'home_repository.dart';

class HomeRepositoryApi extends HomeRepository {

  Api _newBooksApi = Api('/new', method: HTTPMethod.get);
  Api _searchBooksApi = Api('/search/{query}/{page}', method: HTTPMethod.get);

  HomeRepositoryApi({Api? newBooksApi, Api? searchBooksApi}) {
    _newBooksApi = newBooksApi ?? _newBooksApi;
    _searchBooksApi = searchBooksApi ?? _searchBooksApi;
  }

  @override
  Future<HomeResponse> newBooks() async {
    final Result result = await _newBooksApi.call();

    if (result.status == Status.fail) {
      throw result.errorResult();
    }
    final int total = int.tryParse(result.data['total'].toString()) ?? 0;
    final List<BookModel> books = await compute<Map<String, dynamic>, List<BookModel>>(_parseBooks, result.data as Map<String, dynamic>);
    return HomeResponse(result.key, books, total);
  }

  @override
  Future<HomeResponse> searchBooks(int page, String query, String key) async {
    final Result result = await _searchBooksApi.call(
      key: key,
      parameters: <String, dynamic>{
        '{query}': query,
        '{page}': page.toString(),
      },
    );

    if (result.status == Status.fail) {
      throw result.errorResult();
    }
    final int total = int.tryParse(result.data['total'].toString()) ?? 0;
    final List<BookModel> books = await compute<Map<String, dynamic>, List<BookModel>>(_parseBooks, result.data as Map<String, dynamic>);
    return HomeResponse(result.key, books, total);
  }

}

Future<List<BookModel>> _parseBooks(Map<String, dynamic> data) async {
  final List<dynamic> booksList = data['books'] as List<dynamic>;
  return booksList.map((dynamic it) => BookModel.fromMap(it as Map<String, dynamic>)).toList();
}
