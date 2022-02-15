import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iaxel/app/app_router.dart';
import 'package:iaxel/book_detail/model/book_model.dart';
import 'package:iaxel/book_detail/repository/book_detail_repository.dart';
import 'package:iaxel/book_detail/ui/book_detail_screen.dart';
import 'package:mocktail/mocktail.dart';

import '../../common_tests.dart';
import '../../main_widget_tests.dart';

Future<void> main() async {

  final BookDetailRepository bookDetailRepository = MockBookDetailRepository();

  final bookModel = BookModel.fromMap(<String, dynamic>{
    'title': 'Securing DevOps',
    'subtitle': 'Security in the Cloud',
    'authors': 'Julien Vehent',
    'publisher': 'Manning',
    'isbn10': '1617294136',
    'isbn13': '9781617294136',
    'pages': '384',
    'year': '2018',
    'rating': '5',
    'desc': 'An application running in the cloud can benefit from incredible efficiencies, but they come with unique security threats too. ',
    'price': '\$26.98',
    'image': '',
    'url': '',
    'pdf': {
      'Chapter 2': 'https://itbook.store/files/9781617294136/chapter2.pdf',
      'Chapter 5': 'https://itbook.store/files/9781617294136/chapter5.pdf'
    }
  });

  when(() => bookDetailRepository.loadBook(any())).thenAnswer((_) => Future.value(bookModel));

  CommonTests.setupDependencies(
    bookDetailRepository: bookDetailRepository,
  );

  testWidgets('Book detail screen test', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(3800, 5000);
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

    AppRouter.nav = AppNavigation(BookDetailScreen.name);
    AppRouter.nav!.params['isbn13'] = '';

    await tester.pumpWidget(MainWidgetTests(
      homeScreen: Scaffold(body: BookDetailScreen()),
    ));
    await tester.pumpAndSettle();
    await expectLater(find.byType(BookDetailScreen), matchesGoldenFile('book_detail_golden_test.png'));
  });
}
