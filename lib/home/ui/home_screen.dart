import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iaxel/app/app.dart';
import 'package:iaxel/app/app_image.dart';
import 'package:iaxel/app/app_progress.dart';
import 'package:iaxel/app/app_router.dart';
import 'package:iaxel/common/constant.dart';
import 'package:iaxel/common/widget/screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';
import '../model/book_model.dart';

class HomeScreen extends Screen {
  static const String name = ScreenPath.HOME_SCREEN;

  HomeScreen({Key? key}) : super(name, key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final ScrollController _scrollController = ScrollController(initialScrollOffset: 0.0);
  final RefreshController _refreshController = RefreshController();
  String _searchText = '';
  bool _canLoadMore = true;
  List<BookModel>? _results;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _loadData();
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
      ),
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          state.maybeWhen(
            orElse: () {
              _refreshController.refreshCompleted();
            },
            error: (error) {
              //todo
            },
            loaded: (books, total) {
              if (_refreshController.isRefresh || _results == null) {
                _results = [];
              }
              _refreshController.refreshCompleted();
              _refreshController.loadComplete();
              _results!.addAll(books);
              _canLoadMore = _results!.length < total;
              setState(() {});
            },
          );
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            color: App.appTheme.colorBackground,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: _SearchField(
                    onTextChange: (text) {
                      _searchText = text.toLowerCase().trim();
                      Future.delayed(const Duration(milliseconds: 500), () {
                        if (text.toLowerCase().trim() == _searchText) {
                          _searchText = text.toLowerCase().trim();
                          _currentPage = 1;
                          _results = null;
                          setState(() {});
                          _loadData();
                        }
                      });
                    },
                  ),
                ),
                Expanded(
                  child: _resultView(),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }

  Widget _resultView() {
    if (_results == null) {
      return const _LoadingView();
    }

    if (_results!.isEmpty) {
      return const _NoResultsView();
    }

    return _ResultsView(
      scrollController: _scrollController,
      refreshController: _refreshController,
      results: _results!,
      canLoadMore: _canLoadMore,
      loadMore: () {
        _currentPage++;
        _loadData();
      },
      refresh: () {
        _currentPage = 1;
        _results = null;
        _loadData();
      },
    );
  }

  Future<void> _loadData() async {
    if (_searchText.isEmpty) {
      BlocProvider.of<HomeBloc>(context).newBooks();
    } else {
      BlocProvider.of<HomeBloc>(context).searchBooks(page: _currentPage, query: _searchText);
    }
  }
}

class _SearchField extends StatelessWidget {

  final Function(String) onTextChange;

  const _SearchField({required this.onTextChange, Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: App.appTheme.textTitle,
      cursorColor: App.appTheme.colorPrimary,
      decoration: InputDecoration(
        suffixIcon: SizedBox(
          width: 30,
          height: 30,
          child: AppImage(Icons.search, color: App.appTheme.colorPrimary),
        ),
        suffixIconConstraints: const BoxConstraints(
          minHeight: 32,
          minWidth: 32,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: App.appTheme.colorPrimary, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: App.appTheme.colorPrimary, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: App.appTheme.colorInactive, width: 1),
        ),
        fillColor: App.appTheme.colorSecondary,
        filled: true,
        hintStyle: App.appTheme.textTitle.copyWith(color: App.appTheme.colorInactive),
        hintText: 'home__search_hint'.tr(),
      ),
      onChanged: onTextChange,
    );
  }

}

class _LoadingView extends StatelessWidget {

  const _LoadingView({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: AppProgress(),
      ),
    );
  }
}

class _NoResultsView extends StatelessWidget {

  const _NoResultsView({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('home__result_empty'.tr(), style: App.appTheme.textHeader.copyWith(color: App.appTheme.colorInactive)),
            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }
}

class _ResultsView extends StatelessWidget {

  final ScrollController scrollController;
  final RefreshController refreshController;
  final bool canLoadMore;
  final Function loadMore;
  final Function refresh;
  final List<BookModel> results;

  const _ResultsView({
    required this.scrollController,
    required this.refreshController,
    required this.loadMore,
    required this.refresh,
    required this.results,
    this.canLoadMore = true,
    Key? key,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      controller: scrollController,
      thumbColor: App.appTheme.colorPrimary,
      radius: const Radius.circular(2),
      thickness: 4,
      child: SmartRefresher(
        controller: refreshController,
        scrollController: scrollController,
        enablePullDown: true,
        enablePullUp: canLoadMore,
        header: WaterDropHeader(
          waterDropColor: App.appTheme.colorSecondary,
          refresh: const SizedBox(
            width: 25.0,
            height: 25.0,
            child: AppProgress(size: 2),
          ),
          complete: SizedBox(
            width: 30.0,
            height: 30.0,
            child: AppImage(Icons.done_outline_rounded, color: App.appTheme.colorSuccess),
          ),
        ),
        footer: ClassicFooter(
          textStyle: App.appTheme.textTitle,
          loadingIcon: const SizedBox(
            width: 25.0,
            height: 25.0,
            child: AppProgress(size: 2),
          ),
          loadingText: 'home__result_loading'.tr(),
          idleText: 'home__result_pull_up'.tr(),
          canLoadingText: 'home__result_release'.tr(),
        ),
        onLoading: () => loadMore(),
        onRefresh: () => refresh(),
        child: ListView.builder(
          itemCount: results.length,
          controller: scrollController,
          padding: EdgeInsets.fromLTRB(8, 8, 8, MediaQuery.of(context).padding.bottom + 8),
          itemExtent: 154,
          itemBuilder: (context, index) {
            final BookModel book = results[index];
            return _BookInfoView(book);
          },
        ),
      ),
    );
  }
}

class _BookInfoView extends StatelessWidget {

  final BookModel book;

  const _BookInfoView(this.book, {Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: App.appTheme.colorInactive)),
      ),
      height: 150,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            AppRouter.push(context, ScreenPath.BOOK_DETAIL_SCREEN, params: <String, dynamic>{'isbn13': book.isbn13});
          },
          child: Row(
            children: [
              SizedBox(
                width: 150,
                child: AppImage(book.image, boxFit: BoxFit.cover, alignV: -1),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(book.title, style: App.appTheme.textHeader, maxLines: 2),
                    const SizedBox(height: 8),
                    Text(book.subtitle, style: App.appTheme.textTitle, maxLines: 3),
                    const Spacer(),
                    Row(
                      children: [
                        const Spacer(),
                        Text(book.price, style: App.appTheme.textTitle.copyWith(color: App.appTheme.colorActive)),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
