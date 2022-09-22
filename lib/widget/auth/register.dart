import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toy_app/components/components.dart';
import 'package:toy_app/service/mailchimp_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:provider/provider.dart';
import 'package:toy_app/provider/index.dart';

import 'dart:convert';

class Register extends StatefulWidget {
  const Register({Key key}) : super(key: key);
  @override
  State<Register> createState() => _Register();
}

class _Register extends State<Register> {
  // app state
  AppState _appState;
  // user service
  MailChimpService mailChimpService;
  // page slide setting
  final int _numPages = 2;
  final PageController _pageController = PageController(initialPage: 0);
  TextEditingController _firstnameController;
  TextEditingController _lastnameController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _confirmController;
  int _currentPage = 0;
  bool isValid = false;
  bool isValid1 = false;
  // form setting
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _password = '';
  String _confirmpassword = '';
  Map userInfo;
  // loading status
  bool _loadingStatus = false;
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    _firstnameController = TextEditingController();
    _lastnameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmController = TextEditingController();
    _loadingStatus = false;
    mailChimpService = MailChimpService();
    _appState = Provider.of<AppState>(context, listen: false);
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }

    return list;
  }

  void _setTokenToLocalStorage(_token) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('token', _token);
    await _prefs.setString('userEmail', _email);
  }

  void _onNextPage() {
    _checkValidation();
    if (_currentPage != _numPages - 1) {
      if (isValid == true) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }
    } else {
      if (isValid1 == true) {
        _formKey1.currentState?.save();
        // print(1);
        submitRegister();
      }
    }
  }

  void _checkValidation() {
    isValid = _formKey.currentState?.validate();
    isValid1 = _formKey1.currentState?.validate();
    if (isValid == true) {
      _formKey.currentState?.save();
    }
    if (isValid1 == true) {
      _formKey1.currentState?.save();
    }
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 35.0 : 8.0,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  void submitRegister() {
    setState(() {
      _loadingStatus = true;
    });
    userInfo = {
      'firstname': _firstName,
      'lastname': _lastName,
      'email': _email,
      'password': _password
    };
    // mailChimpService.addContact(_email, _firstName, _lastName).then((data) {
    //   _registerHandler(userInfo);
    // }).catchError((onError) {
    //   _registerHandler(userInfo);
    // });
    _registerHandler(userInfo);
  }

  void _registerHandler(Map _userInfo) async {
    try {
      var tokenPutData = {
        'is_guest': true,
        'email': _userInfo['email'],
        'password': _userInfo['password']
      };
      var tokenResponse = await _appState.post(
          Uri.parse("${_appState.endpoint}/Authenticate/GetToken"),
          jsonEncode(tokenPutData));
      var body = jsonDecode(tokenResponse.body);
      _appState.token = body['token'];
      var putData = {
        "model": {
          "email": _userInfo['email'],
          "entering_email_twice": true,
          "confirm_email": _userInfo['email'],
          "usernames_enabled": true,
          "username": _userInfo['firstname'] + _userInfo['lastname'],
          "check_username_availability_enabled": true,
          "password": _userInfo['password'],
          "confirm_password": _userInfo['password'],
          "gender_enabled": false,
          "gender": "string",
          "first_name_enabled": true,
          "first_name": _userInfo['firstname'],
          "first_name_required": true,
          "last_name_enabled": true,
          "last_name": _userInfo['lastname'],
          "last_name_required": true,
          "date_of_birth_enabled": true,
          "date_of_birth_day": 0,
          "date_of_birth_month": 0,
          "date_of_birth_year": 0,
          "date_of_birth_required": true,
          "company_enabled": false,
          "company_required": false,
          "company": "string",
          "street_address_enabled": true,
          "street_address_required": true,
          "street_address": "string",
          "street_address2_enabled": true,
          "street_address2_required": true,
          "street_address2": "string",
          "zip_postal_code_enabled": true,
          "zip_postal_code_required": true,
          "zip_postal_code": "string",
          "city_enabled": true,
          "city_required": true,
          "city": "string",
          "county_enabled": true,
          "county_required": true,
          "county": "string",
          "country_enabled": true,
          "country_required": true,
          "country_id": 0,
          "available_countries": [
            {
              "disabled": true,
              "group": {"disabled": true, "name": "string"},
              "selected": true,
              "text": "string",
              "value": "string"
            }
          ],
          "state_province_enabled": true,
          "state_province_required": true,
          "state_province_id": 0,
          "available_states": [
            {
              "disabled": true,
              "group": {"disabled": true, "name": "string"},
              "selected": true,
              "text": "string",
              "value": "string"
            }
          ],
          "phone_enabled": true,
          "phone_required": true,
          "phone": "string",
          "fax_enabled": true,
          "fax_required": true,
          "fax": "string",
          "newsletter_enabled": true,
          "newsletter": true,
          "accept_privacy_policy_enabled": false,
          "accept_privacy_policy_popup": false,
          "time_zone_id": "string",
          "allow_customers_to_set_time_zone": false,
          "available_time_zones": [
            {
              "disabled": true,
              "group": {"disabled": true, "name": "string"},
              "selected": true,
              "text": "string",
              "value": "string"
            }
          ],
          "vat_number": "string",
          "display_vat_number": true,
          "honeypot_enabled": true,
          "display_captcha": true,
          "customer_attributes": [
            {
              "name": "string",
              "is_required": true,
              "default_value": "string",
              "attribute_control_type": "DropdownList",
              "values": [
                {
                  "name": "string",
                  "is_pre_selected": true,
                  "id": 0,
                  "custom_properties": {
                    "additionalProp1": "string",
                    "additionalProp2": "string",
                    "additionalProp3": "string"
                  }
                }
              ],
              "id": 0,
              "custom_properties": {
                "additionalProp1": "string",
                "additionalProp2": "string",
                "additionalProp3": "string"
              }
            }
          ],
          "gdpr_consents": [
            {
              "message": "string",
              "is_required": true,
              "required_message": "string",
              "accepted": true,
              "id": 0,
              "custom_properties": {
                "additionalProp1": "string",
                "additionalProp2": "string",
                "additionalProp3": "string"
              }
            }
          ],
          "custom_properties": {
            "additionalProp1": "string",
            "additionalProp2": "string",
            "additionalProp3": "string"
          }
        },
        "form": {
          "additionalProp1": "string",
          "additionalProp2": "string",
          "additionalProp3": "string"
        }
      };
      var response = await _appState.postAuth(
          Uri.parse("${_appState.endpoint}/Customer/Register?returnUrl=false"),
          jsonEncode(putData));
      if (response.statusCode == 302) {
        var putUserInfo = {
          'email': _userInfo['email'],
          'password': _userInfo['password']
        };
        var fResult = await _appState.post(
            Uri.parse("${_appState.endpoint}/Authenticate/GetToken"),
            jsonEncode(putUserInfo));
        var body = jsonDecode(fResult.body);
        if (fResult.statusCode == 200) {
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
      }
      if (response.statusCode == 400) {
        var temp = jsonDecode(response.body);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error!"),
              content: Text(temp[0]),
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

      setState(() {
        _loadingStatus = false;
      });
    } catch (err) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error!"),
            content: const Text("Error is occured while registering."),
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
      setState(() {
        _loadingStatus = false;
      });
    }
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
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
        padding: EdgeInsets.zero,
        // height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              // padding: EdgeInsets.zero,
              // height: MediaQuery.of(context).size.height * 0.7,
              child: PageView(
                physics: const ClampingScrollPhysics(),
                controller: _pageController,
                onPageChanged: (int page) {
                  WidgetsBinding.instance?.focusManager?.primaryFocus
                      ?.unfocus();
                  _checkValidation();
                  if (isValid == false && _currentPage == 0) {
                    // _pageController.jumpTo(0);
                    _pageController.jumpToPage(0);
                  } else {
                    setState(() {
                      _currentPage = page;
                    });
                  }
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            AppLocalizations.of(context).register_create,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            AppLocalizations.of(context).register_description1,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xff999999),
                              height: 1.2,
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context).register_description2,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xff999999),
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.zero,
                              child: Column(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)
                                            .register_fname,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black87),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 10),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.grey,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(32),
                                          ),
                                          hintText: AppLocalizations.of(context)
                                              .register_fname,
                                          hintStyle: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal),
                                          border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey)),
                                        ),
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return AppLocalizations.of(context)
                                                .register_pfname;
                                          }
                                          // Return null if the entered email is valid
                                          return null;
                                        },
                                        controller: _firstnameController,
                                        onChanged: (value) {
                                          setState(() {
                                            _firstName = value;
                                          });
                                        },
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)
                                            .register_lname,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black87),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 10),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.grey,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(32),
                                          ),
                                          hintText: AppLocalizations.of(context)
                                              .register_lname,
                                          hintStyle: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal),
                                          border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey)),
                                        ),
                                        controller: _lastnameController,
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return AppLocalizations.of(context)
                                                .register_plname;
                                          }
                                          // Return null if the entered email is valid
                                          return null;
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            _lastName = value;
                                          });
                                        },
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      )
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
                  SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height - 100,
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: Form(
                        key: _formKey1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .registeremail_caccount,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .registeremail_description1,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xff999999),
                                height: 1.2,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context).registeremail_tap,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xff999999),
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.zero,
                                child: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)
                                              .registeremail_email,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black87),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 10),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Colors.grey,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                            ),
                                            border: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey)),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return AppLocalizations.of(
                                                      context)
                                                  .registeremail_pmail;
                                            }
                                            // Check if the entered email has the right format
                                            if (!RegExp(r'\S+@\S+\.\S+')
                                                .hasMatch(value)) {
                                              return AppLocalizations.of(
                                                      context)
                                                  .registeremail_vmail;
                                            }
                                            // Return null if the entered email is valid
                                            return null;
                                          },
                                          controller: _emailController,
                                          onChanged: (value) {
                                            setState(() {
                                              _email = value;
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)
                                              .registeremail_pwd,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black87),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 10),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Colors.grey,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                            ),
                                            border: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey)),
                                          ),
                                          controller: _passwordController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return AppLocalizations.of(
                                                      context)
                                                  .registeremail_ppwd;
                                            }
                                            if (value.trim().length < 8) {
                                              return AppLocalizations.of(
                                                      context)
                                                  .registeremail_lpwd;
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              _password = value;
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)
                                              .registeremail_cpwd,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black87),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 10),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Colors.grey,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                            ),
                                            border: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey)),
                                          ),
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          obscureText: true,
                                          controller: _confirmController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return AppLocalizations.of(
                                                      context)
                                                  .registeremail_pcpwd;
                                            }
                                            if (value != _password) {
                                              return AppLocalizations.of(
                                                      context)
                                                  .registeremail_ipwd;
                                            }

                                            // Return null if the entered email is valid
                                            return null;
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              _confirmpassword = value;
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        )
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
                ],
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageIndicator(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: height * 0.07,
                    width: width * 0.9,
                    child: ElevatedButton(
                      onPressed: _loadingStatus ? null : _onNextPage,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xff283488)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(83.0),
                            side: const BorderSide(color: Color(0xff283488)),
                          ),
                        ),
                      ),
                      child: Text(
                        (_currentPage != _numPages - 1)
                            ? AppLocalizations.of(context).registeremail_next
                            : _loadingStatus
                                ? "Hold on..."
                                : AppLocalizations.of(context)
                                    .registeremail_register_button,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
