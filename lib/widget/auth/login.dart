import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toy_app/components/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:toy_app/provider/index.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenPage();
}

class _LoginScreenPage extends State<LoginScreen> {
  // app state
  AppState _appState;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _useremail = TextEditingController();
  final TextEditingController _userpwd = TextEditingController();
  String _userEmail = '';
  String _userPwd = '';

  Map userInfo;
  // indicator status
  bool _loadingStatus = false;
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    _loadingStatus = false;
    _appState = Provider.of<AppState>(context, listen: false);
  }

  void _setTokenToLocalStorage(_token) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('token', _token);
    await _prefs.setString('userEmail', _userEmail);
  }

  // final TextEditingController _passwordController = TextEditingController();
  void submitLogin() {
    final bool isValid = _formKey.currentState.validate();
    if (isValid == true) {
      setState(() {
        _loadingStatus = true;
      });
      userInfo = {'email': _userEmail, 'password': _userPwd};
      _appState
          .post(Uri.parse("${_appState.endpoint}/Authenticate/GetToken"),
              jsonEncode(userInfo))
          .then((res) {
        var body = jsonDecode(res.body);
        if (res.statusCode == 200) {
          setState(() {
            _loadingStatus = false;
          });
          _appState.user = body;
          _appState.token = body['token'];
          _setTokenToLocalStorage(body['token']);
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          setState(() {
            _loadingStatus = false;
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(AppLocalizations.of(context).login_text1),
                content: Text(AppLocalizations.of(context).login_text2),
                actions: [
                  ElevatedButton(
                    child: Text(AppLocalizations.of(context).login_ok),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            },
          );
        }
      }).catchError((error) {
        print(error);
        setState(() {
          _loadingStatus = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context).login_text1),
              content: Text(AppLocalizations.of(context).login_text2),
              actions: [
                ElevatedButton(
                  child: Text(AppLocalizations.of(context).login_ok),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
      });

      // String response = await _userService.login(_userEmail, _userPwd);
      // if (response == 'success') {
      //   setState(() {
      //     _loadingStatus = false;
      //   });
      //   Navigator.pushReplacementNamed(context, '/home');
      // } else {
      //   setState(() {
      //     _loadingStatus = false;
      //   });
      //   showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         title: const Text(AppLocalizations.of(context).login_text1),
      //         content: const Text(AppLocalizations.of(context).login_text2),
      //         actions: [
      //           ElevatedButton(
      //             child: const Text(AppLocalizations.of(context).login_ok),
      //             onPressed: () {
      //               Navigator.of(context).pop();
      //             },
      //           )
      //         ],
      //       );
      //     },
      //   );
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: Image.asset(
          'assets/img/LoginRegistration/header.png',
          // height: height * 0.1,
          width: width * 0.5,
          fit: BoxFit.cover,
        ),
        leadingAction: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.zero,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        AppLocalizations.of(context).login_login,
                        style: const TextStyle(
                          fontSize: 30,
                          fontFamily: 'Avenir Next',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        AppLocalizations.of(context).login_plogin,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xff999999),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context).login_email,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black87),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    controller: _useremail,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 10),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                      border: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return AppLocalizations.of(context)
                                            .login_pmail;
                                      }
                                      // Check if the entered email has the right format
                                      if (!RegExp(r'\S+@\S+\.\S+')
                                          .hasMatch(value)) {
                                        return AppLocalizations.of(context)
                                            .login_pvmail;
                                      }
                                      // Return null if the entered email is valid
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        _userEmail = value;
                                      });
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context).login_pwd,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black87),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    controller: _userpwd,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 10),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                      border: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return AppLocalizations.of(context)
                                            .login_rpwd;
                                      }
                                      if (value.trim().length < 8) {
                                        return AppLocalizations.of(context)
                                            .login_vpwd;
                                      }
                                      // Return null if the entered password is valid
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        _userPwd = value;
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.zero,
                                    child: Row(
                                      children: [
                                        Text(AppLocalizations.of(context)
                                            .login_fpwd),
                                        Text(
                                          AppLocalizations.of(context)
                                              .login_tap,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: (_loadingStatus)
                  ? const CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xff283488)),
                      strokeWidth: 2)
                  : const SizedBox(
                      height: 0,
                    ),
            ),
            Padding(
              padding: EdgeInsets.zero,
              child: SizedBox(
                height: height * 0.07,
                width: width * 0.9,
                child: ElevatedButton(
                  onPressed: _loadingStatus ? null : submitLogin,
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
                    _loadingStatus
                        ? "Hold on..."
                        : AppLocalizations.of(context).login_login,
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
