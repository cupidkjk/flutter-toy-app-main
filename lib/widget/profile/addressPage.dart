import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toy_app/components/components.dart';
import 'package:toy_app/service/user_auth.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:provider/provider.dart';
import 'package:toy_app/helper/constant.dart';
import 'package:toy_app/provider/index.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({Key key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPage();
}

class _AddressPage extends State<AddressPage> {
  // app state
  AppState _appState;
  final _formKey = GlobalKey<FormState>();
  var savedFirstName = TextEditingController();
  var savedLastName = TextEditingController();
  var savedBio = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  // TextEditingController address2Controller = TextEditingController();
  // TextEditingController zipcodeController = TextEditingController();
  // TextEditingController phoneNumber = TextEditingController();
  final picker = ImagePicker();
  final userService = UserService();
  List<dynamic> country_items = [];
  File _image;
  String imagePath = '';
  int selectedCounty = 234;
  bool isProcessing = false;
  @override
  void initState() {
    super.initState();
    _appState = Provider.of<AppState>(context, listen: false);
    getUserInfo();
  }

  void getUserInfo() async {
    SharedPreferences savedPref = await SharedPreferences.getInstance();
    savedFirstName.text = _appState.firstName;
    savedLastName.text = _appState.lastName;
    userEmailController.text = savedPref.getString('userEmail') ?? "";
    cityController.text = _appState.profileCity;
    address1Controller.text = _appState.profileAddress1;

    savedBio.text = _appState.bio == null ? "" : _appState.bio['default_value'];
    if (mounted) {
      var _country_items_res = await http.get(
        Uri.parse(
            "$backendEndpoint/Country/GetAllCountries?languageId=0&showHidden=false"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
        },
      );
      // print(_country_items_res.body);
      setState(() {
        country_items = jsonDecode(_country_items_res.body);
        imagePath = (savedPref.getString('path') ?? "");
        selectedCounty = _appState.countryId == 0 ? 234 : _appState.countryId;
      });
    }
  }

  void submitInfo() async {
    final bool isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      var list = {
        'firstname': savedFirstName.text,
        'lastname': savedLastName.text,
        'bio': savedBio.text,
        'userEmail': userEmailController.text,
        'country_id': selectedCounty,
        'city': cityController.text,
        'address1': address1Controller.text,
        'bio': _appState.bio['default_value']
      };
      if (_image != null) {
        list['avatar'] = _image.path;
      } else {
        list['avatar'] = imagePath;
      }
      setState(() {
        isProcessing = true;
      });
      String response = await userService.userinfoChange(list, _appState.bio);
      setState(() {
        isProcessing = false;
      });
      if (response == 'success') {
        Navigator.pushNamed(context, '/profile');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      floatingActionButton: const LanguageTransitionWidget(),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(bottom: 25),
          color: const Color(0xffffffff),
          child: Column(
            children: [
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "Address",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Row(
                  children: const [
                    Text(
                      "You can edit your address details and save it here.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff999999),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.zero,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Form(
                              key: _formKey,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)
                                              .editpage_firstname,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black87),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          controller: savedFirstName,
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
                                                  .editpage_pfirstname;
                                            }
                                            // Return null if the entered email is valid
                                            return null;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)
                                              .editpage_lastname,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black87),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          controller: savedLastName,
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
                                                  .editpage_plastname;
                                            }
                                            // Return null if the entered email is valid
                                            return null;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Email",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black87),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          controller: userEmailController,
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
                                                  .login_pmail;
                                            }
                                            // Check if the entered email has the right format
                                            if (!RegExp(r'\S+@\S+\.\S+')
                                                .hasMatch(value)) {
                                              return AppLocalizations.of(
                                                      context)
                                                  .login_pvmail;
                                            }
                                            // Return null if the entered email is valid
                                            return null;
                                          },
                                          onChanged: (value) {},
                                          keyboardType:
                                              TextInputType.emailAddress,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Country",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black87),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        DropdownButton(
                                          value: selectedCounty,
                                          items: country_items?.map((item) {
                                            return DropdownMenuItem<int>(
                                              child: Text('${item["name"]}'),
                                              value: item['id'],
                                            );
                                          })?.toList(),
                                          onChanged: (value) {
                                            print(value);
                                            setState(() {
                                              selectedCounty = value;
                                            });
                                          },
                                          hint: const Text("Select Country"),
                                          disabledHint: const Text("Disabled"),
                                          elevation: 8,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                          icon: const Icon(
                                              Icons.arrow_drop_down_circle),
                                          iconDisabledColor: Colors.red,
                                          // iconEnabledColor: Colors.green,
                                          isExpanded: true,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "City",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black87),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          controller: cityController,
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
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Street Address1",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black87),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          controller: address1Controller,
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
                                        ),
                                        const SizedBox(
                                          height: 10,
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
                      SizedBox(
                        height: height * 0.07,
                        width: width * 0.9,
                        child: ElevatedButton(
                          onPressed: isProcessing
                              ? null
                              : () {
                                  submitInfo();
                                },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xff283488)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(83.0),
                                side:
                                    const BorderSide(color: Color(0xff283488)),
                              ),
                            ),
                          ),
                          child: Text(
                            isProcessing
                                ? "...processing"
                                : AppLocalizations.of(context).editpage_save,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
