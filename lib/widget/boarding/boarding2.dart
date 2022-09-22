import 'package:flutter/material.dart';

class Boarding2 extends StatefulWidget {
  @override
  State<Boarding2> createState() => _Boarding2();
}

class _Boarding2 extends State<Boarding2> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xff7dcbe1),
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
                  "Choose your",
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
                  "Favorite toys",
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
                  "assets/img/onboarding/2-2.png",
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
                    Navigator.pushNamed(context, '/boardingthree');
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
