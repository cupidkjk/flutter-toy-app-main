import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:toy_app/components/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:provider/provider.dart';
import 'package:toy_app/helper/constant.dart';
import 'package:toy_app/provider/index.dart';
import 'package:toy_app/widget/profile/addressPage.dart';
import 'package:toy_app/widget/profile/changePasswordPage.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> {
  AppState _appState;
  String savedFirstName = '';
  String savedLastName = '';
  String imagePath = '';
  int purchageAmount = 0;
  @override
  void initState() {
    super.initState();
    _appState = Provider.of<AppState>(context, listen: false);
    getUserInfo();
    print(_appState.user['token']);
  }

  void onLogout() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String _token = _prefs.getString("token") ?? '';
    await http.get(
      Uri.parse("$apiEndPoint/Customer/Logout"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*'
      },
    );
    Navigator.pushNamed(context, '/');
  }

  void getUserInfo() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String _token = _prefs.getString("token") ?? '';
    var _profileInfoRes = await http.get(
      Uri.parse("$apiEndPoint/Customer/info"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        "Authorization": "Bearer $_token"
      },
    );
    var _body = jsonDecode(_profileInfoRes.body);
    print(_body);
    var _orderInfoRes = await http.get(
      Uri.parse("$apiEndPoint/Order/CustomerOrders"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        "Authorization": "Bearer $_token"
      },
    );
    var _orderBody = jsonDecode(_orderInfoRes.body);
    if (mounted) {
      setState(() {
        savedFirstName = _body['first_name'];
        savedLastName = _body['last_name'];
        imagePath = (_prefs.getString('path') ?? "");
        purchageAmount = (_orderBody['orders'] as List).isEmpty ?? true
            ? 0
            : (_orderBody['orders'] as List).length;
      });
      _appState.profileAddress1 = _body['street_address'];
      _appState.profileCity = _body['city'];
      _appState.countryId = _body['country_id'];
      _appState.firstName = _body['first_name'];
      _appState.lastName = _body['last_name'];
      var _bioAttr = (_body['customer_attributes'] as List)
          .where((e) => e['name'] == "bio")
          .toList();
      print(_bioAttr);
      _appState.bio = _bioAttr[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
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
      floatingActionButton: const LanguageTransitionWidget(),
      bottomNavigationBar:
          CustomBottomNavbar(context: context, selectedIndex: 4),
      body: Column(
        children: [
          Column(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: width * 0.2,
                        margin: EdgeInsets.only(
                            left: width * 0.05, right: width * 0.05),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: Colors.white,
                        ),
                        child: CircleAvatar(
                          radius: 38.0,
                          child: imagePath == ''
                              ? Image.asset(
                                  "assets/img/home/avatar.jpg",
                                  fit: BoxFit.fill,
                                )
                              : Image.file(
                                  File(imagePath),
                                  fit: BoxFit.fill,
                                ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Text(
                                      savedFirstName + " " + savedLastName,
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Text(
                                purchageAmount.toString() + " purchase",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: height * 0.1,
                  )
                ],
              ),
            ],
          ),
          InkWell(
            onTap: () => {
              Navigator.pushNamed(context, '/edit'),
            },
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.account_circle_outlined,
                    size: 25,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context).profilepage_info,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          // InkWell(
          //   onTap: () => {},
          //   child: Row(
          //     children: [
          //       const SizedBox(
          //         width: 20,
          //       ),
          //       const Padding(
          //         padding: EdgeInsets.all(8.0),
          //         child: Icon(
          //           Icons.badge_outlined,
          //           size: 25,
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Text(
          //           AppLocalizations.of(context).profilepage_bank,
          //           style: const TextStyle(
          //             fontSize: 18,
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          // SizedBox(
          //   height: height * 0.02,
          // ),
          InkWell(
            onTap: () => {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 800),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return FadeTransition(
                        opacity: animation, child: const AddressPage());
                  },
                ),
              )
            },
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.pin_drop_outlined,
                    size: 25,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context).profilepage_address,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          InkWell(
            onTap: () => {},
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    size: 25,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context).profilepage_history,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          InkWell(
            onTap: () => {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 800),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return FadeTransition(
                        opacity: animation, child: const ChangePasswordPage());
                  },
                ),
              )
            },
            child: Row(
              children: const [
                SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.settings_outlined,
                    size: 25,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Change Password",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          InkWell(
            onTap: () {
              onLogout();
            },
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.logout_outlined,
                    size: 25,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context).profilepage_logout,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
