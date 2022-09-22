// import 'package:toy_app/model/toy_detail.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toy_app/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:toy_app/helper/constant.dart';

class UserService {
  Future<String> getToken() async {
    try {
      var responnse = await http.post(
        Uri.parse("http://23.21.117.81:5000/token"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "guest": false,
          "username": "devvaleria@protonmail.com",
          "password": "123123123",
          "remember_me": true
        }),
      );
      final body = json.decode(responnse.body);
      String token = body["access_token"];
      print("token =====================================");
      print(token);
      return token;
    } catch (err) {
      rethrow;
    }
  }

  Future<String> login(String userEmail, String userPassword) async {
    try {
      // var responnse = await http.post(
      //   "http://23.21.117.81:5000/api/"
      // )
      String token = await getToken();
      final response = await http.get(
        Uri.parse("http://23.21.117.81:5000/api/customers?Limit=100"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      final body = json.decode(response.body);
      List<UserModel> users = (body['customers'] as List)
          .map((p) => UserModel.fromJson(p))
          .toList();
      users = users
          .where((element) =>
              element.userName == userEmail &&
              element.active == true &&
              element.pass == userPassword)
          .toList();
      if (users.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('bearer_token', token);
        await prefs.setString('auth_name', userEmail);
        await prefs.setString('auth_userid', users[0].id.toString());
        await prefs.setString('first_name', users[0].firstName);
        await prefs.setString('last_name', users[0].lastName);
        await prefs.setString('bio', users[0].bio);
        await prefs.setString('path', users[0].path);
        await prefs.setString('customerId', users[0].customerId);
        await prefs.setString('password', users[0].pass);
        return 'success';
      } else {
        return 'failed';
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> passwordChange(Map list) async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String token = _prefs.getString("token") ?? '';

      final response = await http.post(
        Uri.parse("$apiEndPoint/Customer/ChangePassword"),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "old_password": list['old_password'],
          "new_password": list['new_password'],
          "confirm_new_password": list['confirm_new_password'],
        }),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        return {'ok': true, 'message': jsonDecode(response.body)};
      } else {
        return {'ok': false, 'message': jsonDecode(response.body)};
      }
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<String> userinfoChange(Map list, Map userBio) async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String token = _prefs.getString("token") ?? '';
      String email = _prefs.getString('userEmail') ?? '';
      final response = await http.post(
        Uri.parse("$apiEndPoint/Customer/Info"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "model": {
            "email": list['userEmail'] ?? email,
            "email_to_revalidate": null,
            "check_username_availability_enabled": true,
            "allow_users_to_change_usernames": true,
            "usernames_enabled": true,
            "username": list['userEmail'] ?? email,
            "gender_enabled": false,
            "gender": null,
            "first_name_enabled": true,
            "first_name": list['firstname'],
            "first_name_required": true,
            "last_name_enabled": true,
            "last_name": list['lastname'],
            "last_name_required": true,
            "date_of_birth_enabled": false,
            "date_of_birth_day": 0,
            "date_of_birth_month": 0,
            "date_of_birth_year": 0,
            "date_of_birth_required": false,
            "company_enabled": false,
            "company_required": false,
            "company": "string",
            "street_address_enabled": true,
            "street_address_required": false,
            "street_address": list['address1'],
            "street_address2_enabled": false,
            "street_address2_required": false,
            "street_address2": "string",
            "zip_postal_code_enabled": false,
            "zip_postal_code_required": false,
            "zip_postal_code": null,
            "city_enabled": true,
            "city_required": false,
            "city": list['city'],
            "county_enabled": false,
            "county_required": false,
            "county": "string",
            "country_enabled": true,
            "country_required": false,
            "country_id": list['country_id'],
            "available_countries": [
              {
                "disabled": true,
                "group": {"disabled": true, "name": "string"},
                "selected": true,
                "text": "string",
                "value": "string"
              }
            ],
            "state_province_enabled": false,
            "state_province_required": false,
            "state_province_id": 0,
            "available_states": [],
            "phone_enabled": false,
            "phone_required": false,
            "phone": "string",
            "fax_enabled": false,
            "fax_required": false,
            "fax": null,
            "newsletter_enabled": true,
            "newsletter": true,
            "signature_enabled": false,
            "signature": "string",
            "time_zone_id": null,
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
            "vat_number": null,
            "vat_number_status_note": "Unknown",
            "display_vat_number": false,
            "associated_external_auth_records": [],
            "number_of_external_authentication_providers": 0,
            "allow_customers_to_remove_associations": true,
            "customer_attributes": [
              {
                "name": "bio",
                "is_required": false,
                "default_value": list['bio'],
                "attribute_control_type": "TextBox",
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
                "id": userBio['id'],
                "custom_properties": {}
              }
            ],
            "gdpr_consents": [],
            "custom_properties": {}
          },
          "form": {'customer_attribute_1': list['bio']},
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        await _prefs.setString('path', list['avatar']);
        await _prefs.setString('userEmail', list['userEmail'] ?? email);
        return 'success';
      } else {
        return 'failed';
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<String> register(List<String> info) async {
    try {
      String token = await getToken();
      final response = await http.post(
        Uri.parse("http://23.21.117.81:5000/api/customers"),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          "ObjectPropertyNameValuePairs": {},
          "customer": {
            "billing_address": {
              "first_name": info[0],
              "last_name": info[1],
              "email": info[2],
              "company": "",
              "country_id": 237,
              "country": "United States of America",
              "state_province_id": 41,
              "city": "NewYork",
              "address1": "NewYork",
              "address2": "NewYork",
              "zip_postal_code": "123",
              "phone_number": "123",
              "fax_number": "123",
              "customer_attributes": "123",
              "created_on_utc": "2022-02-07T04:21:33.362Z",
              "province": "123",
              "id": 5
            },
            "shipping_address": {
              "first_name": info[0],
              "last_name": info[1],
              "email": info[2],
              "company": "",
              "country_id": 237,
              "country": "United States of America",
              "state_province_id": 41,
              "city": "NewYork",
              "address1": "NewYork",
              "address2": "NewYork",
              "zip_postal_code": "123",
              "phone_number": "123",
              "fax_number": "123",
              "customer_attributes": "123",
              "created_on_utc": "2022-02-07T04:21:33.362Z",
              "province": "123",
              "id": 5
            },
            "addresses": [
              {
                "first_name": info[0],
                "last_name": info[1],
                "email": info[2],
                "company": "",
                "country_id": 237,
                "country": "United States of America",
                "state_province_id": 41,
                "city": "NewYork",
                "address1": "NewYork",
                "address2": "NewYork",
                "zip_postal_code": "123",
                "phone_number": "123",
                "fax_number": "123",
                "customer_attributes": "123",
                "created_on_utc": "2022-02-07T04:21:33.362Z",
                "province": "123",
                "id": 5
              }
            ],
            "customer_guid": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
            "username": info[2],
            "email": info[2],
            "first_name": info[0],
            "last_name": info[1],
            "password": info[3],
            "language_id": 1,
            "currency_id": 1,
            "date_of_birth": "2022-02-07T04:21:33.362Z",
            "gender": "male",
            "admin_comment": "",
            "is_tax_exempt": false,
            "has_shopping_cart_items": false,
            "active": true,
            "deleted": false,
            "is_system_account": false,
            "system_name": "",
            "last_ip_address": info[3],
            "created_on_utc": "2022-02-07T04:21:33.362Z",
            "last_login_date_utc": "2022-02-07T04:21:33.362Z",
            "last_activity_date_utc": "2022-02-07T04:21:33.362Z",
            "registered_in_store_id": 1,
            "subscribed_to_newsletter": true,
            "role_ids": [3],
            "id": 4
          }
        }),
      );
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        int id = body['customers'][0]['id'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('bearer_token', token);
        await prefs.setString('auth_name', info[2]);
        await prefs.setString('auth_userid', id.toString());
        await prefs.setString('first_name', info[0]);
        await prefs.setString('last_name', info[1]);
        await prefs.setString('pass', info[3]);
        await prefs.setString('path', '');
        return 'success';
      }
      return 'failed';
    } catch (err) {
      print(err);
      rethrow;
    }
  }
}
