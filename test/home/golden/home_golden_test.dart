import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iaxel/home/model/book_model.dart';
import 'package:iaxel/home/model/home_response.dart';
import 'package:iaxel/home/repository/home_repository.dart';
import 'package:iaxel/home/ui/home_screen.dart';
import 'package:mocktail/mocktail.dart';

import '../../common_tests.dart';
import '../../main_widget_tests.dart';

Future<void> main() async {

  final HomeRepository homeRepository = MockHomeRepository();

  final bookModel = BookModel.fromMap(<String, dynamic>{
    'title': 'Securing DevOps',
    'subtitle': 'Security in the Cloud',
    'isbn13': '9781617294136',
    'price': '\$26.98',
    'image': '',
    'url': '',
  });

  final homeResponse = HomeResponse('key', [bookModel, bookModel, bookModel, bookModel, bookModel, bookModel], 6);

  when(() => homeRepository.newBooks()).thenAnswer((_) => Future.value(homeResponse));

  CommonTests.setupDependencies(
    homeRepository: homeRepository,
  );

  testWidgets('Home screen test', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(3800, 5000);
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

    await tester.pumpWidget(MainWidgetTests(
      homeScreen: Scaffold(body: HomeScreen()),
    ));
    await tester.pumpAndSettle();
    await expectLater(find.byType(HomeScreen), matchesGoldenFile('home_golden_test.png'));
  });
}
