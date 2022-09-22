import 'package:flutter/material.dart';
import 'package:toy_app/components/components.dart';

import 'package:toy_app/service/product_repo.dart';
import 'package:toy_app/model/category_list_model.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:provider/provider.dart';
import 'package:toy_app/provider/index.dart';

import 'package:flutter_pagewise/flutter_pagewise.dart';

class Categories extends StatefulWidget {
  const Categories({Key key}) : super(key: key);

  @override
  State<Categories> createState() => _Categories();
}

class _Categories extends State<Categories> {
  // future setting
  static const int PAGE_SIZE = 4;
  // provider setting
  AppState _appState;
  Widget _build() {
    double _width = MediaQuery.of(context).size.width * 0.45;
    double _height = MediaQuery.of(context).size.height * 0.3;
    return PagewiseGridView<CategoryList>.count(
      pageSize: PAGE_SIZE,
      crossAxisCount: 2,
      mainAxisSpacing: 20.0,
      crossAxisSpacing: 10.0,
      childAspectRatio: _width / _height,
      padding: const EdgeInsets.all(15.0),
      itemBuilder: _itemBuilder,
      loadingBuilder: (context) {
        return Center(
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                ],
              )),
        );
      },
      retryBuilder: (context, callback) {
        return Center(
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      child: const Text('Retry'), onPressed: () => callback())
                ],
              )),
        );
      },
      noItemsFoundBuilder: (context) {
        return Center(
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('No Items Found'),
                ],
              )),
        );
      },
      pageFuture: (pageIndex) {
        return ProductService.getAllCategories(pageIndex, PAGE_SIZE);
      },
    );
  }

  Widget _itemBuilder(context, CategoryList entry, _) {
    return InkWell(
      // hoverColor: Colors.pink,
      onTap: () {
        Navigator.pushNamed(
          context,
          "/categoryItem",
          arguments: {'id': entry?.id, 'name': entry?.name},
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Colors.white,
          // boxShadow: [
          //   BoxShadow(
          //     offset: const Offset(0, 1),
          //     blurRadius: 5,
          //     color: Colors.black.withOpacity(0.1),
          //   ),
          // ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32)),
                    child: entry?.image?.isEmpty ?? true
                        ? const Text("")
                        : Image.network(
                            entry?.image,
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width * 0.45,
                            fit: BoxFit.fill,
                            scale: 1.0,
                          ),
                  ),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  margin: const EdgeInsets.only(bottom: 15),
                  width: MediaQuery.of(context).size.width * 0.35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: const Color(0xffffffff),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.zero,
                        child: Center(
                          child: Text(
                            entry?.name.toString(),
                            style: const TextStyle(
                              fontFamily: 'Avenir Next',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff283488),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _appState = Provider.of<AppState>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    // void categoryListShow(String item) async {
    //   products = _productService.getCategory(item);
    //   Navigator.pushNamed(context, '/categoryItem',
    //       arguments: SearchData(item, products));
    // }

    return Scaffold(
      // backgroundColor: Color(0xff283488),
      bottomNavigationBar:
          CustomBottomNavbar(context: context, selectedIndex: 1),
      floatingActionButton: const LanguageTransitionWidget(),
      appBar: CustomAppBar(
        title: const Text(""),
        leadingAction: () {
          Navigator.pushNamed(context, '/search');
        },
        leadingIcon: const Icon(
          Icons.search,
          color: Colors.black,
          size: 30,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      top: 10, left: width * 0.05, right: width * 0.05),
                  child: Text(
                    AppLocalizations.of(context).categoriespage_categories,
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
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: height * 0.02,
                    horizontal: width * 0.05,
                  ),
                  child: Text(
                    AppLocalizations.of(context).categoriespage_text,
                    style: const TextStyle(
                      color: Color(0xff999999),
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      fontFamily: "Avenir Next",
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: height * 0.65, child: _build()
                // child: FutureBuilder(
                //   future: categories,
                //   builder: (BuildContext ctx, AsyncSnapshot<List> snapshot) =>
                //       snapshot.hasData
                //           ? GridView.builder(
                //               gridDelegate:
                //                   SliverGridDelegateWithFixedCrossAxisCount(
                //                       crossAxisCount: 2,
                //                       childAspectRatio: itemWidth / itemHeight),
                //               itemCount: snapshot.data.length,
                //               itemBuilder: (BuildContext context, index) =>
                //                   InkWell(
                //                 onTap: () {
                //                   categoryListShow(snapshot.data[index].name);
                //                 },
                //                 child: Stack(
                //                   children: [
                //                     Container(
                //                       width: width * 0.46,
                //                       height: height * 0.32,
                //                       margin: EdgeInsets.only(
                //                           left: width * 0.02,
                //                           right: width * 0.02),
                //                       decoration: BoxDecoration(
                //                         borderRadius: BorderRadius.circular(32),
                //                         color: Colors.white,
                //                       ),
                //                       child: Image.network(
                //                         snapshot.data[index].image.src,
                //                         fit: BoxFit.fill,
                //                       ),
                //                     ),
                //                     Positioned(
                //                       top: height * 0.25,
                //                       left: width * 0.05,
                //                       child: Container(
                //                         width: width * 0.4,
                //                         height: height * 0.05,
                //                         decoration: BoxDecoration(
                //                           borderRadius: BorderRadius.circular(24),
                //                           color: Colors.white,
                //                         ),
                //                         child: Center(
                //                           child: Text(
                //                             snapshot.data[index].name,
                //                             style: const TextStyle(
                //                               fontFamily: 'Avenir Next',
                //                               fontSize: 12,
                //                               fontWeight: FontWeight.bold,
                //                               color: Color(0xff283488),
                //                             ),
                //                           ),
                //                         ),
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             )
                //           : const Center(
                //               child: CircularProgressIndicator(),
                //             ),
                // ),
                ),
          ],
        ),
      ),
    );
  }
}
