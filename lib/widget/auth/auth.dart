import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Auth extends StatefulWidget {
  const Auth({Key key}) : super(key: key);

  @override
  State<Auth> createState() => _Auth();
}

class _Auth extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Image(
                    image: const AssetImage(
                      'assets/img/LoginRegistration/header.png',
                    ),
                    fit: BoxFit.scaleDown,
                    height: height * 0.1,
                  ),
                ),
                SizedBox(
                  height: height * 0.15,
                ),
                Text(
                  AppLocalizations.of(context).auth_welcome,
                  style: const TextStyle(
                    fontFamily: 'Avenir Next',
                    fontSize: 32,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Text(
                  AppLocalizations.of(context).auth_description1,
                  style: const TextStyle(
                    fontFamily: 'Avenir Next',
                    fontSize: 14,
                    color: Color(0xff999999),
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  AppLocalizations.of(context).auth_description2,
                  style: const TextStyle(
                    fontFamily: 'Avenir Next',
                    fontSize: 14,
                    color: Color(0xff999999),
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: height * 0.1,
                ),
              ],
            ),
          ),
          SizedBox(
            height: height * 0.07,
            width: width * 0.9,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
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
                AppLocalizations.of(context).auth_login,
                style: const TextStyle(color: Color(0xff283488), fontSize: 14),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.03,
          ),
          SizedBox(
            height: height * 0.07,
            width: width * 0.9,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
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
                AppLocalizations.of(context).auth_signup,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
