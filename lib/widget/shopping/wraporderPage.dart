import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Wraporder extends StatefulWidget {
  const Wraporder({Key key}) : super(key: key);

  @override
  State<Wraporder> createState() => _Wraporder();
}

class _Wraporder extends State<Wraporder> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      // backgroundColor: Color(0xff283488),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(top: height * 0.05, left: width * 0.05),
                  child: InkWell(
                    onTap: () {
                      // Navigator.pushNamed(context, '/home');
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: height * 0.05, left: width * 0.15),
                  child: SizedBox(
                    height: height * 0.1,
                    width: width * 0.5,
                    child: Image.asset(
                      "assets/img/LoginRegistration/header.png",
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10, left: width * 0.05),
                  child: Text(
                    AppLocalizations.of(context).wraporderpage_cart,
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
                      bottom: height * 0.05),
                  child: Text(
                    AppLocalizations.of(context).wraporderpage_text1,
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
            Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: height * 0.2,
                            width: width * 0.4,
                            margin: EdgeInsets.only(left: width * 0.04),
                            child: Image.asset('assets/img/Search/6.png'),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(32.0),
                                    bottomLeft: Radius.circular(32.0)),
                                color: Colors.white),
                          ),
                          Container(
                            height: height * 0.2,
                            width: width * 0.5,
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          width * 0.05, height * 0.03, 0, 0),
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .wraporderpage_rocker,
                                        style: const TextStyle(
                                          fontFamily: 'Avenir Next',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          width * 0.05, 8, 0, 0),
                                      child: const Text(
                                        "\$16.99",
                                        style: TextStyle(
                                          fontFamily: 'Avenir Next',
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(32.0),
                                  bottomRight: Radius.circular(32.0)),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: height * 0.2,
                            width: width * 0.4,
                            margin: EdgeInsets.only(left: width * 0.04),
                            child: Image.asset('assets/img/Gift/3.png'),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(32.0),
                                    bottomLeft: Radius.circular(32.0)),
                                color: Colors.white),
                          ),
                          Container(
                            height: height * 0.2,
                            width: width * 0.5,
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          width * 0.05, height * 0.03, 0, 0),
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .wraporderpage_paper,
                                        style: const TextStyle(
                                          fontFamily: 'Avenir Next',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          width * 0.05, 8, 0, 0),
                                      child: const Text(
                                        "\$0.99",
                                        style: TextStyle(
                                          fontFamily: 'Avenir Next',
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(32.0),
                                  bottomRight: Radius.circular(32.0)),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.05,
            ),
            InkWell(
              onTap: () => {},
              child: Padding(
                padding: EdgeInsets.fromLTRB(width * 0.05, 8, 0, 0),
                child: Text(
                  AppLocalizations.of(context).wraporderpage_coupon,
                  style: const TextStyle(
                    fontFamily: 'Avenir Next',
                    fontSize: 14,
                    color: Color(0xff283488),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(width * 0.05, 8, 0, 0),
                  child: Text(
                    AppLocalizations.of(context).wraporderpage_subtotal,
                    style: const TextStyle(
                      fontFamily: 'Avenir Next',
                      fontSize: 14,
                      color: Color(0xff999999),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(width * 0.5, 8, 0, 0),
                  child: const Text(
                    "\$41.98",
                    style: TextStyle(
                      fontFamily: 'Avenir Next',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1d1d1d),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.05,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(width * 0.05, 0, 0, 0),
              child: SizedBox(
                height: height * 0.07,
                width: width * 0.9,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/delivery');
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
                    AppLocalizations.of(context).wraporderpage_checkout,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
