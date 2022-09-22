import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toy_app/components/components.dart';
import 'package:toy_app/model/product.model.dart';
import 'package:toy_app/widget/detailPage_test.dart';
import 'package:toy_app/service/product_repo.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:toy_app/provider/index.dart';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter_pagewise/flutter_pagewise.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  // future setting
  static const int PAGE_SIZE = 10;
  // slider setting
  List<String> imgList = [];
  List<int> bannerProductIds = [];
  // provider setting
  AppState _appState;
  String _languageCode = "en";

  Widget _buildNewArrival() {
    return PagewiseListView<ProductM>(
      pageSize: 100,
      scrollDirection: Axis.horizontal,
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
        return ProductService.getNewArrival(pageIndex, 100);
      },
    );
  }

  Widget _buildRecommend() {
    return PagewiseListView<ProductM>(
      pageSize: 100,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(15.0),
      itemBuilder: _recommendItemBuilder,
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
        return ProductService.getRecommendProduct(pageIndex, 100);
      },
    );
  }

  Widget _recommendItemBuilder(context, ProductM entry, _) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          DetailPageTest.routeName,
          arguments: entry,
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.4,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Colors.white,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32)),
                    child: entry?.images?.isEmpty ?? true
                        ? const Text("")
                        : Image.network(
                            entry?.images[0],
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width * 0.4,
                            fit: BoxFit.cover,
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
                  width: MediaQuery.of(context).size.width * 0.35,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: const Color(0xFF283488),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.zero,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      entry?.name?.isEmpty ?? true
                                          ? ""
                                          : entry?.name,
                                      style: const TextStyle(
                                        fontFamily: 'Avenir Next',
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      '\$' + entry?.price.toString(),
                                      style: const TextStyle(
                                        fontFamily: 'Avenir Next',
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                              width: 30,
                              child: RawMaterialButton(
                                onPressed: () {},
                                elevation: 1.0,
                                fillColor: Colors.white,
                                child: const Icon(
                                  Icons.shopping_cart_outlined,
                                  size: 16.0,
                                  color: Color(0xff283488),
                                ),
                                padding: const EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            ),
                          ],
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

  Widget _itemBuilder(context, ProductM entry, _) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          DetailPageTest.routeName,
          arguments: entry,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.35,
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: Colors.white,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32)),
                      child: entry?.images?.isEmpty ?? true
                          ? const Text("")
                          : Image.network(
                              entry?.images[0],
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: MediaQuery.of(context).size.width * 0.4,
                              fit: BoxFit.cover,
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(32),
                          bottomRight: Radius.circular(32)),
                      color: Color(0xffffffff),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.zero,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      entry?.name?.isEmpty ?? true
                                          ? ""
                                          : entry?.name,
                                      style: const TextStyle(
                                        fontFamily: 'Avenir Next',
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      '\$' + entry?.price.toString(),
                                      style: const TextStyle(
                                        fontFamily: 'Avenir Next',
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                                width: 30,
                                child: RawMaterialButton(
                                  onPressed: () {},
                                  elevation: 1.0,
                                  fillColor: const Color(0xff283488),
                                  child: const Icon(
                                    Icons.shopping_cart_outlined,
                                    size: 16.0,
                                    color: Colors.white,
                                  ),
                                  padding: const EdgeInsets.all(0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                              ),
                            ],
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
      ),
    );
  }

  Widget _buildRobots() {
    return PagewiseListView<ProductM>(
      pageSize: PAGE_SIZE,
      scrollDirection: Axis.horizontal,
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
      pageFuture: (pageIndex) =>
          ProductService.getProductsByCategoryId(pageIndex, PAGE_SIZE, "robot"),
    );
  }

  Widget _buildBabyToys() {
    return PagewiseListView<ProductM>(
      pageSize: PAGE_SIZE,
      scrollDirection: Axis.horizontal,
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
      pageFuture: (pageIndex) =>
          ProductService.getProductsByCategoryId(pageIndex, PAGE_SIZE, "baby"),
    );
  }

  @override
  void initState() {
    super.initState();
    // app state
    _appState = Provider.of<AppState>(context, listen: false);
    _init();
  }

  void _init() async {
    try {
      var _result = await _appState.getAuth(Uri.parse(
          "${_appState.backendEndpoint}/Product/GetAllProductsDisplayedOnHomepage"));
      var _sliderResult = jsonDecode(_result.body);
      bannerProductIds =
          (_sliderResult as List).map((e) => e['id'] as int).toList();
      bannerProductIds ?? List<int>.empty();
      if (bannerProductIds.isNotEmpty) {
        String _implodeBannerProdIds = bannerProductIds.join(";");
        var _bannerImgIds = await _appState.getAuth(Uri.parse(
            "${_appState.backendEndpoint}/ProductPictures/GetProductsImagesIds/$_implodeBannerProdIds"));
        var _body = jsonDecode(_bannerImgIds.body);
        List<int> _imgIds = [];
        for (int element in bannerProductIds) {
          var _temp = _body[element.toString()];
          for (int secElement in _temp) {
            _imgIds.add(secElement);
          }
        }
        for (int item in _imgIds) {
          var _tmpResult = await _appState.getAuth(Uri.parse(
              "${_appState.backendEndpoint}/Picture/GetPictureUrl/$item?targetSize=0&showDefaultPicture=true"));
          var _tmpBody = jsonDecode(_tmpResult.body);
          setState(() {
            imgList.add(_tmpBody['url']);
          });
        }
      }
    } catch (e) {
      print(123);
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    _appState.getLocale().then((locale) {
      setState(() {
        _languageCode = locale.languageCode;
      });
    });
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 237, 236, 236),
        bottomNavigationBar:
            CustomBottomNavbar(context: context, selectedIndex: 0),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: const Color(0xff283488),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: const EdgeInsets.only(top: 70),
                            child: Image.asset(
                              "assets/img/home/header.png",
                              scale: 1.6,
                            ),
                          ),
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/search');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              padding: const EdgeInsets.only(top: 30),
                              child: const Image(
                                image: AssetImage(
                                  'assets/img/home/1-3.png',
                                ),
                                fit: BoxFit.scaleDown,
                                height: 50,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 30),
                      child: Column(
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 250.0,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                            ),
                            items: imgList.map((item) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Stack(
                                      fit: StackFit.expand,
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(35.0),
                                          child: Image.network(
                                            item,
                                            height: 250.0,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.zero,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                offset: const Offset(0, 1),
                                                blurRadius: 5,
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(35.0),
                                          ),
                                          // margin:
                                          //     const EdgeInsets.only(top: 30),
                                          // alignment: Alignment.topCenter,
                                          child: const Text(
                                            "",
                                            style: TextStyle(
                                                fontSize: 28,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ]);
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context).home_top,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/lego');
                          },
                          child: Container(
                            child: Image.asset('assets/img/home/2-1.png'),
                            margin: EdgeInsets.only(
                                left: width * 0.03, right: width * 0.03),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/hotwheels');
                          },
                          child: Container(
                            child: Image.asset('assets/img/home/2-2.png'),
                            margin: EdgeInsets.only(
                                left: width * 0.03, right: width * 0.03),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/barbie');
                          },
                          child: Container(
                            child: Image.asset('assets/img/home/2-3.png'),
                            margin: EdgeInsets.only(
                                left: width * 0.03, right: width * 0.03),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/disney');
                          },
                          child: Container(
                            child: Image.asset('assets/img/home/2-4.png'),
                            margin: EdgeInsets.only(
                                left: width * 0.03, right: width * 0.03),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/bratz');
                          },
                          child: Container(
                            child: Image.asset('assets/img/home/2-5.png'),
                            margin: EdgeInsets.only(
                                left: width * 0.03, right: width * 0.03),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/starwars');
                          },
                          child: Container(
                            child: Image.asset('assets/img/home/2-6.png'),
                            margin: EdgeInsets.only(
                                left: width * 0.03, right: width * 0.03),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/toystory');
                          },
                          child: Container(
                            child: Image.asset('assets/img/home/2-7.png'),
                            margin: EdgeInsets.only(
                                left: width * 0.03, right: width * 0.03),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/marvel');
                          },
                          child: Container(
                            child: Image.asset('assets/img/home/2-8.png'),
                            margin: EdgeInsets.only(
                                left: width * 0.03, right: width * 0.03),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context).home_popular,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/popular');
                          },
                          child: (_languageCode == "en")
                              ? const Icon(
                                  Icons.keyboard_arrow_right_outlined,
                                  color: Colors.black,
                                  size: 30,
                                )
                              : const Icon(
                                  Icons.keyboard_arrow_left_outlined,
                                  color: Colors.black,
                                  size: 30,
                                ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.35, child: _buildNewArrival())
                ],
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/bike');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: const EdgeInsets.only(top: 30, bottom: 30),
                            child: Image.asset(
                              "assets/img/home/5.png",
                              scale: 2,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context).home_new,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/new');
                          },
                          child: (_languageCode == "en")
                              ? const Icon(
                                  Icons.keyboard_arrow_right_outlined,
                                  color: Colors.black,
                                  size: 30,
                                )
                              : const Icon(
                                  Icons.keyboard_arrow_left_outlined,
                                  color: Colors.black,
                                  size: 30,
                                ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.35,
                    child: _buildNewArrival(),
                  )
                ],
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/party');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: const EdgeInsets.only(top: 30, bottom: 30),
                            child: Image.asset(
                              "assets/img/home/7.png",
                              scale: 2,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/school');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: const EdgeInsets.only(top: 30, bottom: 30),
                            child: Image.asset(
                              "assets/img/home/8.png",
                              scale: 2,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context).home_collections,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/top');
                          },
                          child: (_languageCode == "en")
                              ? const Icon(
                                  Icons.keyboard_arrow_right_outlined,
                                  color: Colors.black,
                                  size: 30,
                                )
                              : const Icon(
                                  Icons.keyboard_arrow_left_outlined,
                                  color: Colors.black,
                                  size: 30,
                                ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.35, child: _buildNewArrival())
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context).home_robots,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/robots');
                          },
                          child: (_languageCode == "en")
                              ? const Icon(
                                  Icons.keyboard_arrow_right_outlined,
                                  color: Colors.black,
                                  size: 30,
                                )
                              : const Icon(
                                  Icons.keyboard_arrow_left_outlined,
                                  color: Colors.black,
                                  size: 30,
                                ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.35, child: _buildRobots())
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context).home_baby,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/baby');
                          },
                          child: (_languageCode == "en")
                              ? const Icon(
                                  Icons.keyboard_arrow_right_outlined,
                                  color: Colors.black,
                                  size: 30,
                                )
                              : const Icon(
                                  Icons.keyboard_arrow_left_outlined,
                                  color: Colors.black,
                                  size: 30,
                                ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.35,
                    child: _buildBabyToys(),
                  )
                ],
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/cakes');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: const EdgeInsets.only(top: 30, bottom: 30),
                            child: Image.asset(
                              "assets/img/home/12.png",
                              scale: 2,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context).home_recommended,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/recommended');
                          },
                          child: (_languageCode == "en")
                              ? const Icon(
                                  Icons.keyboard_arrow_right_outlined,
                                  color: Colors.black,
                                  size: 30,
                                )
                              : const Icon(
                                  Icons.keyboard_arrow_left_outlined,
                                  color: Colors.black,
                                  size: 30,
                                ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.35, child: _buildRecommend())
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: const LanguageTransitionWidget(),
      ),
    );
  }
}
