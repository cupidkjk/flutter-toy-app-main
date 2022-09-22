import 'package:flutter/material.dart';

class Boarding1 extends StatefulWidget {
  @override
  State<Boarding1> createState() => _Boarding1();
}

class _Boarding1 extends State<Boarding1> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xffdb6241),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: height * 0.16,
          ),
          Row(
            children: [
              SizedBox(
                width: width * 0.064,
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Explore",
                  style: TextStyle(
                    fontFamily: 'Avenir Next',
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: width * 0.064,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 32),
                child: Text(
                  "the assortment",
                  style: TextStyle(
                    fontFamily: 'Avenir Next',
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Center(
              child: SizedBox(
                height: height * 0.55,
                child: Image.asset(
                  "assets/img/onboarding/1-2.png",
                ),
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: width * 0.6,
              ),
              SizedBox(
                height: 40,
                width: 140,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/boardingtwo');
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(83.0),
                        side: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
