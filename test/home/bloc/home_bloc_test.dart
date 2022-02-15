import 'package:flutter_test/flutter_test.dart';
import 'package:iaxel/home/bloc/home_bloc.dart';
import 'package:iaxel/home/bloc/home_state.dart';
import 'package:iaxel/home/model/book_model.dart';
import 'package:iaxel/home/model/home_response.dart';
import 'package:iaxel/home/repository/home_repository.dart';
import 'package:mocktail/mocktail.dart';
import '../../common_tests.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HomeBloc', () {
    late HomeBloc homeBloc;

    late HomeRepository homeRepository;

    setUp(() {
      homeRepository = MockHomeRepository();
      homeBloc = HomeBloc(
        homeRepository: homeRepository,
      );
    });

    tearDown(() {
      homeBloc.close();
    });

    test('after initialization bloc state is correct', () {
      expect(const HomeState.init(), homeBloc.state);
    });

    test('after closing bloc does not emit any states', () {
      expectLater(homeBloc.stream, emitsInOrder(<dynamic>[emitsDone]));
      homeBloc.close();
    });

    test('after newBooks, loading/loaded state should be emitted', () async {

      final homeResponse = HomeResponse('key', [
        BookModel.fromMap(<String, dynamic>{}),
      ], 1);

      final expectedResponse = <dynamic>[
        const HomeState.loading(),
        HomeState.loaded(homeResponse.books, homeResponse.total),
      ];

      when(() => homeRepository.newBooks()).thenAnswer((_) => Future.value(homeResponse));

      expectLater(homeBloc.stream, emitsInOrder(expectedResponse));

      homeBloc.newBooks();
    });

    test('after searchBooks, loading/loaded state should be emitted', () async {

      final homeResponse = HomeResponse('key', [
        BookModel.fromMap(<String, dynamic>{}),
      ], 1);

      final expectedResponse = <dynamic>[
        const HomeState.loading(),
        HomeState.loaded(homeResponse.books, homeResponse.total),
      ];

      when(() => homeRepository.searchBooks(any(), any(), any())).thenAnswer((_) => Future.value(homeResponse));

      expectLater(homeBloc.stream, emitsInOrder(expectedResponse));

      homeBloc.searchBooks(query: 'key');
    });

  });
}
