import 'package:flutter/material.dart';

import 'package:toy_app/model/product.model.dart';
import 'package:toy_app/service/product_repo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_pagewise/flutter_pagewise.dart';

import 'package:provider/provider.dart';
import 'package:toy_app/provider/index.dart';

class WrapPage extends StatefulWidget {
  WrapPage({Key key, this.id, this.productId, this.product}) : super(key: key);
  int id;
  int productId;
  ProductM product;
  @override
  State<WrapPage> createState() => _WrapPage();
}

class _WrapPage extends State<WrapPage> {
  // future setting
  static const int PAGE_SIZE = 4;
  // provider setting
  AppState _appState;
  int activeWrapId = 0;
  int activeWrapCartId = 0;
  ProductM activeItem;
  bool processing = false;
  final ProductService _productService = ProductService();
  Widget _build() {
    return PagewiseGridView<ProductM>.count(
      pageSize: PAGE_SIZE,
      crossAxisCount: 2,
      mainAxisSpacing: 20.0,
      crossAxisSpacing: 6.0,
      childAspectRatio: 0.75,
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
        return ProductService.getProductsByCategoryId(
            pageIndex, PAGE_SIZE, "wrap");
      },
    );
  }

  Widget _itemBuilder(context, ProductM entry, _) {
    return InkWell(
      // hoverColor: Colors.pink,
      onTap: () {
        setState(() {
          activeWrapId = entry.id;
          activeItem = entry;
          if (widget.productId != entry.id) {
            activeWrapCartId = 0;
          } else {
            activeWrapCartId = widget.id;
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 1),
                blurRadius: 5,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
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
                              height: MediaQuery.of(context).size.height * 0.23,
                              width: MediaQuery.of(context).size.width * 0.4,
                              fit: BoxFit.cover,
                            ),
                    ),
                  )
                ],
              ),
              if (activeWrapId == entry.id)
                Positioned(
                  left: 15.0,
                  top: 15.0,
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: RawMaterialButton(
                      onPressed: () {},
                      elevation: 1.0,
                      fillColor: const Color(0xff283488),
                      child: const Icon(
                        Icons.check,
                        size: 16.0,
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
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
                                      entry?.name.toString(),
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
                                      '\$' + entry.price.toString(),
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

  @override
  void initState() {
    super.initState();
    _appState = Provider.of<AppState>(context, listen: false);
    setState(() {
      activeItem = widget.product;
      activeWrapId = widget.productId;
      activeWrapCartId = widget.id;
    });
  }

  void submitCartItem() {
    int _quantity = 1;
    // print(_appState.user['_id']);
    if (activeWrapId != 0) {
      setState(() {
        processing = true;
      });
      if (activeWrapCartId == 0) {
        if (widget.id != 0) {
          _productService.deleteCartItem(widget.id).then((value) {
            if (value == "success") {
              _productService
                  .addCartItem(activeWrapId, _quantity, activeWrapCartId,
                      _appState.user['customer_id'])
                  .then((response) {
                if (response == 'success') {
                  setState(() {
                    processing = false;
                  });

                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                              AppLocalizations.of(context).detailpage_success),
                          content: Text(
                              AppLocalizations.of(context).detailpage_text1),
                          actions: [
                            ElevatedButton(
                              child: Text(
                                  AppLocalizations.of(context).detailpage_ok),
                              onPressed: () {
                                Navigator.pushNamed(context, '/cart');
                              },
                            )
                          ],
                        );
                      });
                } else {
                  setState(() {
                    processing = false;
                  });

                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                              AppLocalizations.of(context).detailpage_failed),
                          content: Text(
                              AppLocalizations.of(context).detailpage_text2),
                          actions: [
                            ElevatedButton(
                              child: Text(
                                  AppLocalizations.of(context).detailpage_ok),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        );
                      });
                }
              }).catchError((err) {
                print(err);
                setState(() {
                  processing = false;
                });
              });
            } else {
              setState(() {
                processing = false;
              });

              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title:
                          Text(AppLocalizations.of(context).detailpage_failed),
                      content:
                          Text(AppLocalizations.of(context).detailpage_text2),
                      actions: [
                        ElevatedButton(
                          child:
                              Text(AppLocalizations.of(context).detailpage_ok),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  });
            }
          }).catchError((err) {
            print(err);
            setState(() {
              processing = false;
            });
          });
        } else {
          _productService
              .addCartItem(activeWrapId, _quantity, activeWrapCartId,
                  _appState.user['customer_id'])
              .then((response) {
            if (response == 'success') {
              setState(() {
                processing = false;
              });

              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title:
                          Text(AppLocalizations.of(context).detailpage_success),
                      content:
                          Text(AppLocalizations.of(context).detailpage_text1),
                      actions: [
                        ElevatedButton(
                          child:
                              Text(AppLocalizations.of(context).detailpage_ok),
                          onPressed: () {
                            Navigator.pushNamed(context, '/cart');
                          },
                        )
                      ],
                    );
                  });
            } else {
              setState(() {
                processing = false;
              });

              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title:
                          Text(AppLocalizations.of(context).detailpage_failed),
                      content:
                          Text(AppLocalizations.of(context).detailpage_text2),
                      actions: [
                        ElevatedButton(
                          child:
                              Text(AppLocalizations.of(context).detailpage_ok),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  });
            }
          }).catchError((err) {
            print(err);
            setState(() {
              processing = false;
            });
          });
        }
      } else {
        print(2);
        _productService
            .addCartItem(activeWrapId, _quantity, activeWrapCartId,
                _appState.user['customer_id'])
            .then((response) {
          if (response == 'success') {
            setState(() {
              processing = false;
            });

            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title:
                        Text(AppLocalizations.of(context).detailpage_success),
                    content:
                        Text(AppLocalizations.of(context).detailpage_text1),
                    actions: [
                      ElevatedButton(
                        child: Text(AppLocalizations.of(context).detailpage_ok),
                        onPressed: () {
                          Navigator.pushNamed(context, '/cart');
                        },
                      )
                    ],
                  );
                });
          } else {
            setState(() {
              processing = false;
            });

            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context).detailpage_failed),
                    content:
                        Text(AppLocalizations.of(context).detailpage_text2),
                    actions: [
                      ElevatedButton(
                        child: Text(AppLocalizations.of(context).detailpage_ok),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                });
          }
        }).catchError((err) {
          print(err);
          setState(() {
            processing = false;
          });
        });
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context).detailpage_alert),
              content: const Text("Please Select the Wrap Package."),
              actions: [
                ElevatedButton(
                  child: Text(AppLocalizations.of(context).detailpage_ok),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var itemHeight = height * 0.3;
    var itemWidth = width * 0.4;
    return Scaffold(
      // backgroundColor: Color(0xff283488),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      EdgeInsets.only(top: height * 0.1, left: width * 0.05),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/cart');
                      // Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 15, left: width * 0.05),
                  child: Text(
                    AppLocalizations.of(context).wrappage_options,
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
                  padding: EdgeInsets.only(
                    top: height * 0.02,
                    left: width * 0.05,
                  ),
                  child: Text(
                    AppLocalizations.of(context).wrappage_design,
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
              child: _build(),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(width * 0.05, 0, 0, 0),
              child: SizedBox(
                height: height * 0.07,
                width: width * 0.9,
                child: ElevatedButton(
                  onPressed: processing
                      ? null
                      : () {
                          submitCartItem();
                        },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xff283488)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(83.0),
                        side: const BorderSide(color: Color(0xff283488)),
                      ),
                    ),
                  ),
                  child: Text(
                    processing
                        ? "...processing"
                        : AppLocalizations.of(context).wrappage_next,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}
