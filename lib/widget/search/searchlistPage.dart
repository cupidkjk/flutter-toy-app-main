import 'package:flutter/material.dart';
import 'package:toy_app/components/components.dart';
import 'package:toy_app/model/product.model.dart';
import 'package:toy_app/widget/detailPage_test.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:toy_app/service/product_repo.dart';
import 'package:provider/provider.dart';
import 'package:toy_app/provider/index.dart';

// import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class Searchlist extends StatefulWidget {
  Searchlist({Key key, this.searchText}) : super(key: key);
  String searchText;
  @override
  State<Searchlist> createState() => _Searchlist();
}

class _Searchlist extends State<Searchlist> {
  // future setting
  static const int _pageSize = 3;
  // provider setting
  AppState _appState;

  final PagingController<int, ProductM> _pagingController =
      PagingController(firstPageKey: 0);
  @override
  void initState() {
    // app state
    _appState = Provider.of<AppState>(context, listen: false);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    setState(() {});

    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await ProductService.searchProductsByName(
          pageKey, _pageSize, widget.searchText);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
      setState(() {});
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    // 4
    _pagingController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(Searchlist oldWidget) {
    if (oldWidget.searchText != widget.searchText) {
      _pagingController.refresh();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      // backgroundColor: Color(0xff283488),
      bottomNavigationBar:
          CustomBottomNavbar(context: context, selectedIndex: 0),
      appBar: CustomAppBar(
        title: const Text(""),
        leadingAction: () {
          Navigator.pop(context);
        },
      ),
      floatingActionButton: const LanguageTransitionWidget(),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xffffffff),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: height * 0.02, horizontal: width * 0.05),
                    child: Text(
                      widget.searchText,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        letterSpacing: 0.02,
                        fontFamily: "Avenir Next",
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 0, horizontal: width * 0.05),
                    child: Text(
                      AppLocalizations.of(context).searchlistpage_result,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        fontFamily: "Avenir Next",
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: height * 0.65,
                child: // 1
                    RefreshIndicator(
                  onRefresh: () => Future.sync(
                    () => _pagingController.refresh(),
                  ),
                  child: PagedListView.separated(
                    pagingController: _pagingController,
                    padding: const EdgeInsets.all(16),
                    builderDelegate: PagedChildBuilderDelegate<ProductM>(
                      itemBuilder: (context, product, index) =>
                          ProductSearchItemBuilder(entry: product),
                      firstPageErrorIndicatorBuilder: (context) => Center(
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    child: const Text('Retry'),
                                    onPressed: () =>
                                        _pagingController.refresh())
                              ],
                            )),
                      ),
                      noItemsFoundIndicatorBuilder: (context) => Center(
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text('No Items Found'),
                              ],
                            )),
                      ),
                    ),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
