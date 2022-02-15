import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:iaxel/app/app.dart';
import 'package:iaxel/app/app_image.dart';
import 'package:iaxel/app/app_progress.dart';
import 'package:iaxel/app/app_router.dart';
import 'package:iaxel/common/constant.dart';
import 'package:iaxel/common/widget/screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/book_detail_bloc.dart';
import '../bloc/book_detail_state.dart';

class BookDetailScreen extends Screen {
  static const String name = ScreenPath.BOOK_DETAIL_SCREEN;

  BookDetailScreen({Key? key}) : super(name, key: key);

  @override
  State<StatefulWidget> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {

  @override
  void initState() {
    super.initState();
    final String isbn13 = widget.params['isbn13'] as String? ?? '';
    BlocProvider.of<BookDetailBloc>(context).loadBookDetail(isbn13);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: App.appTheme.colorNavbar,
        title: const SizedBox(
          height: 40,
          child: AppImage('assets/images/logo.png'),
        ),
        centerTitle: true,
        actions: const [SizedBox(width: 50)],
      ),
      body: BlocConsumer<BookDetailBloc, BookDetailState>(
        listener: (context, state) {

        },
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => Container(),
            loading: () => const Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: AppProgress(),
              ),
            ),
            loaded: (book) {
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(right: 8, left: 8),
                  child: Column(
                    children: [
                      //general info
                      SizedBox(
                        height: 170,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  Text(book.title, style: App.appTheme.textHeader, maxLines: 3),
                                  const SizedBox(height: 8),
                                  Text(book.year + ' ' + book.authors, style: App.appTheme.textBody, maxLines: 4),
                                  const Spacer(),
                                  Text(book.price, style: App.appTheme.textHeader.copyWith(color: App.appTheme.colorActive)),
                                  const SizedBox(height: 4),
                                ],
                              ),
                            ),

                            SizedBox(
                              width: 170,
                              child: AppImage(book.image, boxFit: BoxFit.cover, alignV: -1),
                            ),

                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      //rating
                      if (book.rating > 0)
                        Row(
                          children: [
                            const Spacer(),
                            ...List.generate(5, (index) => Container(
                              width: 24,
                              height: 24,
                              margin: const EdgeInsets.only(left: 2, right: 2),
                              child: AppImage(Icons.star, color: book.rating > index ? App.appTheme.colorPrimary : App.appTheme.colorInactive),
                            )).toList(),
                            const Spacer(),
                          ],
                        ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: Container(height: 1, color: App.appTheme.colorInactive.withAlpha(100))),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(book.desc),
                      if (book.pdf.isNotEmpty)
                        _previewView(book.pdf),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _previewView(Map<String, String> preview) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: Container(height: 1, color: App.appTheme.colorInactive.withAlpha(100))),
          ],
        ),
        const SizedBox(height: 16),
        Text('book_detail__preview_title'.tr(), style: App.appTheme.textHeader),
        ...preview.keys.map((previewKey) => SizedBox(
          height: 50,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                final String useUrl = preview[previewKey]!;
                if (useUrl.endsWith('pdf')) {
                  AppRouter.pushRoute(context, MaterialPageRoute<dynamic>(
                    builder: (_) => PDFViewerCachedFromUrl(
                      title: previewKey,
                      url: preview[previewKey]!,
                    ),
                  ));
                } else {
                  launch(useUrl);
                }
              },
              child: Row(
                children: [
                  Text(previewKey, style: App.appTheme.textTitle),
                  const Spacer(),
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: AppImage(Icons.chevron_right_outlined, color: App.appTheme.colorIcon),
                  ),
                ],
              ),
            ),
          ),
        )).toList(),
      ],
    );
  }
}

class PDFViewerCachedFromUrl extends StatelessWidget {
  const PDFViewerCachedFromUrl({Key? key, required this.url, required this.title}) : super(key: key);

  final String url;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const PDF().cachedFromUrl(
        url,
        placeholder: (double progress) => Center(child: Text('$progress %')),
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
    );
  }
}