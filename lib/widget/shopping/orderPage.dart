import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Order extends StatefulWidget {
  const Order({Key key}) : super(key: key);

  @override
  State<Order> createState() => _Order();
}

class _Order extends State<Order> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xff283488),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(width * 0.25, height * 0.05, 0, 0),
                child: SizedBox(
                  height: height * 0.1,
                  width: width * 0.5,
                  child: Image.asset(
                    "assets/img/LoginRegistration/header.png",
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(width * 0.35, 0, 0, 0),
                child: SizedBox(
                  height: height * 0.3,
                  width: width * 0.3,
                  child: Image.asset(
                    "assets/img/Shopping cart and Checkout/5.png",
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Text(
              AppLocalizations.of(context).orderpage_orderp,
              style: const TextStyle(
                fontSize: 32,
                fontFamily: "Avenir Next",
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Text(
              AppLocalizations.of(context).orderpage_text1,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: "Avenir Next",
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Text(
              AppLocalizations.of(context).orderpage_text2,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: "Avenir Next",
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: height * 0.2,
          ),
          SizedBox(
            height: height * 0.07,
            width: width * 0.9,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(83.0),
                    side: const BorderSide(color: Color(0xff283488)),
                  ),
                ),
              ),
              child: Text(
                AppLocalizations.of(context).orderpage_okay,
                style: const TextStyle(color: Color(0xff283488), fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
