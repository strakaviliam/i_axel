import 'package:flutter_test/flutter_test.dart';
import 'package:iaxel/book_detail/bloc/book_detail_bloc.dart';
import 'package:iaxel/book_detail/bloc/book_detail_state.dart';
import 'package:iaxel/book_detail/model/book_model.dart';
import 'package:iaxel/book_detail/repository/book_detail_repository.dart';
import 'package:mocktail/mocktail.dart';
import '../../common_tests.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BookDetailBloc', () {
    late BookDetailBloc bookDetailBloc;

    late BookDetailRepository bookDetailRepository;

    setUp(() {
      bookDetailRepository = MockBookDetailRepository();
      bookDetailBloc = BookDetailBloc(
        bookDetailRepository: bookDetailRepository,
      );
    });

    tearDown(() {
      bookDetailBloc.close();
    });

    test('after initialization bloc state is correct', () {
      expect(const BookDetailState.init(), bookDetailBloc.state);
    });

    test('after closing bloc does not emit any states', () {
      expectLater(bookDetailBloc.stream, emitsInOrder(<dynamic>[emitsDone]));
      bookDetailBloc.close();
    });

    test('after newBooks, loading/loaded state should be emitted', () async {

      final bookDetailResponse = BookModel.fromMap(<String, dynamic>{});

      final expectedResponse = <dynamic>[
        const BookDetailState.loading(),
        BookDetailState.loaded(bookDetailResponse),
      ];

      when(() => bookDetailRepository.loadBook(any())).thenAnswer((_) => Future.value(bookDetailResponse));

      expectLater(bookDetailBloc.stream, emitsInOrder(expectedResponse));

      bookDetailBloc.loadBookDetail('');
    });

  });
}
